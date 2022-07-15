library ieee;
use ieee.std_logic_1164.all;

entity mem_mod is
    port(
        end_pc, end_bar: in std_logic_vector(7 downto 0); -- endereço PC (instrução), endereço barramento (dados)
        nb_pc: in std_logic; -- se 0->barr, 1->PC
        mar_nrw, mem_nrw, mbr_nrw: in std_logic; -- se 0->read, 1->write
        
        reset: in std_logic;
        clk: in std_logic;
        
        interface: inout std_logic_vector(7 downto 0)
    );
end;

architecture b of mem_mod is
    component reg8 is
        port(
            d: in std_logic_vector(7 downto 0);
            nrw: in std_logic;
            reset: in std_logic;
            clk: in std_logic;
            q: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component as_ram is
    	port(
            addr: in std_logic_vector(7 downto 0);
    	    data: inout std_logic_vector(7 downto 0);
    	    notrw: in std_logic;
    	    reset: in std_logic
    	);
    end component;
    
    signal smux_nb_pc, smar_out, smem_inout, smbr_out: std_logic_vector(7 downto 0);
begin
    smux_nb_pc <= end_bar when nb_pc='0' else end_pc; -- ok
    
    u_mar: reg8 port map(smux_nb_pc, mar_nrw, reset, clk, smar_out); -- 
    
    u_mem: as_ram port map(smar_out, smem_inout, mem_nrw, reset);
    
    interface <= smbr_out when mem_nrw='0' else "ZZZZZZZZ";
    
    smem_inout <= interface when mem_nrw='1' else "ZZZZZZZZ";
    
    u_mbr: reg8 port map(smem_inout, mbr_nrw, reset, clk, smbr_out);
    
    -- smem_inout <= interface when mem_nrw='1' else smbr_out;
end;

