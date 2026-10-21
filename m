Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578248;
	b=oAM4PELe56d1W2fk09D+k9KgIYTq34EWiZqQqfMMyg9poGtfZwb7DU7BzfPLyfcx6gQf
	 oHat+GLdmPIktQowwsBAnml1vOn2H99UljYfDo8xpAo6DHFsR2Df4ai/X03MPMLCFVRwC
	 oeVRgaBSO/6OOGSB5T3PBypI7pWLQraAPMQkGHU4iTv/jrxA8U+dBMbUHIVxxiRW/LHde
	 RA6DtPTcGmVQvrk+0mOFT4fe4bRydTOgxvjWZHJKJbmrITdqR+O6jr0Powud+5SbKkF3d
	 yeSyfmQhs4a6wxgrAXONhZtjdHYSG8gs8T+YHMtY0fuSoqDYGFV6lVJ7HBbqxcbqYPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578248;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=mFG4i7T06g9il8vF9/ZzGPbbuRDxU8J+x92LA7g2+hs=;
	b=qKxFyd4VHEPBZ4RT7BUTJv7Cjkid8wZawRmfGyI+zFkPrnD0Fhssi7r4ED3VzJQIJbMG
	 fPCm4gbEruRQ0n4tN3cxpVJunsDSaEYT45l4IEqZ1ulvtJHkMSaCHfPqLf8ucSmmEscIU
	 Zbl/dI7ycigPd4ixJeb57a5BA2/w0OvkYPOgM6d/AmZu7V/Czh8L2aEPv1STauAdoTpC1
	 WW0iB/NN0xVJLokSnhmrXpTyrOnZWwJNF9m8G7y63rmr/SRL5uYbXryU9UhJ/p9MdyNkH
	 hayrsYJs/SWLUuV6x1EFgeSeY7vzJJ3FlojbLlgPvZqUVxVEr1B8ME3Y7J/rBa/hvfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=RWTNZkT+;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069F5606A31D
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 069F5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=RWTNZkT+
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA6iCY1731296;
	Wed, 21 Oct 2026 03:24:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=m
	FG4i7T06g9il8vF9/ZzGPbbuRDxU8J+x92LA7g2+hs=; b=RWTNZkT+arDJdH+li
	YGHs2f6uxQc8txUB662XOQfg149LvQ12bt9W11RNmQzY3Ft9tO0LLvkEz8OOwWbO
	Sh8e/PW215ZQSex+TQIUgmssZ0/fOlK29gkk8tDrBePTH6MJA7Evtgvw7/Dl86ej
	4pV+9Ca5oqhWCctL18Yh7K9PjgEyMmsFX4uywuH8eku2vvc965hht/48xJp9ML8f
	Avceymdd3mer8waLERDx+0M4moUEnCN9kj1IpXqJFS+hIoRKanQulubjwrknzy/g
	iB5LMkSUs76QLI/U1Vq+JEta/jiPN5OJFgUHVAHVU67sjBJXZGb3CmBpM5cstDTL
	lTm0A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hebjb4w0q-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:24:04 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:24:02 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:24:02 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 86F5B3F709E;
	Wed, 21 Oct 2026 03:24:00 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 10/14] scsi: qla2xxx: Fix use-after-free races during vport deletion
Date: Wed, 21 Oct 2026 15:53:06 +0530
Message-ID: <20261021102310.3854868-11-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20261021102310.3854868-1-njavali@marvell.com>
References: <20261021102310.3854868-1-njavali@marvell.com>
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
X-Proofpoint-GUID: QFAMYfUu7QnZ7g3cXGRzxLSp4-3-ukRy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX5L/HnUiO3WU1
 ZFROC7BdxntTJZqndjbrDNapJSosXOwGlbnm0o1GkNNxcm/ln5nxBFcdsq/PFyIy4n2zo8oG0LG
 T1nwq9Yn7eZAsru7m6+wh41aLFMZGqVrokd8lt8DDqzElGa6LoccTU6xS4AwobhG6BOn14672Lz
 GUYfce1iKHwDLbYgRXE8PlMglf8QpJ0xjFUgYmP3DjGA0UJz6/XT0g74Ov2H2XzacwaAWxVvUvN
 g/vkJgtBhR9wdKSgrqHmaEBGG+/X9U4yGGHfPjizg/uQiaCfZwaLxFL+PZoLZO0RR5t/dIMSOiB
 7dr9KB6g6dTrjbM920lrSSdoE/Fnq5+yIlf1hdqoaJyOgf5lglk+9cv6GfXLxd9bQUYN+JoO8dt
 +cfdC1HcDTjCBWn1SOPAcHboUhGO19ClLJ0RxkGb3NkF2KfzvzJkisZEq7A6CmSjJ/Gg6zSINnD
 m7qxoeDoOxxReePMLiQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX9Ox80ERaw9hm
 vgb6NCT0tEzDmPnlIrNhvMqTVo8Wq5AouNNgdYB8y8O8sNR3jWPSc0y3DVC3r9Zem326OP46L6r
 5A5ia9AaGxaDr0sg29gS/upA1drWZTA=
X-Proofpoint-ORIG-GUID: QFAMYfUu7QnZ7g3cXGRzxLSp4-3-ukRy
X-Authority-Analysis: v=2.4 cv=BYdNQbt2 c=1 sm=1 tr=0 ts=6ad892c4 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=ucISK5sqIEksk8fNd84A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

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

Cc: stable@vger.kernel.org
Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 34 ++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_mid.c  |  9 +++++----
 drivers/scsi/qla2xxx/qla_os.c   | 30 ++++++++++++++++-------------
 3 files changed, 43 insertions(+), 30 deletions(-)

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
index 90f09d36705a..40b8cbdece7d 100644
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
@@ -439,7 +440,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-		if (vp->vp_idx && !vha->flags.delete_progress) {
+		if (vp->vp_idx && !vp->flags.delete_progress) {
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -447,7 +448,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 
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

