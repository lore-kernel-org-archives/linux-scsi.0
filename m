From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] block: fix CDROM dependency on BLK_DEV
Date: Thu, 2 Nov 2017 14:59:42 +0000
Message-ID: <1509634781.2484.3.camel@wdc.com>
References: <20171102111952.4021454-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171102111952.4021454-1-arnd@arndb.de>
Content-Language: en-US
Content-ID: <6B475AAD9AC35344BB140CB22E9C96AA@namprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "arnd@arndb.de" <arnd@arndb.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

T24gVGh1LCAyMDE3LTExLTAyIGF0IDEyOjE5ICswMTAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBBZnRlciB0aGUgY2Ryb20gY2xlYW51cCwgSSBnZXQgcmFuZGNvbmZpZyB3YXJuaW5ncyBmb3Ig
c29tZSBjb25maWd1cmF0aW9uczoNCj4gDQo+IHdhcm5pbmc6IChCTEtfREVWX0lERUNEICYmIEJM
S19ERVZfU1IpIHNlbGVjdHMgQ0RST00gd2hpY2ggaGFzIHVubWV0IGRpcmVjdCBkZXBlbmRlbmNp
ZXMgKEJMS19ERVYpDQoNCkhlbGxvIEFybmQsDQoNClNpbmNlIEplbnMgaGFzIGFscmVhZHkgcXVl
dWVkIHlvdXIgcGF0Y2ggaXQncyB0b28gbGF0ZSB0byBjb25zaWRlciBhbHRlcm5hdGl2ZXMuDQpB
bnl3YXksIHNpbmNlIHRoZSBjZHJvbSBkcml2ZXIgY2FsbHMgYmxvY2sgbGF5ZXIgZnVuY3Rpb25z
IGRpcmVjdGx5LCBoYXZlIHlvdQ0KY29uc2lkZXJlZCB0aGUgZm9sbG93aW5nIGFsdGVybmF0aXZl
Pw0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ibG9jay9LY29uZmlnIGIvZHJpdmVycy9ibG9jay9L
Y29uZmlnDQppbmRleCAwZGFkMWQyNTM2ZjcuLmU3MDQ0Yzg5MzgxNyAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvYmxvY2svS2NvbmZpZw0KKysrIGIvZHJpdmVycy9ibG9jay9LY29uZmlnDQpAQCAtNjks
NiArNjksNyBAQCBjb25maWcgQU1JR0FfWjJSQU0NCiANCiBjb25maWcgQ0RST00NCiAJdHJpc3Rh
dGUgIkNELVJPTSBkcml2ZXIiDQorCWRlcGVuZHMgb24gQkxLX0RFVg0KIAloZWxwDQogCSAgQSBD
RC1ST00gaXMgYSBwcmUtcHJlc3NlZCBvcHRpY2FsIGNvbXBhY3QgZGlzYyB3aGljaCBjb250YWlu
cw0KIAkgIGRhdGEuIFRoZSBuYW1lIGlzIGFuIGFjcm9ueW0gd2hpY2ggc3RhbmRzIGZvciAiQ29t
cGFjdCBEaXNj
