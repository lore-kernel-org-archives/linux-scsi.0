From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] target/sbc: Fix sparse non static symbol warning
Date: Fri, 10 Jan 2014 23:39:01 +0800
Message-ID: <CAPgLHd_yj=Te74XPRaKit5SdHerr2ywPgAMArETZ3YE3CCL=tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/target/target_core_sbc.c:573:1: warning:
 symbol 'sbc_check_prot' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/target_core_sbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 77d7ae2..ec49257 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -569,7 +569,7 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	return TCM_NO_SENSE;
 }
 
-bool
+static bool
 sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
 {
 	if (!dev->dev_attrib.pi_prot_type)
