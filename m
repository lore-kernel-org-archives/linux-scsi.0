From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: PATCH: fix crashes with aacraid
Date: Mon, 27 Dec 2004 14:43:37 +0000
Message-ID: <1104158617.20952.51.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:48283 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S261913AbUL0Prd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Dec 2004 10:47:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, markh@osdl.org

Is this change still needed for 2.6.10  Mark ?

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.10/drivers/scsi/aacraid/commsup.c linux-2.6.10/drivers/scsi/aacraid/commsup.c
--- linux.vanilla-2.6.10/drivers/scsi/aacraid/commsup.c	2004-12-25 21:14:35.000000000 +0000
+++ linux-2.6.10/drivers/scsi/aacraid/commsup.c	2004-12-26 18:53:37.261691936 +0000
@@ -781,6 +781,7 @@
 static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib;
+#if 0	
 	/*
 	 * Set the status of this FIB to be Invalid parameter.
 	 *
@@ -788,6 +789,8 @@
 	 */
 	*(u32 *)hw_fib->data = cpu_to_le32(ST_OK);
 	fib_adapter_complete(fibptr, sizeof(u32));
+	/* This will be done on our return */
+#endif
 }
 
 /**

