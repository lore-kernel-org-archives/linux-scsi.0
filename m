From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx -- FCP_RSP IU check during command completion.
Date: Tue, 10 Feb 2004 15:17:18 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076455038.6072.62.camel@dieplab1>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-+r15v76lDdnOhSkxLkx6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:26552 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262153AbUBJXQn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 18:16:43 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


--=-+r15v76lDdnOhSkxLkx6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

James,

While processing command completions in qla2x00_status_entry()
interrogate the FCP_RSP IU in case of any FCP protocol errors (FCP-3,
9.4.11) during command execution.  If there were any failures, schedule
a retry of the command via DID_BUS_BUSY.

Please apply.

Regards,
Andrew Vasquez

--=-+r15v76lDdnOhSkxLkx6
Content-Description: 
Content-Disposition: inline; filename=QL1_fcp_protocol_errors.diff
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=

LS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lzci5jCTIwMDQtMDItMDIgMDk6Mzg6Mjku
MDAwMDAwMDAwIC0wODAwDQorKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaXNyLmMJMjAw
NC0wMi0xMCAxMzo1MTozMC40NzQyOTI3MzYgLTA4MDANCkBAIC04MjgsNiArODI4LDcgQEANCiAJ
dWludDhfdAkJbHNjc2lfc3RhdHVzOw0KIAl1aW50MzJfdAlyZXNpZDsNCiAJdWludDhfdAkJc2Vu
c2Vfc3ogPSAwOw0KKwl1aW50MTZfdAlyc3BfaW5mb19sZW47DQogDQogCS8qIEZhc3QgcGF0aCBj
b21wbGV0aW9uLiAqLw0KIAlpZiAobGUxNl90b19jcHUocGt0LT5jb21wX3N0YXR1cykgPT0gQ1Nf
Q09NUExFVEUgJiYNCkBAIC05MTksNiArOTIwLDIzIEBADQogCQl9DQogCX0NCiANCisJLyogQ2hl
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
dCA9IERJRF9CVVNfQlVTWSA8PCAxNjsNCisJCQlyZXR1cm47DQorCQl9DQorCX0NCisNCiAJLyoN
CiAJICogQmFzZWQgb24gSG9zdCBhbmQgc2NzaSBzdGF0dXMgZ2VuZXJhdGUgc3RhdHVzIGNvZGUg
Zm9yIExpbnV4DQogCSAqLw0K

--=-+r15v76lDdnOhSkxLkx6--
