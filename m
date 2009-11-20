From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 7/9] libfc: add fcoe_fc_els_lesb to fc_fcoe.h for FC-BB-5 LESB
	definitions
Date: Fri, 20 Nov 2009 14:55:14 -0800
Message-ID: <20091120225514.495.46190.stgit@localhost.localdomain>
References: <20091120225436.495.88600.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431AbZKTWzH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 17:55:07 -0500
In-Reply-To: <20091120225436.495.88600.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

Add struct fcoe_fc_els_lesb as described in FC-BB-5 LESB for FCoE. It has
the same size as LESB defined in FC-FS-3 (struct fc_els_lesb) but members
have different meanings according to FC-BB-5.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/fc/fc_fcoe.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/scsi/fc/fc_fcoe.h b/include/scsi/fc/fc_fcoe.h
index ccb3dbe..e6ad3d2 100644
--- a/include/scsi/fc/fc_fcoe.h
+++ b/include/scsi/fc/fc_fcoe.h
@@ -86,6 +86,18 @@ struct fcoe_crc_eof {
 #define FCOE_MIN_FRAME 46
 
 /*
+ * FCoE Link Error Status Block: T11 FC-BB-5 Rev2.0, Clause 7.10.
+ */
+struct fcoe_fc_els_lesb {
+	__be32		lesb_link_fail;	/* link failure count */
+	__be32		lesb_vlink_fail; /* virtual link failure count */
+	__be32		lesb_miss_fka;	/* missing FIP keep-alive count */
+	__be32		lesb_symb_err;	/* symbol error during carrier count */
+	__be32		lesb_err_block;	/* errored block count */
+	__be32		lesb_fcs_error; /* frame check sequence error count */
+};
+
+/*
  * fc_fcoe_set_mac - Store OUI + DID into MAC address field.
  * @mac: mac address to be set
  * @did: fc dest id to use

