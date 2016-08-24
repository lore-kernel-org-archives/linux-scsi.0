From: David Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 1/7] aacraid: Use memdup_user() rather than duplicating
 its implementation
Date: Wed, 24 Aug 2016 23:01:20 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A15FA96FC@avsrvexchmbx1.microsemi.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <40d8607f-3934-c31f-3791-ef6a67d65d45@users.sourceforge.net>
 <23c56a66-74a6-6033-f209-ac3e4ba83e61@users.sourceforge.net>
 <423FD6710FB8FB4F8728F93591889F9A15FA8E64@avsrvexchmbx1.microsemi.net>
 <b61d1eef-35c6-5e8c-a342-db312e27cb1f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b61d1eef-35c6-5e8c-a342-db312e27cb1f@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

PiA+DQo+ID4gSGkgTWFya3VzLA0KPiA+DQo+ID4gUGF0Y2ggMi83IHNob3VsZCBwcmVjZWRlIFBh
dGNoIDEvNywgYXMgZmFsbGluZyBpbnRvIGtmcmVlKCkgd291bGQgbm90IGxvb2sNCj4gcHJldHR5
Lg0KPiANCj4gRG8geW91IGV2ZW50dWFsbHkgcHJlZmVyIHRoYXQgdGhpcyBzb3VyY2UgY29kZSBh
ZGp1c3RtZW50IHNob3VsZCBiZSBjb21iaW5lZA0KPiB3aXRoIHRoZSB1cGRhdGUgc3VnZ2VzdGlv
biAiWzIvN10gYWFjcmFpZDogT25lIGZ1bmN0aW9uIGNhbGwgbGVzcyBpbg0KPiBhYWNfc2VuZF9y
YXdfc3JiKCkgYWZ0ZXIgZXJyb3IgZGV0ZWN0aW9uIiBpbiBhIHNpbmdsZSB1cGRhdGUgc3RlcD8N
Cj4gDQoNCkhpIE1hcmt1cywNCg0KTXkgcHJpbWFyeSBvYmplY3RpdmUgaW4gdGhpcyB3b3VsZCBi
ZSB0aGUgYWJpbGl0eSB0byBiaXNlY3QgLi4uIFRoZSBzZWNvbmRhcnkgd291bGQgYmUgb25lIGlz
c3VlL3BhdGNoLiBJIHRoaW5rIG15IHByZWZlcmVuY2Ugd291bGQgYmUgdG8gc3dhcCBwYXRjaGVz
IDEgYW5kIDIuDQoNClRoYW5rcywgLURhdmUNCg==
