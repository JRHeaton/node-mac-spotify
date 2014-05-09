//
//  module.cc
//  mac-spotify
//
//  Created by John Heaton on 5/9/14.
//  Copyright (c) 2014 John Heaton. All rights reserved.
//

#include <node/node.h>
#include <node/v8.h>

#include "SpotifyApp.h"

// Macros
#define Function(impl) Helper::Func([](const FunctionCallbackInfo<Value>& info) { (impl); })
#define DYNAMIC_PROPERTY(name, sel, typeName, type) exports->SetAccessorProperty(Helper::String(name), Function({ \
info.GetReturnValue().Set((type)App().sel); }), Function({ \
App().sel = info[0]->To##typeName()->Value(); }))

// Constants
#define kSpotifyBundleID "com.spotify.client"

using namespace v8;

namespace MacSpotify {

  // V8 helper
  namespace Helper {
    static inline Handle<String> String(const char *val) {
      return v8::String::NewFromUtf8(Isolate::GetCurrent(), val);
    }
    static inline Handle<Function> Func(FunctionCallback impl) {
      return Function::New(Isolate::GetCurrent(), impl);
    }
    static inline NSString *NSStringFromJS(Handle<v8::Value> val) {
      return @(*(v8::String::Utf8Value(val->ToString())));
    }
  }

  // Dumped from sdef/sdp for ObjC wrapper around AE
  SPApplication *App() { return (SPApplication *)[SBApplication applicationWithBundleIdentifier:@kSpotifyBundleID]; }

  static void InitModule(Handle<Object> exports,
                         Handle<Value>  module,
                         void*          priv) {

    // track control
    exports->Set(Helper::String("play"),      Function({ [App() play];          }));
    exports->Set(Helper::String("pause"),     Function({ [App() pause];         }));
    exports->Set(Helper::String("playpause"), Function({ [App() playpause];     }));
    exports->Set(Helper::String("next"),      Function({ [App() nextTrack];     }));
    exports->Set(Helper::String("previous"),  Function({ [App() previousTrack]; }));

    // playing specific tracks
    exports->Set(Helper::String("playTrack"), Function({
      if (!info.Length() or !(info[0]->IsString())) {
        Isolate::GetCurrent()->ThrowException(Exception::Error(Helper::String("ERR: no track URI specified.")));
      } else {
        NSString *ctx (info.Length() > 1 ? Helper::NSStringFromJS(info[1]) : nil);
        [App() playTrack:Helper::NSStringFromJS(info[0]) inContext:ctx];
      }
    }));

    // properties
    DYNAMIC_PROPERTY("volume",    soundVolume,  Integer, int32_t);
    DYNAMIC_PROPERTY("shuffling", shuffling,    Boolean, bool);
    DYNAMIC_PROPERTY("repeating", repeating,    Boolean, bool);

    // track info
//    exports->Set(Helper::String("currentTrack"), Function({
//      SPTrack *track = App().currentTrack;
//      if (track) {
//        auto ret = Object::New(Isolate::GetCurrent());
//
//      }
//    }));
  }
};

NODE_MODULE(macspotify, MacSpotify::InitModule)