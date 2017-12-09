-- Package
library ieee;
use ieee.std_logic_1164.all;


-- Declare packo
package packo is

component ACOUNT
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
end component;

component COUNTER
generic (
    N       : integer := 4
);
port (
    CLK     : in  std_logic;
    RST     : in  std_logic;
    DRST    : in  std_logic_vector (N-1 downto 0);
    SET     : in  std_logic;
    DSET    : in  std_logic_vector (N-1 downto 0);
    EN      : in  std_logic;
    DOUT    : out std_logic_vector (N-1 downto 0)
);
end component;

component MUX5_1b
port (
    A           : in  std_logic;
    B           : in  std_logic;
    C           : in  std_logic;
    D           : in  std_logic;
    E           : in  std_logic;
    SEL         : in  std_logic_vector (2 downto 0);
    O           : out std_logic
);
end component;


end packo;