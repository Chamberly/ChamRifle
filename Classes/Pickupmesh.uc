class Pickupmesh extends actor;

#exec mesh IMPORT MESH=Pickupmeshp ANIVFILE=Models\Pickupmeshp_a.3d DATAFILE=Models\Pickupmeshp_d.3d X=0 Y=0 Z=0
#exec mesh ORIGIN MESH=Pickupmeshp X=0 Y=0 Z=0 YAW=64
#exec mesh SEQUENCE MESH=Pickupmeshp SEQ=All         STARTFRAME=0   NUMFRAMES=1
#exec mesh SEQUENCE MESH=Pickupmeshp SEQ=Still        STARTFRAME=0   NUMFRAMES=1
#exec texture IMPORT NAME=rifletex FILE=Textures\rifletex.BMP GROUP=Skins LODSET=2
#exec MESHMAP scale MESHMAP=Pickupmeshp X=0.07 Y=0.07 Z=0.14

#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshP NUM=0 TEXTURE=rifletex
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshP NUM=1 TEXTURE=rifletex
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshP NUM=2 TEXTURE=rifletex
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshP NUM=3 TEXTURE=rifletex
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshP NUM=4 TEXTURE=rifletex

#exec mesh IMPORT MESH=PickupmeshH ANIVFILE=Models\PickupmeshH_a.3d DATAFILE=Models\PickupmeshH_d.3d X=0 Y=0 Z=0

#exec mesh ORIGIN MESH=PickupmeshH X=-150 Y=0 Z=-30 YAW=255 PITCH=0 ROLL=0
#exec mesh SEQUENCE MESH=PickupmeshH SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP scale MESHMAP=PickupmeshH X=0.07 Y=0.07 Z=0.14
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshH NUM=0 TEXTURE=rifletex
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshH NUM=1 TEXTURE=rifletex
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshH NUM=2 TEXTURE=rifletex
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshH NUM=3 TEXTURE=rifletex
#exec MESHMAP SETTEXTURE MESHMAP=PickupmeshH NUM=4 TEXTURE=rifletex

defaultproperties
{
}
