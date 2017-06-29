From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 0/5] v3 block subsystem refcounter conversions
Date: Thu, 29 Jun 2017 07:38:04 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B6FF1F012@IRSMSX102.ger.corp.intel.com>
References: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com>
 <cbbb6a1f-3203-9523-f47b-227fd646fd29@kernel.dk>
 <CAGXu5jJeTAoy1mh1qy0reP_H=u8D86AN=Aj7G6k2cafz76+8NA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B6FF1DA36@IRSMSX102.ger.corp.intel.com>
 <22e0adc4-3c02-e1f8-9017-213b50fdb8a8@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <22e0adc4-3c02-e1f8-9017-213b50fdb8a8@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, Ingo Molnar <mingo@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
List-Id: linux-scsi@vger.kernel.org

DQo+IE9uIDA2LzI4LzIwMTcgMDU6NTggQU0sIFJlc2hldG92YSwgRWxlbmEgd3JvdGU6DQo+ID4N
Cj4gPj4gU3ViamVjdDogUmU6IFtQQVRDSCAwLzVdIHYzIGJsb2NrIHN1YnN5c3RlbSByZWZjb3Vu
dGVyIGNvbnZlcnNpb25zDQo+ID4+DQo+ID4+IE9uIFR1ZSwgSnVuIDI3LCAyMDE3IGF0IDY6MjYg
QU0sIEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4gd3JvdGU6DQo+ID4+PiBPbiAwNi8yNy8y
MDE3IDA1OjM5IEFNLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4+Pj4gQ2hhbmdlcyBpbiB2
MzoNCj4gPj4+PiBObyBjaGFuZ2VzIGluIHBhdGNoZXMgYXBhcnQgZnJvbSB0cml2aWFsIHJlYmFz
ZXMsIGJ1dCBub3cgYnkNCj4gPj4+PiBkZWZhdWx0IHJlZmNvdW50X3QgPSBhdG9taWNfdCBhbmQg
dXNlcyBhbGwgYXRvbWljIHN0YW5kYXJkIG9wZXJhdGlvbnMNCj4gPj4+PiB1bmxlc3MgQ09ORklH
X1JFRkNPVU5UX0ZVTEwgaXMgZW5hYmxlZC4gVGhpcyBpcyBhIGNvbXByb21pemUgZm9yIHRoZQ0K
PiA+Pj4+IHN5c3RlbXMgdGhhdCBhcmUgY3JpdGljYWwgb24gcGVyZm9ybWFuY2UgYW5kIGNhbm5v
dCBhY2NlcHQgZXZlbg0KPiA+Pj4+IHNsaWdodCBkZWxheSBvbiB0aGUgcmVmY291bnRlciBvcGVy
YXRpb25zLg0KPiA+Pj4NCj4gPj4+IElzIHRoYXQgdHJ1ZSBpbiA0LjEyLXJjLCBvciBpcyB0aGF0
IHRydWUgaW4gYSBsYXRlciByZWxlYXNlIG9uY2UNCj4gPj4+IExpbnVzIGhhcyBwdWxsZWQgdGhv
c2UgY2hhbmdlcyBpbj8gSWYgdGhlIGxhdHRlciwgcGxlYXNlIHJlc2VuZA0KPiA+Pj4gdGhpcyB3
aGVuIHRob3NlIGNoYW5nZXMgYXJlIGluLCB0aGFua3MuDQo+ID4+DQo+ID4+IEl0J3MgaW4gLW5l
eHQgY3VycmVudGx5ICgibG9ja2luZy9yZWZjb3VudDogQ3JlYXRlIHVuY2hlY2tlZCBhdG9taWNf
dA0KPiA+PiBpbXBsZW1lbnRhdGlvbiIpDQo+ID4NCj4gPiBJIHdvdWxkIHJlYWxseSBsaWtlIHRv
IHN0YXJ0IGRpc2N1c3Npb24gb24gdGhlIHRoZXNlIHBhdGNoZXMgYXNhcA0KPiA+IHNpbmNlIGl0
IG5vcm1hbGx5IHRha2VzIHNvbWUgYWRqdXN0bWVudHMgZXRjLiBiZWZvcmUgdGhleSBjYW4gYmUN
Cj4gPiBtZXJnZWQgYW5kIHdlIHdhbnQgbWFueSBjaGFuZ2VzIHRvIGdvIGludG8gbmV4dCByZWxl
YXNlIHJvdW5kIGFuZCBub3QNCj4gPiB0byBtaXNzIHRoZSBtZXJnZSB3aW5kb3cuDQo+IA0KPiBB
cyBmYXIgYXMgSSdtIGNvbmNlcm5lZCwgdGhlcmUncyBubyBuZWVkIGZvciBhIGRpc2N1c3Npb24g
b24gdGhlc2UuIElmDQo+IHRoZSBvdGhlciBwYXRjaGVzIGdvIGluIHRvIG1ha2UgaXQgYXMgbGln
aHQgd2VpZ2h0IGFzIHdoYXQgd2UgY3VycmVudGx5DQo+IGhhdmUsIHRoZW4gSSdtIGZpbmUgd2l0
aCBpdC4gSSBjYW4gcXVldWUgaXQgdXAgZm9yIHBvc3QgaW5pdGlhbCBtZXJnZQ0KPiBzdWJtaXNz
aW9uLg0KDQpPaywgZmFpciBlbm91Z2guIFRoYW5rIHlvdSB2ZXJ5IG11Y2ghDQoNCkJlc3QgUmVn
YXJkcywNCkVsZW5hLg0KDQo+IA0KPiAtLQ0KPiBKZW5zIEF4Ym9lDQoNCg==
