class Rifle_HeadshotMut expands Mutator;

function ModifyPlayer(Pawn Other)
{
	DeathMatchPlus(Level.Game).GiveWeapon(Other,"ChamRifle_v1.CustomSniperRifle");

	if ( NextMutator != None )
		NextMutator.ModifyPlayer(Other);
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	if ((Other.IsA('weapon')) || (Other.IsA('ammo')))
	{
		if ( (Other.IsA('BioAmmo')) || (Other.IsA('BulletBox')) || (Other.IsA('BladeHopper')) || (Other.IsA('RifleShell')) || (Other.IsA('FlakAmmo')) || (Other.IsA('MiniAmmo')) || (Other.IsA('PAmmo')) || (Other.IsA('RocketPack')) || (Other.IsA('ShockCore')) )
		{
			ReplaceWith(Other,"ChamRifle_v1.CustomBullets");
			return false;
		}


        if (( Other.IsA('TournamentHealth')) || ( Other.IsA('HealthPack')) || Other.IsA('HealthVial') )
		return true;


        if ((Other.IsA('ChainSaw')) || (Other.IsA('PulseGun')) || (Other.IsA('Ripper')) || (Other.IsA('UT_BioRifle')) || (Other.IsA('UT_Eightball')) || (Other.IsA('UT_FlakCannon')) || (Other.IsA('Enforcer')) || (Other.IsA('ImpactHammer')) || (Other.IsA('Minigun2')) || (Other.IsA('ShockRifle')) || (Other.IsA('SniperRifle')))
		{
			ReplaceWith(Other,"ChamRifle_v1.CustomSniperRifle");
			return false;
		}

        if ((Other.IsA('ChainSaw')) || (Other.IsA('PulseGun')) || (Other.IsA('Ripper')) || (Other.IsA('UT_BioRifle')) || (Other.IsA('UT_Eightball')) || (Other.IsA('UT_FlakCannon')) || (Other.IsA('Enforcer')) || (Other.IsA('ImpactHammer')) || (Other.IsA('Minigun2')) || (Other.IsA('ShockRifle')) || (Other.IsA('WarheadLauncher')) ||(Other.IsA('SniperRifle')))
		{
		    return true;
		}


		if (Other.IsA('SniperRifle'))
			return false;

		return true;
	}

	return true;
}

defaultproperties
{
}
