From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] current scsi-misc-2.5 scsi_lib.c needs init.h
Date: Thu, 5 Dec 2002 14:16:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021205141633.A10103@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: JEJ Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

The current scsi-misc-2.5 scsi_lib.c needs to include init.h
to get the __init and __exit defined.

--- 1.57/drivers/scsi/scsi_lib.c	Thu Dec  5 11:59:51 2002
+++ edited/drivers/scsi/scsi_lib.c	Thu Dec  5 13:11:35 2002
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/mempool.h>
 #include <linux/slab.h>
+#include <linux/init.h>
 
 #include "scsi.h"
 #include "hosts.h"

-- Patrick Mansfield
