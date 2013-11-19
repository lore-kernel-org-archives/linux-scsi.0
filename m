From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/18] target_core_alua: spellcheck
Date: Tue, 19 Nov 2013 09:07:47 +0100
Message-ID: <1384848483-3771-3-git-send-email-hare@suse.de>
References: <1384848483-3771-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384848483-3771-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_alua.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 8297d37..1994353 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -330,7 +330,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 		} else {
 			/*
-			 * Extact the RELATIVE TARGET PORT IDENTIFIER to identify
+			 * Extract the RELATIVE TARGET PORT IDENTIFIER to identify
 			 * the Target Port in question for the the incoming
 			 * SET_TARGET_PORT_GROUPS op.
 			 */
@@ -487,7 +487,7 @@ static inline int core_alua_state_transition(
 	u8 *alua_ascq)
 {
 	/*
-	 * Allowed CDBs for ALUA_ACCESS_STATE_TRANSITIO as defined by
+	 * Allowed CDBs for ALUA_ACCESS_STATE_TRANSITION as defined by
 	 * spc4r17 section 5.9.2.5
 	 */
 	switch (cdb[0]) {
@@ -515,9 +515,9 @@ static inline int core_alua_state_transition(
 }
 
 /*
- * return 1: Is used to signal LUN not accecsable, and check condition/not ready
+ * return 1: Is used to signal LUN not accessible, and check condition/not ready
  * return 0: Used to signal success
- * reutrn -1: Used to signal failure, and invalid cdb field
+ * return -1: Used to signal failure, and invalid cdb field
  */
 sense_reason_t
 target_alua_state_check(struct se_cmd *cmd)
@@ -802,7 +802,7 @@ static int core_alua_do_transition_tg_pt(
 		 * change, a device server shall establish a unit attention
 		 * condition for the initiator port associated with every I_T
 		 * nexus with the additional sense code set to ASYMMETRIC
-		 * ACCESS STATE CHAGED.
+		 * ACCESS STATE CHANGED.
 		 *
 		 * After an explicit target port asymmetric access state
 		 * change, a device server shall establish a unit attention
@@ -946,7 +946,7 @@ int core_alua_do_port_transition(
 				continue;
 			/*
 			 * If the target behavior port asymmetric access state
-			 * is changed for any target port group accessiable via
+			 * is changed for any target port group accessible via
 			 * a logical unit within a LU group, the target port
 			 * behavior group asymmetric access states for the same
 			 * target port group accessible via other logical units
@@ -1232,7 +1232,7 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 		 * struct se_device is released via core_alua_free_lu_gp_mem().
 		 *
 		 * If the passed lu_gp does NOT match the default_lu_gp, assume
-		 * we want to re-assocate a given lu_gp_mem with default_lu_gp.
+		 * we want to re-associate a given lu_gp_mem with default_lu_gp.
 		 */
 		spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 		if (lu_gp != default_lu_gp)
@@ -1465,7 +1465,7 @@ void core_alua_free_tg_pt_gp(
 	 * been called from target_core_alua_drop_tg_pt_gp().
 	 *
 	 * Here we remove *tg_pt_gp from the global list so that
-	 * no assications *OR* explicit ALUA via SET_TARGET_PORT_GROUPS
+	 * no associations *OR* explicit ALUA via SET_TARGET_PORT_GROUPS
 	 * can be made while we are releasing struct t10_alua_tg_pt_gp.
 	 */
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
@@ -1501,7 +1501,7 @@ void core_alua_free_tg_pt_gp(
 		 * core_alua_free_tg_pt_gp_mem().
 		 *
 		 * If the passed tg_pt_gp does NOT match the default_tg_pt_gp,
-		 * assume we want to re-assocate a given tg_pt_gp_mem with
+		 * assume we want to re-associate a given tg_pt_gp_mem with
 		 * default_tg_pt_gp.
 		 */
 		spin_lock(&tg_pt_gp_mem->tg_pt_gp_mem_lock);
-- 
1.7.12.4
