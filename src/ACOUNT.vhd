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
-- Design Name: address_count
-- Module Name: ACOUNT
--
-- Description: This entity is a generic ACOUNT block
--
-- Copyright:   (C) 2016 Microprocessor & Hardware Lab, TUC
--
-- This source file is free software; you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as published
-- by the Free Software Foundation; either version 2.1 of the License, or
-- (at your option) any later version.
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.packo.all;

entity ACOUNT is
generic (
    N           : integer := 4
);
port (
    CLK         : in  std_logic;
    RST         : in  std_logic;
    AEID        : in  std_logic_vector (1 downto 0);
    INITR       : in  std_logic_vector (N-1 downto 0);
    INITS       : in  std_logic_vector (N-1 downto 0);
    MAX         : in  std_logic_vector (N-1 downto 0);
    SEL         : in  std_logic;
    EN          : in  std_logic;
    COUNT       : out std_logic_vector (N-1 downto 0);
    FIN         : out std_logic
);
end ACOUNT;

architecture arch of ACOUNT is

constant INIT_CNT   : std_logic_vector (N-1 downto 0) := (others => '0');

signal cnt          : std_logic_vector (N-1 downto 0) := (others => '0');
signal cnt_set      : std_logic := '0';
signal cnt_en       : std_logic := '0';
signal cnt_trig     : std_logic := '0';
signal cnt_mux      : std_logic_vector (N-1 downto 0) := (others => '0');


begin

COUNT       <= cnt_mux;
FIN         <= cnt_trig;
cnt_set     <= cnt_trig and cnt_en;
cnt_en      <= EN;


CNTER: COUNTER
generic map (
    N       => N
)
port map (
    CLK     => CLK,
    RST     => RST,
    DRST    => INITR,
    SET     => cnt_set,
    DSET    => INITS,
    EN      => cnt_en,
    DOUT    => cnt
);

cnt_trig <= '1' when (cnt = MAX and cnt_en = '1') else
            '0';

process
begin
    wait until rising_edge(CLK);

    if RST = '1' then
        cnt_mux <= INITR(N-3 downto 0) & AEID;
    else
        if SEL = '1' then
            cnt_mux <= cnt(N-3 downto 0) & AEID;
        else
            cnt_mux <= cnt;
        end if;
    end if;
end process;

end arch;