library ieee;
use ieee.std_logic_1164.all;

entity uc_decode is
    port(
        code: in std_logic_vector(7 downto 0);
        inst: out std_logic_vector(10 downto 0)
    );
end;

architecture b of uc_decode is
    signal sdecode: std_logic_vector(10 downto 0);
    -- nop | sta | lda | add | or | and | not | jmp | jn | jz | hlt
begin
    
    inst <= "10000000000" when code="00000000"   -- nop
       else "01000000000" when code="00010000"   -- sta
       else "00100000000" when code="00100000"   -- lda
       else "00010000000" when code="00110000"   -- add
       else "00001000000" when code="01000000"   -- or
       else "00000100000" when code="01010000"   -- and
       else "00000010000" when code="01100000"   -- not
       else "00000001000" when code="10000000"   -- jmp
       else "00000000100" when code="10010000"   -- jn
       else "00000000010" when code="10100000"   -- jz
       else "00000000001" when code="11110000"   -- hlt
       else "ZZZZZZZZZZZ"; 
end;

