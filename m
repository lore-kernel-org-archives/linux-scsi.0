From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx -- FCP_RSP IU check during command completion.
Date: Tue, 10 Feb 2004 15:44:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076456661.6072.68.camel@dieplab1>
References: <1076455038.6072.62.camel@dieplab1>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-dVISdiOMRuP53o1Ke97w"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:51519 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262123AbUBJXnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 18:43:45 -0500
In-Reply-To: <1076455038.6072.62.camel@dieplab1>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


--=-dVISdiOMRuP53o1Ke97w
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2004-02-10 at 15:17, Andrew Vasquez wrote:
> James,
> 
> While processing command completions in qla2x00_status_entry()
> interrogate the FCP_RSP IU in case of any FCP protocol errors (FCP-3,
> 9.4.11) during command execution.  If there were any failures, schedule
> a retry of the command via DID_BUS_BUSY.
> 
> Please apply.
> 

Damn, this patch is incomplete.  Corrected patch attached.  Thanks to RA
for pointing this out.

Regards,
Andrew Vasquez

--=-dVISdiOMRuP53o1Ke97w
Content-Disposition: attachment; filename=QL1_fcp_protocol_errors_2.diff
Content-Transfer-Encoding: base64
Content-Type: text/plain; name=QL1_fcp_protocol_errors_2.diff; charset=

LS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jCTIwMDQtMDItMDIgMDk6Mzg6Mjku
MDAwMDAwMDAwIC0wODAwDQorKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMJMjAw
NC0wMi0xMCAxMzo1MTozMC40NzQyOTI3MzYgLTA4MDANCkBAIC04MjgsNiArODI4LDcgQEANCiAJ
dWludDhfdAkJbHNjc2lfc3RhdHVzOw0KIAl1aW50MzJfdAlyZXNpZDsNCiAJdWludDhfdAkJc2Vu
c2Vfc3ogPSAwOw0KKwl1aW50MTZfdAlyc3BfaW5mb19sZW47DQogDQogCS8qIEZhc3QgcGF0aCBj
b21wbGV0aW9uLiAqLw0KIAlpZiAobGUxNl90b19jcHUocGt0LT5jb21wX3N0YXR1cykgPT0gQ1Nf
Q09NUExFVEUgJiYNCkBAIC05MTksNiArOTIwLDI0IEBADQogCQl9DQogCX0NCiANCisJLyogQ2hl
Y2sgZm9yIGFueSBGQ1AgdHJhbnNwb3J0IGVycm9ycy4gKi8NCisJaWYgKHNjc2lfc3RhdHVzICYg
U1NfUkVTUE9OU0VfSU5GT19MRU5fVkFMSUQpIHsNCisJCXJzcF9pbmZvX2xlbiA9IGxlMTZfdG9f
Y3B1KHBrdC0+cnNwX2luZm9fbGVuKTsNCisJCWlmIChyc3BfaW5mb19sZW4gPiAzICYmIHBrdC0+
cnNwX2luZm9bM10pIHsNCisJCQlERUJVRzIocHJpbnRrKCJzY3NpKCVsZDolZDolZDolZCkgRkNQ
IEkvTyBwcm90b2NvbCAiDQorCQkJICAgICJmYWlsdXJlICgleC8lMDJ4JTAyeCUwMnglMDJ4JTAy
eCUwMnglMDJ4JTAyeCkuLi4iDQorCQkJICAgICJyZXRyeWluZyBjb21tYW5kXG4iLCBoYS0+aG9z
dF9ubywgYiwgdCwgbCwNCisJCQkgICAgcnNwX2luZm9fbGVuLCBwa3QtPnJzcF9pbmZvWzBdLCBw
a3QtPnJzcF9pbmZvWzFdLA0KKwkJCSAgICBwa3QtPnJzcF9pbmZvWzJdLCBwa3QtPnJzcF9pbmZv
WzNdLA0KKwkJCSAgICBwa3QtPnJzcF9pbmZvWzRdLCBwa3QtPnJzcF9pbmZvWzVdLA0KKwkJCSAg
ICBwa3QtPnJzcF9pbmZvWzZdLCBwa3QtPnJzcF9pbmZvWzddKSk7DQorDQorCQkJY3AtPnJlc3Vs
dCA9IERJRF9CVVNfQlVTWSA8PCAxNjsNCisJCQlhZGRfdG9fZG9uZV9xdWV1ZShoYSwgc3ApOw0K
KwkJCXJldHVybjsNCisJCX0NCisJfQ0KKw0KIAkvKg0KIAkgKiBCYXNlZCBvbiBIb3N0IGFuZCBz
Y3NpIHN0YXR1cyBnZW5lcmF0ZSBzdGF0dXMgY29kZSBmb3IgTGludXgNCiAJICovDQo=

--=-dVISdiOMRuP53o1Ke97w--
