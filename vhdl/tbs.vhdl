-- tb registrador 8 bits ==============================================
library ieee;
use ieee.std_logic_1164.all;

entity reg8_tb is
end;

architecture tb of reg8_tb is
    constant CLK_PERIOD: time := 10 ns;
        
    component reg8 is
        port(
            d: in std_logic_vector(7 downto 0);
            nrw: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            q: out std_logic_vector(7 downto 0)
        );
    end component;

    signal sd: std_logic_vector(7 downto 0);
    signal snrw, sreset: std_logic;
    signal sclk: std_logic := '0';
    signal sq: std_logic_vector(7 downto 0);
begin
    u_reg8: reg8 port map(sd, snrw, sreset, sclk, sq);
    
    u_tb: process begin
        -- reset
        sreset <= '0';
        wait for CLK_PERIOD;
        sreset <= '1';
        
        -- read
        snrw <= '0';
        sd <= "11110000";
        wait for CLK_PERIOD;
        
        -- write
        snrw <= '1';
        sd <= "00001111";
        wait for CLK_PERIOD;
        
        -- read
        snrw <= '0';
        sd <= "11110000";
        wait for CLK_PERIOD;
    end process;


    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD / 2;
    end process;
end;


-- tb registrador - ff c/ carga ==============================================
library ieee;
use ieee.std_logic_1164.all;

entity ffc_tb is
end;

architecture tb of ffc_tb is
    constant CLK_PERIOD: time := 10 ns;
        
    component ff_charge is
        port(
            d: in std_logic;
            nrw: in std_logic;
            clk: in std_logic;
            pr, cl: in std_logic;
            q: out std_logic
        );
    end component;

    signal sd: std_logic;
    signal snrw: std_logic;
    signal sclk: std_logic := '0';
    signal spr, scl: std_logic;
    signal sq: std_logic;
begin
    u_reg8: ff_charge port map(sd, snrw, sclk, spr, scl, sq);
    
    u_tb: process begin
        -- preset
        spr <= '0';
        scl <= '1';
        wait for CLK_PERIOD;

        -- clear
        spr <= '1';
        scl <= '0';
        wait for CLK_PERIOD;

        -- done
        spr <= '1';
        scl <= '1';

        -- write 0
        snrw <= '1';
        sd <= '0';
        wait for CLK_PERIOD;

        -- read
        snrw <= '0';
        sd <= '1';
        wait for CLK_PERIOD;

        -- write 1
        snrw <= '1';
        sd <= '1';
        wait for CLK_PERIOD;
    end process;


    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD / 2;
    end process;
end;

-- tb ffd ======================================================
library ieee;
use ieee.std_logic_1164.all;

entity ffd_tb is
end;

architecture tb of ffd_tb is
    constant CLK_PERIOD: time := 10 ns;

    component ffd is
        port(
            d: in std_logic;
            clk: in std_logic;
            pr, cl: in std_logic;
            q, nq: out std_logic
        );
    end component;

    signal sd: std_logic;
    signal sclk: std_logic := '1';
    signal spr, scl: std_logic;
    signal sq, snq: std_logic;
begin
    u_ffd: ffd port map(sd, sclk, spr, scl, sq, snq);
    
    u_tb: process begin
        -- preset
        spr <= '0';
        scl <= '1';
        wait for CLK_PERIOD;

        -- clear
        spr <= '1';
        scl <= '0';
        wait for 6 ns;

        spr <= '1';
        scl <= '1';
        
        -- set
        sd <= '1';
        wait for CLK_PERIOD;
        
        -- reset
        sd <= '0';
        wait for CLK_PERIOD;
    end process;

    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD / 2;
    end process;
end;


-- tb ula_alu ===================================================
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

-- tb ula_mod ================================================================
library ieee;
use ieee.std_logic_1164.all;


entity ula_mod_tb is
end;

architecture tb of ula_mod_tb is
    constant CLK_PERIOD: time := 10 ns;
    
    component ula_mod is
        port(
            mem: in std_logic_vector(7 downto 0);
            mem_nrw: in std_logic;
    
            ula_op: in std_logic_vector(2 downto 0);    
            ac_nrw: in std_logic;
            
            reset: in std_logic;
            clk: in std_logic;
    
            zf, nf: out std_logic
        );
    end component;
   
    signal smem: std_logic_vector(7 downto 0);
    signal smem_nrw: std_logic;

    signal sula_op: std_logic_vector(2 downto 0);
    signal sac_nrw: std_logic;

    signal sreset: std_logic;
    signal sclk: std_logic := '0';

    signal szf, snf: std_logic;
begin
    u_ula: ula_mod port map(smem, smem_nrw, sula_op, sac_nrw, sreset, sclk, szf, snf);

    u_tb: process begin
        sreset <= '0';
        smem_nrw <= '0';
        sac_nrw <= '0';
        wait for CLK_PERIOD / 2;
        sreset <= '1';
        
        -- teste 1
        -- lda 11110000 -- AC: 11110000 ;; nf
        -- add 00011111 -- AC: 00001111 ;;
        -- or  10000000 -- AC: 10001111 ;; nf
        -- and 10010101 -- AC: 10000101 ;; nf
        -- not          -- AC: 01111010 ;;
        -- and 00000000 -- AC: 00000000 ;; zf
        
        -- lda 11110000
        smem <= "11110000";
        smem_nrw <= '0';
        sula_op <= "000";
        sac_nrw <= '1';
        wait for CLK_PERIOD;
        
        -- add 000111111
        smem <= "00011111";
        smem_nrw <= '0';
        sula_op <= "001";
        sac_nrw <= '1';
        wait for CLK_PERIOD;
        
        -- or 10000000
        smem <= "10000000";
        smem_nrw <= '0';
        sula_op <= "010";
        sac_nrw <= '1';
        wait for CLK_PERIOD;
        
        -- and 10010101
        smem <= "10010101";
        smem_nrw <= '0';
        sula_op <= "011";
        sac_nrw <= '1';
        wait for CLK_PERIOD;
    
        -- not
        sula_op <= "100";
        sac_nrw <= '1';
        wait for CLK_PERIOD;

        -- and 00000000
        smem <= "00000000";
        smem_nrw <= '0';
        sula_op <= "011";
        sac_nrw <= '1';
        wait for CLK_PERIOD;
    end process;


    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD;
    end process;
end;
