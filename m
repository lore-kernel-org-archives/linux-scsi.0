From: Don Brace <don.brace@microsemi.com>
Subject: RE: [PATCH 02/12] hpsa: cleanup sas_phy structures in sysfs when
 unloading
Date: Tue, 24 Oct 2017 15:08:37 +0000
Message-ID: <4993A297653ECB4581FA5C3C31323D196721EBE0@avsrvexchmbx2.microsemi.net>
References: <150853443786.28275.17878578984391668998.stgit@brunhilda>
         <150853627417.28275.14954285884974003997.stgit@brunhilda>
 <1508802293.3209.3.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0058.outbound.protection.outlook.com ([104.47.42.58]:52256
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751743AbdJXPIu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Oct 2017 11:08:50 -0400
In-Reply-To: <1508802293.3209.3.camel@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, "joseph.szczypek@hpe.com" <joseph.szczypek@hpe.com>, Gerry Morong <gerry.morong@microsemi.com>, John Hall <John.Hall@microsemi.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Bader Ali - Saleh <bader.alisaleh@microsemi.com>, "hch@infradead.org" <hch@infradead.org>, Scott Teel <scott.teel@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, "POSWALD@suse.com" <POSWALD@suse.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBPbiBGcmksIDIwMTctMTAtMjAgYXQgMTY6
NTEgLTA1MDAsIERvbiBCcmFjZSB3cm90ZToNCj4gPiBGcm9tOiBNYXJ0aW4gV2lsY2sgPG13aWxj
a0BzdXNlLmRlPg0KPiA+DQo+ID4gSSBhbSByZXN1Ym1pdHRpbmcgdGhpcyBwYXRjaCBvbiBiZWhh
bGYgb2YgTWFydGluIFdpbGNrDQo+ID4gd2l0aCBoaXMgcGVybWlzc2lvbi4NCj4gPg0KPiA+IFRo
ZSBvcmlnaW5hbCBwYXRjaCBjYW4gYmUgZm91bmQgaGVyZToNCj4gPiBodHRwczovL3d3dy5zcGlu
aWNzLm5ldC9saXN0cy9saW51eC1zY3NpL21zZzEwMjA4My5odG1sDQo+ID4NCj4gPiBUaGlzIHBh
dGNoIGRpZCBub3QgaGVscCB1bnRpbCBIYW5uZXMncw0KPiA+IGNvbW1pdCA5NDQxMjg0ZmJjMzkg
KCJzY3NpLWZpeHVwLWtlcm5lbC13YXJuaW5nLWR1cmluZy1ybW1vZCIpDQo+ID4gd2FzIGFwcGxp
ZWQgdG8gdGhlIGtlcm5lbC4NCj4gPg0KPiA+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+ID4gT3JpZ2luYWwgcGF0Y2ggZGVzY3JpcHRpb24gZnJvbSBNYXJ0aW46DQo+
ID4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPg0KPiA+IFdoZW4g
dGhlIGhwc2EgbW9kdWxlIGlzIHVubG9hZGVkIHVzaW5nIHJtbW9kLCBkYW5nbGluZw0KPiA+IHN5
bWxpbmtzIHJlbWFpbiB1bmRlciAvc3lzL2NsYXNzL3Nhc19waHkuIEZpeCB0aGlzIGJ5DQo+ID4g
Y2FsbGluZyBzYXNfcGh5X2RlbGV0ZSgpIHJhdGhlciB0aGFuIHNhc19waHlfZnJlZSAod2hpY2gs
DQo+ID4gYWNjb3JkaW5nIHRvIGNvbW1lbnRzLCBzaG91bGQgbm90IGJlIGNhbGxlZCBmb3IgUEhZ
cyB0aGF0DQo+ID4gaGF2ZSBiZWVuIHNldCB1cCBzdWNjZXNzZnVsbHksIGFueXdheSkuDQo+ID4N
Cj4gPiBUZXN0ZWQtYnk6IERvbiBCcmFjZSA8ZG9uLmJyYWNlQG1pY3Jvc2VtaS5jb20+DQo+ID4g
UmV2aWV3ZWQtYnk6IERvbiBCcmFjZSA8ZG9uLmJyYWNlQG1pY3Jvc2VtaS5jb20+DQo+ID4gU2ln
bmVkLW9mZi1ieTogTWFydGluIFdpbGNrIDxtd2lsY2tAeHh4eHh4eD4NCj4gDQo+IEhleSwgd2hh
dCdzIHRoaXMgZm9yIGEgc2lnbm9mZj8gIFRoZSBvcmlnaW5hbCBwYXRjaCBoYWQgdGhlIGNvcnJl
Y3QNCj4gZW1haWwgYWRkcmVzczsgaG93IGRpZCBpdCBnZXQgbWFuZ2xlZCBsaWtlIHRoaXM/DQo+
IA0KPiBKYW1lcw0KDQpVbnN1cmUuIEkgZG8gbm90IHNlZSB0aGUgbWFuZ2xlZCBlLW1haWwgYW55
d2hlcmUgaW4gdGhlIGUtbWFpbA0KY2hhaW4uIEkgZGlkIG5vdCB0eXBlIHRoZSBlLW1haWwgaW4g
bGlrZSB0aGF0LiBCdXQgaXQgb3JpZ2luYXRlZCBmcm9tIG1lLg0KSSBtYXkgaGF2ZSBwdWxsZWQg
dGhlIHBhdGNoIGZyb20gYW4gYXJjaGl2ZSB0aGF0IG1hbmdsZWQgaXQuDQoNCkRvIHlvdSB3YW50
IG1lIHRvIHJlLXBvc3QgdGhlIHR3byBwYXRjaGVzPyANCg0KVGhhbmtzLA0KRG9uIEJyYWNlDQpF
U0MgLSBTbWFydCBTdG9yYWdlDQpNaWNyb3NlbWkgQ29ycG9yYXRpb24NCg0KDQoNCg==
