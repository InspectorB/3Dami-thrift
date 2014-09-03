namespace c_glib usage
namespace java wire.data
namespace cpp wire.data
namespace js wire.data
namespace py wire.data

namespace * wire.data

struct NoData
{
//  1: optional bool empty = 1,
}

struct SessionStart
{
  1: optional map<string, string> properties,
  2: optional i16 blenderVersion,
  3: optional i16 blenderSubversion,
  4: optional string os,
  5: optional string osVersion,
  6: optional i16 resolutionX,
  7: optional i16 resolutionY,
  8: optional bool gui,
  9: optional i16 numDisplays,
  10: optional string sessionKey, /* a uuid, to be repeated in the SessionEnd message */
}

struct SessionEnd
{
  1: optional string sessionKey,
}

union RNAPropertyData
{
  1: bool valueBoolean,
  2: list<bool> listBoolean,
  3: i32 valueInt,
  4: list<i32> listInt,
  5: double valueDouble,
  6: list<double> listDouble,
  7: string valueString,
  8: string valueEnum,
  9: set<string> listEnum,
  10: string valuePointer, /* TODO: This should be elaborated on */
  11: list<string> collection, /* TODO: this should be elaborated on */
}


/**
  * `type` is set to -1 for unknown types
  * `length` is set to -1 for unknown values where the type is known
  *
  
  type:
  
  PROP_BOOLEAN      = 0,
  PROP_INT          = 1,
  PROP_FLOAT        = 2,
  PROP_STRING       = 3,
  PROP_ENUM         = 4,
  PROP_POINTER      = 5,
  PROP_COLLECTION   = 6,
  
  subtype:
  
  PROP_NONE              = 0,

  PROP_FILEPATH          = 1,
  PROP_DIRPATH           = 2,
  PROP_FILENAME          = 3,
  PROP_BYTESTRING        = 4,
  PROP_PASSWORD          = 6,

  PROP_PIXEL             = 12,
  PROP_UNSIGNED          = 13,
  PROP_PERCENTAGE        = 14,
  PROP_FACTOR            = 15,
  PROP_ANGLE             = 16 | PROP_UNIT_ROTATION,
  PROP_TIME              = 17 | PROP_UNIT_TIME,
  PROP_DISTANCE          = 18 | PROP_UNIT_LENGTH,
  PROP_DISTANCE_CAMERA   = 19 | PROP_UNIT_CAMERA,

  PROP_COLOR             = 20,
  PROP_TRANSLATION       = 21 | PROP_UNIT_LENGTH,
  PROP_DIRECTION         = 22,
  PROP_VELOCITY          = 23 | PROP_UNIT_VELOCITY,
  PROP_ACCELERATION      = 24 | PROP_UNIT_ACCELERATION,
  PROP_MATRIX            = 25,
  PROP_EULER             = 26 | PROP_UNIT_ROTATION,
  PROP_QUATERNION        = 27,
  PROP_AXISANGLE         = 28,
  PROP_XYZ               = 29,
  PROP_XYZ_LENGTH        = 29 | PROP_UNIT_LENGTH,
  PROP_COLOR_GAMMA       = 30,
  PROP_COORDS            = 31,

  PROP_LAYER             = 40,
  PROP_LAYER_MEMBER      = 41,
  **/
struct RNAProperty
{
  1: optional string identifier,
  2: optional i16 type,
  5: optional i16 subtype,
  3: optional i16 length,
  4: optional RNAPropertyData data,
}

struct Object
{
  1: optional bool selected,
  2: optional bool active,
  3: optional string name,
  4: optional i16 type,
  5: optional string baseAddress,   /* base pointer address */
  6: optional string objectAddress, /* object pointer address, used for parent linking */
  7: optional i16 parentType,       /* don't set if there's no parent */
  8: optional string parentAddress, /* don't set if there's no parent */
}

/* RegionView3D */
struct ViewOrientation
{
  1: optional list<double> offset,    /* view center: x, y, z */
  2: optional double distance,        /* distance from center */
  3: optional list<double> viewquat, /* normalized view quaternion: w, x, y, z */

  4: optional double camzoom,
  5: optional double camdx,
  6: optional double camdy,

  7: optional bool is_persp,       /* false for orthogonal, true for perspective */
  8: optional byte persp,          /* 0 for ortho, 1 for persp, 2 for camera */
  9: optional byte view,           /* check source for RV3D_VIEW_* */

  10: optional bool is_local,      /* true for local view */
}

struct Context
{
  1: optional string windowName,
  2: optional string windowAddress,
  3: optional string screenName,
  4: optional string screenAddress,
  5: optional i16 spaceType,
  6: optional string spaceAddress,
  7: optional i16 regionType,
  8: optional string regionAddress,
  9: optional string dataMode,
  10: optional string sceneName,
  11: optional string sceneAddress,

  40: optional ViewOrientation viewOrientation,
  50: optional list<Object> visibleObjects,
}

struct Report
{
  1: optional i16 type,
  2: optional i32 flag,
  3: optional string typestr,
  4: optional string message,
}

struct WmOp
{
  1: optional string operatorId,
  2: optional list<RNAProperty> properties,
  3: optional string pythonRepresentation,
  4: optional string screenshotHash,
  5: optional Context context,
  6: optional bool repeat,                  /* when an operator is a redo then repeat is true */
  7: optional i32 retval,                   /* 2 = cancelled, 4 = finished (OPERATOR_*) */
  8: optional list<Report> reports,
}

struct WmTabletData
{
  1: optional i32 active,
  2: optional double pressure,
  3: optional double xtilt,
  4: optional double ytilt,
}

struct WmEv
{
  1: optional i16 type,
  2: optional i16 value, /* can't use val, because it conflicts with generated code */
  3: optional i32 x,
  4: optional i32 y,
  5: optional i32 mval1,
  6: optional i32 mval2,
  7: optional string character, /* either utf8_buf, or ascii */
  8: optional i16 prevtype,
  9: optional i16 prevval,
  10: optional i32 prevx,
  11: optional i32 prevy,
  12: optional double prevclicktime,
  13: optional i32 prevclickx,
  14: optional i32 prevclicky,
  15: optional i16 shift,
  16: optional i16 ctrl,
  17: optional i16 alt,
  18: optional i16 oskey,
  19: optional i16 keymodifier,
  20: optional i16 check_click,
  21: optional string keymap_idname,
  22: optional WmTabletData tablet_data,
  /* skipping custom data for now */
}

/**
 * We'll use a special type for mouse moves. One the one hand we would like to
 * keep all mouse movement data, but sending a message for each one results in
 * too much data. Therefore we will accumulate the mouse movements and send them
 * in one go once a non-mouse-movement WmEv is registered. The event->type == 4 (MOUSEMOVE)
 * for mouse movements.
 */

struct MouseMove
{
  1: optional i64 timestamp,
  2: optional i32 x,
  3: optional i32 y,
}

struct WmEvMouseMoves
{
  1: optional list<MouseMove> moves,
}

/**
 * For an a button press
 *
 * Note that it's hard to introspect a uiBut without including "interface_intern.h".
 * I'll look into it if necessary, for now registering a button press is good enough.
 */
struct ButPress 
{
  // 1: optional i32 type,
  // 2: optional i32 pointerType,
  // 3: optional string str,
  // 4: optional string strdata,
  // 5: optional string drawstr,
  // 6: optional string poin,      /* pointer, perhaps this can be used to identify the button */
  // 7: optional string func,      /* pointer, perhaps this can be used to identify the button */
  // 8: optional string funcN,     /* pointer, perhaps this can be used to identify the button */
  // 9: optional string tip,       /* tooltip */
}

struct Assignment
{
  1: optional string pythonRepresentation,
  2: optional RNAProperty property,
}

/*
 N.B. make sure that the field names are decapitalized versions
 of the type names, otherwise the scala introspection can't
 find the right type id.
*/
union Data
{
  1: NoData noData,
  2: SessionStart sessionStart,
  3: WmOp wmOp,
  4: WmEv wmEv,
  5: ButPress butPress,
  6: Assignment assignment,
  7: SessionEnd sessionEnd,
  8: WmEvMouseMoves wmEvMouseMoves,
}

