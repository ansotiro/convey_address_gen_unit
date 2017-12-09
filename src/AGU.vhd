----------------------------------------------------------------------------------
--                 ________  __       ___  _____        __
--                /_  __/ / / / ___  / _/ / ___/______ / /____
--                 / / / /_/ / / _ \/ _/ / /__/ __/ -_) __/ -_)
--                /_/  \____/  \___/_/   \___/_/  \__/\__/\__/
--
----------------------------------------------------------------------------------
--
-- Author(s):   ansotiropoulos
--
-- Design Name: address_gen_unit
-- Module Name: AGU
--
-- Description: This entity is a generic AGU block
--
-- Copyright:   (C) 2016 Microprocessor & Hardware Lab, TUC
--
-- This source file is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published
-- by the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
--
-- ae_addr_sel & ae_bank_sel & ae_mc_sel & ae_chip_sel & cnt_addr_sel & cnt_bank_sel & cnt_mc_sel & cnt_chip_sel & MAX_ADDR & MAX_BANK & MAX_MC & MAX_CHIP
--    [63]           [62]         [61]        [60]         [59:56]        [55:52]      [51:48]       [47:44]       [43:12]     [11:8]     [7:4]     [3:0]
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.packo.all;

entity AGU is
port (
    CLK             : in  std_logic;
    RST             : in  std_logic;
    START           : in  std_logic;
    PSIZE           : in  std_logic_vector (31 downto 0);
    AEID            : in  std_logic_vector (1  downto 0);
    PEID            : in  std_logic_vector (2  downto 0);
    ODDEVEN         : in  std_logic;
    AEREG           : in  std_logic_vector (63 downto 0);
    INIT            : in  std_logic_vector (5 downto 0);
    MC_RQ_STALL     : in  std_logic;
    FIFO_STALL      : in  std_logic;
    MC_RQ_ADDR      : out std_logic_vector (47 downto 0);
    MC_RQ_EN        : out std_logic;
    FIFO_POP        : out std_logic;
    FINISH          : out std_logic
);
end AGU;

architecture arch of AGU is

constant FIN_LATENCY    : std_logic_vector (31 downto 0) := x"00000200";      -- 512
constant ZERO           : std_logic_vector (31 downto 0) := x"00000000";

constant INIT_ADDR      : std_logic_vector (21 downto 0) := "00" & x"00000";
constant INIT_BANK      : std_logic_vector (2  downto 0) := "000";
constant INIT_MC        : std_logic_vector (2  downto 0) := "000";
constant INIT_CHIP      : std_logic_vector (2  downto 0) := "000";

signal ctrl_rsp_en      : std_logic := '0';
signal ctrl_addr_cnt_en : std_logic := '0';
signal ctrl_addr_cnt    : std_logic_vector (31 downto 0) := x"00000000";
signal ctrl_rq_en       : std_logic := '0';
signal ctrl_finish      : std_logic := '0';
signal finito           : std_logic := '0';
signal run_time         : std_logic := '0';
signal count_finish_en  : std_logic := '0';
signal count_finish     : std_logic_vector (31 downto 0) := x"00000000";

signal MAX_ADDR         : std_logic_vector (21 downto 0) := "00" & x"00000";
signal MAX_BANK         : std_logic_vector (2  downto 0) := "000";
signal MAX_MC           : std_logic_vector (2  downto 0) := "000";
signal MAX_CHIP         : std_logic_vector (2  downto 0) := "000";

signal cnt_addr         : std_logic_vector (21 downto 0) := x"00000" & "00";
signal cnt_bank         : std_logic_vector (2  downto 0) := "000";
signal cnt_mc           : std_logic_vector (2  downto 0) := "000";
signal cnt_chip         : std_logic_vector (2  downto 0) := "000";

signal cnt_addr_mux     : std_logic_vector (21 downto 0) := x"00000" & "00";
signal cnt_bank_mux     : std_logic_vector (2  downto 0) := "000";
signal cnt_mc_mux       : std_logic_vector (2  downto 0) := "000";
signal cnt_chip_mux     : std_logic_vector (2  downto 0) := "000";

signal cnt_addr_en      : std_logic := '0';
signal cnt_bank_en      : std_logic := '0';
signal cnt_mc_en        : std_logic := '0';
signal cnt_chip_en      : std_logic := '0';

signal cnt_addr_trig    : std_logic := '0';
signal cnt_bank_trig    : std_logic := '0';
signal cnt_mc_trig      : std_logic := '0';
signal cnt_chip_trig    : std_logic := '0';

signal cnt_addr_sel     : std_logic_vector (2 downto 0) := "000";
signal cnt_bank_sel     : std_logic_vector (2 downto 0) := "000";
signal cnt_mc_sel       : std_logic_vector (2 downto 0) := "000";
signal cnt_chip_sel     : std_logic_vector (2 downto 0) := "000";

signal ae_addr_sel      : std_logic := '0';
signal ae_bank_sel      : std_logic := '0';
signal ae_mc_sel        : std_logic := '0';
signal ae_chip_sel      : std_logic := '0';


begin

-- Hook up Outputs
MC_RQ_ADDR      <= x"000"&"0" & cnt_addr_mux & cnt_bank_mux & ODDEVEN & PEID & cnt_chip_mux & "000";
MC_RQ_EN        <= ctrl_rq_en;
FIFO_POP        <= ctrl_addr_cnt_en;
FINISH          <= finito and run_time;

-- Dispatch AEREG
ae_addr_sel     <= AEREG(63);
ae_bank_sel     <= AEREG(62);
ae_mc_sel       <= AEREG(61);
ae_chip_sel     <= AEREG(60);

cnt_addr_sel    <= AEREG(58 downto 56);
cnt_bank_sel    <= AEREG(54 downto 52);
cnt_mc_sel      <= AEREG(50 downto 48);
cnt_chip_sel    <= AEREG(46 downto 44);

MAX_ADDR        <= AEREG(33 downto 12);
MAX_BANK        <= AEREG(10 downto 8);
MAX_MC          <= AEREG(6  downto 4);
MAX_CHIP        <= AEREG(2  downto 0);


ctrl_rsp_en         <= (((MC_RQ_STALL nor FIFO_STALL) and (not ctrl_finish)) and run_time);
ctrl_addr_cnt_en    <= ctrl_rsp_en;
count_finish_en     <= ctrl_finish;


process
begin
    wait until rising_edge(CLK);

    if ctrl_addr_cnt >= PSIZE then
        ctrl_finish <= '1';
    else
        ctrl_finish <= '0';
    end if;
end process;

process
begin
    wait until rising_edge(CLK);

    if count_finish >= FIN_LATENCY then
        finito <= '1';
    else
        finito <= '0';
    end if;
end process;

process
begin
    wait until rising_edge(CLK);

    if RST = '1' then
        run_time <= '0';
    else
        if START = '1' then
            run_time <= '1';
        else
            run_time <= run_time;
        end if;
    end if;
end process;

process
begin
    wait until rising_edge(CLK);

    if RST = '1' then
        ctrl_rq_en <= '0';
    else
        ctrl_rq_en <= ctrl_addr_cnt_en;
    end if;
end process;


CNT_A: COUNTER
generic map (N=>32)
port map (
    CLK     => CLK,
    RST     => RST,
    DRST    => ZERO,
    SET     => '0',
    DSET    => ZERO,
    EN      => ctrl_addr_cnt_en,
    DOUT    => ctrl_addr_cnt
);

CNT_FIN: COUNTER
generic map (N=>32)
port map (
    CLK     => CLK,
    RST     => RST,
    DRST    => ZERO,
    SET     => '0',
    DSET    => ZERO,
    EN      => count_finish_en,
    DOUT    => count_finish
);


ADDR_CNT: ACOUNT
generic map (N=>22)
port map (
    CLK     => CLK,
    RST     => RST,
    AEID    => AEID,
    INITR   => INIT_ADDR,
    INITS   => INIT_ADDR,
    MAX     => MAX_ADDR,
    SEL     => ae_addr_sel,
    EN      => cnt_addr_en,
    COUNT   => cnt_addr_mux,
    FIN     => cnt_addr_trig
);

BANK_CNT: ACOUNT
generic map (N=>3)
port map (
    CLK     => CLK,
    RST     => RST,
    AEID    => AEID,
    INITR   => INIT_BANK,
    INITS   => INIT_BANK,
    MAX     => MAX_BANK,
    SEL     => ae_bank_sel,
    EN      => cnt_bank_en,
    COUNT   => cnt_bank_mux,
    FIN     => cnt_bank_trig
);

MC_CNT: ACOUNT
generic map (N=>3)
port map (
    CLK     => CLK,
    RST     => RST,
    AEID    => AEID,
    INITR   => INIT_MC,
    INITS   => INIT_MC,
    MAX     => MAX_MC,
    SEL     => ae_mc_sel,
    EN      => cnt_mc_en,
    COUNT   => cnt_mc_mux,
    FIN     => cnt_mc_trig
);

CHIP_CNT: ACOUNT
generic map (N=>3)
port map (
    CLK     => CLK,
    RST     => RST,
    AEID    => AEID,
    INITR   => INIT_CHIP,
    INITS   => INIT_CHIP,
    MAX     => MAX_CHIP,
    SEL     => ae_chip_sel,
    EN      => cnt_chip_en,
    COUNT   => cnt_chip_mux,
    FIN     => cnt_chip_trig
);


ADDR_MUX5_1b: MUX5_1b port map (cnt_addr_trig, cnt_bank_trig, cnt_mc_trig, cnt_chip_trig, ctrl_rsp_en, cnt_addr_sel, cnt_addr_en);

BANK_MUX5_1b: MUX5_1b port map (cnt_addr_trig, cnt_bank_trig, cnt_mc_trig, cnt_chip_trig, ctrl_rsp_en, cnt_bank_sel, cnt_bank_en);

MC_MUX5_1b: MUX5_1b port map (cnt_addr_trig, cnt_bank_trig, cnt_mc_trig, cnt_chip_trig, ctrl_rsp_en, cnt_mc_sel, cnt_mc_en);

CHIP_MUX5_1b: MUX5_1b port map (cnt_addr_trig, cnt_bank_trig, cnt_mc_trig, cnt_chip_trig, ctrl_rsp_en, cnt_chip_sel, cnt_chip_en);

end arch;