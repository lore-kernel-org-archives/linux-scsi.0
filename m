From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] remove ->emulated from host template, part 2
Date: Wed, 31 Mar 2004 19:06:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406B5D0B.8020901@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000408050509050407020608"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:65233 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262103AbUDAAGs
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 19:06:48 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000408050509050407020608
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


and once all the uses are gone, we can kill it from the struct itself.



--------------000408050509050407020608
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== include/scsi/scsi_host.h 1.14 vs edited =====
--- 1.14/include/scsi/scsi_host.h	Thu Mar  4 17:29:02 2004
+++ edited/include/scsi/scsi_host.h	Wed Mar 31 19:05:42 2004
@@ -309,11 +309,6 @@
 	unsigned use_clustering:1;
 
 	/*
-	 * True for emulated SCSI host adapters (e.g. ATAPI)
-	 */
-	unsigned emulated:1;
-
-	/*
 	 * Countdown for host blocking with no commands outstanding
 	 */
 	unsigned int max_host_blocked;

--------------000408050509050407020608--

