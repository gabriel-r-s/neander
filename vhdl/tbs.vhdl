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
-- library ieee;
-- use ieee.std_logic_1164.all;
-- 
-- entity ffd_tb is
-- end;
-- 
-- architecture tb of ffd_tb is
--     constant CLK_PER


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
            mem: inout std_logic_vector(7 downto 0);
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
        wait for CLK_PERIOD / 4;
        sreset <= '1';
        
        -- teste 1
        -- lda 11110000         11110000        NF
        -- add 00011111         00001111        
        -- or  10000000         10001111        NF
        -- and 10010101         10000101        NF
        -- not                  01111010
        -- and 00000000         00000000        ZF


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
        wait for CLK_PERIOD/2;
    end process;
end;


-- tb mem mod ====================================================================
library ieee;
use ieee.std_logic_1164.all;

entity mem_mod_tb is
end;

architecture tb of mem_mod_tb is
    constant CLK_PERIOD: time := 4 ns;

    component mem_mod is
        port(
            end_pc, end_bar: in std_logic_vector(7 downto 0); -- endereço PC (instrução), endereço barramento (dados)
            nb_pc: in std_logic; -- se 0->barr, 1->PC
            mar_nrw, mem_nrw, mbr_nrw: in std_logic; -- se 0->read, 1->write
            
            reset: in std_logic;
            clk: in std_logic;
            
            interface: inout std_logic_vector(7 downto 0)
        );
    end component;
    
    signal send_pc, send_bar: std_logic_vector(7 downto 0);
    signal snb_pc, smar_nrw, smem_nrw, smbr_nrw: std_logic;
    signal sreset: std_logic;
    signal sclk: std_logic := '1';
    signal sinterface: std_logic_vector(7 downto 0);
begin
    u_mem: mem_mod port map(send_pc, send_bar, snb_pc, smar_nrw, smem_nrw, smbr_nrw, sreset, sclk, sinterface);
    u_tb: process begin
        -- reset
        sinterface <= "ZZZZZZZZ";  
        sreset <= '0';
        send_pc <= "00000000";
        send_bar <= "00000000";
        snb_pc <= '0';
        smar_nrw <= '0';
        smem_nrw <= '0';
        smbr_nrw <= '0';
        wait for CLK_PERIOD;
        sreset <= '1';
        wait for CLK_PERIOD;

        -- read *5 (132)
        sinterface <= "ZZZZZZZZ";        
        send_bar <= "00000101";
        snb_pc <= '0';
        smar_nrw <= '1';
        wait for CLK_PERIOD;
        smem_nrw <= '0';
        smbr_nrw <= '1';
        wait for CLK_PERIOD;

        -- write *64 = 77
        send_bar <= "01000000";
        snb_pc <= '0';
        smar_nrw <= '1';
        wait for CLK_PERIOD;
        smem_nrw <= '1';
        smbr_nrw <= '0';
        sinterface <= "01001101";
        wait for CLK_PERIOD;
        smem_nrw <= '0';

        -- read *64 (77)
        sinterface <= "ZZZZZZZZ";        
        send_bar <= "01000000";
        snb_pc <= '0';
        smar_nrw <= '1';
        wait for CLK_PERIOD;
        smem_nrw <= '0';
        smbr_nrw <= '1';
        wait for CLK_PERIOD;

        wait;
    end process;

    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD / 2;
    end process;
end;


-- tb uc pc ====================================================================
library ieee;
use ieee.std_logic_1164.all;

entity uc_pc_tb is
end;

architecture tb of uc_pc_tb is
    constant CLK_PERIOD: time := 4 ns;

    component pc is
        port(
            nb_inc: in std_logic;
            pc_nrw: in std_logic;
            barr: in std_logic_vector(7 downto 0);
            reset: in std_logic;
            clk: in std_logic;
            end_out: out std_logic_vector(7 downto 0)
        );
    end component;
    
    signal snb_inc, spc_nrw, sreset: std_logic;
    signal sclk: std_logic := '0';
    signal sbar: std_logic_vector(7 downto 0);
    signal send_out: std_logic_vector(7 downto 0);

begin
    u_pc: pc port map(snb_inc, spc_nrw, sbar, sreset, sclk, send_out);
    
    u_tb: process begin
        snb_inc <= '0';
        spc_nrw <= '0';
        sreset <= '0';
        wait for CLK_PERIOD;
        sreset <= '1';

        -- verificar estado reset
        
        -- jump 11111100
        sbar <= "11111100";
        snb_inc <= '0';
        spc_nrw <= '1';
        wait for CLK_PERIOD;
        
        -- deixar incrementar algumas vezes
        snb_inc <= '1';
        spc_nrw <= '1';
        wait for CLK_PERIOD * 5;
    
        -- esperar algumas vezes
        spc_nrw <= '0';
        wait for CLK_PERIOD * 2;

        -- jump 10
        sbar <= "00001010";
        snb_inc <= '0';
        spc_nrw <= '1';
        wait for CLK_PERIOD;

        -- incrementar algumas vezes
        snb_inc <= '1';
        spc_nrw <= '1';
        wait for CLK_PERIOD;

        -- ok
        wait;
    end process;

    u_clk: process begin
        sclk <= not sclk;
        wait for CLK_PERIOD / 2;
    end process;
end;
