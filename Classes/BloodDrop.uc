//=============================================================================
// BloodDrop.
//=============================================================================
class BloodDrop extends UT_BloodDrop;

var() bool bDecal;

function PostBeginPlay()
{
//	Velocity = (Vector(Rotation) * (400 + 200 * FRand()) );
	Velocity.z += 30;
	if ( !Level.bDropDetail )
		Texture = MultiSkins[Rand(8)];
	Drawscale = FRand()*0.2+0.1;
}

auto state Explode
{

	simulated function Landed( vector HitNormal )
	{
		if ( bDecal )
			Spawn(class'BloodSplat',,,Location,rotator(HitNormal));
		Destroy();
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		if ( bDecal )
			Spawn(class'BloodSplat',,,Location,rotator(HitNormal));
		Destroy();
	}
}

defaultproperties
{
    bDecal=True
    LifeSpan=3.00
}
