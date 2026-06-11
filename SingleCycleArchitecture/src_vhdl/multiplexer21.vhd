library ieee;
use ieee.std_logic_1164.all;

entity mux2to1 is
    generic(WIDTH : integer := 8);
    port(
        d0 : in  std_logic_vector(WIDTH-1 downto 0);
        d1 : in  std_logic_vector(WIDTH-1 downto 0);
        s  : in  std_logic;
        y  : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity mux2to1;

architecture rtl of mux2to1 is
begin
    y <= d1 when s = '1' else d0;
end architecture rtl;
