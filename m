Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750606;
	b=K3mqLPGnSOtiUgearJREiq2Uf4ni74Ec/pRjslkPXF4tYnMYFywfhF+HXajJLj9gYqcU
	 JSFizAYGIMfhDUelnDPNbH3AO/ut3Wg4HvfMB1p7uEWFzkr/1l82EPtbXH0a0aQHkypPd
	 t8pyxq9Sj+tBva2gDypu3rdkK5r/yQqmdb68mSkGn84SEcQOHtvVhPNt3UUfQcCDLaN9F
	 7yFOBafUqDa84Wr2oue2oPBAKwZIvU5jHwRzmIwJM0aNfVTN2QxL9iaZzpvO5CISS6qbp
	 tRFrDL3zVzgK/fQ89yeVKlbwPdE1M2JIKtqiRUGMzuIKBjbq4eo4dElaV3AotmQPBoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750606;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=ibU4pnMffILhHpVl9Fg66u4WaN3lyJ9Qb8xJ5lCTC6s=;
	b=iDvOl/p3lqihhqbcVys/EDTqs1IwEswiDKjDORul4SlUjHKlEs2cM5oBzo1SSqU8hz4X
	 s7UrEl+2g5k0ka0hHxgZHR+K2pVj3wlpoaxj7Q/QGvXSZYzWFCf/sjmk6EFdWnRoPwlsa
	 pUCBEZPOCAPs0P3eGHgkhyiz/pdE/ofpwzdy0b6IBB9L5rbwqjZPFIi9OQ4MOqTYbb93Z
	 fSKGMMQkJFl4SsxRQeARmxzdDr7MR0k4z5+xsAUsAV786xamfRECvwFgQaVc7pngEPC2P
	 F+5wohwknSIa8K9NPORbyizcAEB+85y8w6dboz2wG44ym94yh1BaGkb16xXU2bNgLVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=fkezUb0W;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5660606A31B
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5660606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=fkezUb0W
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAEAKx3757772;
	Fri, 23 Oct 2026 03:16:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=i
	bU4pnMffILhHpVl9Fg66u4WaN3lyJ9Qb8xJ5lCTC6s=; b=fkezUb0WjIhXGUfuW
	vxE0O9BTV+oEPDZR2CJSWR926VoqF5xY8JFgwOYcpud7vFsRqGx+xcrYcWtbXP8h
	mGcyyd7C5yNVB7N+OREJluHFwkKI6CGd/5vEIv22zaBIUsxaMEYCE6oGLDudna0D
	MvIY7Ca6+8dfH0nLP1D+Tw+va3IbL2DSddoNzwUZqlFhDkWfYy7wUqCGtYk5v2Jd
	p7RPssqEavFGD9i+TGE2ACRxMMFViNA7h/g5so3hfvBxFrm3mNC6BCCCdQYahDu8
	whbnAZz2g1ELEyotU8yHcHeAeGjpL5SfMPhbTV7PrmzUdBBUJixEl6U0VpF+uVMU
	sUMTg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hfmdtn9xq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:41 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:41 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0B8273F7069;
	Fri, 23 Oct 2026 03:16:38 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 11/13] scsi: qla2xxx: Re-acquire vport_slock and refresh tvp during vport DPC
Date: Fri, 23 Oct 2026 15:45:58 +0530
Message-ID: <20261023101600.1431179-12-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX53ZPv4hYIT51
 intW8nJd/cWV40FL91LAolqR6lvjLov/1ZsAkD1Pf7CI+oMPYRh7THBaKeZTDE4sFUdE41bbMAc
 SA+gIdyXrvdM5PyRE4MAHmN4Jl3lNWY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX94l/J2O360ke
 LqEgmFMgn8Ikyc85CzGVyKqzNpYNOXEMSlzUbjzn3k1qnocDpm8QG4pa1zlpwTCZjZLWDwxqUVU
 QHr6Ds5NZIhYdoYqXfeRB2aUNWnAKIxbqRNkIhJDd3HqQ0KuDUW4C+wIOqLaDKQssMAErc8eX3B
 5pX2RfpZEk8o3GNJ8GAQtjhaJ9OOU7WO4uH/9cqUVPuBX0r5M83ISx1zEDDdUl8crpttRCDoZdn
 0pCM3waFTSU604ZRzfSAZv0FOAdSA+xH7scYvs3vwx4u+6eXSRkY7XqvsF5C8syg7dHBdIO1O9R
 ueDunqJ4yM/xHQF1qksOHRirlHPzt0dJ+wKh2N46ryXLGYmxLrl9bNvlUwu43pyDp1RhzZeO6+F
 W6AaLrXimUQFe92FB5YRX/QhchtVGAtWXSWprQFyCyZ/dPgbj9mJQIeWYaFBBqiSPUbWWt0gZxD
 wbYm/6VqkALl4S5L3gg==
X-Proofpoint-GUID: sAvsZ2yjMTpfGdpx58Y6sOY_duqbuO7q
X-Proofpoint-ORIG-GUID: sAvsZ2yjMTpfGdpx58Y6sOY_duqbuO7q
X-Authority-Analysis: v=2.4 cv=PalqFShd c=1 sm=1 tr=0 ts=6adb3409 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=R4VxIG7slp-53JiOhT4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

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
index 754c806dac80..65dcfc1b04ef 100644
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
@@ -446,11 +451,28 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
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

