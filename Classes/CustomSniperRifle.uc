class CustomSniperRifle expands TournamentWeapon config (ChamRifle_v1);


#EXEC AUDIO IMPORT name=Fire FILE=sounds\Fire.wav GROUP=rifle
#EXEC AUDIO IMPORT name=RiflePickup FILE=sounds\RiflePickup.wav GROUP=rifle
#EXEC AUDIO IMPORT name=HitSound FILE=sounds\HitSound.wav GROUP=rifle

#exec AUDIO IMPORT NAME=zoomstart FILE=Sounds\zoomstart.WAV GROUP=Rifle
#exec AUDIO IMPORT NAME=zoomstop FILE=Sounds\zoomstop.WAV GROUP=Rifle

#exec AUDIO IMPORT NAME=WhippingSound FILE=Sounds\WhippingSound.WAV GROUP=Rifle




#exec TEXTURE IMPORT NAME=Rifle2A FILE=Textures\Rifle2a.BMP GROUP=Rifle
#exec TEXTURE IMPORT NAME=Rifle2B FILE=Textures\Rifle2b.BMP GROUP=Rifle
#exec TEXTURE IMPORT NAME=Rifle2C FILE=Textures\Rifle2c.BMP GROUP=Rifle
#exec TEXTURE IMPORT NAME=Rifle2D FILE=Textures\Rifle2d.BMP GROUP=Rifle








#EXEC texture IMPORT NAME=crosshair FILE=Textures\crosshair.BMP MIPS=0 FLAGS=2

var int NumFire;
var name FireAnims[5];
var vector OwnerLocation;
var float StillTime, StillStart;
var bool bZoom;
var config color CColor;




simulated event PostNetBeginPlay()
{
   local Rifle_HUDMutator crosshair;
   local PlayerPawn HUDOwner;

   Super.PostNetBeginPlay();

   // If owner is the local player, check that the HUD Mutator exists. Also check for the presense of a bbPlayer (UTPure enabled)
   HUDOwner = PlayerPawn(Owner);
   if (HUDOwner != None && HUDOwner.IsA('bbPlayer') && HUDOwner.myHUD != None)
   {
      ForEach AllActors(Class'Rifle_HUDMutator', crosshair)
         break;
      if (crosshair == None)
      {
         crosshair = Spawn(Class'Rifle_HUDMutator', Owner);
         crosshair.RegisterHUDMutator();
         crosshair.HUDOwner = HUDOwner;
      }
   }
}

simulated function PostRender( canvas Canvas )
{
   local PlayerPawn P;
   //local float HudScale;
	local float Scale;
        local float Xlength;
        local float range;
        local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
        local actor Other;
        local float radpitch;




 Super.PostRender(Canvas);
   P = PlayerPawn(Owner);
   if ( (P != None) && (P.DesiredFOV != P.DefaultFOV) )
   {
	bOwnsCrossHair = true;

      if ( Level.bHighDetailMode )
         Canvas.Style = ERenderStyle.STY_Normal;
      else
         Canvas.Style = ERenderStyle.STY_Normal;

      // Square
      Canvas.SetPos( 3*Canvas.ClipX/7, 3*Canvas.ClipY/7 );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/7, Canvas.ClipY/7, 0, 0, 256, 193 );

      // Top Line
      Canvas.SetPos( 200*Canvas.ClipX/401, Canvas.ClipY/229*(90-P.DesiredFOV)+0.6*Canvas.ClipY/28 );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/401, Canvas.ClipY/28, 0, 20, 3, 10 );

      // Bottom Line
      Canvas.SetPos( 200*Canvas.ClipX/401, 15.35*Canvas.ClipY/28 + Canvas.ClipY/229*P.DesiredFOV );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/401, Canvas.ClipY/28, 0, 20, 3, 10 );

      // Left Line
      Canvas.SetPos( Canvas.ClipX/229*(90-P.DesiredFOV)+0.6*Canvas.ClipX/28, 200*Canvas.ClipY/401 );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/28, Canvas.ClipY/401, 10, 0, 10, 3 );

      // Right Line
      Canvas.SetPos( 15.35*Canvas.ClipX/28 + Canvas.ClipX/229*P.DesiredFOV, 200*Canvas.ClipY/401 );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/28, Canvas.ClipY/401, 10, 0, 10, 3 );

      // Dot
   //   Canvas.SetPos( (9*Canvas.ClipX/19) + (Canvas.ClipX/P.DesiredFOV/6), (9*Canvas.ClipY/19) + (Canvas.ClipY/P.DesiredFOV/6) );
   //   Canvas.DrawTile( Texture'crosshair',
   //      (Canvas.ClipX/19) - (Canvas.ClipX/P.DesiredFOV/3), (Canvas.ClipY/19) - (Canvas.ClipY/P.DesiredFOV/3), 0, 202, 53, 53 );
      Canvas.SetPos( 199.5*Canvas.ClipX/401, 199.5*Canvas.ClipY/401 );
      Canvas.DrawTile( Texture'crosshair', 2*Canvas.ClipX/401, 2*Canvas.ClipY/401, 0, 202, 53, 53 );

      // Top Gradient
      Canvas.SetPos( 200*Canvas.ClipX/401, 4*Canvas.ClipY/9 );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/401, Canvas.ClipY/1360*(90-P.DesiredFOV), 129, 197, 3, 54 );

      // Left Gradient
      Canvas.SetPos( 4*Canvas.ClipX/9, 200*Canvas.ClipY/401 );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/1360*(90-P.DesiredFOV), Canvas.ClipY/401, 69, 200, 54, 3 );

      //Bottom Gradient
      Canvas.SetPos( 200*Canvas.ClipX/401, 5*Canvas.ClipY/9 - Canvas.ClipY/1360*(90-P.DesiredFOV) );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/401, Canvas.ClipY/1360*(90-P.DesiredFOV), 144, 199, 3, 54 );

      //Right Gradient
      Canvas.SetPos( 5*Canvas.ClipX/9 - Canvas.ClipX/1360*(90-P.DesiredFOV), 200*Canvas.ClipY/401 );
      Canvas.DrawTile( Texture'crosshair', Canvas.ClipX/1360*(90-P.DesiredFOV), Canvas.ClipY/401, 163, 199, 54, 3 );

  // Calc range
        	XLength=255.0;
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
		if ((Pawn(Owner).ViewRotation.Pitch >= 0) && (Pawn(Owner).ViewRotation.Pitch <= 18000))
			radpitch = float(Pawn(Owner).ViewRotation.Pitch) / float(182) * (Pi/float(180));
		else
			radpitch = float(Pawn(Owner).ViewRotation.Pitch - 65535) / float(182) * (Pi/float(180));

		StartTrace = Owner.Location + Pawn(Owner).EyeHeight*Z*cos(radpitch);
	    	AdjustedAim = pawn(owner).AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);
		EndTrace = StartTrace +(20000 * vector(AdjustedAim));
		Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
		range = Vsize(StartTrace-HitLocation)/48-0.25;

         // Range Display
		Canvas.SetPos( 202*Canvas.ClipX/401-75, 4*Canvas.ClipY/7 + Canvas.ClipY/401 );
		Canvas.Font = Font'Botpack.WhiteFont';
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 0;
		Canvas.DrawColor.B = 0;
        Canvas.DrawText( "ZSZ"$int(range)$"."$int(10 * range -10 * int(range))$"");

		// Magnification Display
		Canvas.SetPos( 202*Canvas.ClipX/401, 4*Canvas.ClipY/7 + Canvas.ClipY/401 );
		Canvas.Font = Font'Botpack.WhiteFont';
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 0;
		Canvas.DrawColor.B = 0;
		Scale = P.DefaultFOV/P.DesiredFOV;
		Canvas.DrawText("ZOOM x"$int(Scale)$"."$int(10 * Scale - 10 * int(Scale)));
	}
	else
		bOwnsCrossHair = false;
}














function float RateSelf( out int bUseAltMode )
{
	local float dist;

	if ( AmmoType.AmmoAmount <=0 )
		return -2;

	bUseAltMode = 0;
	if ( (Bot(Owner) != None) && Bot(Owner).bSniping )
		return AIRating + 1.15;
	if (  Pawn(Owner).Enemy != None )
	{
		dist = VSize(Pawn(Owner).Enemy.Location - Owner.Location);
		if ( dist > 1200 )
		{
			if ( dist > 2000 )
				return (AIRating + 0.75);
			return (AIRating + FMin(0.0001 * dist, 0.45));
		}
	}
	return AIRating;
}

function setHand(float Hand)
{
	Super.SetHand(Hand);
	if ( Hand == 1 )
	{
		Mesh = mesh(DynamicLoadObject("Botpack.Rifle2mL", class'Mesh'));
	}
	else
	{
		Mesh = mesh'Rifle2m';
		MultiSkins[0] = Texture'ChamRifle_v1.Rifle.Rifle2a';
		MultiSkins[1] = Texture'ChamRifle_v1.Rifle.Rifle2b';
		MultiSkins[2] = Texture'ChamRifle_v1.Rifle.Rifle2c';
		MultiSkins[3] = Texture'ChamRifle_v1.Rifle.Rifle2d';

	}
}

simulated function PlayFiring()
{
	local int r;

	PlayOwnedSound(FireSound, SLOT_None, Pawn(Owner).SoundDampening*3.0);
	if ( (Owner.Physics != PHYS_Falling && Owner.Physics != PHYS_Swimming && Pawn(Owner).bDuck != 0)
	   || Owner.Velocity == 0 * Owner.Velocity )
		PlayAnim(FireAnims[/*Rand(5)*/4],3 + 3 * FireAdjust, 0.05);
	else
		PlayAnim(FireAnims[Rand(5)],0.3 + 0.3 * FireAdjust, 0.05);

	if ( (PlayerPawn(Owner) != None)
		&& (PlayerPawn(Owner).DesiredFOV == PlayerPawn(Owner).DefaultFOV) )
		bMuzzleFlash++;
}

simulated function bool ClientAltFire( float Value )
{
	PlayOwnedSound(Misc1Sound, SLOT_Misc, 1.0*Pawn(Owner).SoundDampening,,, Level.TimeDilation-0.1);
	GotoState('Zooming');
	return true;
}

function AltFire( float Value )
{
	PlayOwnedSound(Misc1Sound, SLOT_Misc, 1.0*Pawn(Owner).SoundDampening,,, Level.TimeDilation-0.1);
	ClientAltFire(Value);
}


function Fire( float Value )
{
	if ( (AmmoType == None) && (AmmoName != None) )
	{

		GiveAmmo(Pawn(Owner));
	}
	if ( AmmoType.UseAmmo(1) )
	{
		GotoState('NormalFire');
		bPointing=True;
		bCanClientFire = true;
		ClientFire(Value);
		if ( bRapidFire || (FiringSpeed > 0) )
			Pawn(Owner).PlayRecoil(FiringSpeed);
		if ( bInstantHit )
		{
			if ( (Owner.Physics != PHYS_Falling && Owner.Physics != PHYS_Swimming && Pawn(Owner).bDuck != 0)
		  || Owner.Velocity == 0 * Owner.Velocity )
				TraceFire(0.0);
		    else
				TraceFire(16);
		}
		else
		ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
	}
}

state NormalFire
{
	function EndState()
	{
		Super.EndState();
		OldFlashCount = FlashCount;
	}

Begin:
		FlashCount++;
}

function Timer()
{
	local actor targ;
	local float bestAim, bestDist;
	local vector FireDir;
	local Pawn P;

	bestAim = 0.95;
	P = Pawn(Owner);
	if ( P == None )
	{
		GotoState('');
		return;
	}
	if ( VSize(P.Location - OwnerLocation) < 6 )
		StillTime += FMin(2.0, Level.TimeSeconds - StillStart);

	else
		StillTime = 0;
	StillStart = Level.TimeSeconds;
	OwnerLocation = P.Location;
	FireDir = vector(P.ViewRotation);
	targ = P.PickTarget(bestAim, bestDist, FireDir, Owner.Location);
	if ( Pawn(targ) != None )
	{
		SetTimer(1 + 4 * FRand(), false);
		bPointing = true;
		Pawn(targ).WarnTarget(P, 200, FireDir);
	}
	else
	{
		SetTimer(0.4 + 1.6 * FRand(), false);
		if ( (P.bFire == 0) && (P.bAltFire == 0) )
			bPointing = false;
	}
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	/* local UT_Shellcase s;

	s = Spawn(class'UT_ShellCase',, '', Owner.Location + CalcDrawOffset() + 30 * X + (2.8 * FireOffset.Y+5.0) * Y - Z * 1);
	if ( s != None )
	{
		s.DrawScale = 2.0;
		s.Eject(((FRand()*0.3+0.4)*X + (FRand()*0.2+0.2)*Y + (FRand()*0.3+1.0) * Z)*160);
	} */


	if (Other == Level)
		Spawn(class'UT_HeavyWallHitEffect',,, HitLocation+HitNormal, Rotator(HitNormal));
	else if ( (Other != self) && (Other != Owner) && (Other != None) )
	{
		if ( Other.bIsPawn )
		{
			Other.PlaySound(Sound 'ChamRifle_v1.Rifle.HitSound',, 4.0,,100);
			Other.PlaySound(sound 'UnrealI.Razorjack.BladeThunk',, 4.0,,100);
			PlayOwnedSound(Sound 'ChamRifle_v1.Rifle.HitSound',, 4.0,,10);
		}
		if ( Other.bIsPawn && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight)
		&& (instigator.IsA('PlayerPawn') || (instigator.IsA('Bot') && !Bot(Instigator).bNovice))
		&& ((Owner.Physics != PHYS_Falling && Owner.Physics != PHYS_Swimming && Pawn(Owner).bDuck != 0)
		|| Owner.Velocity == 0 * Owner.Velocity) )
		{
			if ( Pawn(Other).Health > 0 )
			{
				Other.TakeDamage(100000, Pawn(Owner), HitLocation, 35000 * X, AltDamageType);

				if ( Pawn(Other).Health < 1
				    && (!Level.Game.bTeamGame || Pawn(Owner).PlayerReplicationInfo.Team != Pawn(Other).PlayerReplicationInfo.Team) )
					AmmoType.AddAmmo(3);
			}
			else
				Other.TakeDamage(100000, Pawn(Owner), HitLocation, 35000 * X, AltDamageType);
		}
		else
			Other.TakeDamage(45,  Pawn(Owner), HitLocation, 30000.0*X, MyDamageType);

		if ( !Other.bIsPawn && !Other.IsA('Carcass') )
			spawn(class'UT_SpriteSmokePuff',,,HitLocation+HitNormal*9);
	}
}

function Finish()
{
	if ( (Pawn(Owner).bFire!=0) && (FRand() < 0.6) )
		Timer();
	Super.Finish();
}

function TraceFire( float Accuracy )
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local Pawn PawnOwner;

	PawnOwner = Pawn(Owner);

	Owner.MakeNoise(PawnOwner.SoundDampening);
	GetAxes(PawnOwner.ViewRotation,X,Y,Z);
	StartTrace = Owner.Location + PawnOwner.Eyeheight * Z;
	AdjustedAim = PawnOwner.AdjustAim(1000000, StartTrace, 2*AimError, False, False);
	EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
		+ Accuracy * (FRand() - 0.5 ) * Z * 1000;
	X = vector(AdjustedAim);
	EndTrace += (100000 * X);
	Other = PawnOwner.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
	ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
}


state Idle
{
	function Fire( float Value )
	{
		if ( AmmoType == None )
		{

			GiveAmmo(Pawn(Owner));
		}
		if (AmmoType.UseAmmo(1))
		{
			GotoState('NormalFire');
			bCanClientFire = true;
			bPointing=True;
			if ( Owner.IsA('Bot') )
			{
				if ( Bot(Owner).bSniping && (FRand() < 0.65) )
					AimError = AimError/FClamp(StillTime, 1.0, 8.0);
				else if ( VSize(Owner.Location - OwnerLocation) < 6 )
					AimError = AimError/FClamp(0.5 * StillTime, 1.0, 3.0);
				else
					StillTime = 0;
			}
			Pawn(Owner).PlayRecoil(FiringSpeed);
			if ( (Owner.Physics != PHYS_Falling && Owner.Physics != PHYS_Swimming && Pawn(Owner).bDuck != 0)
			   || Owner.Velocity == 0 * Owner.Velocity )
				TraceFire(0.0);
			else
				TraceFire(0.0);
			AimError = Default.AimError;
			ClientFire(Value);
		}
	}


	function BeginState()
	{
		bPointing = false;
		SetTimer(0.4 + 1.6 * FRand(), false);
		Super.BeginState();
	}

	function EndState()
	{
		SetTimer(0.0, false);
		Super.EndState();
	}

Begin:
	bPointing=False;
	if ( AmmoType.AmmoAmount<=0 )
		Pawn(Owner).SwitchToBestWeapon();
	if ( Pawn(Owner).bFire!=0 ) Fire(0.0);
	Disable('AnimEnd');
	PlayIdleAnim();
}

state Zooming
{
	simulated function Tick(float DeltaTime)
	{
		if ( Pawn(Owner).bAltFire == 0 )
		{
			if ( (PlayerPawn(Owner) != None) && PlayerPawn(Owner).Player.IsA('ViewPort') )
				PlayerPawn(Owner).StopZoom();
                                PlayOwnedSound(Misc2Sound, SLOT_Misc, 1.0*Pawn(Owner).SoundDampening,,, Level.TimeDilation-0.1);
			bZoom = false;
			SetTimer(0.0,False);
			GoToState('Idle');
		}
		else if ( bZoom )
		{
			if ( PlayerPawn(Owner).DesiredFOV > 3.0 )
			{
				PlayerPawn(Owner).DesiredFOV -= PlayerPawn(Owner).DesiredFOV*DeltaTime*3.4;
			}

			if ( PlayerPawn(Owner).DesiredFOV <=3.0 )
			{
				PlayerPawn(Owner).DesiredFOV = 3.0;
				bZoom = false;
				SetTimer(0.0,False);
				GoToState('Idle');
			}
		}
	}
	simulated function BeginState()
	{
		if ( Owner.IsA('PlayerPawn') )
		{
			if ( PlayerPawn(Owner).DesiredFOV == PlayerPawn(Owner).DefaultFOV )
			{
				bZoom = true;
				SetTimer(0.2,True);
			}
			else if ( bZoom == false )
			{
				PlayerPawn(Owner).DesiredFOV = PlayerPawn(Owner).DefaultFOV;
				Pawn(Owner).bAltFire = 0;
			}
		}
		else
		{
			Pawn(Owner).bFire = 1;
			Pawn(Owner).bAltFire = 0;
			Global.Fire(0);
		}
	}
}

simulated function PlayIdleAnim()
{
	if ( Mesh != PickupViewMesh )
		PlayAnim('Still',1.0, 0.05);
}

function SetWeaponStay()
{
	bWeaponStay = false;
}

defaultproperties
{
    FireAnims(0)=Fire
    FireAnims(1)=Fire2
    FireAnims(2)=Fire3
    FireAnims(3)=Fire4
    FireAnims(4)=Fire5
    WeaponDescription="ChamRifle_v1"
    AmmoName=Class'CustomBullets'
    PickupAmmoCount=200
    bInstantHit=True
    bAltInstantHit=True
    FiringSpeed=1.60
    FireOffset=(X=0.00,Y=-5.00,Z=-2.00),
    MyDamageType=shot
    AltDamageType=Decapitated
    shakemag=0.00
    shaketime=0.00
    shakevert=0.00
    AIRating=0.54
    RefireRate=0.99
    AltRefireRate=0.30
    FireSound=Sound'ChamRifle_v1.Rifle.Fire'
    SelectSound=Sound'ChamRifle_v1.Rifle.WhippingSound'
    Misc1Sound=Sound'ChamRifle_v1.Rifle.zoomstart'
    Misc2Sound=Sound'ChamRifle_v1.Rifle.zoomstop'
    DeathMessage="%k FuckedUp %o with the sexy Rifle. "
    NameColor=(R=0,G=0,B=255,A=0),
    bDrawMuzzleFlash=True
    MuzzleScale=1.00
    FlashY=0.11
    FlashO=0.01
    FlashC=0.03
    FlashLength=0.01
    FlashS=256
    AutoSwitchPriority=5
    InventoryGroup=10
    PickupMessage="You picked up the Rifle!"
    ItemName="Green Rifle"
    PlayerViewOffset=(X=5.00,Y=-1.60,Z=-1.70),
    PlayerViewMesh=LodMesh'Botpack.Rifle2m'
    PlayerViewScale=2.00
    BobDamping=0.98
    PickupViewMesh=LodMesh'Pickupmeshp'
    ThirdPersonMesh=LodMesh'PickupmeshH'
    StatusIcon=Texture'Botpack.Icons.UseRifle'
    bMuzzleFlashParticles=True
    MuzzleFlashMesh=LodMesh'Botpack.muzzsr3'
    MuzzleFlashScale=0.10
    MuzzleFlashTexture=Texture'Botpack.Skins.Muzzy3'
    PickupSound=Sound'ChamRifle_v1.Rifle.RiflePickup'
    Icon=Texture'Botpack.Icons.UseRifle'
    Rotation=(Pitch=0,Yaw=0,Roll=-1536),
    Mesh=LodMesh'Botpack.RiflePick'
    bNoSmooth=False
    CollisionRadius=32.00
    CollisionHeight=8.00
}
