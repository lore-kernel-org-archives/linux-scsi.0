From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: Re: 2.6.0-test1 and qlogic 8.00.00b4 driver
Date: Tue, 29 Jul 2003 09:27:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598B26@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C355EE.4B5F10BF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:18500 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S271895AbTG2Q1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jul 2003 12:27:19 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C355EE.4B5F10BF
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Andrew,

> Is the midlayer not scanning the devices or does the device driver not
> recognize any devices to present to the mid-layer during its scan?
> Could you forward along the output of the /proc entries made by the
> device driver, for example: /proc/scsi/qla2300/0, ...
>=20
> 	# cat /proc/scsi/qla2300/0
> 	# cat /proc/scsi/qla2300/1
>=20

Forget the previous request, you'll want to apply the attached
patch to 8.00.00b4, since scsi_scan_host() is needed for the mid-layer
to initiate the scan.

Regards,
Andrew Vasquez

------_=_NextPart_001_01C355EE.4B5F10BF
Content-Type: application/octet-stream;
	name="scan_host_fix-v8.00.00b4.diff"
Content-Transfer-Encoding: base64
Content-Description: scan_host_fix-v8.00.00b4.diff
Content-Disposition: attachment;
	filename="scan_host_fix-v8.00.00b4.diff"

ZGlmZiAtTnVyZCAtWCBkb250ZGlmZiA4MDAwMGI0L3FsYV9vcy5jIDgwMDAwYjQtc2Nhbl9ob3N0
L3FsYV9vcy5jCi0tLSA4MDAwMGI0L3FsYV9vcy5jCTIwMDMtMDctMTUgMTQ6NDE6MjUuMDAwMDAw
MDAwIC0wNzAwCisrKyA4MDAwMGI0LXNjYW5faG9zdC9xbGFfb3MuYwkyMDAzLTA3LTI5IDA5OjE5
OjQ5LjE3NDI1Nzk1MiAtMDcwMApAQCAtMjYzNSw2ICsyNjM1LDggQEAKIAogCXNjc2lfYWRkX2hv
c3QoaG9zdCwgJnBkZXYtPmRldik7CiAKKwlzY3NpX3NjYW5faG9zdChob3N0KTsKKwogCXJldHVy
biAwOwogCiBwcm9iZV9mYWlsZWRfY2xlYW51cDoK

------_=_NextPart_001_01C355EE.4B5F10BF--
