library ieee;
use ieee.std_logic_1164.all;

entity mux3 is
    generic(WIDTH : integer := 8);
    port(
        d0 : in  std_logic_vector(WIDTH-1 downto 0);
        d1 : in  std_logic_vector(WIDTH-1 downto 0);
        d2 : in  std_logic_vector(WIDTH-1 downto 0);
        s  : in  std_logic_vector(1 downto 0);
        y  : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity mux3;

architecture rtl of mux3 is
begin
    y <= d2 when s(1) = '1' else
         d1 when s(0) = '1' else
         d0;
end architecture rtl;
