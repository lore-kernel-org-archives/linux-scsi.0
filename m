From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [PATCH 0/5] v3 block subsystem refcounter conversions
Date: Wed, 28 Jun 2017 11:58:37 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B6FF1DA36@IRSMSX102.ger.corp.intel.com>
References: <1498563601-10949-1-git-send-email-elena.reshetova@intel.com>
 <cbbb6a1f-3203-9523-f47b-227fd646fd29@kernel.dk>
 <CAGXu5jJeTAoy1mh1qy0reP_H=u8D86AN=Aj7G6k2cafz76+8NA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jJeTAoy1mh1qy0reP_H=u8D86AN=Aj7G6k2cafz76+8NA@mail.gmail.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Btrfs <linux-btrfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@linuxfoundation.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, Ingo Molnar <mingo@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>
List-Id: linux-scsi@vger.kernel.org

DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMC81XSB2MyBibG9jayBzdWJzeXN0ZW0gcmVmY291bnRl
ciBjb252ZXJzaW9ucw0KPiANCj4gT24gVHVlLCBKdW4gMjcsIDIwMTcgYXQgNjoyNiBBTSwgSmVu
cyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPiB3cm90ZToNCj4gPiBPbiAwNi8yNy8yMDE3IDA1OjM5
IEFNLCBFbGVuYSBSZXNoZXRvdmEgd3JvdGU6DQo+ID4+IENoYW5nZXMgaW4gdjM6DQo+ID4+IE5v
IGNoYW5nZXMgaW4gcGF0Y2hlcyBhcGFydCBmcm9tIHRyaXZpYWwgcmViYXNlcywgYnV0IG5vdyBi
eQ0KPiA+PiBkZWZhdWx0IHJlZmNvdW50X3QgPSBhdG9taWNfdCBhbmQgdXNlcyBhbGwgYXRvbWlj
IHN0YW5kYXJkIG9wZXJhdGlvbnMNCj4gPj4gdW5sZXNzIENPTkZJR19SRUZDT1VOVF9GVUxMIGlz
IGVuYWJsZWQuIFRoaXMgaXMgYSBjb21wcm9taXplIGZvciB0aGUNCj4gPj4gc3lzdGVtcyB0aGF0
IGFyZSBjcml0aWNhbCBvbiBwZXJmb3JtYW5jZSBhbmQgY2Fubm90IGFjY2VwdCBldmVuDQo+ID4+
IHNsaWdodCBkZWxheSBvbiB0aGUgcmVmY291bnRlciBvcGVyYXRpb25zLg0KPiA+DQo+ID4gSXMg
dGhhdCB0cnVlIGluIDQuMTItcmMsIG9yIGlzIHRoYXQgdHJ1ZSBpbiBhIGxhdGVyIHJlbGVhc2Ug
b25jZQ0KPiA+IExpbnVzIGhhcyBwdWxsZWQgdGhvc2UgY2hhbmdlcyBpbj8gSWYgdGhlIGxhdHRl
ciwgcGxlYXNlIHJlc2VuZA0KPiA+IHRoaXMgd2hlbiB0aG9zZSBjaGFuZ2VzIGFyZSBpbiwgdGhh
bmtzLg0KPiANCj4gSXQncyBpbiAtbmV4dCBjdXJyZW50bHkgKCJsb2NraW5nL3JlZmNvdW50OiBD
cmVhdGUgdW5jaGVja2VkIGF0b21pY190DQo+IGltcGxlbWVudGF0aW9uIikNCg0KSSB3b3VsZCBy
ZWFsbHkgbGlrZSB0byBzdGFydCBkaXNjdXNzaW9uIG9uIHRoZSB0aGVzZSBwYXRjaGVzIGFzYXAg
c2luY2UgaXQgbm9ybWFsbHkgdGFrZXMNCiBzb21lIGFkanVzdG1lbnRzIGV0Yy4gYmVmb3JlIHRo
ZXkgY2FuIGJlIG1lcmdlZCBhbmQgd2Ugd2FudCBtYW55IGNoYW5nZXMgdG8gZ28gaW50bw0KbmV4
dCByZWxlYXNlIHJvdW5kIGFuZCBub3QgdG8gbWlzcyB0aGUgbWVyZ2Ugd2luZG93LiANCg0KQmVz
dCBSZWdhcmRzLA0KRWxlbmEuDQoNCj4gDQo+IC1LZWVzDQo+IA0KPiAtLQ0KPiBLZWVzIENvb2sN
Cj4gUGl4ZWwgU2VjdXJpdHkNCg==
