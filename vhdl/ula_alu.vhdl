-- ula_alu ======================================
library ieee;
use ieee.std_logic_1164.all;

entity ula_alu is
    port(
        x, y: in std_logic_vector(7 downto 0);
        op: in std_logic_vector(2 downto 0);
        
        zf, nf: out std_logic;
        s: out std_logic_vector(7 downto 0)
    );
end;

architecture b of ula_alu is
    component add8 is
        port(
            x, y: in std_logic_vector(7 downto 0);
            cin: in std_logic;
            cout: out std_logic;
            s: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component calc_flag is
        port(
            result: in std_logic_vector(7 downto 0);
            zf, nf: out std_logic
        );
    end component;
   
    signal dump_cout: std_logic;
    signal slda, sadd, sor, sand, snot: std_logic_vector(7 downto 0);
    signal result: std_logic_vector(7 downto 0);
begin
    slda <= y;
    u_adder: add8 port map(x, y, '0', dump_cout, sadd);
    snot <= not x;
    sand <= x and y;
    sor <= x or y;
    
    result <= slda when op="000" else
              sadd when op="001" else
              sor  when op="010" else
              sand when op="011" else
              snot when op="100" else
              "ZZZZZZZZ";
    u_flags: calc_flag port map(result, zf, nf); 
    s <= result;        
end;


-- somador ======================================
library ieee;
use ieee.std_logic_1164.all;

entity add8 is
    port(
        x, y: in std_logic_vector(7 downto 0);
        cin: in std_logic;
        cout: out std_logic;
        s: out std_logic_vector(7 downto 0)
    );
end;

architecture b of add8 is
    signal carry: std_logic_vector(8 downto 0);
begin
    carry(0) <= cin;
    u_gen: for i in 0 to 7 generate
        s(i) <= (x(i) xor y(i)) xor carry(i);
        carry(i+1) <= (x(i) and y(i)) or (x(i) and carry(i)) or (y(i) and carry(i));
    end generate;
    cout <= carry(8);
end;
