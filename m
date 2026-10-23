Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750603;
	b=hHaE17DxMycAWsLbJucKCwqtVI+JDTSz8IpcC1JZ/oHHmYj+zZluGDXkQuOWVpQvV0hQ
	 EggxtdzTy4Xi1spz+J1w1G97r4c1W7lIv/vb8lJMrOLz74PoR+q7KChQb6XWgbB9demTV
	 5znIM3tbCFW7s99JIyB+IP1A0NqWaFJIlS5xawKqswinB1Wvr2fomAONCF83FHZ6bqWDf
	 13eN/uNYEzcQMnbUALyLlSHG+PIzkOJglCcbiQRpUVQIwRIDtR0tHNRmd5PHbrGIa6rQS
	 sevV4DpH1+/FG4+Nni72sDGOFc7PwGrhxiatofSkh90L4mX4dZeUQKhqmmMU/IHQvKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750603;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=7UlBp8GQeMziKNLW7atYAeN3xBo86EN9MUCYC4b/0Wc=;
	b=34NqjPyG4DMjB52RFgutDBHl/TRPw6o/pSek2A6ETe5J1Lsto6agBkbhB/1cfiJr7tzQ
	 BddbEzpx8jmBP9sJW5Niyit2l3Nv6J8tEMf1AZiBNm+RU5jQbulmlTwTgwuzPhwClbB9i
	 l6pl3XwwrnVDDaFh6NYSe+Mby1PGaoBQ+dH18+ApwfIZrBvf5ysZDstdoFOT4XJKRnOXj
	 CZh46qHREL6W9j9YczUQHO7d9WM4gcxIGVVcucYV/AYryQJERGHBHK+TDxxeeqtnbaTfg
	 IWFD1mUyAjf2i+sXcn2AjKeOyPcskRGEqszZcfLE7qBs8WUPqe/a6NZei2cyj9LwlQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=QbEkmh7n;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9968D606A31D
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9968D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=QbEkmh7n
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADN0b3195577;
	Fri, 23 Oct 2026 03:16:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=7
	UlBp8GQeMziKNLW7atYAeN3xBo86EN9MUCYC4b/0Wc=; b=QbEkmh7nr3GSGei7H
	k+YlBKqBg0UnA8pVXf/YLKqTL399H7BGQibvzCFvMxZkT/WHkZGCY6BGw5dFsF67
	NEuPIrg4rwmYGS/UxccmqYKN22EBU5Tj6AvJOMFgXV3STo9YO6ehXF3EXtd+F021
	LFiJYx3ZXI49nkjFBqbyk1/+ELv15nXnpaJubgHXVvBzrvhhTWo+itL4pGdT50jE
	CVQA9e2DS53yQIr0i/nglIdDKv1GFr/98+BJCFBhOvhdO+Q1uOV368rstMiIDX9V
	TjVhvwRtF6Fsg7gz02A5tTQqh9Q0NuR3wTAuCSs48QhxGqomjE7+lweVxW9iv4mj
	jVkDQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hfn6ccvy8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:39 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:38 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5E4E43F7069;
	Fri, 23 Oct 2026 03:16:36 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 10/13] scsi: qla2xxx: Fix use-after-free races during vport deletion
Date: Fri, 23 Oct 2026 15:45:57 +0530
Message-ID: <20261023101600.1431179-11-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20261023101600.1431179-1-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
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
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=Se9i5fRu c=1 sm=1 tr=0 ts=6adb3407 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=ucISK5sqIEksk8fNd84A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX1w5e2VjVjNr0
 V4mUyAXp3ao2bewG43HVDVkLsKkydlFf3oWpUnP6pPsVZRc8xvBEQXZ80ZswStgsivtXwhdnNEI
 GOPPc+9cq1+UWU3rCH1/KF7IHaVmfasM6eD1G2nNmpPZBWwSHneRmbDP5+dEVEJ873tuPnrc/3H
 P5svV0gdAV12NhnjiZ7cAXKUS8MyoK49BgHsevkVa2AIySRvMR02q6um4ytuCCus63+KDb3QS0f
 4YZSEiST1dJ+hfdz6CKJ90XdIzgUYhVC87EVo1jBe+ABw2EONMPoOzcDLsRvJI7VUO7FG6P6GL3
 zThN3f+X4lwGYW0yXurdNCsyTFNR8payu4s+7PDVLFbQDb14BXlyv9AkO3qx9IXd/a6S76yOwAC
 /b5xVk2bMnRQEx8Gsf1ZfGe2wkIGcCDVolmGqpybTk8HM/PoUgvLPsDUNk05xMWEEJwAvAzl9+I
 Q3gdh2Jt4xrDdRpqc2Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX5GMI2U4aeJcf
 jEQwgPw6BqjRR1xmfU8McNuD1oPni2Tr2K8EL0CuYFfBFl7ELzOEITSerEt1OyhdQ4neyp5De7k
 EXX4vnVR5KiiWterhaZrHb9Gljec5Fs=
X-Proofpoint-GUID: lDc11pmfSn8tRJo-LiLCGjHuVDn_OjzK
X-Proofpoint-ORIG-GUID: lDc11pmfSn8tRJo-LiLCGjHuVDn_OjzK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

System continued to crash during vport deletion due to use-after-free
races on the vport list. While the vport_slock is dropped, another thread
can delete and free the vport; subsequently touching vp->vref_count on the
freed node leads to a general protection fault.

 general protection fault, probably for non-canonical address 0xdead000000000100: 0000 [#1] SMP NOPTI
 RIP: 0010:qla2x00_do_dpc_all_vps+0x8d/0x4f0 [qla2xxx]
 RSP: 0018:ffff9c4e07047ea0 EFLAGS: 00010002
 RAX: 0000000000000246 RBX: ffff8da4d7a7aa58 RCX: 0000000000000027
 RDX: dead000000000100 RSI: 000000010d2b276c RDI: ffff8da4d01d4488
 RBP: ffff8da4d01d47c0 R08: 0000000000000000 R09: c00000010d2b276c
  R10: ffff8da614945098 R11: ffff9c4e07047bb8 R12: ffff8da4d01d4488
  R13: dead000000000100 R14: dead000000000100 R15: ffff8da4d01d4000
  FS:  0000000000000000(0000) GS:ffff8dac1f0c0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f9e55261974 CR3: 0000000a46410000 CR4: 0000000000350ee0
  Call Trace:
   ? qla2x00_do_dpc+0x2bc/0x750 [qla2xxx]
   ? qla2xxx_pci_error_detected+0x130/0x130 [qla2xxx]
   ? kthread+0x134/0x150
   ? set_kthread_struct+0x50/0x50
   ? ret_from_fork+0x35/0x40

Validate the vport (vp_idx and delete_progress flag) before referencing it
across all the remaining vp_list traversals in qla2x00_abort_isp_cleanup(),
qla2x00_abort_isp(), qla2x00_alert_all_vps() and qla_pci_error_cleanup().
Also use list_del_init() instead of list_del() in
qla24xx_deallocate_vp_id() so a concurrent traversal does not crash on
the poisoned list node value.

DPC skips the vport when VPORT_DELETE is set, because delete_progress is
not set until teardown is already underway.

Cc: stable@vger.kernel.org
Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 34 ++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_mid.c  | 10 ++++++----
 drivers/scsi/qla2xxx/qla_os.c   | 30 ++++++++++++++++-------------
 3 files changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7898521b76d4..c02571a6f0c7 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7573,15 +7573,17 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-			atomic_inc(&vp->vref_count);
-			spin_unlock_irqrestore(&ha->vport_slock, flags);
+			if (vp->vp_idx && !vp->flags.delete_progress) {
+				atomic_inc(&vp->vref_count);
+				spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-			qla2x00_mark_all_devices_lost(vp);
+				qla2x00_mark_all_devices_lost(vp);
 
-			spin_lock_irqsave(&ha->vport_slock, flags);
-			/* Check if vp is still valid before accessing it */
-			if (vp->vp_idx && !vp->flags.delete_progress)
+				spin_lock_irqsave(&ha->vport_slock, flags);
+				/* Reference held under vport_slock keeps vp valid. */
 				atomic_dec(&vp->vref_count);
+				wake_up(&vp->vref_waitq);
+			}
 		}
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	} else {
@@ -7597,14 +7599,18 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	}
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-		atomic_inc(&vp->vref_count);
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
+		if (vp->vp_idx && !vp->flags.delete_progress) {
+			atomic_inc(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-		list_for_each_entry(fcport, &vp->vp_fcports, list)
-			fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+			list_for_each_entry(fcport, &vp->vp_fcports, list)
+				fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 
-		spin_lock_irqsave(&ha->vport_slock, flags);
-		atomic_dec(&vp->vref_count);
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			/* Reference held under vport_slock keeps vp valid. */
+			atomic_dec(&vp->vref_count);
+			wake_up(&vp->vref_waitq);
+		}
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -7786,7 +7792,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		qla2x00_configure_hba(vha);
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-			if (vp->vp_idx) {
+			if (vp->vp_idx && !vp->flags.delete_progress) {
 				atomic_inc(&vp->vref_count);
 				spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -7801,7 +7807,9 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 				qla2x00_vp_abort_isp(vp);
 
 				spin_lock_irqsave(&ha->vport_slock, flags);
+				/* Reference held under vport_slock keeps vp valid. */
 				atomic_dec(&vp->vref_count);
+				wake_up(&vp->vref_waitq);
 			}
 		}
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 90f09d36705a..754c806dac80 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -79,7 +79,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	for (i = 0; i < 500; i++) {
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		if (atomic_read(&vha->vref_count) == 0) {
-			list_del(&vha->list);
+			list_del_init(&vha->list);
 			qla_update_vp_map(vha, RESET_VP_IDX);
 			bailout = 1;
 		}
@@ -94,7 +94,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 		ql_log(ql_log_info, vha, 0xfffa,
 			"vha->vref_count=%u timeout\n", vha->vref_count.counter);
 		spin_lock_irqsave(&ha->vport_slock, flags);
-		list_del(&vha->list);
+		list_del_init(&vha->list);
 		qla_update_vp_map(vha, RESET_VP_IDX);
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	}
@@ -312,6 +312,7 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 			}
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
+			/* Reference held under vport_slock keeps vha valid. */
 			atomic_dec(&vha->vref_count);
 			wake_up(&vha->vref_waitq);
 		}
@@ -439,7 +440,8 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-		if (vp->vp_idx && !vha->flags.delete_progress) {
+		if (vp->vp_idx &&
+		    !test_bit(VPORT_DELETE, &vp->dpc_flags)) {
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -447,7 +449,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
 			/* Check if vp is still valid before accessing it */
-			if (!vp->flags.delete_progress)
+			if (vp->vp_idx && !vp->flags.delete_progress)
 				atomic_dec(&vp->vref_count);
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0047c2bd531b..5593dff7eb9b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7941,13 +7941,15 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-		atomic_inc(&vp->vref_count);
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
-		qla2x00_mark_all_devices_lost(vp);
-		spin_lock_irqsave(&ha->vport_slock, flags);
-		/* Check if vp is still valid before accessing it */
-		if (vp->vp_idx && !vp->flags.delete_progress)
+		if (vp->vp_idx && !vp->flags.delete_progress) {
+			atomic_inc(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+			qla2x00_mark_all_devices_lost(vp);
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			/* Reference held under vport_slock keeps vp valid. */
 			atomic_dec(&vp->vref_count);
+			wake_up(&vp->vref_waitq);
+		}
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -7957,14 +7959,16 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-		atomic_inc(&vp->vref_count);
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
-		list_for_each_entry(fcport, &vp->vp_fcports, list)
-			fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
-		spin_lock_irqsave(&ha->vport_slock, flags);
-		/* Check if vp is still valid before accessing it */
-		if (vp->vp_idx && !vp->flags.delete_progress)
+		if (vp->vp_idx && !vp->flags.delete_progress) {
+			atomic_inc(&vp->vref_count);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
+			list_for_each_entry(fcport, &vp->vp_fcports, list)
+				fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			/* Reference held under vport_slock keeps vp valid. */
 			atomic_dec(&vp->vref_count);
+			wake_up(&vp->vref_waitq);
+		}
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
-- 
2.52.0

