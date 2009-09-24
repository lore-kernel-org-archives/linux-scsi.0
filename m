From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/4] Convert a dev_info to a dev_dbg
Date: Thu, 24 Sep 2009 16:18:27 -0600
Message-ID: <20090924221827.GB7943@parisc-linux.org>
References: <20090920225348.GB3690@parisc-linux.org> <Pine.LNX.4.44L0.0909202104300.14465-100000@netrider.rowland.org> <20090924221702.GA7943@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41288 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZIXWSX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 18:18:23 -0400
Content-Disposition: inline
In-Reply-To: <20090924221702.GA7943@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

Knowing which configuration was chosen is a debugging aid more than it
is informational.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/usb/core/generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index 30ecac3..60368ae 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -139,7 +139,7 @@ int usb_choose_configuration(struct usb_device *udev)
 
 	if (best) {
 		i = best->desc.bConfigurationValue;
-		dev_info(&udev->dev,
+		dev_dbg(&udev->dev,
 			"configuration #%d chosen from %d choice%s\n",
 			i, num_configs, plural(num_configs));
 	} else {
-- 
1.6.3.3

