From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 5/8] target/iscsi: Delete an unnecessary variable
 initialisation in iscsi_copy_param_list()
Date: Tue, 12 Dec 2017 22:47:40 +0100
Message-ID: <1dc1578d-277b-ec04-6493-f243a3f568ce@users.sourceforge.net>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Content-Language: en-GB
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 21:15:55 +0100

The variable "param_list" will be reassigned by a following statement.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 06310b2c4e26..25a3a9550488 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -566,7 +566,7 @@ int iscsi_copy_param_list(
 {
 	struct iscsi_param *param = NULL;
 	struct iscsi_param *new_param = NULL;
-	struct iscsi_param_list *param_list = NULL;
+	struct iscsi_param_list *param_list;
 
 	param_list = kzalloc(sizeof(struct iscsi_param_list), GFP_KERNEL);
 	if (!param_list)
-- 
2.15.1
