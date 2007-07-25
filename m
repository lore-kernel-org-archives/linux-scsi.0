From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Subject: [PATCH trivial] include linux/mutex.h from scsi_transport_iscsi.h
Date: Wed, 25 Jul 2007 14:09:08 +0300
Message-ID: <20070725110907.GF3826@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:16818 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758891AbXGYLJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jul 2007 07:09:05 -0400
Received: by ug-out-1314.google.com with SMTP id j3so325820ugf
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jul 2007 04:09:03 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Roland Dreier <rdreier@cisco.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, general@lists.openfabrics.org

scsi/scsi_transport_iscsi.h uses struct mutex, so while
linux/mutex.h seems to be pulled in indirectly
by one of the headers it includes, the right thing
is to include linux/mutex.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>

---

diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 706c0cd..7530e98 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -24,6 +24,7 @@
 #define SCSI_TRANSPORT_ISCSI_H
 
 #include <linux/device.h>
+#include <linux/mutex.h>
 #include <scsi/iscsi_if.h>
 
 struct scsi_transport_template;


-- 
MST
