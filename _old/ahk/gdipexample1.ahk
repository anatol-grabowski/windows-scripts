
#include libs\gdip\Gdip.ahk
#include libs\gdip\GdipHelper.ahk

h::
	draw()
return

draw() {
	SetUpGDIP()
	StartDrawGDIP()
	ClearDrawGDIP()

	Gdip_SetSmoothingMode(G, 4)

	pBrush := Gdip_BrushCreateSolid(0x660000ff)
	Gdip_FillRectangle(G, pBrush, 250, 80, 300, 200)
	Gdip_DeleteBrush(pBrush)

	EndDrawGDIP()
}