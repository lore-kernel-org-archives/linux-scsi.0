From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: [patch] Have qla2xxx driver bind fcports.
Date: Mon, 19 Jan 2004 09:03:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598E40@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C3DEAE.1B255EDE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:26787 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265375AbUASRCv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:02:51 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C3DEAE.1B255EDE
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Andrew/James,

During the removal of the failover and IOCTL code from the=20
scsi-qla2xxx-2.6 tree, one critical piece of code (a one-liner) was=20
inadvertently removed that effectively disables the drivers ability=20
to bind fcports (devices found in the loop or fabric) to the SCSI=20
nexus (h/b/t/l).  This could cause users to believe that no devices
would be discovered during driver scans.

BTW: This fix is already in the resync_bk-v8.00.00b9 patch up on the
SF.net site.

Please apply.

Regards,
Andrew Vasquez

------_=_NextPart_001_01C3DEAE.1B255EDE
Content-Type: application/octet-stream;
	name="bind_fcports-v8.00.00b8-mm4.diff"
Content-Transfer-Encoding: base64
Content-Description: bind_fcports-v8.00.00b8-mm4.diff
Content-Disposition: attachment;
	filename="bind_fcports-v8.00.00b8-mm4.diff"

LS0tIGxpbnV4LTIuNi4xLW1tNC9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jLm9yaWcJ
MjAwNC0wMS0xOSAwODoyMzo0Ni45MjQzMjMwMzIgLTA4MDAKKysrIGxpbnV4LTIuNi4xLW1tNC9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jCTIwMDQtMDEtMTkgMDg6MjQ6NDguODYwOTA3
MjQwIC0wODAwCkBAIC0xNTkyLDYgKzE1OTIsOCBAQAogCWlmICghYXRvbWljX3JlYWQoJmhhLT5s
b29wX2Rvd25fdGltZXIpICYmCiAJICAgICEodGVzdF9iaXQoTE9PUF9SRVNZTkNfTkVFREVELCAm
aGEtPmRwY19mbGFncykpKSB7CiAKKwkJcWxhMngwMF9jb25maWdfb3MoaGEpOworCiAJCS8qIElm
IHdlIGZvdW5kIGFsbCBkZXZpY2VzIHRoZW4gZ28gcmVhZHkgKi8KIAkJaWYgKCEodGVzdF9iaXQo
TE9HSU5fUkVUUllfTkVFREVELCAmaGEtPmRwY19mbGFncykpKSB7CiAJCQlhdG9taWNfc2V0KCZo
YS0+bG9vcF9zdGF0ZSwgTE9PUF9SRUFEWSk7Cg==

------_=_NextPart_001_01C3DEAE.1B255EDE--
