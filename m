From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 01/17] Clear up sc_data_direction documentation
Date: Fri, 23 Jan 2015 13:06:19 +0100
Message-ID: <54C2393B.5000208@sandisk.com>
References: <54C2390A.3000700@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0056.outbound.protection.outlook.com ([157.56.111.56]:60362
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750881AbbAWMGZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:06:25 -0500
In-Reply-To: <54C2390A.3000700@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 Documentation/DMA-API-HOWTO.txt         | 6 +++---
 Documentation/scsi/scsi_mid_low_api.txt | 5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 0f7afb2..3999ec3 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -507,9 +507,9 @@ Only streaming mappings specify a direction, consistent mappings
 implicitly have a direction attribute setting of
 DMA_BIDIRECTIONAL.
 
-The SCSI subsystem tells you the direction to use in the
-'sc_data_direction' member of the SCSI command your driver is
-working on.
+Except for bidi commands, the SCSI subsystem tells you the direction to
+use in the 'sc_data_direction' member of the SCSI command your driver
+is working on.
 
 For Networking drivers, it's a rather simple affair.  For transmit
 packets, map/unmap them with the DMA_TO_DEVICE direction
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index 731bc4f..39cbbca 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1259,8 +1259,9 @@ be at least one instance of struct scsi_cmnd available for each SCSI device.
 Members of interest:
     cmnd         - array containing SCSI command
     cmnd_len     - length (in bytes) of SCSI command
-    sc_data_direction - direction of data transfer in data phase. See
-                "enum dma_data_direction" in include/linux/dma-mapping.h
+    sc_data_direction - except for bidi commands, direction of data transfer
+                in data phase. See "enum dma_data_direction" in
+                include/linux/dma-mapping.h
     request_bufflen - number of data bytes to transfer (0 if no data phase)
     use_sg       - ==0 -> no scatter gather list, hence transfer data
                           to/from request_buffer
-- 
2.1.2

