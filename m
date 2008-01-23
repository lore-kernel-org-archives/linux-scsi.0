From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/10] [FCoE] Removing unused defines
Date: Tue, 22 Jan 2008 16:37:57 -0800
Message-ID: <20080123003757.8469.461.stgit@fritz>
References: <20080123003523.8469.62236.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:9692 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758528AbYAWAvt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 19:51:49 -0500
In-Reply-To: <20080123003523.8469.62236.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

These defines were used with the DEBUG_ASSERT code that has
been removed.

Removed defines are,

FC_ELS_CSP_LEN
FC_ELS_CSSP_LEN
FC_ELS_FLOGI_LEN
FC_ELS_SPP_LEN
FC_ELS_RRQ_LEN
FC_ELS_PRLI_LEN
FC_ELS_LOGO_LEN

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/ofc/include/fc_els.h |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)


diff --git a/drivers/scsi/ofc/include/fc_els.h b/drivers/scsi/ofc/include/fc_els.h
index 6bff73e..502f0c5 100644
--- a/drivers/scsi/ofc/include/fc_els.h
+++ b/drivers/scsi/ofc/include/fc_els.h
@@ -232,8 +232,6 @@ struct fc_els_csp {
 #define	sp_rel_off	sp_u.sp_plogi._sp_rel_off
 #define	sp_r_a_tov	sp_u.sp_flogi_acc._sp_r_a_tov
 
-#define	FC_ELS_CSP_LEN	16	/* expected size of struct */
-
 #define	FC_SP_BB_DATA_MASK 0xfff /* mask for data field size in sp_bb_data */
 
 /*
@@ -278,8 +276,6 @@ struct fc_els_cssp {
 	u_int8_t	_cp_resv2[2];	/* reserved */
 };
 
-#define	FC_ELS_CSSP_LEN 16	/* expected size of struct */
-
 /*
  * cp_class flags.
  */
@@ -314,8 +310,6 @@ struct fc_els_flogi {
 	net8_t		fl_vend[16];	/* vendor version level */
 };
 
-#define	FC_ELS_FLOGI_LEN (7 * 16 + 4)	/* expected size of flogi struct */
-
 /*
  * Process login service parameter page.
  */
@@ -329,8 +323,6 @@ struct fc_els_spp {
 	net32_t		spp_params;	/* service parameters */
 };
 
-#define	FC_ELS_SPP_LEN	    16	/* expected length of struct */
-
 /*
  * spp_flags.
  */
@@ -365,8 +357,6 @@ struct fc_els_rrq {
 	net16_t		rrq_rx_id;	/* responders exchange ID */
 };
 
-#define	FC_ELS_RRQ_LEN	    12	/* expected length of struct */
-
 /*
  * ELS_REC - Read exchange concise.
  */
@@ -405,8 +395,6 @@ struct fc_els_prli {
 	/* service parameter pages follow */
 };
 
-#define	FC_ELS_PRLI_LEN     4	/* expected length of struct */
-
 /*
  * ELS_LOGO - process or fabric logout.
  */
@@ -418,8 +406,6 @@ struct fc_els_logo {
 	net64_t		fl_n_port_wwn;	/* port name */
 };
 
-#define	FC_ELS_LOGO_LEN     16	/* expected length of struct */
-
 /*
  * ELS_RTV - read timeout value.
  */

