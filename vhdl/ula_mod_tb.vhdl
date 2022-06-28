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
        wait for CLK_PERIOD;
        sreset <= '1';
        wait for CLK_PERIOD;
        
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
