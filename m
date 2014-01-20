From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
Date: Mon, 20 Jan 2014 11:21:14 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45FF6C@AcuExch.aculab.com>
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com>
 <20140114172056.GB12126@xanatos> <52D5ABBD.7090202@gmail.com>
 <063D6719AE5E284EB5DD2968C1650D6D45EDA3@AcuExch.aculab.com>
 <52DAE2BF.7020208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <52DAE2BF.7020208@gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: 'walt' <w41ter@gmail.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogd2FsdCANCj4gT24gMDEvMTcvMjAxNCAwNjozNCBBTSwgRGF2aWQgTGFpZ2h0IHdyb3Rl
Og0KPiANCj4gPiBDYW4geW91IHRyeSB0aGUgcGF0Y2ggSSBwb3N0ZWQgdGhhdCBzdG9wcyB0aGUg
b3duZXJzaGlwIG9uIExJTksgVFJCcw0KPiA+IGJlaW5nIGNoYW5nZWQgYmVmb3JlIHRoYXQgb24g
dGhlIGxpbmtlZC10byBUUkI/DQo+IA0KPiBQbGVhc2UgZGlzcmVnYXJkIG15IGVhcmxpZXIgcG9z
dCBhYm91dCB0aGUgcGF0Y2ggbm90IGFwcGx5aW5nIGNsZWFubHkuDQo+IFRoYXQgd2FzIHRoZSB1
c3VhbCBodG1sIGNvcnJ1cHRpb24sIHNvIEkgZm91bmQgdGhlIG9yaWdpbmFsIG9uIHRoZSB1c2IN
Cj4gbGlzdCBhbmQgaXQgd2FzIG9rYXkuDQo+IA0KPiBTYWRseSwgdGhlIHBhdGNoIGRpZG4ndCBm
aXggdGhlIEFTTWVkaWEgbG9ja3VwIGJlaGF2aW9yLCBob3dldmVyIDooDQo+IA0KPiBJIGRpZCBu
b3RpY2UgdGhhdCB0aGUgbG9ja3VwIG9jY3VycmVkIG9ubHkgd2hlbiBjb3B5aW5nICp0byogdGhl
IHVzYjMNCj4gZHJpdmUsIGFuZCBub3Qgd2hlbiBjb3B5aW5nIGZyb20gaXQuICBJIHRoaW5rIHRo
YXQgbWF5IGJlIG5ldyBiZWhhdmlvcg0KPiBidXQgSSBjYW4ndCBzd2VhciB0byBpdC4NCg0KQ29u
c2lzdGVudCB3aXRoIGFub3RoZXIgcmVwb3J0IHRoYXQgc2F5cyB0aGF0IGV0aGVybmV0IHdvcmtl
ZCBwcm92aWRlZA0KdGhhdCBUU08gd2FzIGRpc2FibGVkIChpZSBubyBzZyB0eCkuDQooV2l0aG91
dCB0aGUgcGF0Y2ggdG8gZGVsYXkgaGUgb3duZXJzaGlwIGNoYW5nZSBvbiBsaW5rIHRyYnMgaXQg
ZGlkbid0DQp3b3JrIGF0IGFsbC4pDQoNCkEgZ3Vlc3MuLi4NCg0KSW4gcXVldWVfYnVsa19zZ190
eCgpIHRyeSBjYWxsaW5nIHhoY2lfdjFfMF90ZF9yZW1haW5kZXIoKSBpbnN0ZWFkDQpvZiB4aGNp
X3RkX3JlbWFpbmRlcigpLg0KDQpZb3UgY2FuIHRyeSB0aGF0IG9uIHRvcCBvZiBlaXRoZXIgb2Yg
bXkgb3RoZXIgcGF0Y2hlcy4NCg0KCURhdmlkDQoNCg==
