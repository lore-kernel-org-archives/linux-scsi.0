From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] aacraid: fix integer constant warning
Date: Tue, 16 Nov 2004 15:13:31 -0800
Message-ID: <419A899B.6010401@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030306090708000107090400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:11246 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261897AbUKPX0S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 18:26:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------030306090708000107090400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


drivers/scsi/aacraid/aachba.c:1140: warning: integer constant is too 
large for "long" type

diffstat:=
  drivers/scsi/aacraid/aachba.c |    2 +-
  1 files changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

--------------030306090708000107090400
Content-Type: text/x-patch;
 name="aachba_const.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aachba_const.patch"

diff -Naurp ./drivers/scsi/aacraid/aachba.c~aachba_const ./drivers/scsi/aacraid/aachba.c
--- ./drivers/scsi/aacraid/aachba.c~aachba_const	2004-11-16 13:33:33.951988776 -0800
+++ ./drivers/scsi/aacraid/aachba.c	2004-11-16 14:27:58.464707408 -0800
@@ -1137,7 +1137,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 		char *cp;
 
 		dprintk((KERN_DEBUG "READ CAPACITY command.\n"));
-		if (fsa_dev_ptr[cid].size <= 0x100000000)
+		if (fsa_dev_ptr[cid].size <= 0x100000000ULL)
 			capacity = fsa_dev_ptr[cid].size - 1;
 		else
 			capacity = (u32)-1;

--------------030306090708000107090400--
