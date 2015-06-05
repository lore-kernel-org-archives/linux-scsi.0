From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 1/3] libfc: Fix a typo in a source code comment
Date: Fri, 05 Jun 2015 14:20:40 -0700
Message-ID: <20150605212040.6054.1198.stgit@lin-nd1-054.jf.intel.com>
References: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10762 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbbFEVUl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Jun 2015 17:20:41 -0400
In-Reply-To: <20150605212003.6054.15351.stgit@lin-nd1-054.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: fcoe-devel@open-fcoe.org, target-devel <target-devel@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Vasu Dev <vasu.dev@intel.com>

From: Bart Van Assche <bart.vanassche@sandisk.com>

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index c679594..4cd49d4 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -191,7 +191,7 @@ static void fc_fcp_pkt_hold(struct fc_fcp_pkt *fsp)
 }
 
 /**
- * fc_fcp_pkt_destory() - Release hold on a fcp_pkt
+ * fc_fcp_pkt_destroy() - Release hold on a fcp_pkt
  * @seq: The sequence that the FCP packet is on (required by destructor API)
  * @fsp: The FCP packet to be released
  *

