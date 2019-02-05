From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH v4 3/3] scsi: ufs-bsg: Allow reading descriptors
Date: Tue, 5 Feb 2019 12:07:25 +0000
Message-ID: <SN6PR04MB4925C574E60B3BA44DD6E0A0FC6E0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1548572868-12589-1-git-send-email-avri.altman@wdc.com>
 <1548572868-12589-4-git-send-email-avri.altman@wdc.com>
 <CAE=gft6mLsW-iEBZ9pFRWWyDQz_gCs20_4JBoBzxL1tYv0rbYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft6mLsW-iEBZ9pFRWWyDQz_gCs20_4JBoBzxL1tYv0rbYg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Avi Shchislowski <Avi.Shchislowski@wdc.com>, Alex Lemberg <Alex.Lemberg@wdc.com>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

TWFydGluLA0KQW55IGZ1cnRoZXIgY29tbWVudHM/DQoNClRoYW5rcywNCkF2cmkNCg0KDQo+IC0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEV2YW4gR3JlZW4gPGV2Z3JlZW5AY2hy
b21pdW0ub3JnPg0KPiBTZW50OiBNb25kYXksIEphbnVhcnkgMjgsIDIwMTkgODo0MiBQTQ0KPiBU
bzogQXZyaSBBbHRtYW4gPEF2cmkuQWx0bWFuQHdkYy5jb20+DQo+IENjOiBKYW1lcyBFLkouIEJv
dHRvbWxleSA8amVqYkBsaW51eC52bmV0LmlibS5jb20+OyBNYXJ0aW4gSy4gUGV0ZXJzZW4NCj4g
PG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPjsgU0NTSSA8bGludXgtc2NzaUB2Z2VyLmtlcm5l
bC5vcmc+OyBMS01MDQo+IDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgQXZpIFNoY2hp
c2xvd3NraSA8QXZpLlNoY2hpc2xvd3NraUB3ZGMuY29tPjsNCj4gQWxleCBMZW1iZXJnIDxBbGV4
LkxlbWJlcmdAd2RjLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2NCAzLzNdIHNjc2k6IHVm
cy1ic2c6IEFsbG93IHJlYWRpbmcgZGVzY3JpcHRvcnMNCj4gDQo+IE9uIFNhdCwgSmFuIDI2LCAy
MDE5IGF0IDExOjA4IFBNIEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPiB3cm90ZToN
Cj4gPg0KPiA+IEFkZCB0aGlzIGZ1bmN0aW9uYWxpdHksIHBsYWNpbmcgdGhlIGRlc2NyaXB0b3Ig
YmVpbmcgcmVhZCBpbiB0aGUgYWN0dWFsDQo+ID4gZGF0YSBidWZmZXIgaW4gdGhlIGJpby4NCj4g
Pg0KPiA+IFRoYXQgaXMsIGZvciBib3RoIHJlYWQgYW5kIHdyaXRlIGRlc2NyaXB0b3JzIHF1ZXJ5
IHVwaXUsIHdlIGFyZSB1c2luZw0KPiA+IHRoZSBqb2IncyByZXF1ZXN0X3BheWxvYWQuICBUaGlz
IGluIHR1cm4sIGlzIG1hcHBlZCBiYWNrIGluIHVzZXIgbGFuZCB0bw0KPiA+IHRoZSBhcHBsaWNh
YmxlIHNnX2lvX3Y0IHhmZXJwOiBkb3V0X3hmZXJwIGZvciB3cml0ZSBkZXNjcmlwdG9yLA0KPiA+
IGFuZCBkaW5feGZlcnAgZm9yIHJlYWQgZGVzY3JpcHRvci4NCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEF2cmkgQWx0bWFuIDxhdnJpLmFsdG1hbkB3ZGMuY29tPg0KPiANCj4gUmV2aWV3ZWQtYnk6
IEV2YW4gR3JlZW4gPGV2Z3JlZW5AY2hyb21pdW0ub3JnPg0K
