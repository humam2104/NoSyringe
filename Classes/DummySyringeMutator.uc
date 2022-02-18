class DummySyringeMutator extends KFMutator;
	var class<KFWeapon> DummyHealingSyringe;

	//Healing Vars
	var float DummySyringeStandAloneHealAmount;
	var float DummySyringeOthersHealAmount;

	//Recharge Vars
	var float DummySyringeHealSelfRechargeSeconds;
	var float DummySyringeHealOthersRechargeSeconds;


function InitMutator(string Options, out string ErrorMessage)
{

	super.InitMutator( Options, ErrorMessage );
	`log("No Syringe mutator initialized");
	
}

function PostBeginPlay()
{
		Super.PostBeginPlay();
		
		if (WorldInfo.Game.BaseMutator == None)
			WorldInfo.Game.BaseMutator = Self;
		else
			WorldInfo.Game.BaseMutator.AddMutator(Self);

}

function AddMutator(Mutator M)
{
	if (M != Self)
	{
		if (M.Class == Class)
			M.Destroy();
		else
			Super.AddMutator(M);
	}
} 
	
	function ReplaceSyringe(Pawn P)
	{
		local KFInventoryManager KFIM;
		local KFWeapon OriginalSyringe;
		
		KFIM = KFInventoryManager(KFPawn(P).InvManager);
		
		if (KFIM != none)
		{
				KFIM.GetWeaponFromClass(OriginalSyringe, 'KFWeap_Healer_Syringe'); 					// Assigns the "BabySyringe" name to the original syringe.

				if (DummyHealingSyringe != none) 
				{
					KFIM.CreateInventory(DummyHealingSyringe /*, false*/);
					LogInternal("=== DummySyringe === Added the real syringe");
				} 																				// If the real solo syringe doesn't exist, then create it

				if (OriginalSyringe != none)
				{
					KFIM.ServerRemoveFromInventory(OriginalSyringe);
					LogInternal("=== DummySyringe === Removed Original syringe");
				}

		}
	}
	

// APPLY SYRINGE REPLACEMENT FUNCTION TO PLAYER

	function ModifyPlayer(Pawn P) 															 	// Function to modify the player
	{
		Super.ModifyPlayer(P);
		
		if (P != none)
			ReplaceSyringe(P); 																	// This calls the ReplaceSyringe function defined just above if a player exists.
	}
	

	
	
	defaultproperties
	{
		DummyHealingSyringe = class'NoSyringe.DummyHealingSyringe'
	}

	


