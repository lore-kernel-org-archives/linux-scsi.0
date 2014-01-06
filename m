From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Mon, 6 Jan 2014 10:35:26 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D29D4F9@AcuExch.aculab.com>
References: <20131218211219.461663463@linuxfoundation.org>
 <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com>
 <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <52C6D9F1.9000709@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: 'walt' <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Mark Lord <mlord@pobox.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

PiBGcm9tOiB3YWx0DQouLi4NCj4gICAgICAgICAvKiBBY2NlcHQgYXJiaXRyYXJpbHkgbG9uZyBz
Y2F0dGVyLWdhdGhlciBsaXN0cyAqLw0KPiAtICAgICAgIGhjZC0+c2VsZi5zZ190YWJsZXNpemUg
PSB+MDsNCj4gKyAgICAgICBoY2QtPnNlbGYuc2dfdGFibGVzaXplID0gMzE7DQoNCkV2ZW4gaWYg
dGhhdCByZWR1Y2VzIHRoZSBudW1iZXIgb2YgZnJhZ21lbnRzIHBhc3NlZCB0byB0aGUgeGhjaSBk
cml2ZXINCml0IG1heSBub3QgYmUgZW5vdWdoIHRvIGxpbWl0IHRoZSBhY3R1YWwgbnVtYmVyIG9m
IGZyYWdtZW50cyB0aGF0DQpuZWVkIHRvIGJlIHBsYWNlZCBpbiB0aGUgcmluZyBpdHNlbGYuDQpU
aGUgeGhjaSBkcml2ZXIgaGFzIHRvIHNwbGl0IGV2ZXJ5IGZyYWdtZW50IG9uIGFueSA2NGsgYWRk
cmVzcyBib3VuZGFyeS4NCg0KT25lIHBvc3NpYmlsaXR5IGlzIHRvIHNjYW4gbG9uZyBTRyBsaXN0
cyB0byBzZWUgaXQgdGhleSBhcmUgYWN0dWFsbHkNCnByb2JsZW1hdGljLiBJZiBhbGwgdGhlIGZy
YWdtZW50cyBhcmUgc3VpdGFibHkgYWxpZ25lZCBsZXQgdGhlbSB0aHJvdWdoDQood2l0aG91dCBh
bnkgbm9wcykuDQoNCk15IGd1dCBmZWVsaW5nIGlzIHRoYXQgcHJvYmxlbXMgb25seSBhcmlzZSB3
aGVuIHRoZSByaW5nIGVuZCBpc24ndCBhdA0KYSAxayBib3VuZGFyeSBpbiB0aGUgZGF0YS4NCg0K
U28gcHJvdmlkZWQgYWxsIHRoZSBmcmFnbWVudHMgYXJlIG11bHRpcGxlcyBvZiAxayAoYWZ0ZXIg
c3BsaXR0aW5nIG9uIDY0aw0KYm91bmRhcmllcykgdGhlIHRyYW5zZmVyIHdpbGwgYmUgcHJvY2Vz
c2VkIGNvcnJlY3RseS4NCkFsdGVybmF0aXZlbHksIGlmIHRoZSBmcmFnbWVudHMgYXJlIGFsbCBs
b25nZXIgdGhhbiAxayAoYWZ0ZXIgdGhlIDY0ayBzcGxpdCksDQp0aGUgb25lIHRoYXQgY3Jvc3Nl
cyB0aGUgcmluZyBlbmQgY2FuIGJlIHNwbGl0IGluIHR3by4NCg0KQSBxdWljayAnZml4JyB3b3Vs
ZCBiZSB0byBhc3N1bWUgdGhhdCBhbnl0aGluZyB3aXRoIHRvbyBtYW55IGZyYWdtZW50cyBpcw0K
cHJvYmFibHkgb2sgLSBtYXliZSBjaGVjayB0aGUgZmlyc3QgZnJhZ21lbnQgaXMgc3VpdGFibHkg
YWxpZ25lZC4NClRoYXQgd291bGQgcmVjb3ZlciB0aGUgb2xkIGJlaGF2aW91ciBmb3IgdXNiIGRp
c2sgdHJhbnNmZXJzIHdpdGggYSBsb3QNCm9mIGZyYWdtZW50cyAtIHllcyBpdCBpcyBhIGhhY2su
Li4NCg0KCURhdmlkDQoNCg==
