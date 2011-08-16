From: Xiangliang Yu <yuxiangl@marvell.com>
Subject: RE: [PATCH] [SCSI] mvsas: Add support for Marvell's 88SE9480 chip.
Date: Mon, 15 Aug 2011 19:44:33 -0700
Message-ID: <F766E4F80769BD478052FB6533FA745D19FE5D21A9@SC-VEXCH4.marvell.com>
References: <1313231597.6786.0.camel@alexander>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:59400 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897Ab1HPCwB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2011 22:52:01 -0400
In-Reply-To: <1313231597.6786.0.camel@alexander>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Kurtz <kurtz.alex@googlemail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>

SGksIEFsZXhhbmRlcg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFs
ZXhhbmRlciBLdXJ0eiBbbWFpbHRvOmt1cnR6LmFsZXhAZ29vZ2xlbWFpbC5jb21dDQo+IFNlbnQ6
IDIwMTHlubQ45pyIMTPml6UgMTg6MTINCj4gVG86IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3Jn
DQo+IENjOiBYaWFuZ2xpYW5nIFl1OyBKYW1lcyBCb3R0b21sZXkNCj4gU3ViamVjdDogW1BBVENI
XSBbU0NTSV0gbXZzYXM6IEFkZCBzdXBwb3J0IGZvciBNYXJ2ZWxsJ3MgODhTRTk0ODAgY2hpcC4N
Cj4gDQo+IFRoaXMgcGF0Y2ggYWRkcyB0aGUgbWlzc2luZyBwY2kgaWQgZm9yIE1hcnZlbGwncyA4
OFNFOTQ4MCBTQVMvU0FUQcKgSEJBDQo+IHdoaWNoIGlzIGFsc28gc29sZCB3aXRoIGEgdmVuZG9y
IGlkIG9mIDB4MUI0QiBpbnN0ZWFkIG9mIDB4MTFBQi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFs
ZXhhbmRlciBLdXJ0eiA8a3VydHouYWxleEBnb29nbGVtYWlsLmNvbT4NCj4gLS0tDQo+ICBkcml2
ZXJzL3Njc2kvbXZzYXMvbXZfaW5pdC5jIHwgICAgOSArKysrKysrKysNCj4gIDEgZmlsZXMgY2hh
bmdlZCwgOSBpbnNlcnRpb25zKCspLCAwIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc2NzaS9tdnNhcy9tdl9pbml0LmMgYi9kcml2ZXJzL3Njc2kvbXZzYXMvbXZfaW5p
dC5jDQo+IGluZGV4IDRlOWFmNjYuLmJkNWI4ZTEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2Nz
aS9tdnNhcy9tdl9pbml0LmMNCj4gKysrIGIvZHJpdmVycy9zY3NpL212c2FzL212X2luaXQuYw0K
PiBAQCAtNzIzLDYgKzcyMywxNSBAQCBzdGF0aWMgc3RydWN0IHBjaV9kZXZpY2VfaWQgX19kZXZp
bml0ZGF0YSBtdnNfcGNpX3RhYmxlW10NCj4gPSB7DQo+ICAJCS5jbGFzc19tYXNrCT0gMCwNCj4g
IAkJLmRyaXZlcl9kYXRhCT0gY2hpcF85NDg1LA0KPiAgCX0sDQo+ICsJew0KPiArCQkudmVuZG9y
CQk9IDB4MWI0YiwNCj4gKwkJLmRldmljZQkJPSAweDk0ODAsDQo+ICsJCS5zdWJ2ZW5kb3IJPSBQ
Q0lfQU5ZX0lELA0KPiArCQkuc3ViZGV2aWNlCT0gUENJX0FOWV9JRCwNCg0KU3ViZGV2aWNlIHNo
b3VsZCBiZSBpcyAweDk0ODANCgkJLnN1YmRldmljZSA9IDB4OTQ4MCwNCg0KDQo=
