From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 1/3] SCSI: fix typo in definition of struct scsi_target
Date: Tue, 10 Jan 2012 13:43:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1201101336500.1594-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55183 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756457Ab2AJSnF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 13:43:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>
Cc: Perry Wagle <wagle@mac.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

This patch (as1506) corrects a typo in the definition of the
scsi_target structure.  pdt_1f_for_no_lun is supposed to be a
single-bit flag, not a full-sized integer.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

 include/scsi/scsi_device.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: usb-3.2/include/scsi/scsi_device.h
===================================================================
--- usb-3.2.orig/include/scsi/scsi_device.h
+++ usb-3.2/include/scsi/scsi_device.h
@@ -247,8 +247,8 @@ struct scsi_target {
 	unsigned int		single_lun:1;	/* Indicates we should only
 						 * allow I/O to one of the luns
 						 * for the device at a time. */
-	unsigned int		pdt_1f_for_no_lun;	/* PDT = 0x1f */
-						/* means no lun present */
+	unsigned int		pdt_1f_for_no_lun:1;	/* PDT = 0x1f
+						 * means no lun present. */
 	/* commands actually active on LLD. protected by host lock. */
 	unsigned int		target_busy;
 	/*

