From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH v2] target/iscsi: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 17:16:26 +0000
Message-ID: <1509470185.12927.1.camel@wdc.com>
References: <20171027091930.GA14728@beast> <1509109031.3135.1.camel@wdc.com>
         <CAGXu5j+z9t28n33e6r9hxRNX1hpkzF4Z5sy308sWYh84whkRfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5j+z9t28n33e6r9hxRNX1hpkzF4Z5sy308sWYh84whkRfQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <5E0796C106C4694889FA563329B3FBDA@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "keescook@chromium.org" <keescook@chromium.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

T24gTW9uLCAyMDE3LTEwLTMwIGF0IDE3OjA0IC0wNzAwLCBLZWVzIENvb2sgd3JvdGU6DQo+IE9u
IEZyaSwgT2N0IDI3LCAyMDE3IGF0IDU6NTcgQU0sIEJhcnQgVmFuIEFzc2NoZSA8QmFydC5WYW5B
c3NjaGVAd2RjLmNvbT4gd3JvdGU6DQo+ID4gT24gRnJpLCAyMDE3LTEwLTI3IGF0IDAyOjE5IC0w
NzAwLCBLZWVzIENvb2sgd3JvdGU6DQo+ID4gPiBJbiBwcmVwYXJhdGlvbiBmb3IgdW5jb25kaXRp
b25hbGx5IHBhc3NpbmcgdGhlIHN0cnVjdCB0aW1lcl9saXN0IHBvaW50ZXIgdG8NCj4gPiA+IGFs
bCB0aW1lciBjYWxsYmFja3MsIHN3aXRjaCB0byB1c2luZyB0aGUgbmV3IHRpbWVyX3NldHVwKCkg
YW5kIGZyb21fdGltZXIoKQ0KPiA+ID4gdG8gcGFzcyB0aGUgdGltZXIgcG9pbnRlciBleHBsaWNp
dGx5LiBJbmNsdWRlcyBhIGZpeCBmb3IgY29ycmVjdGluZyBhbg0KPiA+ID4gb24tc3RhY2sgdGlt
ZXIgdXNhZ2UuDQo+ID4gDQo+ID4gVGhlc2UgY2hhbmdlcyBsb29rIGdvb2QgdG8gbWUgYnV0IEkg
d291bGQgbGlrZSB0byB0ZXN0IHRoaXMgcGF0Y2guIElzIHRoZXJlDQo+ID4gYSB0cmVlIGF2YWls
YWJsZSBzb21ld2hlcmUgdGhhdCBpbmNsdWRlcyB0aGlzIHBhdGNoPw0KPiANCj4gSSBkaWRuJ3Qs
IGJ1dCBpbiBjYXNlIGl0J3MgZWFzaWVyIHRvIHRlc3QsIEkgaGF2ZSBwdXQgaXQgdXAgaGVyZSwN
Cj4gd2hpY2ggaXMganVzdCB0aXAvdGltZXJzL2NvcmUgd2l0aCB0aGUgdHdvIHRhcmdldCB0aW1l
ciBwYXRjaGVzIG9uDQo+IHRvcDoNCj4gDQo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS9saW51eC9rZXJuZWwvZ2l0L2tlZXMvbGludXguZ2l0L2xvZy8/aD1rc3BwL3RpbWVyL3RpcC90
YXJnZXQNCg0KSGVsbG8gS2VlcywNCg0KVGhhdCB0cmVlIHBhc3NlZCB0aGUgaVNDU0kgdGFyZ2V0
IHRlc3RzIEkgcmFuIHNvIGZlZWwgZnJlZSB0byBhZGQgbXkgUmV2aWV3ZWQtYnkNCmFuZCBUZXN0
ZWQtYnkgdG8gW1BBVENIIHYyXSB0YXJnZXQvaXNjc2k6IENvbnZlcnQgdGltZXJzIHRvIHVzZSB0
aW1lcl9zZXR1cCgpLg0KDQpCYXJ0Lg0KDQo=
