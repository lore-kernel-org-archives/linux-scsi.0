From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH] raid_class.c - adding RAID10 and RAID10 defines
Date: Wed, 4 Jan 2006 14:58:43 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F153870@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C6117A.079E78B3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43677 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030260AbWADV6t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 16:58:49 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jejb@steeleye.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C6117A.079E78B3
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Adding defines for RAID10 and RAID50 levels, in preparation
of adding RAID Transport support in the mpt fusion drivers.
(BTW: IME is RAID10, and IM is RAID1).

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_001_01C6117A.079E78B3
Content-Type: application/octet-stream;
	name="raid_class.patch"
Content-Transfer-Encoding: base64
Content-Description: raid_class.patch
Content-Disposition: attachment;
	filename="raid_class.patch"

LS0tIGIvaW5jbHVkZS9saW51eC9yYWlkX2NsYXNzLmgJMjAwNS0xMi0yOCAxMzo1NzowOC4wMDAw
MDAwMDAgLTA3MDAKKysrIGEvaW5jbHVkZS9saW51eC9yYWlkX2NsYXNzLmgJMjAwNi0wMS0wNCAx
NDo0MDozMC4wMDAwMDAwMDAgLTA3MDAKQEAgLTMxLDkgKzMxLDExIEBACiAJUkFJRF9MRVZFTF9M
SU5FQVIsCiAJUkFJRF9MRVZFTF8wLAogCVJBSURfTEVWRUxfMSwKKwlSQUlEX0xFVkVMXzEwLAog
CVJBSURfTEVWRUxfMywKIAlSQUlEX0xFVkVMXzQsCiAJUkFJRF9MRVZFTF81LAorCVJBSURfTEVW
RUxfNTAsCiAJUkFJRF9MRVZFTF82LAogfTsKIAotLS0gYi9kcml2ZXJzL3Njc2kvcmFpZF9jbGFz
cy5jCTIwMDUtMTItMjggMTM6NTc6NDIuMDAwMDAwMDAwIC0wNzAwCisrKyBhL2RyaXZlcnMvc2Nz
aS9yYWlkX2NsYXNzLmMJMjAwNi0wMS0wNCAxNDo0MTowNy4wMDAwMDAwMDAgLTA3MDAKQEAgLTE0
OCw5ICsxNDgsMTEgQEAKIAl7IFJBSURfTEVWRUxfTElORUFSLCAibGluZWFyIiB9LAogCXsgUkFJ
RF9MRVZFTF8wLCAicmFpZDAiIH0sCiAJeyBSQUlEX0xFVkVMXzEsICJyYWlkMSIgfSwKKwl7IFJB
SURfTEVWRUxfMTAsICJyYWlkMTAiIH0sCiAJeyBSQUlEX0xFVkVMXzMsICJyYWlkMyIgfSwKIAl7
IFJBSURfTEVWRUxfNCwgInJhaWQ0IiB9LAogCXsgUkFJRF9MRVZFTF81LCAicmFpZDUiIH0sCisJ
eyBSQUlEX0xFVkVMXzUwLCAicmFpZDUwIiB9LAogCXsgUkFJRF9MRVZFTF82LCAicmFpZDYiIH0s
CiB9OwogCg==

------_=_NextPart_001_01C6117A.079E78B3--
