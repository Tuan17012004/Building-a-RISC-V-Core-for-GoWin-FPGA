library ieee;
use ieee.std_logic_1164.all;

entity flopenr is
    generic(WIDTH : integer := 8);
    port(
        clk   : in  std_logic;
        reset : in  std_logic;
        en    : in  std_logic;
        d     : in  std_logic_vector(WIDTH-1 downto 0);
        q     : out std_logic_vector(WIDTH-1 downto 0)
    );
end entity flopenr;

architecture rtl of flopenr is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if en = '1' then
                q <= d;
            end if;
        end if;
    end process;
end architecture rtl;
