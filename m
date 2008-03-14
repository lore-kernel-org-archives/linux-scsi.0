From: "nickcheng" <nick.cheng@areca.com.tw>
Subject: [PATCH] scsi: The supplement for the arithmetic of iomem of the Type_B Adapter of arcmsr
Date: Fri, 14 Mar 2008 20:51:17 +0800
Message-ID: <000201c885d2$1814ecb0$9a00a8c0@Nick>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0003_01C88615.26382CB0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 60-248-88-209.HINET-IP.hinet.net ([60.248.88.209]:25526 "EHLO
	areca.com.tw" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752485AbYCNMz3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Mar 2008 08:55:29 -0400
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, 'Tomas Henzl' <thenzl@redhat.com>, viro@ftp.linux.org.uk, 'Andrew Morton' <akpm@linux-foundation.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0003_01C88615.26382CB0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Subject: [PATCH] scsi: The supplement for the arithmetic of iomem of the
Type_B Adapter
Description:
add the description for the change of the arithmetic of iomem of the Type_B
Adapter in ChangeLog.arcmsr 
Signed-off-by: Nick Cheng <nick.cheng@areca.com.tw>

------=_NextPart_000_0003_01C88615.26382CB0
Content-Type: text/plain;
	name="patch-ChangeLog.arcmsr.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="patch-ChangeLog.arcmsr.txt"

=EF=BB=BF--- ChangeLog.arcmsr.old	2008-03-14 20:15:07.000000000 +0800
+++ ChangeLog.arcmsr.new	2008-03-14 20:02:12.000000000 +0800
@@ -115,4 +115,8 @@
 **						that the current GFP_KERNEL|GFP_DMA flags are wrong: firstly we =
are in
 **						atomic context, secondly this memory is not used for DMA.
 **						Also removed some unneeded casts. Thanks to Daniel Drake =
<dsd@gentoo.org>
+**						2.The Type B Adapter teardown does iounmap on pointers =
subtracted by a
+**						constant offset.  Since the offset is in bytes, we need the =
pointers to
+**						be of type void * not uint32_t * so the subtraction is done in =
the
+**						correct units and we iounmap the correct area.
 =
*************************************************************************=
*
------=_NextPart_000_0003_01C88615.26382CB0--

