From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI: fdomain.c: make a struct static
Date: Mon, 15 Nov 2004 02:59:58 +0100
Message-ID: <20041115015958.GI2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:7694 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261415AbUKOCMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:12:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: faith@cs.unc.edu
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes a needlessly global struct static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/fdomain.c.old	2004-11-13 21:03:26.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/fdomain.c	2004-11-13 21:03:45.000000000 +0100
@@ -458,7 +458,7 @@
 
 */
 
-struct signature {
+static struct signature {
    const char *signature;
    int  sig_offset;
    int  sig_length;

