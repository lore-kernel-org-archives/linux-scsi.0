From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 20/24] fcoe: ETH_P_8021Q is already in if_ether and fcoe is
	not using it anyway
Date: Fri, 27 Feb 2009 10:56:16 -0800
Message-ID: <20090227185616.25509.86752.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26737 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbZB0S4S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:18 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

From: Yi Zou <yi.zou@intel.com>

fcoe: ETH_P_8021Q is already in if_ether and fcoe is not using it anyway

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/fc/fc_fcoe.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/scsi/fc/fc_fcoe.h b/include/scsi/fc/fc_fcoe.h
index 57aaa8f..f271d9c 100644
--- a/include/scsi/fc/fc_fcoe.h
+++ b/include/scsi/fc/fc_fcoe.h
@@ -31,10 +31,6 @@
 #define	ETH_P_FCOE	0x8906		/* FCOE ether type */
 #endif
 
-#ifndef ETH_P_8021Q
-#define	ETH_P_8021Q	0x8100
-#endif
-
 /*
  * FC_FCOE_OUI hasn't been standardized yet.   XXX TBD.
  */

