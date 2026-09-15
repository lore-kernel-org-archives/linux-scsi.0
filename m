Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9703D3D34A2;
	Tue, 15 Sep 2026 05:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450033; cv=none; b=lyPnbvXEbbwlB2t0IKhJs0zD6nFVBX3hoPrFXUgR+JWd/dUR+CkK3pa397kK+WkrFXn8BMJO9LmBQrhdFXSxjFx2F0EOMAhBLkxwO3bmPdnu+ZpR9F1GTt8m6vZxSWTUXVsLKrnANBpYHD7/dNd0KcL61w/X+Kh6QBPF0rdO4pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450033; c=relaxed/simple;
	bh=6s/CSeUmjV64vwCvJvpziBKmACQPr0g1iZdQ4UMa2HI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tW9x8NYGzr4RtqSssoXlRgQBJi9ez3NX31zB4bNWorVZ0kPlqKAKKP9wXwLQO0NzgtyWaoawwfEVdjpd9j2anYtUrNbFVt5vJy6UIqW9oAfpJBolbnaMpvLSYxI1PqhI3fmYwYBOo9ROf3VL4h//FjafKlhXEDAnwVWuavpoG2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=qCy8PznX; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="qCy8PznX"
X-UUID: 1311e568b0c611f18dc8c9802ae25ab1-20260915
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=33cVQ5J4yhsyUS8HwbCV24xkwsxQdh7bjkPhas/popg=;
	b=qCy8PznXjGVLGKiXuDTyHM1puJ33Jsr/CmFjwBaGPKjH9bj/hsSBFT1XWvDrd1fX9oNDxaRHA9tdPo7CUbcudBy13wkguzZ8eRaD5zSkBzQw7yq9aGB57luPbQjgFwJ+ljZnfRGG3PNWCenYaB8PMYmgwnWL7fQfFC+CMh93hBE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:74493fa1-7f17-4e8a-9dfc-a6391bef3175,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:d77dd9e2-72a5-4ba1-af40-18bbd6ea8ffd,B
	ulkID:nil,BulkQuantity:0,SF:102|123|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1311e568b0c611f18dc8c9802ae25ab1-20260915
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <alice.chao@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1096064766; Tue, 15 Sep 2026 13:26:59 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 15 Sep 2026 13:26:58 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 15 Sep 2026 13:26:58 +0800
From: <alice.chao@mediatek.com>
To: <stable@vger.kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<bvanassche@acm.org>, <avri.altman@sandisk.com>, <alim.akhtar@samsung.com>,
	<wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH 6.18.y] scsi: ufs: core: Re-arm the device command completion before submitting
Date: Tue, 15 Sep 2026 13:26:37 +0800
Message-ID: <20260915052638.459390-1-alice.chao@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Alice Chao <alice.chao@mediatek.com>

Commit 20b97acc4caf ("scsi: ufs: core: Fix a race condition related to
device commands") moved the device management command completion into
struct ufs_hba, initialized once by ufshcd_init(), and dropped the

	hba->dev_cmd.complete = NULL;

assignments that used to make ufshcd_compl_one_cqe() discard completions
the submitter had already given up on. Nothing replaced them, so the
completion is never reset between two device commands:

  Task A (device command submitter) IRQ (tag == hba->reserved_slot)
  --------------------------------- ------------------------------
  ufshcd_read_desc_param()
   ufshcd_query_descriptor_retry()
    __ufshcd_query_descriptor()
     ufshcd_exec_dev_cmd()
      ufshcd_issue_dev_cmd()
       ufshcd_send_command()
       ufshcd_wait_for_dev_cmd()
        wait_for_completion_timeout()
        /* times out, done == 0 */
        ufshcd_clear_cmd()
        /* returns 0, no effect */
       return -EAGAIN
                                    ufs_mtk_mcq_intr()
                                     ufshcd_mcq_poll_cqe_lock()
                                      ufshcd_mcq_process_cqe()
                                       ufshcd_compl_one_cqe()
                                        /* lrbp->cmd == NULL */
                                        complete(&hba->dev_cmd.complete)
                                        /* done: 0 -> 1 */
  ufshcd_query_attr_retry()
   ufshcd_query_attr()
    ufshcd_exec_dev_cmd()
     ufshcd_issue_dev_cmd()
      ufshcd_send_command()
      ufshcd_wait_for_dev_cmd()
       wait_for_completion_timeout()
       /* returns at once, done: 1 -> 0 */
       ufshcd_dev_cmd_completion()
       /* response UPIU not written yet */
       return -EINVAL

Task A then rejects what it reads out of the response UPIU:

  ufshcd_dev_cmd_completion: Invalid device management cmd response: 0
  ufshcd_dev_cmd_completion: unexpected response in Query RSP: ff

The skew does not self-correct. On a UFS 4.0 controller in MCQ mode it
persisted across more than a thousand consecutive device commands,
failing every descriptor and attribute read until the link was reset.

The controller can still complete the timed-out command because in MCQ
mode ufshcd_clear_cmd() only issues an SQ cleanup (SQRTC.ICU), which
shows the command left the submission queue but not that a CQE is not
already posted. The MCQ path also skips the hba->outstanding_reqs
re-check that the SDB path does, so it returns -EAGAIN with the
completion still armed.

Re-arm the completion in ufshcd_issue_dev_cmd(), immediately before
submitting. All submitters - ufshcd_exec_dev_cmd(),
ufshcd_issue_devman_upiu_cmd() and ufshcd_advanced_rpmb_op() - reach it
holding hba->dev_cmd.lock, so no extra serialization is needed.

This narrows the window rather than closing it: the CQE only carries the
tag and every device command uses hba->reserved_slot, so a late
completion is still indistinguishable from the expected one. It no
longer spans the idle time between two commands.

No mainline commit: commit 08b12cda6c44 ("scsi: ufs: core: Switch to
scsi_get_internal_cmd()") moved this path onto the block layer and
removed struct ufs_dev_cmd::complete and ufshcd_wait_for_dev_cmd(). Each
device command now waits on its own request via blk_execute_rq(), so
mainline has no shared completion to skew. That refactor is not a
reasonable stable backport; this is the minimal alternative.

Affected versions: v6.15 through v6.18, i.e. the kernels that carry the
commit named in the Fixes: tag but not the mainline rewrite above.

Fixes: 20b97acc4caf ("scsi: ufs: core: Fix a race condition related to device commands")
Cc: stable@vger.kernel.org
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 87578e8824d2..003fa8af4f4d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3312,6 +3312,15 @@ static int ufshcd_issue_dev_cmd(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 {
 	int err;
 
+	/*
+	 * A device command that timed out may still be completed by the
+	 * controller later on. hba->dev_cmd.complete is shared by all device
+	 * commands, so re-arm it here, immediately before submitting, to keep
+	 * such a late completion from being mistaken for the completion of
+	 * this command.
+	 */
+	reinit_completion(&hba->dev_cmd.complete);
+
 	ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
 	ufshcd_send_command(hba, tag, hba->dev_cmd_queue);
 	err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
-- 
2.45.2

