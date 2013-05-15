From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/6] Drivers: hv: Add the GUID fot synthetic fiber channel device
Date: Wed, 15 May 2013 15:02:30 -0700
Message-ID: <1368655354-27651-2-git-send-email-kys@microsoft.com>
References: <1368655320-27599-1-git-send-email-kys@microsoft.com>
 <1368655354-27651-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1368655354-27651-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

In preparation for supporting synthetic Fiber Channel device, add the GUID for
this service.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 include/linux/hyperv.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index a1a97a7..bffee1d 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1389,6 +1389,16 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 		}
 
 /*
+ * Synthetic FC GUID
+ * {2f9bcc4a-0069-4af3-b76b-6fd0be528cda}
+ */
+#define HV_SYNTHFC_GUID \
+	.guid = { \
+			0x4A, 0xCC, 0x9B, 0x2F, 0x69, 0x00, 0xF3, 0x4A, \
+			0xB7, 0x6B, 0x6F, 0xD0, 0xBE, 0x52, 0x8C, 0xDA \
+		}
+
+/*
  * Common header for Hyper-V ICs
  */
 
-- 
1.7.4.1
