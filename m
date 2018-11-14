From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH] drivers/scsi/fnic/fnic_trace.c: Use vzalloc
Date: Wed, 14 Nov 2018 10:44:12 +0000
Message-ID: <d5ff3e3cb7cb435a9eff8d159e85f704@AcuMS.aculab.com>
References: <5beae8ff.1c69fb81.bd59a.b7fa@mx.google.com>
         <a34379dd-f6f0-b439-b6de-f2db142f1823@huawei.com>
         <13d3418f-49d1-d683-48a6-cedbc073d86f@suse.de>
 <1542125473.3042.6.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1542125473.3042.6.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'James Bottomley' <jejb@linux.vnet.ibm.com>, Johannes Thumshirn <jthumshirn@suse.de>, John Garry <john.garry@huawei.com>, Sabyasachi Gupta <sabyasachi.linux@gmail.com>, "satishkh@cisco.com" <satishkh@cisco.com>, "sebaddel@cisco.com" <sebaddel@cisco.com>, "kartilak@cisco.com" <kartilak@cisco.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "jrdr.linux@gmail.com" <jrdr.linux@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "brajeswar.linux@gmail.com" <brajeswar.linux@gmail.com>
List-Id: linux-scsi@vger.kernel.org

RnJvbTogSmFtZXMgQm90dG9tbGV5DQo+IFNlbnQ6IDEzIE5vdmVtYmVyIDIwMTggMTY6MTENCj4g
DQo+IE9uIFR1ZSwgMjAxOC0xMS0xMyBhdCAxNjo1MyArMDEwMCwgSm9oYW5uZXMgVGh1bXNoaXJu
IHdyb3RlOg0KPiA+IE9uIDEzLzExLzIwMTggMTY6NDQsIEpvaG4gR2Fycnkgd3JvdGU6DQo+ID4g
PiBPbiAxMy8xMS8yMDE4IDE1OjA4LCBTYWJ5YXNhY2hpIEd1cHRhIHdyb3RlOg0KPiBbLi4uXQ0K
PiA+ID4gPiAtICAgIGZuaWNfdHJhY2VfYnVmX3AgPSAodW5zaWduZWQgbG9uZyl2bWFsbG9jKCh0
cmFjZV9tYXhfcGFnZXMgKg0KPiA+ID4gPiBQQUdFX1NJWkUpKTsNCj4gPiA+ID4gKyAgICBmbmlj
X3RyYWNlX2J1Zl9wID0gKHVuc2lnbmVkIGxvbmcpdnphbGxvYygodHJhY2VfbWF4X3BhZ2VzICoN
Cj4gPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUEFHRV9TSVpFKSk7DQo+
ID4gPg0KPiA+ID4gSWYgeW91IHJlbW92ZSB0aGUgZXh0cmEgYnJhY2tldHMgaW4gdnphbGxvYygp
IGFyZ3VtZW50IHRoZW4geW91IG1heQ0KPiA+ID4gbm90IHNwaWxsIG9udG8gdGhlIG5leHQgbGlu
ZS4NCj4gPg0KPiA+IEFuZCByZW1vdmUgdGhlIHVubmVjZXNzYXJ5IGNhc3QuIHZ6YWxsb2MoKSAo
anVzdCBsaWtlIHZtYWxsb2MoKSkNCj4gPiByZXR1cm5zIGEgdm9pZCosIHNvIG5vIHJlYXNvbiB0
byBjYXN0IGl0Lg0KPiANCj4gVGhpcyBpcyBpbmNvcnJlY3QgYWR2aWNlOiB0aGVyZSdzIG5vIG5l
ZWQgdG8gY2FzdCBpdCB0byBvdGhlciAqcG9pbnRlcioNCj4gdHlwZXMsIGJ1dCBpZiB5b3UgY2Fz
dCBpdCB0byBhIG5vbi1wb2ludGVyIHR5cGUgKHdoaWNoIHRoaXMgaXMgZG9pbmcpDQo+IHRoZSBj
b21waWxlciB3aWxsIGNvbXBsYWluIGlmIHRoZXJlIGlzIG5vIGV4cGxpY2l0IGNhc3QuDQoNClRo
ZSByZWFsIHF1ZXN0aW9uIGlzIHdoeSBpcyB0aGlzIGNvZGUgdXNpbmcgJ3Vuc2lnbmVkIGxvbmcn
DQp0byBob2xkIHBvaW50ZXJzPw0KDQpOZXZlciBtaW5kIHdoeSBpdCBpcyBhbGxvY2F0aW5nIGEg
bGFyZ2UgbWVtb3J5IGJsb2NrIHRoZW4gc2V0dGluZw0KdXAgYW5vdGhlciBhcnJheSB3aXRoIHBv
aW50ZXJzIHRvIGV2ZXJ5IDY0IGJ5dGVzIGRvd24gaXQuDQoNCkFsc28gd2h5IGRlZmF1bHQgdG8g
MTYgKiBQQUdFX1NJWkUgLSB0aGF0IGlzIHNpbGx5IGlmIHBhZ2VzIGFyZSBiaWcuDQoNCglEYXZp
ZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQg
RmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4
NiAoV2FsZXMpDQo=
