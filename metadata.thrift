namespace c_glib usage
namespace java wire.metadata
namespace cpp wire.metadata
namespace js wire.metadata
namespace py wire.metadata

namespace * wire.metadata

struct NoMetadata
{
//  1: optional bool empty = 1,
}

struct OnlyUser
{
  1: optional i64 user,
}

struct SessionKey
{
  1: optional string sessionKey,
}

/*
 N.B. make sure that the field names are decapitalized versions
 of the type names, otherwise the scala introspection can't
 find the right type id.
*/
union Metadata
{
  1: NoMetadata noMetadata,
  2: OnlyUser onlyUser,
  3: SessionKey sessionKey,
}