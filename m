Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793004469;
	b=Y2KTbo6asCJpA8rd3/g4NmjIEM6YSH7PNMO6RPzxpICUQG1Fta84LVONcWsfGmXkCKAR
	 dPqkuWeHLBPLi4MR7TXUjQfvHAnHoSUHfLyEkmVfwAfsLitPPc+bEJmxyAqlvCRaC4/+B
	 YOSOYqq0UP4kJkfBZEWwT2tyYsNn+DdHO2HN4G6OvPMR+qfY/AAN04JqfszTohaxzI21r
	 rIOffzUAnkJiheDEyUHyf/M241yDD7F/G1Rdtcd0/P0GhpTJ25gwZy9mjV8qkFO2AbXhF
	 H1WwUj2/pi+DhlC/j1zmknkOPudsDgCrR7Ox5kzt86BItqF5urWzsFGZe2DUZgAzlyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793004469;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=vulwwgQLqtwVdHtm6f8SILXutvQ/6bXosfywf7QCVIE=;
	b=QLHyAyGnafoNEKETn0XTnpsAb1JWlcYcRiAe9Ki+00h58c6jVCSiH6/cgeoeen8cagRl
	 nNmxArZh+P0Uu0k2XOAdISO0HXIaMqpQyE7v66hAlkEOEFHvxPp82DYqTTe+AXyZBPShT
	 jXpy/4wnjQ4HppsWtBLw7QZEgiQSHsFbdM7dcXkKaiW1mdmV6tmrK64uV7QyTsHVKcB4N
	 qB2QeEHTpFcIyVPVUlhfQlbj2EZi2er6HwZwDxx/XnrUqGIPGeLpRoVkQqayUUD77O65A
	 DHkpeJ6WGaOZkNWZg8W7jk3BKNHaGD0ppF1fv2ilI3nZ6ax5lvXM0dVqh2lf9tHJejg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676C8606A324;
	Mon, 26 Oct 2026 08:47:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 676C8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jCnM223T9z5B165;
	Mon, 26 Oct 2026 16:47:42 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 69Q8laJW081998;
	Mon, 26 Oct 2026 16:47:36 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 26 Oct 2026 16:47:38 +0800 (CST)
X-Zmail-TransId: 2afc6adf13aa83b-89140
X-Mailer: Zmail v1.0
Message-ID: <202610261647385343iIt_Rpe2JeqxY7SCEeUl@zte.com.cn>
Date: Mon, 26 Oct 2026 16:47:38 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Cc: <alim.akhtar@samsung.com>, <avri.altman@wdc.com>, <bvanassche@acm.org>,
        <peter.wang@mediatek.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBzY3NpOiB1ZnM6IGNvcmU6IGZpeCBOVUxMIGRlcmVmIGluIHJlbWFpbmluZyBzY3NpX2NtZF9wcml2KCkgY2FsbGVycw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 69Q8laJW081998
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 26 Oct 2026 16:47:42 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6ADF13AE.000/4jCnM223T9z5B165

From: Shao Mingyin <shao.mingyin@zte.com.cn>

Commit 4cf752f6b99a ("scsi: ufs: core: Fix NULL pointer dereference in
scsi_cmd_priv() calls") fixed the callers that dereference the command
pointer returned by ufshcd_tag_to_cmd() via scsi_cmd_priv() without
checking for NULL first, but three call sites with the same pattern were
left:

- ufshcd_compl_one_cqe(): scsi_cmd_priv(cmd) runs before the !cmd check.
- ufshcd_mcq_sq_cleanup(): scsi_cmd_priv(cmd) and scsi_cmd_to_rq(cmd)
  run before the !cmd check.
- ufshcd_issue_devman_upiu_cmd(): scsi_cmd_priv(cmd) runs before the
  WARN_ON_ONCE(!cmd) check.

Fix these three remaining sites by deferring the pointer arithmetic until
after the NULL check.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

---
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cc75384c6502..76c5400009ff 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5984,13 +5984,15 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
 			  struct cq_entry *cqe)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct ufshcd_lrb *lrbp;
 	enum utp_ocs ocs;

 	if (WARN_ONCE(!cmd, "invalid completion tag %d, cqe->command_desc_base_addr = %#llx\n",
 		      task_tag, cqe ? le64_to_cpu(cqe->command_desc_base_addr) : 0ULL))
 		return;

+	lrbp = scsi_cmd_priv(cmd);
+
 	if (hba->monitor.enabled) {
 		lrbp->compl_time_stamp = ktime_get();
 		lrbp->compl_time_stamp_local_clock = local_clock();
@@ -7707,7 +7709,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 					enum query_opcode desc_op)
 {
 	struct scsi_cmnd *cmd = ufshcd_get_dev_mgmt_cmd(hba);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
+	struct ufshcd_lrb *lrbp;
 	u32 tag;
 	int err = 0;
 	u8 upiu_flags;
@@ -7718,6 +7720,8 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	if (WARN_ON_ONCE(!cmd))
 		return -ENOMEM;

+	lrbp = scsi_cmd_priv(cmd);
+
 	tag = scsi_cmd_to_rq(cmd)->tag;

 	ufshcd_setup_dev_cmd(hba, cmd, cmd_type, 0, tag);
diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index df293b66350d..ecb54b410730 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -565,8 +565,8 @@ static int ufshcd_mcq_sq_start(struct ufs_hba *hba, struct ufs_hw_queue *hwq)
 int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 {
 	struct scsi_cmnd *cmd = ufshcd_tag_to_cmd(hba, task_tag);
-	struct ufshcd_lrb *lrbp = scsi_cmd_priv(cmd);
-	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct ufshcd_lrb *lrbp;
+	struct request *rq;
 	struct ufs_hw_queue *hwq;
 	void __iomem *reg, *opr_sqd_base;
 	u32 nexus, id, val;
@@ -578,6 +578,9 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 	if (!cmd)
 		return -EINVAL;

+	lrbp = scsi_cmd_priv(cmd);
+	rq = scsi_cmd_to_rq(cmd);
+
 	hwq = ufshcd_mcq_req_to_hwq(hba, rq);
 	if (!hwq)
 		return 0;
