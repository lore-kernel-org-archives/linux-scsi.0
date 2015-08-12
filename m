From: Harry Yang <Harry.Yang@pmcs.com>
Subject: RE: [PATCH V5 11/11] [SCSI] aacraid: Requests at least 2 MSIx in
 pci_enable_msix_range()
Date: Wed, 12 Aug 2015 18:56:43 +0000
Message-ID: <BB0C8AA151C3864B937589292F687F02DAC33C22@BBYEXM02.pmc-sierra.internal>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <1437583757-5449-12-git-send-email-rajinikanth.pandurangan@pmcs.com>
	 <55B0E429.2090805@redhat.com>
 <1439404140.2825.61.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:34969 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbbHLS4p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Aug 2015 14:56:45 -0400
In-Reply-To: <1439404140.2825.61.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Tomas Henzl <thenzl@redhat.com>
Cc: Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>

SGkgSmFtZXMsDQoNCkp1c3QgRllJDQoNClJhaiBpcyBubyBsb25nZXIgd2l0aCBQTUMtU2llcnJh
LiBXaGF0ZXZlciBwYXRjaGVzIGhlIHdhcyBoYW5kbGluZyBpcyBub3cgdGFrZW4gb3ZlciBieSBN
YWhlc2ggd2hvIGhhcyBhbHNvIGJlZW4gb24gYXNzb2NpYXRlZCBlbWFpbCB0aHJlYWRzLg0KDQoN
CkhpIE1haGVzaCwNCg0KUGxlYXNlIGZvbGxvdyB1cC4NCg0KUmVnYXJkcywNCg0KSGFycnkNCg0K
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEphbWVzIEJvdHRvbWxleSBbbWFpbHRv
OkphbWVzLkJvdHRvbWxleUBIYW5zZW5QYXJ0bmVyc2hpcC5jb21dIA0KU2VudDogV2VkbmVzZGF5
LCBBdWd1c3QgMTIsIDIwMTUgMTE6MjkgQU0NClRvOiBUb21hcyBIZW56bA0KQ2M6IFJhamluaWth
bnRoIFBhbmR1cmFuZ2FuOyBqYm90dG9tbGV5QHBhcmFsbGVscy5jb207IGxpbnV4LXNjc2lAdmdl
ci5rZXJuZWwub3JnOyBhYWNyYWlkQHBtYy1zaWVycmEuY29tOyBIYXJyeSBZYW5nOyBSaWNoIEJv
bm87IE1haGVzaCBSYWphc2hla2hhcmE7IEFjaGltIExldWJuZXI7IE11cnRoeSBCaGF0DQpTdWJq
ZWN0OiBSZTogW1BBVENIIFY1IDExLzExXSBbU0NTSV0gYWFjcmFpZDogUmVxdWVzdHMgYXQgbGVh
c3QgMiBNU0l4IGluIHBjaV9lbmFibGVfbXNpeF9yYW5nZSgpDQoNCg0KPiBPbiAyMi43LjIwMTUg
MTg6NDksIHJhamluaWthbnRoLnBhbmR1cmFuZ2FuQHBtY3MuY29tIHdyb3RlOg0KPiA+IEZyb206
IFJhamluaWthbnRoIFBhbmR1cmFuZ2FuIDxyYWppbmlrYW50aC5wYW5kdXJhbmdhbkBwbWNzLmNv
bT4NCj4gPiANCj4gPiBEZXNjcmlwdGlvbjoNCj4gPiAgICAgICAgIEluIE1TSXggbW9kZSwgd2Ug
bmVlZCBhdCBsZWFzdCAyIHZlY3RvcnMuDQo+ID4gDQo+ID4gQ2hhbmdlcyBmcm9tIFY0Og0KPiA+
ICAgICAgIE5ld2x5IGNyZWF0ZWQgZm9yIFY1IGJhc2VkIG9uIHJldmlldyBjb21tZW50Lg0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFJhamluaWthbnRoIFBhbmR1cmFuZ2FuDQo+IDxyYWppbmlr
YW50aC5wYW5kdXJhbmdhbkBwbWNzLg0KPiANCj4gUmV2aWV3ZWQtYnk6IFRvbWFzIEhlbnpsIDx0
aGVuemxAcmVkaGF0LmNvbT4NCg0KSSdtIGNvbmZ1c2VkIGJ5IHlvdXIgW1BBVENIIHY2XSBwb3N0
aW5nOiB3aGVyZSBkaWQgdGhpcyBwYXRjaCBnbyAuLi4gZG8geW91IHdhbnQgaXQgZHJvcHBlZCBv
ciBkaWQgeW91IGp1c3QgZm9yZ2V0IHRvIGluY2x1ZGUgaXQ/DQoNCkphbWVzDQoNCg0K
