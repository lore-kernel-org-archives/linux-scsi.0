From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove outdated comment from scsi.c
Date: Sat, 23 Nov 2002 04:03:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021123040331.B11428@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

In 2.5 there's just one request_fn left.


--- 1.73/drivers/scsi/scsi.c	Fri Nov 22 12:59:03 2002
+++ edited/drivers/scsi/scsi.c	Sat Nov 23 02:58:22 2002
@@ -169,30 +169,13 @@
 /*
  * Function:    scsi_initialize_queue()
  *
- * Purpose:     Selects queue handler function for a device.
+ * Purpose:     Sets up the block queue for a device.
  *
  * Arguments:   SDpnt   - device for which we need a handler function.
  *
  * Returns:     Nothing
  *
  * Lock status: No locking assumed or required.
- *
- * Notes:       Most devices will end up using scsi_request_fn for the
- *              handler function (at least as things are done now).
- *              The "block" feature basically ensures that only one of
- *              the blocked hosts is active at one time, mainly to work around
- *              buggy DMA chipsets where the memory gets starved.
- *              For this case, we have a special handler function, which
- *              does some checks and ultimately calls scsi_request_fn.
- *
- *              The single_lun feature is a similar special case.
- *
- *              We handle these things by stacking the handlers.  The
- *              special case handlers simply check a few conditions,
- *              and return if they are not supposed to do anything.
- *              In the event that things are OK, then they call the next
- *              handler in the list - ultimately they call scsi_request_fn
- *              to do the dirty deed.
  */
 void  scsi_initialize_queue(Scsi_Device * SDpnt, struct Scsi_Host * SHpnt)
 {
