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
-- Module Name: tb_agu
--
-- Description: Testbench for generic AGU
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_agu is
end tb_agu;

architecture behavior of tb_agu is

component AGU
port (
    CLK         : in  std_logic;
    RST         : in  std_logic;
    START       : in  std_logic;
    PSIZE       : in  std_logic_vector (31 downto 0);
    AEID        : in  std_logic_vector (1 downto 0);
    PEID        : in  std_logic_vector (2 downto 0);
    ODDEVEN     : in  std_logic;
    AEREG       : in  std_logic_vector (63 downto 0);
    INIT        : in  std_logic_vector (5 downto 0);
    MC_RQ_STALL : in  std_logic;
    FIFO_STALL  : in  std_logic;
    MC_RQ_ADDR  : out std_logic_vector (47 downto 0);
    MC_RQ_EN    : out std_logic;
    FIFO_POP    : out std_logic;
    FINISH      : out std_logic
);
end component;

procedure printf_slv (dat : in std_logic_vector (31 downto 0); file f: text) is
    variable my_line : line;
begin
    write(my_line, CONV_INTEGER(dat));
    write(my_line, string'(" -   ("));
    write(my_line, now);
    write(my_line, string'(")"));
    writeline(f, my_line);
end procedure printf_slv;

constant CLK_period : time := 10 ns;
constant BASEADDR_0 : std_logic_vector(47 downto 0) := x"000000000000";
constant BASEADDR_1 : std_logic_vector(47 downto 0) := x"000000000020";

signal CLK          : std_logic := '0';
signal RST          : std_logic := '0';
signal START        : std_logic := '0';
signal PSIZE        : std_logic_vector (31 downto 0) := (others => '0');
signal AEID         : std_logic_vector (1 downto 0) := (others => '0');
signal PEID         : std_logic_vector (2 downto 0) := (others => '0');
signal ODDEVEN      : std_logic := '0';
signal AEREG        : std_logic_vector (63 downto 0) := (others => '0');
signal INIT         : std_logic_vector (5 downto 0) := (others => '0');
signal MC_RQ_STALL  : std_logic := '0';
signal FIFO_STALL   : std_logic := '0';
signal MC_RQ_ADDR   : std_logic_vector (47 downto 0) := (others => '0');
signal MC_RQ_EN     : std_logic := '0';
signal FIFO_POP     : std_logic := '0';
signal FINISH       : std_logic := '0';

signal MC_0         : std_logic_vector (47 downto 0) := (others => '0');
signal MC_1         : std_logic_vector (47 downto 0) := (others => '0');
signal MC_0_DEC     : std_logic_vector (44 downto 0) := (others => '0');
signal MC_1_DEC     : std_logic_vector (44 downto 0) := (others => '0');

file file_addr      : text open WRITE_MODE is "out/test_d.out";

begin


U: AGU
port map (
    CLK         => CLK,
    RST         => RST,
    START       => START,
    PSIZE       => PSIZE,
    AEID        => AEID,
    PEID        => PEID,
    ODDEVEN     => ODDEVEN,
    AEREG       => AEREG,
    INIT        => INIT,
    MC_RQ_STALL => MC_RQ_STALL,
    FIFO_STALL  => FIFO_STALL,
    MC_RQ_ADDR  => MC_RQ_ADDR,
    MC_RQ_EN    => MC_RQ_EN,
    FIFO_POP    => FIFO_POP,
    FINISH      => FINISH
);

CLKP :process
begin
    CLK <= '0';
    wait for CLK_period/2;
    CLK <= '1';
    wait for CLK_period/2;
end process;

TRACE: process
begin
    wait until rising_edge(CLK);
    if MC_RQ_EN = '1' then
        printf_slv(MC_RQ_ADDR(34 downto 3), file_addr);
    end if;
end process;

SIMUL: process
begin

    wait until rising_edge(CLK);

    RST 		<= '0';
    START 		<= '0';
    PSIZE 		<= x"00000000";
    AEID 		<= "00";
    PEID 		<= "000";
    ODDEVEN 	<= '0';
    AEREG 		<= x"0000000000000000";
    MC_RQ_STALL <= '0';
    FIFO_STALL 	<= '0';
    wait for 100 ns;

    RST 		<= '1';
    START 		<= '0';
    PSIZE 		<= x"00000000";
    AEID 		<= "00";
    PEID 		<= "000";
    ODDEVEN 	<= '0';
    AEREG 		<= x"0000000000000000";
    MC_RQ_STALL <= '0';
    FIFO_STALL 	<= '0';
    wait for 100 ns;

    RST 		<= '0';
    START 		<= '0';
    PSIZE 		<= x"0000003F";
    AEID 		<= "00";
    PEID 		<= "000";
    ODDEVEN 	<= '0';
    AEREG 		<= x"4137400000003177";
    MC_RQ_STALL <= '0';
    FIFO_STALL 	<= '0';
    wait for 40 ns;

    RST 		<= '0';
    START 		<= '1';
    MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
    MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
    MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    wait for 10 ns;

    RST 		<= '0';
    START 		<= '0';
    MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
    MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
    MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    wait for 10 ns;

    RST 		<= '0';
    START 		<= '0';
    MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
    MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
    MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    wait for 10 ns;

    RST 		<= '0';
    START 		<= '0';
    MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
    MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
    MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    wait for 10 ns;

    RST 		<= '0';
    START 		<= '0';
    MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
    MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
    MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
    wait for 10 ns;


    for J in 1 to 300 loop
        for I in 1 to 9 loop
            MC_RQ_STALL <= '0';
            FIFO_STALL 	<= '0';
            MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
            MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
            MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            wait for 10 ns;
        end loop;
        for I in 1 to 6 loop
            MC_RQ_STALL <= '1';
            FIFO_STALL 	<= '0';
            MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
            MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
            MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            wait for 10 ns;
        end loop;
        for I in 1 to 4 loop
            MC_RQ_STALL <= '0';
            FIFO_STALL 	<= '0';
            MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
            MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
            MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            wait for 10 ns;
        end loop;
        for I in 1 to 2 loop
            MC_RQ_STALL <= '0';
            FIFO_STALL 	<= '1';
            MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
            MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
            MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            wait for 10 ns;
        end loop;
        for I in 1 to 1 loop
            MC_RQ_STALL <= '0';
            FIFO_STALL 	<= '0';
            MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
            MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
            MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            wait for 10 ns;
        end loop;
        for I in 1 to 4 loop
            MC_RQ_STALL <= '1';
            FIFO_STALL 	<= '1';
            MC_0 <= BASEADDR_0 + MC_RQ_ADDR;
            MC_1 <= BASEADDR_1 + MC_RQ_ADDR;
            MC_0_DEC <= BASEADDR_0(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            MC_1_DEC <= BASEADDR_1(47 downto 2) + MC_RQ_ADDR(47 downto 2);
            wait for 10 ns;
        end loop;
    end loop;

wait;
end process;

end;
