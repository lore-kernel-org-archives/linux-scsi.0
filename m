From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 2/3] nvme-fabrics: revise host transport option
 descriptions
Date: Thu, 28 Jul 2016 17:00:26 -0700
Message-ID: <579a9c9a.hlvHI7SZaXIxRR5X%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33722 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbcG2AA3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2016 20:00:29 -0400
Received: by mail-pf0-f182.google.com with SMTP id y134so26535788pfg.0
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2016 17:00:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org


Revise some of the comments so not so ethernet-network centric

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/nvme/host/fabrics.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index 89df52c..2755efd 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -64,9 +64,10 @@ enum {
  *		being added.
  * @subsysnqn:	Hold the fully qualified NQN subystem name (format defined
  *		in the NVMe specification, "NVMe Qualified Names").
- * @traddr:	network address that will be used by the host to communicate
- *		to the added NVMe controller.
- * @trsvcid:	network port used for host-controller communication.
+ * @traddr:	The transport-specific TRADDR field for a port on the
+ *              subsystem which is adding a controller.
+ * @trsvcid:	The transport-specific TRSVCID field for a port on the
+ *              subsystem which is adding a controller.
  * @queue_size: Number of IO queue elements.
  * @nr_io_queues: Number of controller IO queues that will be established.
  * @reconnect_delay: Time between two consecutive reconnect attempts.
-- 
2.5.0

