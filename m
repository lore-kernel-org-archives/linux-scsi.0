From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 1/7] scsi: storvsc: Increase the ring buffer size
Date: Mon, 23 Mar 2015 14:06:35 -0700
Message-ID: <1427144801-11920-1-git-send-email-kys@microsoft.com>
References: <1427144760-11875-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427144760-11875-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Increase the default ring buffer size as this can significantly
improve performance especially on high latency storage back-ends.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index efc6e44..27fe850 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -308,7 +308,7 @@ enum storvsc_request_type {
  * This is the end of Protocol specific defines.
  */
 
-static int storvsc_ringbuffer_size = (20 * PAGE_SIZE);
+static int storvsc_ringbuffer_size = (256 * PAGE_SIZE);
 
 module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
-- 
1.7.4.1
