From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/10] [FCoE] Remove ASSERTs from frame headers.
Date: Tue, 22 Jan 2008 16:37:26 -0800
Message-ID: <20080123003726.8469.28067.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34270 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757881AbYAWAvS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:51:18 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/include/fc_frame.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/ofc/include/fc_frame.h b/drivers/scsi/ofc/include/fc_frame.h
index 6f8e85e..3fce700 100644
--- a/drivers/scsi/ofc/include/fc_frame.h
+++ b/drivers/scsi/ofc/include/fc_frame.h
@@ -126,7 +126,6 @@ struct fc_frame *fc_frame_alloc_fill(struct fc_port *, size_t payload_len);
 static inline struct fc_frame *fc_port_frame_alloc(struct fc_port *port,
 	size_t payload_len)
 {
-	WARN_ON((payload_len % 4) != 0);
 	return (*port->np_frame_alloc)(payload_len);
 }
 

