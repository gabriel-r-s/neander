library ieee;
use ieee.std_logic_1164.all;

entity uc_ctl is
    port(
        inst: in std_logic_vector(10 downto 0);
        -- 10nop|9lda|8sta|7add|6and|5or|4not|3jmp|2jn|1jz|0hlt
        zf, nf: in std_logic;
        reset: in std_logic;
        clk: in std_logic;
        bar_ctl: out std_logic_vector(10 downto 0)
        -- 10nb_inc|9nb_pc|8..6ula_op|5pc_nrw|4ac_nrw|3mem_nrw|2mar_nrw|1mbr_nrw|0ri_nrw
    );
end;

architecture b of uc_ctl is
    component count0a7 is
        port(
            reset: in std_logic;
            clk: in std_logic;
            num: out std_logic_vector(2 downto 0)
        );
    end component;
    
    component bnop is
        port(
            st: in std_logic_vector(2 downto 0);
            outs: out std_logic_vector(10 downto 0)
        );
    end component;

    component blda is
        port(
            st: in std_logic_vector(2 downto 0);
            outs: out std_logic_vector(10 downto 0)
        );
    end component;
    
    component bsta is
        port(
            st: in std_logic_vector(2 downto 0);
            outs: out std_logic_vector(10 downto 0)
        );
    end component;
    
    component ula_not is
        port(
            st: in std_logic_vector(2 downto 0);
            outs: out std_logic_vector(10 downto 0)
        );
    end component;

    component ula_binop is
        port(
            st: in std_logic_vector(2 downto 0);
            which: in std_logic_vector(2 downto 0);
            outs: out std_logic_vector(10 downto 0)
        );
    end component;
    
    component jmp_true is
        port(
            st: in std_logic_vector(2 downto 0);
            outs: out std_logic_vector(10 downto 0)
        );
    end component;
    
    component jmp_false is
        port(
            st: in std_logic_vector(2 downto 0);
            outs: out std_logic_vector(10 downto 0)
        );
    end component;


    
    signal st: std_logic_vector(2 downto 0);
    -- signal snop, slda, ssta, sadd, sand, sor, snot, sjmp, sjn, sjz, shlt: std_logic_vector(10 downto 0);
    signal snop, slda, ssta, sula_binop, snot, sjmp_true, sjmp_false, shlt: std_logic_vector(10 downto 0);
    
    signal will_jump, will_not_jump, will_binop: std_logic;
    signal which_binop: std_logic_vector(2 downto 0);
begin
    -- 10nop|9lda|8sta|7add|6and|5or|4not|3jmp|2jn|1jz|0hlt
    u_count: count0a7 port map(reset, clk, st);

    will_jump <= inst(3) or (inst(2) and nf) or (inst(1) and zf);
    will_not_jump <= (inst(2) and not nf) or (inst(1) and not zf);
    will_binop <= inst(7) or inst(6) or inst(5);
    which_binop <= inst(7 downto 5);
   
    u_nop: bnop port map(st, snop);
    u_sta: bsta port map(st, ssta);
    u_lda: blda port map(st, slda);
    u_binop: ula_binop port map(st, which_binop, sula_binop);
    u_not: ula_not port map(st, snot);
    u_jmptrue: jmp_true port map(st, sjmp_true);
    u_jmpfalse: jmp_false port map(st, sjmp_false);
    shlt <= "00000000000";

    bar_ctl <= 
            snop            when inst(10)='1'
       else ssta            when inst(9)='1'
       else slda            when inst(8)='1'
       else sula_binop      when will_binop='1'
       else snot            when inst(4)='1'
       else sjmp_true       when will_jump='1'
       else sjmp_false      when will_not_jump='1' 
       else shlt            when inst(0)='1'
    ;
   
    -- u_nop: bnop port map(st, snop);
    -- u_lda: blda port map(st, slda);
    -- u_sta: bsta port map(st, ssta);
    -- u_binop: ula_binop port map(st, inst(7 downto 5), sula_binop);
    -- u_not: ula_not port map(st, snot);
    -- u_jmptrue: jmp_true port map(st, sjmp_true);
    -- u_jmpfalse: jmp_false port map(st, sjmp_false);

    -- bar_ctl <= snop         when  inst="10000000000"
    --     else slda           when  inst="01000000000"
    --     else ssta           when  inst="00100000000"
    --     else sula_binop     when  inst="00010000000"
    --     else sula_binop     when  inst="00001000000"
    --     else sula_binop     when  inst="00000100000"
    --     else snot           when  inst="00000010000"
    --     
    --     else sjmp_true      when  inst="00000001000"
    --     else sjmp_true      when (inst="00000000100") and (nf='1')
    --     else sjmp_true      when (inst="00000000010") and (zf='1')
    --     
    --     else sjmp_false     when (inst="00000000100") and (nf='0')
    --     else sjmp_false     when (inst="00000000010") and (zf='0')
    --     
    --     else "00000000000"  when  inst="00000000001"
    --     else "ZZZZZZZZZZZ";
end;


library ieee;
use ieee.std_logic_1164.all;

entity count0a7 is
    port(
        reset: in std_logic;
        clk: in std_logic;
        num: out std_logic_vector(2 downto 0)
    );
end;

architecture b of count0a7 is
    component ffjk is
        port(
            j, k: in std_logic;
            clk: in std_logic;
            pr, cl: in std_logic;
            q, nq: out std_logic
        );
    end component;

    signal snum: std_logic_vector(2 downto 0);
    signal sj, sk: std_logic_vector(2 downto 0);
    signal vcc: std_logic := '1';
begin

    u_ffs: for i in 2 downto 0 generate
        -- reset em "111"
        st: ffjk port map(sj(i), sk(i), clk, reset, vcc, snum(i));
    end generate;
    
    sj(0) <= vcc;
    sk(0) <= vcc;
    
    sj(1) <= snum(0);
    sk(1) <= snum(0);

    sj(2) <= snum(1) and snum(0);
    sk(2) <= snum(1) and snum(0);
    
    num <= snum;
end;

-- CAIXAS DE OPERACOES ==============================

-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity bnop is
    port(
        st: in std_logic_vector(2 downto 0);
        outs: out std_logic_vector(10 downto 0)
    );
end;

architecture b of bnop is
    --
    --  0: MAR <- PC
    --  1: MBR <- MEM; PC++
    --  2: RI <- RDM
    --
begin
    outs(10) <= '1';
    outs(9) <= '1';
    outs(8 downto 6) <= "000"; 
    outs(5) <= not st(2) and not st(1) and st(0);
    outs(4) <= '0';
    outs(3) <= '0';
    outs(2) <= not (st(2) or st(1) or st(0));
    outs(1) <= not st(2) and not st(1) and st(0);
    outs(0) <= not st(2) and st(1) and not st(0);
end;



-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity blda is
    port(
        st: in std_logic_vector(2 downto 0);
        outs: out std_logic_vector(10 downto 0)
    );
end;

architecture b of blda is
    --
    --  000 MAR <- PC
    --  001 MBR <- MEM; PC++
    --  010 RI <- MBR;
    --  011 MAR <- PC
    --  100 MBR <- MEM; PC++
    --  101 MAR <- BARR
    --  110 MBR <- MEM
    --  111 AC <- RDM
    --
begin
    outs(10) <= '1';
    outs(9) <= not (st(2) and not st(1) and st(0));
    outs(8 downto 6) <= "000"; 
    outs(5) <= (not st(1)) and (st(2) xor st(0)); 
    outs(4) <= st(2) and st(1) and st(0);
    outs(3) <= '0'; 
    outs(2) <= (not st(1) and (st(2) xnor st(0))) or (not st(2) and st(1) and st(0));
    outs(1) <= (not st(1) and (st(2) xor st(0))) or (st(2) and st(1) and not (st(0))); 
    outs(0) <= not st(2) and st(1) and not st(0); 
end;


-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity bsta is
    port(
        st: in std_logic_vector(2 downto 0);
        outs: out std_logic_vector(10 downto 0)
    );
end;

architecture b of bsta is
begin
    outs(10) <= '1';
    outs(9) <= not (st(2) and not st(1) and st(0));
    outs(8 downto 6) <= "000"; 
    outs(5) <= not st(1) and (st(2) xor st(0)); 
    outs(4) <= '0'; 
    outs(3) <= st(2) and st(1) and not st(0); 
    outs(2) <= (not st(1) and (st(2) xnor st(0))) or (not st(2) and st(1) and st(0));
    outs(1) <= not st(1) and (st(2) xor st(0)); 
    outs(0) <= not st(2) and st(1) and not st(0); 
end;


-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ula_not is
    port(
        st: in std_logic_vector(2 downto 0);
        outs: out std_logic_vector(10 downto 0)
    );
end;

architecture b of ula_not is
begin
    outs(10) <= '1';
    outs(9) <= '1';  
    outs(8 downto 6) <= "100"; 
    outs(5) <= not st(2) and not st(1) and st(0); 
    outs(4) <= st(2) and st(1) and st(0); 
    outs(3) <= '0'; 
    outs(2) <= not (st(2) or st(1) or st(0)); 
    outs(1) <= not st(2) and not st(1) and st(0); 
    outs(0) <= not st(2) and st(1) and not st(0); 
end;


-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity ula_binop is
    port(
        st: in std_logic_vector(2 downto 0);
        which: in std_logic_vector(2 downto 0);
        outs: out std_logic_vector(10 downto 0)
    );
end;

architecture b of ula_binop is
begin
    outs(10) <= '1';
    outs(9) <= not (st(2) and not st(1) and st(0));  
    outs(8 downto 6) <= 
             "011" when which="001" -- and 
        else "010" when which="010" -- or 
        else "001" when which="100" -- add
        else "000"
    ;
    outs(5) <= not st(1) and (st(2) xor st(0)); 
    outs(4) <= st(2) and st(1) and st(0); 
    outs(3) <= '0'; 
    outs(2) <= (not st(1) and (st(2) xnor st(0))) or (not st(2) and st(1) and st(0));
    outs(1) <= (not st(1) and (st(2) xor st(0))) or (st(2) and st(1) and not st(0)); 
    outs(0) <= not st(2) and st(1) and not st(0); 
end;


-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity jmp_true is
    port(
        st: in std_logic_vector(2 downto 0);
        outs: out std_logic_vector(10 downto 0)
    );
end;

architecture b of jmp_true is
begin
    outs(10) <= not st(2);
    outs(9) <= '1';  
    outs(8 downto 6) <= "000"; 
    outs(5) <= not st(1) and st(0); 
    outs(4) <= '0'; 
    outs(3) <= '0'; 
    outs(2) <= not st(2) and (st(1) xnor st(0)); 
    outs(1) <= not st(1) and (st(2) xor st(0)); 
    outs(0) <= not st(2) and st(1) and not st(0); 
end;


-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity jmp_false is
    port(
        st: in std_logic_vector(2 downto 0);
        outs: out std_logic_vector(10 downto 0)
    );
end;

architecture b of jmp_false is
begin
    outs(10) <= '1';
    outs(9) <= '1';  
    outs(8 downto 6) <= "000"; 
    outs(5) <= not st(2) and st(0); 
    outs(4) <= '0'; 
    outs(3) <= '0'; 
    outs(2) <= not (st(2) or st(1) or st(0)); 
    outs(1) <= not st(2) and not st(1) and st(0); 
    outs(0) <= not st(2) and st(1) and not st(0); 
end;

