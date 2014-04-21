From: Terence Eden <terence.eden@gmail.com>
Subject: [PATCH 2/2] Correcting a spelling mistake which was causing some confusion - "recieved_value" should be "received_value".
Date: Mon, 21 Apr 2014 19:19:46 +0100
Message-ID: <1398104386-15313-1-git-send-email-terence.eden@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org, Terence Eden <github.com@shkspr.mobi>
List-Id: linux-scsi@vger.kernel.org

From: Terence Eden <github.com@shkspr.mobi>


Signed-off-by: Terence Eden <github.com@shkspr.mobi>
---
 drivers/target/iscsi/iscsi_target_parameters.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 4d2e23f..ce88892 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1240,7 +1240,7 @@ static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 	}
 
 	if (IS_TYPE_NUMBER_RANGE(param)) {
-		u32 left_val = 0, right_val = 0, recieved_value = 0;
+		u32 left_val = 0, right_val = 0, received_value = 0;
 		char *left_val_ptr = NULL, *right_val_ptr = NULL;
 		char *tilde_ptr = NULL;
 
@@ -1268,15 +1268,15 @@ static int iscsi_check_proposer_state(struct iscsi_param *param, char *value)
 		right_val_ptr = param->value + strlen(left_val_ptr) + 1;
 		left_val = simple_strtoul(left_val_ptr, NULL, 0);
 		right_val = simple_strtoul(right_val_ptr, NULL, 0);
-		recieved_value = simple_strtoul(value, NULL, 0);
+		received_value = simple_strtoul(value, NULL, 0);
 
 		*tilde_ptr = '~';
 
-		if ((recieved_value < left_val) ||
-		    (recieved_value > right_val)) {
+		if ((received_value < left_val) ||
+		    (received_value > right_val)) {
 			pr_err("Illegal response \"%s=%u\", value must"
 				" be between %u and %u.\n", param->name,
-				recieved_value, left_val, right_val);
+				received_value, left_val, right_val);
 			return -1;
 		}
 	} else if (IS_TYPE_VALUE_LIST(param)) {
-- 
1.7.9.5
