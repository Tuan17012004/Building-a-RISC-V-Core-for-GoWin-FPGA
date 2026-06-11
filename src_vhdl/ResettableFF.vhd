library ieee;
use ieee.std_logic_1164.all;

entity flopr is
    generic(WIDTH : integer := 8);
    port(
        clk   : in  std_logic;
        reset : in  std_logic;
        d     : in  std_logic_vector(WIDTH-1 downto 0);
        q     : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity flopr;

architecture rtl of flopr is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end architecture rtl;
