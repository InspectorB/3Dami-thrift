include "data.thrift"
include "metadata.thrift"

namespace c_glib usage
namespace java wire
namespace cpp wire
namespace js wire
namespace py wire

namespace * wire

/*
The Message struct is used to send a Metadata and Data pair over the network. It is saved directly in a file, but preceded by a non-thrift header that describes the Message block. This description includes type information about the metadata and data types, the user id, the client timestamp and the server timestamp

 timestamp: the client's local time in milliseconds
 user: the user id, corresponds to the toc website userid
 token: the user token, a bit like an api key - 36 character UUID
 */
struct Message
{
  1: optional metadata.Metadata metadata,
  2: optional data.Data data,
  3: optional i64 user,
  4: optional i64 timestamp,
  5: optional string token,
}

/*
The Screenshot struct is used to send a jpeg formatted image. The message isn't saved to disk, only the image.
 */
struct Screenshot
{
  1: optional string token,         // user token
  2: optional string hash,          // hash for the screenshot, so that it can be linked to other objects
  3: optional binary screenshot,    // jpeg data
  4: optional i64 timestamp,
  5: optional i16 subdivisions,
}

exception Unavailable
{
  1: string message
}

exception UnknownToken
{
  1: string message
}

exception IncorrectlyFormattedMessage
{
  1: string message
}

exception ScreenshotHashNotUnique
{
  1: string message
}

service TocService
{
  void sendMessage(1:Message message) throws (1:Unavailable unavailable, 2: UnknownToken unknownToken, 3: IncorrectlyFormattedMessage incorrectlyFormattedMessage)
  void sendScreenshot(1:Screenshot screenshot) throws (1:Unavailable unavailable, 2: UnknownToken unknownToken, 3: IncorrectlyFormattedMessage incorrectlyFormattedMessage, 4: ScreenshotHashNotUnique screenshotHashNotUnique)
  void ping() throws (1:Unavailable unavailable)
}





/*
 The Wander service
 */

// Used to represent the header structs in the files
struct Header 
{
  1: optional i64 timestampServer,
  2: optional i64 timestampClient,
  3: optional i64 user,
}

struct File
{
  1: optional string name,
  2: optional i64 lastModified,
  3: optional string relativePath,
}

struct Files
{
  1: optional list<File> files
}

struct HeaderAndMessage
{
  1: optional Header header,
  2: optional Message message,
}

exception NoMoreMessages {}

service WanderService
{
  void ping()
  HeaderAndMessage getNextMessage() throws (1: NoMoreMessages noMoreMessages)
  HeaderAndMessage getPreviousMessage() throws (1: NoMoreMessages noMoreMessages)
  string getWmOpScreenshotURL(1: i64 user, 2: i64 timestamp, 3: string hash)
  Files getFiles()
}
