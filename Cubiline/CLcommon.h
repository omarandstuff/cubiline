#ifndef Cubiline_CLcommon_h
#define Cubiline_CLcommon_h

#import "CLdata.h"
#import "VEads.h"
#import "VEinapppurchase.h"
#import "VErenderbox.h"
#import "VEaudiobox.h"
#import "CLlanguage.h"

enum CL_ZONE
{
	CL_ZONE_FRONT,
	CL_ZONE_BACK,
	CL_ZONE_RIGHT,
	CL_ZONE_LEFT,
	CL_ZONE_TOP,
	CL_ZONE_BOTTOM,
	CL_ZONE_NUMBER
};

enum CL_TURN
{
	CL_TURN_NONE,
	CL_TURN_UP,
	CL_TURN_UP_RIGHT,
	CL_TURN_UP_LEFT,
	CL_TURN_DOWN,
	CL_TURN_DOWN_RIGHT,
	CL_TURN_DOWN_LEFT,
	CL_TURN_RIGHT,
	CL_TURN_RIGHT_UP,
	CL_TURN_RIGHT_DOWN,
	CL_TURN_LEFT,
	CL_TURN_LEFT_UP,
	CL_TURN_LEFT_DOWN
};

enum CL_HANDLE
{
	CL_HANDLE_NONE,
	CL_HANDLE_FRONT,
	CL_HANDLE_FRONT_RIGHT,
	CL_HANDLE_FRONT_LEFT,
	CL_HANDLE_FRONT_TOP,
	CL_HANDLE_FRONT_BOTTOM,
	CL_HANDLE_BACK,
	CL_HANDLE_BACK_RIGHT,
	CL_HANDLE_BACK_LEFT,
	CL_HANDLE_BACK_TOP,
	CL_HANDLE_BACK_BOTTOM,
	CL_HANDLE_RIGHT,
	CL_HANDLE_RIGHT_FRONT,
	CL_HANDLE_RIGHT_BACK,
	CL_HANDLE_RIGHT_TOP,
	CL_HANDLE_RIGHT_BOTTOM,
	CL_HANDLE_LEFT,
	CL_HANDLE_LEFT_FRONT,
	CL_HANDLE_LEFT_BACK,
	CL_HANDLE_LEFT_TOP,
	CL_HANDLE_LEFT_BOTTOM,
	CL_HANDLE_TOP,
	CL_HANDLE_TOP_FRONT,
	CL_HANDLE_TOP_BACK,
	CL_HANDLE_TOP_RIGHT,
	CL_HANDLE_TOP_LEFT,
	CL_HANDLE_BOTTOM,
	CL_HANDLE_BOTTOM_FRONT,
	CL_HANDLE_BOTTOM_BACK,
	CL_HANDLE_BOTTOM_RIGHT,
	CL_HANDLE_BOTTOM_LEFT
	
};

enum CL_SIZE
{
	CL_SIZE_SMALL,
	CL_SIZE_NORMAL,
	CL_SIZE_BIG,
	CL_SIZE_EXTRA
};

enum CL_MAIN_MENU_SELECTION
{
	CL_MAIN_MENU_SELECTION_NONE,
	CL_MAIN_MENU_SELECTION_PLAY,
	CL_MAIN_MENU_SELECTION_LOBY,
	CL_MAIN_MENU_SELECTION_GC,
	CL_MAIN_MENU_SELECTION_HOWTO,
	CL_MAIN_MENU_SELECTION_ABOUT
};

enum CL_GRAPHICS
{
	CL_GRAPHICS_VERYLOW,
	CL_GRAPHICS_LOW,
	CL_GRAPHICS_MEDIUM,
	CL_GRAPHICS_HIGH
};

struct rect
{
	float top;
	float bottom;
	float right;
	float left;
};
//#define PrimaryColor GLKVector3Make(0.1372f, 0.1568f, 0.1647f)
//#define SecundaryColor GLKVector3Make(0.4705f, 0.5294f, 0.5490f)
//#define TertiaryColor GLKVector3Make(0.3f, 0.35f, 0.4f) (0.1372f, 0.1568f, 0.1647f, 1.0f)

#define ColorWhite GLKVector3Make(1.0f, 1.0f, 1.0f)
#define ColorCubiline GLKVector3Make(0.9f, 0.93f, 0.93f)
#define ColorBlack GLKVector3Make(0.0f, 0.0f, 0.0f)

#define PrimaryColor GLKVector3Make(0.3f, 0.35f, 0.4f)
#define SecundaryColor GLKVector3Make(0.1372f, 0.1568f, 0.1647f)
#define TertiaryColor GLKVector3Make(1.0f, 1.0f, 1.0f)
#define BackgroundColor GLKVector4Make(0.9f, 0.93f, 0.93f, 0.0f)
#define TextColor GLKVector3Make(0.3f, 0.35f, 0.4f)

#define GrayColor GLKVector3Make(0.3f, 0.35f, 0.4f)

#define FrontColor GLKVector3Make(0.0f, 0.76f, 1.0f)
#define BackColor GLKVector3Make(0.35f, 0.15f, 0.62f)
#define RightColor GLKVector3Make(0.0f, 1.0f, 0.4f)
#define LeftColor GLKVector3Make(1.0f, 0.36f, 0.0f)
#define TopColor GLKVector3Make(1.0f, 0.96f, 0.0f)
#define BottomColor GLKVector3Make(1.0f, 0.12f, 0.12f)

#define SmallSizeVector GLKVector3Make(9.0f, 9.0f, 9.0f)
#define NormalSizeVector GLKVector3Make(15.0f, 15.0f, 15.0f)
#define BigSizeVector GLKVector3Make(21.0f, 21.0f, 21.0f)
#define ExtraSizeVector GLKVector3Make(27.0f, 27.0f, 27.0f)

#define GuidesSmallSizeVector GLKVector3Make(9.01f, 9.01f, 9.01f)
#define GuidesNormalSizeVector GLKVector3Make(15.01f, 15.01f, 15.01f)
#define GuidesBigSizeVector GLKVector3Make(21.01f, 21.01f, 21.01f)
#define GuidesExtraSizeVector GLKVector3Make(27.01f, 27.01f, 27.01f)

#define SmallSizeLimit 4.5f
#define NormalSizeLimit 7.5f
#define BigSizeLimit 10.5f
#define ExtraSizeLimit 13.5f

#define CommonButtonStyle(Button) Button.Opasity = 0.0f; Button.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH; Button.OpasityTransitionTime = 0.13f; Button.LockAspect = true; Button.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH; Button.ScaleTransitionTime = 0.1f

#define CommonTextStyle(Text) Text.Color = TextColor; Text.Opasity = 0.0f; Text.OpasityTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH; Text.OpasityTransitionTime = 0.13f; Text.ScaleTransitionEffect = VE_TRANSITION_EFFECT_END_SUPER_SMOOTH; Text.ScaleTransitionTime = 0.1f

#endif
