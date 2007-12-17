From: Joe Perches <joe@perches.com>
Subject: [PATCH] include/scsi/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:26 -0800
Message-ID: <1197920439-5455-20-git-send-email-joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3212 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933971AbXLQTlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:24 -0500
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918894.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/scsi/scsi_transport_fc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index e466d88..4769efd 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -176,7 +176,7 @@ struct class_device_attribute class_device_attr_vport_##_name = 	\
  * ports has a unique presense on the SAN, and may be instantiated via
  * NPIV, Virtual Fabrics, or via additional ALPAs. As the vport is a
  * unique presense, each vport has it's own view of the fabric,
- * authentication priviledge, and priorities.
+ * authentication privilege, and priorities.
  *
  * A virtual port may support 1 or more FC4 roles. Typically it is a
  * FCP Initiator. It could be a FCP Target, or exist sole for an IP over FC
-- 
1.5.3.7.949.g2221a6

