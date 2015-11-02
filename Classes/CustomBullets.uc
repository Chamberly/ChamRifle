class CustomBullets extends TournamentAmmo;

#EXEC AUDIO IMPORT name=AmmoPick FILE=sounds\AmmoPick.wav GROUP=Rifle
#exec TEXTURE IMPORT NAME=Ammo FILE=Textures\Ammo.BMP GROUP=Rifle

defaultproperties
{
    AmmoAmount=200
    MaxAmmo=200
    UsedInWeaponSlot(9)=1
    PickupMessage="Feed them some bullets!"
    ItemName="ChamRifle_v1 Rifle Rounds"
    PickupViewMesh=LodMesh'Botpack.BulletBoxM'
    MaxDesireability=0.24
    PickupSound=Sound'ChamRifle_v1.Rifle.AmmoPick'
    Icon=Texture'UnrealI.Icons.I_RIFLEAmmo'
    Skin=Texture'Botpack.Skins.BulletBoxT'
    Mesh=LodMesh'Botpack.BulletBoxM'
    MultiSkins(0)=Texture'ChamRifle_v1.Rifle.Ammo'
    MultiSkins(1)=Texture'ChamRifle_v1.Rifle.Ammo'
    MultiSkins(2)=Texture'ChamRifle_v1.Rifle.Ammo'
    MultiSkins(3)=Texture'ChamRifle_v1.Rifle.Ammo'
    MultiSkins(4)=Texture'ChamRifle_v1.Rifle.Ammo'
    MultiSkins(5)=Texture'ChamRifle_v1.Rifle.Ammo'
    MultiSkins(6)=Texture'ChamRifle_v1.Rifle.Ammo'
    MultiSkins(7)=Texture'ChamRifle_v1.Rifle.Ammo'
    CollisionRadius=15.00
    CollisionHeight=10.00
    bCollideActors=True
}
