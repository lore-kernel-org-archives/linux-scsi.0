From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [1/6] - make functions static
Date: Thu, 21 Aug 2003 20:14:34 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821101434.GB7570@twibble.org>
References: <20030821101348.GA7570@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:26002 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262556AbTHUKOf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 06:14:35 -0400
Content-Disposition: inline
In-Reply-To: <20030821101348.GA7570@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

I forgot to make some of the new functions added during the list
cleanups static. This patch just declares those new functions static.

diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-19 23:24:41.797147152 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-19 23:24:49.822927048 +1000
@@ -822,6 +822,7 @@
  *
  * @head: The pointer to the head of the list to count the items in.
  **/
+static
 unsigned int list_size(struct list_head *head)
 {
 	unsigned int count = 0;
@@ -841,6 +842,7 @@
  * @pos: The pointer the dcb for which we are searching for the
  *       following dcb.
  **/
+static
 struct DeviceCtlBlk *dcb_get_next(
 		struct list_head *head,
 		struct DeviceCtlBlk *pos)

-- 
 Jamie Lenehan <lenehan@twibble.org>
