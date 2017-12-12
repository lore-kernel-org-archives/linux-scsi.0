From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 7/8] target/iscsi: Delete an unnecessary variable
 initialisation in iscsi_set_default_param()
Date: Tue, 12 Dec 2017 22:50:09 +0100
Message-ID: <b5de8128-f836-a973-1eb2-2cb54c8418b1@users.sourceforge.net>
References: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6163538d-a406-2f60-11a2-88b4694e9975@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Dan Carpenter <dan.carpenter@oracle.com>, David Disseldorp <ddiss@suse.de>, Hannes Reinecke <hare@suse.com>, Ingo Molnar <mingo@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Jiang Yi <jiangyilism@gmail.com>, Kees Cook <keescook@chromium.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Russell King <rmk+kernel@armlinux.org.uk>, Tang Wenji <tang.wenji@zte.com.cn>, Theodore Ts'o <tytso@mit.edu>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 21:21:31 +0100

The local variable "param" will be reassigned by a following statement.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 151269b8816d..a49b0b2a4f6c 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -127,7 +127,7 @@ static struct iscsi_param *iscsi_set_default_param(struct iscsi_param_list *para
 		char *name, char *value, u8 phase, u8 scope, u8 sender,
 		u16 type_range, u8 use)
 {
-	struct iscsi_param *param = NULL;
+	struct iscsi_param *param;
 
 	param = kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
 	if (!param)
-- 
2.15.1
