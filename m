From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH] scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
Date: Sat, 8 Aug 2015 14:55:22 +0000
Message-ID: <BY2PR0301MB16546980B9E154666E576ED7A0720@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1438974286.7315.74.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0112.outbound.protection.outlook.com ([65.55.169.112]:11872
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964774AbbHHOz0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Aug 2015 10:55:26 -0400
In-Reply-To: <1438974286.7315.74.camel@decadent.org.uk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Long Li <longli@microsoft.com>, linux-scsi <linux-scsi@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCZW4gSHV0Y2hpbmdzIFttYWls
dG86YmVuQGRlY2FkZW50Lm9yZy51a10NCj4gU2VudDogRnJpZGF5LCBBdWd1c3QgNywgMjAxNSAx
MjowNSBQTQ0KPiBUbzogS1kgU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+DQo+IENjOiBM
b25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT47IGxpbnV4LXNjc2kgPGxpbnV4LXNjc2lAdmdl
ci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBzY3NpOiBzdG9ydnNjOiBGaXgg
YSBidWcgaW4gY29weV9mcm9tX2JvdW5jZV9idWZmZXIoKQ0KPiANCj4gQ29tbWl0IDhkZTU4MDc0
MmZlZSAoInNjc2k6IHN0b3J2c2M6IEZpeCBhIGJ1ZyBpbg0KPiBjb3B5X2Zyb21fYm91bmNlX2J1
ZmZlcigpIiksIGFjdHVhbGx5IG1vZGlmaWVkIHRoZSBmdW5jdGlvbg0KPiBjb3B5X3RvX2JvdW5j
ZV9idWZmZXIoKS4gIElzIHRoZSBjb21taXQgbWVzc2FnZSB3cm9uZywgb3Igd2FzIHRoZSBwYXRj
aA0KPiBhcHBsaWVkIHRvIHRoZSB3cm9uZyBmdW5jdGlvbj8NCj4gDQpCZW4sDQoNCk1vc3QgbGlr
ZWx5IHRoZSBtZXNzYWdlIGlzICJtaXNsZWFkaW5nIi4gSSBjdXJyZW50bHkgZG9uJ3QgaGF2ZSBh
Y2Nlc3MgdG8gdGhlIHNvdXJjZTsgSSB3aWxsIGNvbmZpcm0gc29tZXRpbWUgdG9uaWdodC4NCg0K
VGhhbmsgeW91LA0KDQpLLiBZDQo+IEJlbi4NCj4gDQo+IC0tDQo+IEJlbiBIdXRjaGluZ3MNCj4g
Q29tcHV0ZXJzIGFyZSBub3QgaW50ZWxsaWdlbnQuCVRoZXkgb25seSB0aGluayB0aGV5IGFyZS4N
Cg0K
