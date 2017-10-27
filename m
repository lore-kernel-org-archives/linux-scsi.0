From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2] target/iscsi: Convert timers to use timer_setup()
Date: Fri, 27 Oct 2017 12:57:16 +0000
Message-ID: <1509109031.3135.1.camel@wdc.com>
References: <20171027091930.GA14728@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20171027091930.GA14728@beast>
Content-Language: en-US
Content-ID: <21992BEF2662F4469E182F065BE27AEF@namprd04.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "keescook@chromium.org" <keescook@chromium.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

T24gRnJpLCAyMDE3LTEwLTI3IGF0IDAyOjE5IC0wNzAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IElu
IHByZXBhcmF0aW9uIGZvciB1bmNvbmRpdGlvbmFsbHkgcGFzc2luZyB0aGUgc3RydWN0IHRpbWVy
X2xpc3QgcG9pbnRlciB0bw0KPiBhbGwgdGltZXIgY2FsbGJhY2tzLCBzd2l0Y2ggdG8gdXNpbmcg
dGhlIG5ldyB0aW1lcl9zZXR1cCgpIGFuZCBmcm9tX3RpbWVyKCkNCj4gdG8gcGFzcyB0aGUgdGlt
ZXIgcG9pbnRlciBleHBsaWNpdGx5LiBJbmNsdWRlcyBhIGZpeCBmb3IgY29ycmVjdGluZyBhbg0K
PiBvbi1zdGFjayB0aW1lciB1c2FnZS4NCg0KSGVsbG8gS2VlcywNCg0KVGhlc2UgY2hhbmdlcyBs
b29rIGdvb2QgdG8gbWUgYnV0IEkgd291bGQgbGlrZSB0byB0ZXN0IHRoaXMgcGF0Y2guIElzIHRo
ZXJlDQphIHRyZWUgYXZhaWxhYmxlIHNvbWV3aGVyZSB0aGF0IGluY2x1ZGVzIHRoaXMgcGF0Y2g/
DQoNClRoYW5rcywNCg0KQmFydC4=
