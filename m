From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] target/rd: remove unused variable from target_core_rd.c
Date: Fri, 10 Jan 2014 23:38:25 +0800
Message-ID: <CAPgLHd_JGz6g4_4_+yOoHOQr0Lq0+g9-WV-7dGCnvWZn2L5-uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The variable 'sg_table' is initialized but never used
otherwise, so remove the unused variable.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/target_core_rd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 3fd51eb..9a107c0 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -105,14 +105,11 @@ static u32 rd_release_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *s
 
 static void rd_release_device_space(struct rd_dev *rd_dev)
 {
-	struct rd_dev_sg_table *sg_table;
 	u32 page_count;
 
 	if (!rd_dev->sg_table_array || !rd_dev->sg_table_count)
 		return;
 
-	sg_table = rd_dev->sg_table_array;
-
 	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_table_array,
 					  rd_dev->sg_table_count);
 
@@ -228,14 +225,11 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 
 static void rd_release_prot_space(struct rd_dev *rd_dev)
 {
-	struct rd_dev_sg_table *sg_table;
 	u32 page_count;
 
 	if (!rd_dev->sg_prot_array || !rd_dev->sg_prot_count)
 		return;
 
-	sg_table = rd_dev->sg_prot_array;
-
 	page_count = rd_release_sgl_table(rd_dev, rd_dev->sg_prot_array,
 					  rd_dev->sg_prot_count);
 
