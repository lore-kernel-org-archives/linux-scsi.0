From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [5.0-rc5 regression] "scsi: kill off the legacy IO path" causes 5
 minute delay during boot on Sun Blade 2500
Date: Tue, 12 Feb 2019 03:37:22 +0000
Message-ID: <AT5PR8401MB1169D3DBEBC4F88D76BD1710AB650@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAM43=SO6bdDAEULEPArfgdbjLAYDo9OiPBa8gL4fsSg7Dky=gA@mail.gmail.com>
 <1549736341.2971.7.camel@HansenPartnership.com>
 <CAM43=SPUMzOLRmkoT+DQSpzu2DYRTyOhU6o8KRUU_Q902o2e1Q@mail.gmail.com>
 <1549813472.4142.3.camel@HansenPartnership.com>
 <3380ed8e-ae02-96f2-142b-7cce09459df8@kernel.dk>
 <1549815924.4142.8.camel@HansenPartnership.com>
 <0e6e5d67-d305-dd00-2e42-e2299166c8b2@kernel.dk>
 <1549898730.2831.6.camel@HansenPartnership.com>
 <44bb4374-0b7c-733b-a53e-92d2f03f2f49@kernel.dk>
 <1549899773.2831.12.camel@HansenPartnership.com>
 <1a00da0e-cb8e-30ea-8d17-120f97242b2f@kernel.dk>
 <1549902521.2831.23.camel@HansenPartnership.com>
 <fce66227-ff41-3a4e-4c6a-f4c2ca492b95@kernel.dk>
 <1549937598.2857.8.camel@HansenPartnership.com>
 <fc547d40-9a42-a823-b62f-460c3244fe7d@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fc547d40-9a42-a823-b62f-460c3244fe7d@kernel.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Mikael Pettersson <mikpelinux@gmail.com>
Cc: Linux SPARC Kernel Mailing List <sparclinux@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGludXgta2VybmVsLW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgta2VybmVsLQ0KPiBvd25lckB2Z2VyLmtlcm5lbC5v
cmc+IE9uIEJlaGFsZiBPZiBKZW5zIEF4Ym9lDQo+IFNlbnQ6IE1vbmRheSwgRmVicnVhcnkgMTEs
IDIwMTkgODo1MCBQTQ0KPiBUbzogSmFtZXMgQm90dG9tbGV5IDxKYW1lcy5Cb3R0b21sZXlASGFu
c2VuUGFydG5lcnNoaXAuY29tPjsgTWlrYWVsDQo+IFBldHRlcnNzb24gPG1pa3BlbGludXhAZ21h
aWwuY29tPg0KPiBDYzogTGludXggU1BBUkMgS2VybmVsIE1haWxpbmcgTGlzdCA8c3BhcmNsaW51
eEB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiBsaW51eC1ibG9ja0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXNjc2kNCj4gPGxpbnV4LXNjc2lAdmdlci5r
ZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogWzUuMC1yYzUgcmVncmVzc2lvbl0gInNjc2k6IGtp
bGwgb2ZmIHRoZSBsZWdhY3kgSU8gcGF0aCINCj4gY2F1c2VzIDUgbWludXRlIGRlbGF5IGR1cmlu
ZyBib290IG9uIFN1biBCbGFkZSAyNTAwDQouLi4NCg0KPiA+IFdlIGNhbiBlaXRoZXIgZml4IHRo
aXMgYnkgc2V0dGluZyB0aGUgUVVFVUVfRkxBR19BRERfUkFORE9NIGlmDQo+ID4gdGhlcmUncyBu
byAweEIxIHBhZ2Ugb3IgYnkgc2V0dGluZyB0aGUgZGVmYXVsdCBhcyBKZW5zIHByb3Bvc2VkLg0K
PiANCj4gSSdkIHJlY29tbWVuZCBqdXN0IGRvaW5nIG15IHBhdGNoLCBzaW5jZSB0aGF0J2xsIGJl
IHRoZSBzYW1lIGJlaGF2aW9yDQo+IHRoYXQgU0NTSSBoYWQgYmVmb3JlLg0KDQpXaGVuIGJsay1t
cSBhbmQgc2NzaS1tcSB3ZXJlIGludHJvZHVjZWQgdG8gYm9vc3QgU0FTIFNTRHMgb3Zlcg0KMSBt
aWxsaW9uIElPUFMsIHRoaXMgd2FzIHB1cnBvc2VseSBrZXB0IG9mZiwgYmVjYXVzZSBpdCBnZW5l
cmF0ZWQNCmEgbm90aWNlYWJsZSAzLTEyIHVzIGxhdGVuY3kgYmxpcCB3aGVuZXZlciB0aGUgImZh
c3RfbWl4IiBjb2RlIHJhbg0Kb3V0IG9mIGJpdHMuIElmIEplbnMnIHBhdGNoIGNoYW5nZXMgdGhl
IGRlZmF1bHQgdG8gYmUgZW5hYmxlZCBmb3INCmFsbCBzY3NpLW1xIHVzZXJzLCB0aGF0J2xsIGJl
IGEgY2hhbmdlIGZvciB0aGUgbmV3ZXIgbGVnYWN5DQpzY3NpLW1xIHVzZXJzIChleGNlcHQgZm9y
IHVzZXJzIHRoYXQgZG9uJ3QgdHJ1c3QgdGhlIGRlZmF1bHQgYW5kDQphbHdheXMgc2V0IHRoZSB2
YWx1ZSBpbiBzeXNmcykuDQoNCg0K
