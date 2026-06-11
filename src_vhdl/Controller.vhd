library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        op         : in  std_logic_vector(6 downto 0);
        funct3     : in  std_logic_vector(2 downto 0);
        funct7b5   : in  std_logic;
        Zero       : in  std_logic;
        ResultSrc  : out std_logic_vector(1 downto 0);
        MemWrite   : out std_logic;
        PCSrc      : out std_logic;
        ALUSrc     : out std_logic;
        RegWrite   : out std_logic;
        Jump       : out std_logic;
        ImmSrc     : out std_logic_vector(1 downto 0);
        ALUControl : out std_logic_vector(2 downto 0)
    );
end entity controller;

architecture rtl of controller is
    signal ALUOp   : std_logic_vector(1 downto 0);
    signal Branch  : std_logic;
    signal Jump_i  : std_logic;
begin
    md : entity work.maindec
        port map(
            op => op, ResultSrc => ResultSrc, MemWrite => MemWrite,
            Branch => Branch, ALUSrc => ALUSrc, RegWrite => RegWrite,
            Jump => Jump_i, ImmSrc => ImmSrc, ALUOp => ALUOp
        );

    ad : entity work.aludec
        port map(
            opb5 => op(5), funct3 => funct3, funct7b5 => funct7b5,
            ALUOp => ALUOp, ALUControl => ALUControl
        );

    PCSrc <= (Branch and Zero) or Jump_i;
    Jump  <= Jump_i;
end architecture rtl;
