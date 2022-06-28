library ieee;
use ieee.std_logic_1164.all;

entity ula_alu_tb is
end;

architecture tb of ula_alu_tb is
    constant PERIOD: time := 10 ns;

    component ula_alu is
        port(
            x: in std_logic_vector(7 downto 0);
            y: in std_logic_vector(7 downto 0);
            op: in std_logic_vector(2 downto 0);
            zf, nf: out std_logic;
            s: out std_logic_vector(7 downto 0)
        );
    end component;

    signal sx, sy: std_logic_vector(7 downto 0);
    signal sop: std_logic_vector(2 downto 0);
    signal szf, snf: std_logic;
    signal ss: std_logic_vector(7 downto 0);
begin
    u_alu: ula_alu port map(sx, sy, sop, szf, snf, ss);
    
    u_tb: process begin
        -- teste lda
        sx <= "00000001";
        sy <= "00000010";
        
        sop <= "000";
        wait for PERIOD;


        sop <= "001";
        -- x + y
        -- result = 11111111
        -- zf=0 nf=1
        wait for PERIOD;
        
        sop <= "010";
        -- x | y
        -- result=111111111
        --zf=0 nf=1
        wait for PERIOD;

        sop <= "011";
        -- x & y
        -- result=00000000
        --zf=1 nf=0
        wait for PERIOD;

        sop <= "100";
        -- !x
        -- result = 10101010
        -- zf=0 nf=1
        wait for PERIOD;
        
        sop <= "111";
        -- result = ZZZZZZZZ
        -- zf=? nf=?
        wait for PERIOD;
        
        wait;
    end process;
end;

