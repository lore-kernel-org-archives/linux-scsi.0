From: "Frank Borich" <Frank_Borich@us.xyratex.com>
Subject: [PATCH] 2.4.26 add devices to scsi_scan.c's blacklist
Date: Thu, 15 Apr 2004 07:40:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <47F3C2BE74738E4683574107469DFA203B961C@XYUSEX01.xyus.xyratex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C422F7.A543803C"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratexus19.xyratex.com ([65.203.33.19]:61219 "EHLO
	XYUSEX01.xyus.xyratex.com") by vger.kernel.org with ESMTP
	id S264114AbUDOOkz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Apr 2004 10:40:55 -0400
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C422F7.A543803C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
Apologies for the late submission to 2.4.26-rc2. =20
This patch sets BLIST_SPARSELUN and BLIST_FORCELUN flags for=20
Xyratex 4200 for 2.4.26. =20

Thanks,
Frank Borich
------------------------------------------------------------------
Systems Engineer
Direct 630 654 6089
Fax 630 325 2513
e-mail frank_borich@us.xyratex.com
=20


------_=_NextPart_001_01C422F7.A543803C
Content-Type: application/octet-stream;
	name="XYR4200.patch"
Content-Transfer-Encoding: base64
Content-Description: XYR4200.patch
Content-Disposition: attachment;
	filename="XYR4200.patch"

LS0tIHNjc2lfc2Nhbi5jLm9sZAkyMDA0LTA0LTE0IDA5OjQ5OjM2LjAwMDAwMDAwMCAtMDUwMAor
Kysgc2NzaV9zY2FuLmMJMjAwNC0wNC0xNCAwOTo1NToxOS4wMDAwMDAwMDAgLTA1MDAKQEAgLTIw
OCw3ICsyMDgsOSBAQAogCXsiU01TQyIsICJVU0IgMiBIUyIsICIqIiwgQkxJU1RfU1BBUlNFTFVO
IHwgQkxJU1RfTEFSR0VMVU59LCAKIAl7IlhZUkFURVgiLCAiUlMiLCAiKiIsIEJMSVNUX1NQQVJT
RUxVTiB8IEJMSVNUX0xBUkdFTFVOfSwKIAl7Ik5FQyIsICJpU3RvcmFnZSIsICIqIiwgQkxJU1Rf
U1BBUlNFTFVOIHwgQkxJU1RfTEFSR0VMVU4gfCBCTElTVF9GT1JDRUxVTn0sCi0KKwl7Ilh5cmF0
ZXgiLCAiNDIwMCIsICIqIiwgQkxJU1RfU1BBUlNFTFVOIHwgQkxJU1RfRk9SQ0VMVU59LAorCXsi
Q05TaSIsICJKIiwgIioiLCBCTElTVF9TUEFSU0VMVU4gfCBCTElTVF9GT1JDRUxVTn0sCisJCiAJ
LyoKIAkgKiBNdXN0IGJlIGF0IGVuZCBvZiBsaXN0Li4uCiAJICovCg==

------_=_NextPart_001_01C422F7.A543803C--
