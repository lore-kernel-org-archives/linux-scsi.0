From: tom.ty89@gmail.com
Subject: [PATCH v2 1/1] uas: remove can_queue set in host template
Date: Tue, 24 May 2016 03:28:44 +0800
Message-ID: <574359f3.4667620a.6c0f.528f@mx.google.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: kraxel@redhat.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, hdegoede@redhat.com, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level") made
qdepth limit set in host template (`.can_queue = MAX_CMNDS`) redundant.
Removing it to avoid confusion.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 4d49fce..e03c490 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -848,7 +848,6 @@ static struct scsi_host_template uas_host_template = {
 	.slave_configure = uas_slave_configure,
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_bus_reset_handler = uas_eh_bus_reset_handler,
-	.can_queue = MAX_CMNDS,
 	.this_id = -1,
 	.sg_tablesize = SG_NONE,
 	.skip_settle_delay = 1,
-- 
2.8.2
