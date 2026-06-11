library ieee;
use ieee.std_logic_1164.all;

entity maindec is
    port(
        op        : in  std_logic_vector(6 downto 0);
        ResultSrc : out std_logic_vector(1 downto 0);
        MemWrite  : out std_logic;
        Branch    : out std_logic;
        ALUSrc    : out std_logic;
        RegWrite  : out std_logic;
        Jump      : out std_logic;
        ImmSrc    : out std_logic_vector(1 downto 0);
        ALUOp     : out std_logic_vector(1 downto 0)
    );
end entity maindec;

architecture rtl of maindec is
    -- controls = {RegWrite, ImmSrc[1:0], ALUSrc, MemWrite, ResultSrc[1:0], Branch, ALUOp[1:0], Jump}
    --             bit10      9:8          7       6         5:4             3       2:1          0
    signal controls : std_logic_vector(10 downto 0);
begin
    process(op)
    begin
        case op is
            when "0000011" => controls <= "10010010000"; -- lw
            when "0100011" => controls <= "00111000000"; -- sw
            when "0110011" => controls <= "10000000100"; -- R-type
            when "1100011" => controls <= "01000001010"; -- beq
            when "0010011" => controls <= "10010000100"; -- I-type (addi/ori/...)
            when "1101111" => controls <= "11100010001"; -- jal
            when others    => controls <= "00000000000";
        end case;
    end process;

    RegWrite  <= controls(10);
    ImmSrc    <= controls(9 downto 8);
    ALUSrc    <= controls(7);
    MemWrite  <= controls(6);
    ResultSrc <= controls(5 downto 4);
    Branch    <= controls(3);
    ALUOp     <= controls(2 downto 1);
    Jump      <= controls(0);
end architecture rtl;
