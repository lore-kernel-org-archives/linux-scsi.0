Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793259209;
	b=IKS3Qr26upj5ERyZGvJJxn2Nai1DJRK/dS1PkPEB42bh42MbpyIawBLah0PuLBvTQQaW
	 CXS7fKHPEMnU7RPsjw6qlmjkFgV2F23QKx75QC+VyprO2PchttFP5lB5VNgUc1Exgu5zw
	 sf+BaTdVoz17uGlrBCLOO4M4z9ymX2s4fe4xtqElLCANtZ/+c+VVZe1z7hiMhW5zWI9cR
	 A73MRbYCb6wHznFGOreWky+tjnsUMuCLYRhJ8NqSCpvKbxdJAxtf7gVB1Hkb+zJRW+5H4
	 jajJBFArjHJDu4ihhM8w6Yvh11cal2gPmYLGclSzdP9csxC3dRmKGambxbyrgO1lmjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793259209;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=bXPKDbH3PNtj5136u7ofkfRwViNAHeELc+rHOkMvnMc=;
	b=GLJfSU6Gle0y+qPBCxbTV+A/u/J/BcKUVjEHQtPtWMkEG0m9P35iXvYZZ+tYOb/8CXeW
	 pLAiRL4W7qK2Z9/0BHV11MljkThKSyauRj1Qdw7fxE7BooMQb12d2rbjNc+DOJZAcxenv
	 9GEcq0hfhRXMc7c6ET5mDLfoc4aLmAgfqGqVk52g2q0wQ4PeWUSuKktzy8x4ayFf1XP4t
	 8SBthVPze0LNJAg4EMm/STUhkENywkDFWP5X3PtpLZsDP9OP3JawZmuKrRmtmsZzJi/Up
	 7nd7aUdl62VKnoILtrPT58XxVMoYvx0aKsTrI6h39L8qU74dl69lE41+GXib5R5arrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=xiaopeng.com;
	spf=pass smtp.mailfrom=xiaopeng.com;
	dkim=pass header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=px8Jk6Ch;
	arc=none smtp.remote-ip=115.124.28.123
Received: from out28-123.mail.aliyun.com (out28-123.mail.aliyun.com [115.124.28.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C667606A31C;
	Thu, 29 Oct 2026 07:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0C667606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=px8Jk6Ch
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1793259198; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=bXPKDbH3PNtj5136u7ofkfRwViNAHeELc+rHOkMvnMc=;
	b=px8Jk6Ch8o3m8p3eqegV9kvADKQj5oDT82ST7IcL4STdh4Cp4aoslh4AW8bbaYF8X5VnYYr5fd7ttr+xqkQQ+KwLV1crX13U3PsT333f12SirSIJ8n/vQERXsh8rw9LoIABxQK5GV4yg7Heor0QtKFWCMmhNylChBo6SQY/zKgM=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07566782|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00806344-0.00431747-0.987619;FP=12609998778953435122|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033023087102;MF=liuwb@xiaopeng.com;NM=1;PH=DS;RN=11;RT=11;SR=0;TI=SMTPD_---.js3X9Mm_1793259196;
Received: from localhost(mailfrom:liuwb@xiaopeng.com fp:SMTPD_---.js3X9Mm_1793259196 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 29 Oct 2026 15:33:17 +0800
From: Weibin Liu <liuwb@xiaopeng.com>
To: linux-scsi@vger.kernel.org,
	suganath-prabu.subramani@broadcom.com,
	sreekanth.reddy@broadcom.com,
	ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com
Cc: linux-kernel@vger.kernel.org,
	James.Bottomley@HansenPartnership.com,
	MPT-FusionLinux.pdl@broadcom.com,
	mkp@kernel.org,
	stable@vger.kernel.org,
	zhugl3@xiaopeng.com
Subject: [PATCH v2] scsi: mpt3sas: validate data_out size before SMP link-reset check
Date: Thu, 29 Oct 2026 15:33:16 +0800
Message-ID: <20261029073316.4188569-1-liuwb@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

_ctl_do_mpt_command() handles MPI2_FUNCTION_SMP_PASSTHROUGH by reading
data[1] and data[10] of the data_out buffer to detect SMP link-reset
requests. The non-IMMEDIATE path sets data = data_out after checking only
for a NULL pointer, so a payload shorter than 11 bytes can read past the
end of the buffer, and out-of-bounds bytes can unexpectedly set
ioc_link_reset_in_progress and ignore_loginfos.

However, a short SMP request is not invalid: SMP_REPORT_GENERAL, for
example, can use an 8-byte payload. Rejecting every data_out smaller than
11 bytes would break valid requests.

Instead, require enough data only when checking for a link reset, and
keep sending the request normally otherwise. The IMMEDIATE path reads
from the request frame rather than data_out, so data_out_sz does not
apply to it.

Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Cc: stable@vger.kernel.org # 3.8+
Assisted-by: LLM
Reviewed-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
---
Changes in v2:
- Do not reject valid short SMP requests. Apply the data_out size check
  only to link-reset detection.
- Keep IMMEDIATE handling independent of data_out_sz and use the SAS
  definitions instead of magic numbers.

Link: https://lore.kernel.org/all/20261015-mpt3sas-dataout-sz-v1-1-0781d24bb7ad@xiaopeng.com/

 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 8bb947004885..b069dd384ed7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -57,9 +57,13 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
+#include <scsi/sas.h>
+
 #include "mpt3sas_base.h"
 #include "mpt3sas_ctl.h"
 
+/* PHY operation byte in an SMP PHY Control request */
+#define SMP_PHY_CONTROL_OP_OFFSET	10
 
 static struct fasync_struct *async_queue;
 static DECLARE_WAIT_QUEUE_HEAD(ctl_poll_wait);
@@ -959,13 +963,17 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 		Mpi2SmpPassthroughRequest_t *smp_request =
 		    (Mpi2SmpPassthroughRequest_t *)mpi_request;
 		u8 *data;
+		bool immediate;
 
 		if (!ioc->multipath_on_hba) {
 			/* ioc determines which port to use */
 			smp_request->PhysicalPort = 0xFF;
 		}
-		if (smp_request->PassthroughFlags &
-		    MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE)
+
+		immediate = smp_request->PassthroughFlags &
+			    MPI2_SMP_PT_REQ_PT_FLAGS_IMMEDIATE;
+
+		if (immediate)
 			data = (u8 *)&smp_request->SGL;
 		else {
 			if (unlikely(data_out == NULL)) {
@@ -978,7 +986,11 @@ _ctl_do_mpt_command(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command karg,
 			data = data_out;
 		}
 
-		if (data[1] == 0x91 && (data[10] == 1 || data[10] == 2)) {
+		if ((immediate ||
+		     data_out_sz >= SMP_PHY_CONTROL_OP_OFFSET + 1) &&
+		    data[1] == SMP_PHY_CONTROL &&
+		    (data[10] == PHY_FUNC_LINK_RESET ||
+		     data[10] == PHY_FUNC_HARD_RESET)) {
 			ioc->ioc_link_reset_in_progress = 1;
 			ioc->ignore_loginfos = 1;
 		}
-- 
2.50.1

