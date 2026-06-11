library ieee;
use ieee.std_logic_1164.all;

entity aludec is
    port(
        opb5       : in  std_logic;
        funct3     : in  std_logic_vector(2 downto 0);
        funct7b5   : in  std_logic;
        ALUOp      : in  std_logic_vector(1 downto 0);
        ALUControl : out std_logic_vector(2 downto 0)
    );
end entity aludec;

architecture rtl of aludec is
    signal RTypeSub : std_logic;
begin
    RTypeSub <= funct7b5 and opb5;

    process(ALUOp, funct3, RTypeSub)
    begin
        case ALUOp is
            when "00" => ALUControl <= "000";   -- lw/sw: add
            when "01" => ALUControl <= "001";   -- beq: sub
            when "10" =>
                case funct3 is
                    when "000" =>
                        if RTypeSub = '1' then
                            ALUControl <= "001"; -- sub
                        else
                            ALUControl <= "000"; -- add/addi
                        end if;
                    when "010" => ALUControl <= "101"; -- slt/slti
                    when "100" => ALUControl <= "100"; -- xor/xori
                    when "110" => ALUControl <= "011"; -- or/ori
                    when "111" => ALUControl <= "010"; -- and/andi
                    when others => ALUControl <= "000";
                end case;
            when others => ALUControl <= "000";
        end case;
    end process;
end architecture rtl;
