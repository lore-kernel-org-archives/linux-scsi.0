From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove dead struct/typedef from hosts.h
Date: Sun, 17 Nov 2002 23:51:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117235115.A9824@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.37/drivers/scsi/hosts.h	Sat Nov 16 20:26:02 2002
+++ edited/drivers/scsi/hosts.h	Sun Nov 17 21:37:54 2002
@@ -500,15 +500,6 @@
 extern void scsi_unblock_requests(struct Scsi_Host *);
 extern void scsi_block_requests(struct Scsi_Host *);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
-
-typedef struct SHN
-{
-	struct list_head shn_list;
-	char *name;
-	unsigned short host_no;
-	unsigned short host_registered;
-} Scsi_Host_Name;
-	
 extern void scsi_register_blocked_host(struct Scsi_Host *);
 extern void scsi_deregister_blocked_host(struct Scsi_Host *);
 
