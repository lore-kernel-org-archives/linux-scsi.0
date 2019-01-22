From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] SCSI: fcoe: remove unneeded fcoe_ctlr_destroy_store export
Date: Tue, 22 Jan 2019 15:28:18 +0100
Message-ID: <20190122142818.GC18225@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jth@kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There's no need to export fcoe_ctlr_destroy_store as a symbol, so remove
the EXPORT_SYMBOL() line for it.

Cc: Johannes Thumshirn <jth@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/fcoe/fcoe_transport.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index f4909cd206d3..6d3949b687ef 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -855,7 +855,6 @@ ssize_t fcoe_ctlr_destroy_store(struct bus_type *bus,
 	mutex_unlock(&ft_mutex);
 	return rc;
 }
-EXPORT_SYMBOL(fcoe_ctlr_destroy_store);
 
 /**
  * fcoe_transport_create() - Create a fcoe interface
-- 
2.20.1
