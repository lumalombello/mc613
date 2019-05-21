library ieee;
use ieee.std_logic_1164.all;

entity clk_div is
  port (
    clk : in std_logic;
    clk_hz : out std_logic
  );
end clk_div;

architecture behavioral of clk_div is
  SIGNAL Count : INTEGER RANGE 0 TO 49999999;
begin
	process (clk, count)
	BEGIN  
	
		if(clk'event and clk = '1') then
			if ( count = 49999999 ) then
				count <= 0;
			else 
				count <= count + 1;
			end if;
		end if;
		
		if count = 49999999 then
			clk_hz <= '1';
		else
			clk_hz <= '0';
		end if;
		
	END PROCESS ;
end behavioral;