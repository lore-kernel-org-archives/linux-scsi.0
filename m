From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] crc-t10dif.c comments
Date: Mon, 07 Nov 2011 17:59:51 -0500
Message-ID: <4EB862E7.5020606@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000706060903060906000203"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:43555 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab1KGW77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Nov 2011 17:59:59 -0500
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id D07CB2041B9
	for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2011 23:59:54 +0100 (CET)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xnBd0HEFzV3L for <linux-scsi@vger.kernel.org>;
	Mon,  7 Nov 2011 23:59:53 +0100 (CET)
Received: from [192.168.48.66] (ip-180.53.99.216.dsl-cust.ca.inter.net [216.99.53.180])
	by smtp.infotech.no (Postfix) with ESMTPA id 10AC62041B4
	for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2011 23:59:52 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------000706060903060906000203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

ChangeLog:
   - translate Latin (and Danish) to English
   - fix error (in comment) and give a reference

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------000706060903060906000203
Content-Type: text/x-patch;
 name="crc-t10dif.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="crc-t10dif.patch"

diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index fbbd66e..97cc436 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -12,9 +12,11 @@
 #include <linux/module.h>
 #include <linux/crc-t10dif.h>
 
-/* Table generated using the following polynomium:
+/* Table generated using the following polynomial:
  * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
- * gt: 0x8bb7
+ * G(x): 0x18bb7
+ *
+ * Reference: SBC-2 or SBC-3 at www.t10.org (protection information model)
  */
 static const __u16 t10_dif_crc_table[256] = {
 	0x0000, 0x8BB7, 0x9CD9, 0x176E, 0xB205, 0x39B2, 0x2EDC, 0xA56B,

--------------000706060903060906000203--
