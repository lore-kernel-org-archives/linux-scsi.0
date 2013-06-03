From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 5/5] Drivers: scsi: storvsc: Increase the value of STORVSC_MAX_IO_REQUESTS
Date: Mon,  3 Jun 2013 16:21:28 -0700
Message-ID: <1370301688-27286-5-git-send-email-kys@microsoft.com>
References: <1370301519-27196-1-git-send-email-kys@microsoft.com>
 <1370301688-27286-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:50505
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759397Ab3FCWqY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jun 2013 18:46:24 -0400
In-Reply-To: <1370301688-27286-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

Increase the value of STORVSC_MAX_IO_REQUESTS to 200 requests. The current
ringbuffer size can support this higher value.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a728179..e32a0b2 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -328,7 +328,7 @@ static int storvsc_timeout = 180;
 module_param(storvsc_timeout, uint, (S_IRUGO | S_IWUSR));
 MODULE_PARM_DESC(storvsc_timeout, "Device timeout (seconds)");
 
-#define STORVSC_MAX_IO_REQUESTS				128
+#define STORVSC_MAX_IO_REQUESTS				200
 
 static void storvsc_on_channel_callback(void *context);
 
-- 
1.7.4.1

