From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: change srb status busy return
Date: Tue, 19 Jun 2007 11:41:21 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22D5D@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01AB890D@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7B288.497CF21C"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:56646 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbXFSPlY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 11:41:24 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 4AB3118AB35
	for <linux-scsi@vger.kernel.org>; Tue, 19 Jun 2007 08:41:23 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01AB890D@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7B288.497CF21C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This patch is more like a spelling correction than a fix. It was
discovered that if we had a busy status return from the Adapter for the
SCSI srb command to a physical component, that we returned
DID_NO_CONNECT rather than what one would expect DID_BUS_BUSY.

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)=20

------_=_NextPart_001_01C7B288.497CF21C
Content-Type: application/octet-stream;
	name="aacraid_srb_status_busy.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_srb_status_busy.patch
Content-Disposition: attachment;
	filename="aacraid_srb_status_busy.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDYtMTkgMTE6MzE6NTkuODgxNTk2MzAyIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDYtMTkgMTE6MzU6NTMuNDEyMTI2Mzk0IC0wNDAwCkBAIC0yMjY2LDcg
KzIyNjYsNyBAQAogCQlicmVhazsKIAogCWNhc2UgU1JCX1NUQVRVU19CVVNZOgotCQlzY3NpY21k
LT5yZXN1bHQgPSBESURfTk9fQ09OTkVDVCA8PCAxNiB8IENPTU1BTkRfQ09NUExFVEUgPDwgODsK
KwkJc2NzaWNtZC0+cmVzdWx0ID0gRElEX0JVU19CVVNZIDw8IDE2IHwgQ09NTUFORF9DT01QTEVU
RSA8PCA4OwogCQlicmVhazsKIAogCWNhc2UgU1JCX1NUQVRVU19CVVNfUkVTRVQ6Cg==

------_=_NextPart_001_01C7B288.497CF21C--
