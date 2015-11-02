class Rifle_HUDMutator expands Mutator;

var PlayerPawn HUDOwner;

simulated event PostRender( canvas Canvas )
{
	if (HUDOwner != None && HUDOwner.Weapon != None)
	{
        if (HUDOwner.Weapon.IsA('ChamRifle_v1')) // You may want to enable this.
		HUDOwner.Weapon.PostRender(Canvas);
	}
}

defaultproperties
{
}
