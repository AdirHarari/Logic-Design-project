library ieee;
use ieee.std_logic_1164.all;

entity IU is	--IU - Input Unit
	port (switch, restN, fanD_switch :in std_logic; 
		 mov : in std_logic_vector (1 downto 0);
		 itinerary : out std_logic_vector (1 downto 0);
		 fanD_out : out std_logic
		);
end entity;

-- Inputs:
-- switch - system on/off switch
-- restN - reset 
-- fanD_switch - fan on/off switch
-- mov - input, the route type.
-- Outputs:
-- itinerary - output, forward the rout type 
-- fanD_out -- output, fan switch

architecture IU_arc of IU is 

begin
	
	process (switch, restN)
	
		begin
		
		if switch = '0' then --switch off
			itinerary <= "11"; --stand still.
			fanD_out <= '0'; 

		elsif switch = '1' then --switch on
			if restN = '1' then --reset is off
				itinerary <= mov; --forward the rout tipe to the OG
				fanD_out <= fanD_switch; --system is on
				
			elsif restN = '0' then --reset the system
				itinerary <= "11"; --stand still
				fanD_out <= '0'; 
			end if;
		end if;	
				
	end process;
end architecture;	

library ieee;
use ieee.std_logic_1164.all;

entity OG is --orbital generation
	port (IU : in std_logic_vector (1 downto 0);
		 clk : in std_logic;
		 motion : out std_logic_vector (1 downto 0)
		);
end entity;

-- Inputs: 
-- ITI - the itinerary
-- clk - clock
-- Outputs:
-- motion - command to the wheel controller

architecture OG_arc of OG is

signal counter : integer range 0 to 100; 

begin
	
	process (clk, ITI, counter)  
	
	begin
	
		if rising_edge (clk) then 
	
			if ITI = "00"  then --rout 1: forward/backwards
			counter <= 0;
				if counter < 10 then --10 Clock signals (*200ns)
				motion <= "00"; --forward
				counter <= counter + 1;
				elsif counter >= 10 AND counter < 15 then 
				motion <= "11"; --stop
				counter <= counter + 1;
				elsif counter >= 15 AND counter < 25 then 
				motion <= "01"; --backwards
				counter <= counter + 1;
				elsif counter >= 25 AND counter < 30 then 
				motion <= "11"; --stop
				counter <= counter + 1;
				end if;
		
			
		elsif ITI = "01" then --rout 2: sqaure
			counter <= 0;
			if counter < 10 then 
				motion <= "00"; --forward
				counter <= counter + 1;
				
			elsif counter >= 10 AND counter < 15 then 
				motion <= "10"; --left turn
				counter <= counter + 1;
				--another 3 times to make the sqaure
			elsif counter >= 15 AND counter < 25 then 
				motion <= "00";
				counter <= counter + 1;
			elsif counter >= 25 AND counter < 30 then 
				motion <= "10";
				counter <= counter + 1;
				
			elsif counter >= 30 AND counter < 40 then 
				motion <= "00";
				counter <= counter + 1;
			elsif counter >= 40 AND counter < 45 then 
				motion <= "10";
				counter <= counter + 1;
				
			elsif counter >= 45 AND counter < 55 then 
				motion <= "00";
				counter <= counter + 1;
			elsif counter >= 55 AND counter < 60 then 
				motion <= "10";
				counter <= counter + 1;	
			end if;
		
		elsif ITI = "10" then --rout 3: circle
			counter <= 0;
			if counter <= 10 then 
				motion <= "10"; --left turn
				counter <= counter + 1;
			end if;
			
		elsif ITI = "11" then --rout 4: stop
			motion <= "11";
		end if;
	end if;	
		
	end process;
end architecture;				