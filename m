From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 6/7] iscsi-target: Delete unnecessary variable initialisations
 in iscsi_check_valuelist_for_support()
Date: Sat, 12 Dec 2015 15:43:35 +0100
Message-ID: <566C3297.1040404@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <566C2F7B.6030704@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 12 Dec 2015 14:34:26 +0100

The variables "tmp1" and "tmp2" will eventually be set to appropriate
pointers from a call of the strchr() function.
Thus let us omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 29ecf29..53e3345 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -920,7 +920,7 @@ static char *iscsi_check_valuelist_for_support(
 	struct iscsi_param *param,
 	char *value)
 {
-	char *tmp1 = NULL, *tmp2 = NULL;
+	char *tmp1, *tmp2;
 	char *acceptor_values = NULL, *proposer_values = NULL;
 
 	acceptor_values = param->value;
-- 
2.6.3

