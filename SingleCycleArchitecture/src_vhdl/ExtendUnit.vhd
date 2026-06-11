library ieee;
use ieee.std_logic_1164.all;

-- Don vi mo rong so nguyen co dau cho immediate RISC-V
-- immsrc: 00=I-type, 01=S-type, 10=B-type, 11=J-type
entity extend is
    port(
        instr  : in  std_logic_vector(31 downto 0);
        immsrc : in  std_logic_vector(1 downto 0);
        immext : out std_logic_vector(31 downto 0)
    );
end entity extend;

architecture rtl of extend is
begin
    process(instr, immsrc)
    begin
        case immsrc is
            when "00" => -- I-type: {{20{instr[31]}}, instr[31:20]}
                immext <= (31 downto 12 => instr(31)) & instr(31 downto 20);
            when "01" => -- S-type: {{20{instr[31]}}, instr[31:25], instr[11:7]}
                immext <= (31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
            when "10" => -- B-type: {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}
                immext <= (31 downto 12 => instr(31)) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';
            when "11" => -- J-type: {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0}
                immext <= (31 downto 20 => instr(31)) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0';
            when others =>
                immext <= (others => '0');
        end case;
    end process;
end architecture rtl;
