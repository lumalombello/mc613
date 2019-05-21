LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.std_logic_unsigned.all ;

ENTITY clock IS
	port (
    clk : in std_logic;
    decimal : in std_logic_vector(3 downto 0);
    unity : in std_logic_vector(3 downto 0);
    set_hour : in std_logic;
    set_minute : in std_logic;
    set_second : in std_logic;
    hour_dec, hour_un : out std_logic_vector(6 downto 0);
    min_dec, min_un : out std_logic_vector(6 downto 0);
    sec_dec, sec_un : out std_logic_vector(6 downto 0)
  );
END clock ;

ARCHITECTURE rtl OF clock IS
component clk_div is
    port (
      clk : in std_logic;
      clk_hz : out std_logic
    );
  end component;
signal clk_hz : std_logic;
signal BCD1, BCD0, BCD2, BCD3, BCD4, BCD5: STD_LOGIC_VECTOR(3 DOWNTO 0); 
BEGIN
	clock_divider : clk_div port map (clk, clk_hz);
	PROCESS ( clk, clk_hz )
	BEGIN
	
		if (clk'event and clk = '1') then
	
			if(set_hour = '1') then
				if (decimal = "0000" or decimal = "0001") then
					BCD5 <= decimal;
					BCD4 <= unity;
				elsif (decimal = "0010") then
					if( unity <= "0011" ) then
						BCD5 <= decimal;
						BCD4 <= unity;
					end if;
				end if;				
			end if;
			
			if(set_minute = '1') then
				if (decimal <= "0101") then
					BCD3 <= decimal;
					BCD2 <= unity;
				end if;
			end if;
			
			if(set_second = '1') then 
				if (decimal <= "0101") then
					BCD1 <= decimal;
					BCD0 <= unity;
				end if;
			end if;
		
		end if;
	
		IF clk_hz'EVENT AND clk_hz = '1' THEN	
			IF BCD0 = "1001" THEN
				BCD0 <= "0000" ;
				IF BCD1 = "0101" THEN
					BCD1 <= "0000";
					IF BCD2 = "1001" THEN
						BCD2 <= "0000";
						IF BCD3 = "0101" THEN
							BCD3 <= "0000";
							IF BCD4 = "1001" THEN
								BCD4 <= "0000";
								IF BCD5 = "0010" THEN
									BCD5 <= "0000";
								ELSE
									BCD5 <= BCD5 + 1;
								END IF;
							ELSIF BCD4 = "0011" THEN
								IF BCD5 = "0010" THEN
									BCD4 <= "0000";
									BCD5 <= "0000";
								ELSE 
									BCD4 <= BCD4 + 1;
								END IF;
							ELSE
								BCD4 <= BCD4 + 1;
							END IF;
						ELSE
							BCD3 <= BCD3 + 1;
						END IF;
					ELSE
						BCD2 <= BCD2 + 1;
					END IF;
				ELSE
					BCD1 <= BCD1 + '1' ;
				END IF ;
			ELSE
				BCD0 <= BCD0 + '1' ;
			END IF ;
		END IF;
	END PROCESS;
	
	bin0: entity work.bin2dec port map ( BCD0, sec_un );
	bin1: entity work.bin2dec port map ( BCD1, sec_dec );
	bin2: entity work.bin2dec port map ( BCD2, min_un );
	bin3: entity work.bin2dec port map ( BCD3, min_dec );
	bin4: entity work.bin2dec port map ( BCD4, hour_un );
	bin5: entity work.bin2dec port map ( BCD5, hour_dec );

		
END rtl ;