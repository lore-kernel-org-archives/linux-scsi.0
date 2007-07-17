From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: correct valid container response in management ioctl
Date: Tue, 17 Jul 2007 10:59:19 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5D2E@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5C40@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7C883.0DA6D020"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:50960 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbXGQO7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 10:59:21 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 5791D191FBF
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2007 07:59:20 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5C40@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7C883.0DA6D020
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

During an Adapter Initiated scan request, the query disk ioctl reports a
value of 2 rather than 1 for the valid field. This presents a problem
for some legacy management applications.

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
=20
Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7C883.0DA6D020
Content-Type: application/octet-stream;
	name="aacraid_valid_check.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_valid_check.patch
Content-Disposition: attachment;
	filename="aacraid_valid_check.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDctMTcgMTA6NTI6NTAuNDA1MjI5Njc2IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDctMTcgMTA6NTM6MjMuMjM1MDkwNjg2IC0wNDAwCkBAIC0yMDcwLDcg
KzIwNzAsNyBAQAogCX0KIAllbHNlIHJldHVybiAtRUlOVkFMOwogCi0JcWQudmFsaWQgPSBmc2Ff
ZGV2X3B0cltxZC5jbnVtXS52YWxpZDsKKwlxZC52YWxpZCA9IGZzYV9kZXZfcHRyW3FkLmNudW1d
LnZhbGlkICE9IDA7CiAJcWQubG9ja2VkID0gZnNhX2Rldl9wdHJbcWQuY251bV0ubG9ja2VkOwog
CXFkLmRlbGV0ZWQgPSBmc2FfZGV2X3B0cltxZC5jbnVtXS5kZWxldGVkOwogCg==

------_=_NextPart_001_01C7C883.0DA6D020--
