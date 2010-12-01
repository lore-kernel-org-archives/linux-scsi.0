From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/27] libfc: remove define of fc_seq_exch in fc_exch.c
Date: Tue, 30 Nov 2010 16:18:01 -0800
Message-ID: <20101201001801.18369.8458.stgit@localhost.localdomain>
References: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60756 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab0LAASD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:18:03 -0500
In-Reply-To: <20101201001756.18369.7107.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

The define for fc_seq_exch is unnecessary, since it also appears in scsi/libfc.h

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_exch.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index ec2a1ae..1dec593 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -108,7 +108,6 @@ struct fc_exch_mgr {
 		atomic_t non_bls_resp;
 	} stats;
 };
-#define	fc_seq_exch(sp) container_of(sp, struct fc_exch, seq)
 
 /**
  * struct fc_exch_mgr_anchor - primary structure for list of EMs

