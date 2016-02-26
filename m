From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] storvsc: use small sg_tablesize on x86
Date: Fri, 26 Feb 2016 22:11:25 +0000
Message-ID: <BY2PR0301MB16541EE2E564134A6785FF32A0A70@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1441706801-15300-1-git-send-email-olaf@aepfle.de>
	 <BY2PR0301MB16540206D42C1E00EC353D0EA04C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
	 <1443732718.6886.23.camel@HansenPartnership.com>
	 <20151002171415.GA30430@gmail.com> <20160125083514.GA11991@gmail.com>
	 <BY2PR0301MB1654E0BA47F3D2CC6D83BD64A0D90@BY2PR0301MB1654.namprd03.prod.outlook.com>
	 <1453960859.2322.58.camel@HansenPartnership.com>
	 <20160128064822.GA12884@aepfle.de>
 <1453995435.2342.10.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453995435.2342.10.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Olaf Hering <olaf@aepfle.de>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFtZXMgQm90dG9tbGV5
IFttYWlsdG86SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbV0NCj4gU2VudDog
VGh1cnNkYXksIEphbnVhcnkgMjgsIDIwMTYgNzozNyBBTQ0KPiBUbzogT2xhZiBIZXJpbmcgPG9s
YWZAYWVwZmxlLmRlPg0KPiBDYzogS1kgU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+OyBI
YWl5YW5nIFpoYW5nDQo+IDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPjsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsgbGludXgtDQo+IHNjc2lAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0hdIHN0b3J2c2M6IHVzZSBzbWFsbCBzZ190YWJsZXNpemUgb24geDg2DQo+IA0K
PiBPbiBUaHUsIDIwMTYtMDEtMjggYXQgMDc6NDggKzAxMDAsIE9sYWYgSGVyaW5nIHdyb3RlOg0K
PiA+IE9uIFdlZCwgSmFuIDI3LCBKYW1lcyBCb3R0b21sZXkgd3JvdGU6DQo+ID4NCj4gPiA+IEl0
J3Mgbm90IHJlYWxseSBhcmNoaXRlY3R1cmUgaW5kZXBlbmRlbnQsIGlzIGl0PyAgSnVzdCB1c2Ug
dGhlIGJpdA0KPiA+ID4gd2lkdGggY29uZmlnLg0KPiA+DQo+ID4gQWdhaW46IHdoaWNoIG9uZT8g
VGhpcyBkcml2ZXIgaXMgbm90IGZvciBtaXBzfHBvd2VycGN8c2NvcmV8c2guDQo+IA0KPiB6Z3Jl
cCBDT05GSUdfLipCSVQgL3Byb2MvY29uZmlnLmd6DQo+IFsuLi5dDQo+IENPTkZJR182NEJJVD15
DQo+IA0KPiBKYW1lcw0KDQpPbGFmLA0KDQpXb3VsZCB5b3UgYmUgcmVzdWJtaXR0aW5nIHRoaXMg
cGF0Y2g/DQoNClRoYW5rcywNCg0KSy4gWQ0KDQo=
