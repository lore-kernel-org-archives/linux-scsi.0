From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: [PATCH] 2.4.26-rc2 add devices to scsi_scan.c's blacklist
Date: Mon, 12 Apr 2004 12:14:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA203B9616@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C420C2.61DFBCE8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus19.xyratex.com ([65.203.33.19]:57823 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S263039AbUDLTOe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Apr 2004 15:14:34 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Frank Borich <Frank_Borich@us.xyratex.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C420C2.61DFBCE8
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

This patch sets BLIST_SPARSELUN and BLIST_FORCELUN flags for=20
Xyratex 4200. =20

Thanks,
Frank Borich
------------------------------------------------------------------
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
=20


------_=_NextPart_001_01C420C2.61DFBCE8
Content-Type: application/octet-stream;
	name="XYR4200.patch"
Content-Transfer-Encoding: base64
Content-Description: XYR4200.patch
Content-Disposition: attachment;
	filename="XYR4200.patch"

LS0tIHNjc2lfc2Nhbi5jLk9MRAkyMDA0LTA0LTA5IDA3OjQ5OjM5LjAwMDAwMDAwMCAtMDUwMAor
Kysgc2NzaV9zY2FuLmMJMjAwNC0wNC0xMyAxMjowODoyNy4wMDAwMDAwMDAgLTA1MDAKQEAgLTIw
Nyw2ICsyMDcsOCBAQAogCXsiU01TQyIsICJVU0IgMiBIUyIsICIqIiwgQkxJU1RfU1BBUlNFTFVO
IHwgQkxJU1RfTEFSR0VMVU59LCAKIAl7IlhZUkFURVgiLCAiUlMiLCAiKiIsIEJMSVNUX1NQQVJT
RUxVTiB8IEJMSVNUX0xBUkdFTFVOfSwKIAl7Ik5FQyIsICJpU3RvcmFnZSIsICIqIiwgQkxJU1Rf
U1BBUlNFTFVOIHwgQkxJU1RfTEFSR0VMVU4gfCBCTElTVF9GT1JDRUxVTn0sCisJeyJYeXJhdGV4
IiwgIjQyMDAiLCAiKiIsIEJMSVNUX1NQQVJTRUxVTiB8IEJMSVNUX0ZPUkNFTFVOfSwKKwl7IkNO
U2kiLCAiSiIsICIqIiwgQkxJU1RfU1BBUlNFTFVOIHwgQkxJU1RfRk9SQ0VMVU59LAogCiAJLyoK
IAkgKiBNdXN0IGJlIGF0IGVuZCBvZiBsaXN0Li4uCg==

------_=_NextPart_001_01C420C2.61DFBCE8--
