Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578250;
	b=vcLzk03v4wo0smUiYaSx6YbT16HZk/5q1xfY9VQGbcZqqyn0iQa9HHzHw5LbQc9lGzm0
	 nvyk96kJEBzOS8G7x6CJ0BlS4E5YU/dk9nc8GmJeMEnStcdzS1vOK2JPy8baXShezcicc
	 yX+3yukOiA1drldSQuQL+zDhD+wl2VLv5M3t9EpZagtZr0NfXdMXTJLMMqHzX1FkNPRr6
	 mLYuMN6zrd4PJk1krqmaq1ZG0LE/p1k/powQihX66oalp0AOd6fpTaCr6OcZr/WMNMsvP
	 CLZnyaAyfMN19GHQiQwsB8VyxBrfkPzn1VUGYqRj0SjVosO/VYlhZ3Ogy1l7AWEdKxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578250;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=wDI6AiwZ9dB6u6q5LPLI6MJYLCjiKsFtLHApOPyk/yw=;
	b=aoGk3uMFWsObmXL7BFDZo6Y2Hm5zpItlSlvslZTNgkrIq3mnhkEgm9/11aY3Yf2Ttc6Z
	 JFkY8KKEBQEvHLdUwnPt2ikawy40FYTXg9rhuxRAj1gnYtj6UVu1dJdhxqT8ksfpAuR0L
	 pCe3nhaJuKKSPbNIqfC/4nu9yBBd3OU1GHGckcH+o4TkAA4JAvGM5Fwkft77agro96zW7
	 ueAnAiOfl+E6XApzlDyhps5duhPZHeFp9o2mUQFHegs/1Cq72yUpmWIqD+rW7N5wy42S6
	 YJeuNb9sTMT6r10PCInceZ1jCUwF9uxtBcqmj6S5QL19jBzuehqkmc/vgUW994loGew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=dPjm5XKX;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBEA606A331
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BBEA606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=dPjm5XKX
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5ubx2174228;
	Wed, 21 Oct 2026 03:24:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=w
	DI6AiwZ9dB6u6q5LPLI6MJYLCjiKsFtLHApOPyk/yw=; b=dPjm5XKXo234IBP8K
	nc0O17lh7RRa/ndMaIy3DZPyTho/Jz3dhZK4zYC/8eNMOC1fycvNXUSVhPmBgWfF
	9Ye1gNLPfZX/bGGmG+2ouQMSb4xl9dkvYHikjDjvf9ABp0SQ0mhq2oAoxMp9W629
	P4bTZUjQhetvGIFJho8AjWqCMHPYxEn8Cf4v/tqowVDjTmVrwPaXJfOedSpS4V4J
	wxnre00rNo21S6W6OCJfogzyozpwjEIClFiU4hVjTCsSyObpIB9ydUu1e/S9BvfJ
	/6Nmn8Nf0tvqi9DhqgrzIphYeHi1WovOtMWjS5BFcodIlxHiONZ8njy5j/eHsnfM
	6w3EA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hemfbsppg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:24:06 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:24:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:24:05 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2B53D3F709E;
	Wed, 21 Oct 2026 03:24:02 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 11/14] scsi: qla2xxx: Re-acquire vport_slock and refresh tvp during vport DPC
Date: Wed, 21 Oct 2026 15:53:07 +0530
Message-ID: <20261021102310.3854868-12-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=AvJ7T+9P c=1 sm=1 tr=0 ts=6ad892c6 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=R4VxIG7slp-53JiOhT4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Zr3F5fnqhqZatyRH2qRoA6dslBtPSgst
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX0Et8OGQOxNJI
 SFAhhE0WX2oD7DnO9jKoMNRkA215tAYVDxYfKvA0E7IGyp2v+T9PMAI6RkSQr10TULRddZQ0iHr
 6I/1R/pdXFzNsgFz65dpYZyF2GVhksg=
X-Proofpoint-GUID: Zr3F5fnqhqZatyRH2qRoA6dslBtPSgst
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX99B+Ii2osK7c
 tWAbyQnsT7h68YwfpLOJoMOeOXtSs6IZ6NYXPjLdcfoFTNfhYHtw88KNMLhll/ZV2V1F51yVDYD
 SlhPOtmoKHaOd1Q34SUdwzzksuk8bhpo2aOVVDd+1hwi2r1yfymMSMlj7kb8lpe/vy/sGZLhZXe
 n8BZVIHzAQxsbJh0AJ7YSoMHFzPXGFWGbUk8z9ijc0ki5vMm24obxzYvF24lat2R0Bz+RcYTlSy
 CsVOaG0MZ2Ogia+RMvQUC8pJ1hV3e6O1GsIV8gLJFD5/FxUsAFkH0olIFRpm7BusR7iR6QnsyFA
 RmnzE2s1ppw60Hs+yRK/zGFenQAoLOOmhYOF9YpipCu58R1k/10JJwHcnnog98OveOxSc7fark/
 j8WMUtMIrxp6wp33wxrIqaOmNbwBVqRSTgtbSQqV0yY5r6SdLxJNw0DMxZPbdNu5nQYJTK9MXuL
 8QJj4mWpr1yR449e7Fg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

A hard lockup was observed after multiple iterations of vport delete. While
the vport_slock is dropped during DPC processing, the next entry (tvp) may
be removed via list_del_init(), making its list.next point to itself.
list_for_each_entry_safe then loops forever since the self-referencing node
never matches the list head.

 NMI watchdog: Watchdog detected hard LOCKUP on cpu 13
 RIP: 0010:qla2x00_do_dpc_all_vps+0x8f/0x510 [qla2xxx]
 RSP: 0018:ffffac4ac72b7ea0 EFLAGS: 00000006
 RAX: ffff95be03c12a58 RBX: ffff95be03c12a58 RCX: ffffffffc0d660ff
 RDX: 0000000000000001 RSI: ffff95be03c10a58 RDI: ffff95b688b90488
 RBP: ffff95be03c12a58 R08: ffffffffc0d5e8f0 R09: c0000001001400be
 R10: ffff95b7b580d098 R11: ffffac4ac72b7bb8 R12: ffff95b688b907c0
 R13: ffff95b688b90488 R14: 0000000000000246 R15: 0000000000000246
 FS:  0000000000000000(0000) GS:ffff95bdded40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055c11dd3a730 CR3: 0000000fe1610000 CR4: 0000000000350ee0
 Call Trace:
  qla2x00_do_dpc+0x2bc/0x750 [qla2xxx]
  ? qla2xxx_pci_error_detected+0x130/0x130 [qla2xxx]
  kthread+0x134/0x150

Re-acquire vport_slock using a spin_trylock + cond_resched() yield loop to
avoid a hard lockup if the lock holder is delayed, and refresh tvp from the
current list state after re-locking (break out if vp itself was removed).
Apply the same tvp refresh in qla2x00_alert_all_vps() and add a
cond_resched() before qla2x00_loop_resync() in qla2x00_do_dpc_vp().

Cc: stable@vger.kernel.org
Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 40b8cbdece7d..a2d76c8e81e5 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -315,6 +315,10 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 			/* Reference held under vport_slock keeps vha valid. */
 			atomic_dec(&vha->vref_count);
 			wake_up(&vha->vref_waitq);
+			/* refresh tvp from the current list state */
+			if (list_empty(&vha->list))
+				break;
+			tvp = list_next_entry(vha, list);
 		}
 		i++;
 	}
@@ -409,6 +413,7 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 		if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))) {
 			ql_dbg(ql_dbg_dpc, vha, 0x401a,
 			    "Loop resync scheduled.\n");
+			cond_resched();
 			qla2x00_loop_resync(vha);
 			clear_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags);
 			ql_dbg(ql_dbg_dpc, vha, 0x401b,
@@ -445,11 +450,28 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 			qla2x00_do_dpc_vp(vp);
-
-			spin_lock_irqsave(&ha->vport_slock, flags);
-			/* Check if vp is still valid before accessing it */
-			if (vp->vp_idx && !vp->flags.delete_progress)
-				atomic_dec(&vp->vref_count);
+			cond_resched();
+
+			/* Re-acquire lock with yield to avoid hard lockup if holder is delayed */
+			while (!spin_trylock_irqsave(&ha->vport_slock, flags))
+				cond_resched();
+			/* Reference held under vport_slock keeps vp valid. */
+			atomic_dec(&vp->vref_count);
+			wake_up(&vp->vref_waitq);
+			/*
+			 * While the lock was dropped, the next entry (tvp) may
+			 * have been removed via list_del_init(), making its
+			 * list.next point to itself. list_for_each_entry_safe
+			 * would then loop infinitely since the self-referencing
+			 * pointer never matches the list head.
+			 *
+			 * If vp itself was removed (deallocate timeout), we
+			 * cannot continue iterating from it, break out.
+			 * Otherwise refresh tvp from the current list state.
+			 */
+			if (list_empty(&vp->list))
+				break;
+			tvp = list_next_entry(vp, list);
 		}
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
-- 
2.52.0

