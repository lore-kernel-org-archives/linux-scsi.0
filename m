From: akpm@osdl.org
Subject: [patch 12/28] drivers/scsi/FlashPoint.c: remove ushort_ptr
Date: Wed, 08 Mar 2006 00:14:27 -0800
Message-ID: <200603080816.k288GGt6002188@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25004 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1752100AbWCHIQU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com


From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/FlashPoint.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-ushort_ptr drivers/scsi/FlashPoint.c
--- 25/drivers/scsi/FlashPoint.c~drivers-scsi-flashpointc-remove-ushort_ptr	Mon Feb  6 14:50:06 2006
+++ 25-akpm/drivers/scsi/FlashPoint.c	Mon Feb  6 14:50:06 2006
@@ -42,7 +42,6 @@
 
 
 
-typedef unsigned short          * ushort_ptr;
 
 
 #define s08bits	char
@@ -6003,7 +6002,7 @@ static void FPT_scasid(unsigned char p_c
    unsigned char i,k,scam_id;
 	unsigned char crcBytes[3];
 	PNVRamInfo pCurrNvRam;
-	ushort_ptr pCrcBytes;
+	unsigned short * pCrcBytes;
 
 	pCurrNvRam = FPT_BL_Card[p_card].pNvRamInfo;
 
@@ -6023,7 +6022,7 @@ static void FPT_scasid(unsigned char p_c
       if (!(FPT_sciso(p_port,&temp_id_string[0])))
          {
 			if(pCurrNvRam){
-				pCrcBytes = (ushort_ptr)&crcBytes[0];
+				pCrcBytes = (unsigned short *)&crcBytes[0];
 				*pCrcBytes = FPT_CalcCrc16(&temp_id_string[0]);
 				crcBytes[2] = FPT_CalcLrc(&temp_id_string[0]);
 				temp_id_string[1] = crcBytes[2];
_
