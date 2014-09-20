From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [PATCH] scsi_host: fix comment
Date: Sat, 20 Sep 2014 13:37:55 +0200
Message-ID: <20140920133755.0000496a@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54668 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601AbaITLh7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2014 07:37:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Sebastian Herbszt <herbszt@gmx.de>

Commit 1abf635 (scsi: use 64-bit value for 'max_luns') changed the order
of Scsi_Host members. Update the comment to reflect this.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index ba20347..d4e0509 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -603,13 +603,13 @@ struct Scsi_Host {
 	unsigned long last_reset;
 
 
 	/*
 	 * These three parameters can be used to allow for wide scsi,
 	 * and for host adapters that support multiple busses
-	 * The first two should be set to 1 more than the actual max id
+	 * The last two should be set to 1 more than the actual max id
 	 * or lun (e.g. 8 for SCSI parallel systems).
 	 */
 	unsigned int max_channel;
 	unsigned int max_id;
 	u64 max_lun;
 
