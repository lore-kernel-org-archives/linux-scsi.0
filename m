From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH V5 11/11] [SCSI] aacraid: Requests at least 2 MSIx in
 pci_enable_msix_range()
Date: Thu, 13 Aug 2015 00:22:25 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AEC5F987E@BBYEXM02.pmc-sierra.internal>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <1437583757-5449-12-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <55B0E429.2090805@redhat.com>
 <1439404140.2825.61.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:52734 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137AbbHMAW1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Aug 2015 20:22:27 -0400
In-Reply-To: <1439404140.2825.61.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Tomas Henzl <thenzl@redhat.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

QXMgVG9tYXMgSGVuemwgc3VnZ2VzdGVkLCBJIGhhdmUgbWVyZ2VkIDEwIGFuZCAxMSBvZiBWNSBp
bnRvIHNpbmdsZSBwYXRjaCAoaS5lIDkgb2YgVjYpDQoNCkNoYW5nZXMgZnJvbSBWNToNCkFwcGxp
ZWQgZHJpdmVyIHVwZGF0ZSBjaGFuZ2UgYXQgdGhlIGVuZC4NCk1lcmdlZCAxMCBhbmQgMTEgb2Yg
VjUgaW50byA5IG9mIFY2Lg0KQUFDX01BWF9NU0lYIGRlZmluaXRpb24gY2hhbmdlLg0KYWFjX21z
aSBvcHRpb24gZGVzY3JpcHRpb24gYW5kIHN1YmplY3QgY2hhbmdlLg0KDQpUaGFua3MsDQpNYWhl
c2gNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEphbWVzIEJvdHRvbWxleSBb
bWFpbHRvOkphbWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb21dIA0KU2VudDogV2Vk
bmVzZGF5LCBBdWd1c3QgMTIsIDIwMTUgMTE6NTkgUE0NClRvOiBUb21hcyBIZW56bA0KQ2M6IFJh
amluaWthbnRoIFBhbmR1cmFuZ2FuOyBqYm90dG9tbGV5QHBhcmFsbGVscy5jb207IGxpbnV4LXNj
c2lAdmdlci5rZXJuZWwub3JnOyBhYWNyYWlkQHBtYy1zaWVycmEuY29tOyBIYXJyeSBZYW5nOyBS
aWNoIEJvbm87IE1haGVzaCBSYWphc2hla2hhcmE7IEFjaGltIExldWJuZXI7IE11cnRoeSBCaGF0
DQpTdWJqZWN0OiBSZTogW1BBVENIIFY1IDExLzExXSBbU0NTSV0gYWFjcmFpZDogUmVxdWVzdHMg
YXQgbGVhc3QgMiBNU0l4IGluIHBjaV9lbmFibGVfbXNpeF9yYW5nZSgpDQoNCg0KPiBPbiAyMi43
LjIwMTUgMTg6NDksIHJhamluaWthbnRoLnBhbmR1cmFuZ2FuQHBtY3MuY29tIHdyb3RlOg0KPiA+
IEZyb206IFJhamluaWthbnRoIFBhbmR1cmFuZ2FuIDxyYWppbmlrYW50aC5wYW5kdXJhbmdhbkBw
bWNzLmNvbT4NCj4gPiANCj4gPiBEZXNjcmlwdGlvbjoNCj4gPiAgICAgICAgIEluIE1TSXggbW9k
ZSwgd2UgbmVlZCBhdCBsZWFzdCAyIHZlY3RvcnMuDQo+ID4gDQo+ID4gQ2hhbmdlcyBmcm9tIFY0
Og0KPiA+ICAgICAgIE5ld2x5IGNyZWF0ZWQgZm9yIFY1IGJhc2VkIG9uIHJldmlldyBjb21tZW50
Lg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhamluaWthbnRoIFBhbmR1cmFuZ2FuDQo+IDxy
YWppbmlrYW50aC5wYW5kdXJhbmdhbkBwbWNzLg0KPiANCj4gUmV2aWV3ZWQtYnk6IFRvbWFzIEhl
bnpsIDx0aGVuemxAcmVkaGF0LmNvbT4NCg0KSSdtIGNvbmZ1c2VkIGJ5IHlvdXIgW1BBVENIIHY2
XSBwb3N0aW5nOiB3aGVyZSBkaWQgdGhpcyBwYXRjaCBnbyAuLi4gZG8geW91IHdhbnQgaXQgZHJv
cHBlZCBvciBkaWQgeW91IGp1c3QgZm9yZ2V0IHRvIGluY2x1ZGUgaXQ/DQoNCkphbWVzDQoNCg0K
