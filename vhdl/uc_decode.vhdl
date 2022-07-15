library ieee;
use ieee.std_logic_1164.all;

entity cont is
    port(
        bar: in std_logic_vector(7 downto 0);
        ri_nrw: std_logic;
        reset: std_logic;
        clk: std_logic;
        inst: out std_logic_vector(10 downto 0)
    );
end;

architecture b of cont is
    component reg8 is
        port(
            d: in std_logic_vector(7 downto 0);
            nrw: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            q: out std_logic_vector(7 downto 0)
        );
    end component;

    signal ri_out: std_logic_vector(7 downto 0);
    signal sdecode: std_logic_vector(10 downto 0);
    -- nop | lda | sta | add | and | or | not | jmp | jn | jz | hlt
begin
    u_ri: reg8 port map(bar, ri_nrw, reset, clk, ri_out); 
    
    inst <= "10000000000" when bar="00000000"   -- nop
       else "01000000000" when bar="00010000"   -- lda
       else "00100000000" when bar="00100000"   -- sta
       else "00010000000" when bar="00110000"   -- add
       else "00001000000" when bar="01000000"   -- and
       else "00000100000" when bar="01010000"   -- or
       else "00000010000" when bar="01100000"   -- not
       else "00000001000" when bar="10000000"   -- jmp
       else "00000000100" when bar="10100000"   -- jn
       else "00000000010" when bar="10110000"   -- jz
       else "00000000001" when bar="11110000"   -- hlt
       else "ZZZZZZZZZZZ"; 
end;

