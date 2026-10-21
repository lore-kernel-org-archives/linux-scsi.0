Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578236;
	b=tm6FyQdnuXAU6+3hPCX+B+zvGruEmRk9x84/Z0oZ51q7R69UExzWoVE7pPavyj2RCjNO
	 aZPcFWwmvbMOHNPXgBx9LMZNJ49h33i4Sz4q316N76LfpVBbtTby3biDHRzNd6vMnsFp2
	 CSqtpg15bDQWvT78yKriWwjV+zfNESXvubqcT6hMmSFJNg6mBA08r6Qogqr1Dppui2UPc
	 wNsiksviLubyiiL6XlMtq7M2PEdGUzfuuIEQwv3O+whk3eNR2plfMJYnv49xl/2vRwbvX
	 C9lqldGM8eUUsuD2V1ImYqSnD5VijC/rs1lBQ//qaLI088a2ba8rLgcAF/w1yNM/RzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578236;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=7vlJP4N9+pr6k13BQl5E2AJkcWE7NWhsNFyg24uiPxo=;
	b=L+jRJaDp9WphyEOO1YSkDvoF62OZn2pSxdj4yjCE2PJ4YyVpQ04w+n5iutSfFS3X8EdL
	 ll4BylRU0ZI8YyLPxdxlV8OZvGe66Pt5g/933S2QZStEooIW4WXyNh15H+AVtOUY+U2iZ
	 xaSJOZgyVxTjOEjPeaIqmdFg3VlGWsSqhLxAyUxDuA4r0yLxP+06UoTSbje79kctzTepa
	 L160gldFIDO4DFxIgA/hbzslPtu/+JTq840+639/gHfutAcyRjEMBU3i32k6O9dQ211hw
	 wskboJ7x5nQEw+e5iiXBovgv3rH9gEzvuYiPp6Ynm3s4lWwX+fEnVmf3LOlTbfSTKkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=ByBMARul;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC06606A320
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:23:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CC06606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=ByBMARul
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5Fdc1715546;
	Wed, 21 Oct 2026 03:23:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=7
	vlJP4N9+pr6k13BQl5E2AJkcWE7NWhsNFyg24uiPxo=; b=ByBMARulcmsbeEdnk
	LguIMXh8ib8PHYFNI910awmXr+BLWj23XdDSmjNMwJPoRyw6Tni1bBpwBpLikaMP
	gSyrpXWaaHrsk8LAZspnwvtMYAMrvAM54vnwFV+oni3So22K27KdilgPxlYaFAm6
	EzmP6aeyvY6xGPovSbsMCwAiFyYnHTzcNk6InEqtxIEAh2YudiiaHPxlPmzJinYe
	ef0SojygzeYmNqpsjzz6OY9RgEhYWFusMWSszhUPVthXH+S+QUVUaI1oBW4icWB/
	0No7EzxWlPRYh5QWpQIz6TMddAomLpHW1xdd2WNNL9j/ZFhBkBpe6yxm9svzr4r5
	9Yv0w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4heu07g4k9-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:52 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:50 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6AC453F709E;
	Wed, 21 Oct 2026 03:23:48 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 05/14] scsi: qla2xxx: Fix double addition of fcport to gnl.fcport list
Date: Wed, 21 Oct 2026 15:53:01 +0530
Message-ID: <20261021102310.3854868-6-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=DunDa2/+ c=1 sm=1 tr=0 ts=6ad892b8 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=6q2e2AqKrR5IR0yc1uQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX4kRYLRv2CWy3
 7vDljF3Rup/NMctmjvZ2EH5l2DCiWfv4byPF+J7ANZC+Ajpxd4D4DDugAvfikBY6kumnsHx6SXH
 tUfUfZ5PNJ4MqJ7Pic8xpNla03J6K98=
X-Proofpoint-GUID: FJLIOYJ6TLgPumQe7bJ3TXIEA1bcy6tR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX8Ml3Ddmwstdy
 tZjv0R6xKiO8pd8+fMw+xeidVj/4w3ewq8kdCCGnVQOvIMjCAWYZtjU43si25B/NxmZ5IrtcCdn
 Wz0rVhHK7mQyiHWNF6qATUtEYuYRkrEteaocZvsAIfG3lBFepqvMyb6tGdnd0bTcCjRL0AbE0Cm
 ASDKzFH3dir0m8TrNwdOXPiqxQdo15YFRqzXKg9PSUn17tliHAidwIyV9jNIsp6ei24fAzjsi6+
 p1HD+fzYKO3qDsro9Z8cgIrNEjzodoJwuuKMtjRbiMjq1lLn4/+izTK7c9QAJJeOmw6cgHYYWgu
 1ZvyQInCzEHSMmwWBUgCIBQVSrX12ED8RETcJ+FZcsbesV2v6SIZD7Y8uuDLYY01Ny0SSroVXC+
 VZh1GcheNHdmhGgu7Sqh5oaRdud+PjgPBDraSB7DspfeOU5hsCOY/z1t7VFzLF1VKypgMgMZJ5U
 VmvL//TLmWW1qnkAwGQ==
X-Proofpoint-ORIG-GUID: FJLIOYJ6TLgPumQe7bJ3TXIEA1bcy6tR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

The lockless FCF_ASYNC_SENT check in qla24xx_async_gnl() is only a
fast-path optimization. When two work items for the same fcport race,
both can pass the lockless check before either takes sess_lock, and the
second thread then calls list_add_tail() on an already-listed gnl_entry,
tripping __list_add_valid_or_report() and crashing the kernel.

list_add double add: new=ff47fbf2d9b34158, prev=ff47fbf2d9b34158,
next=ff47fbf28788bca8.

BUG: kernel BUG at lib/list_debug.c:35!
Oops: invalid opcode: 0000 [#1] SMP NOPTI
qla2xxx [0000:a2:00.1]-8037:17: F/W Ready - OK.
Workqueue: qla2xxx_wq qla2x00_iocb_work_fn [qla2xxx]
RIP: 0010:__list_add_valid_or_report.cold+0x23/0x5b
RSP: 0018:ff7e6f67487c3d30 EFLAGS: 00010046
RAX: 0000000000000058 RBX: ff47fbf28788bca8 RCX: 0000000000000027
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ff47fbfa5f19ccc0
RBP: ff47fbf2d9b34034 R08: 0000000000000000 R09: ffffffffbcd45c98
R10: ffffffffbcae35d8 R11: 0000000000000003 R12: ff47fbf2d9b34000
R13: ff47fbf28788b838 R14: ff47fbf2d9b34158 R15: ff47fbf2d9b34158
FS:  0000000000000000(0000) GS:ff47fbfa5f180000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa5ea7bade8 CR3: 000000102b422005 CR4: 0000000000773ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
  <TASK>
  ? show_trace_log_lvl+0x1b0/0x2f0
  ? show_trace_log_lvl+0x1b0/0x2f0
  ? qla2xxx_async_gnl+0x136/0x300 [qla2xxx]
  qla2xxx [0000:a2:00.1]-803a:17: fw_state=3 (7, 8144, 0, 0 0) curr time=102ddc336.

Drop FCF_ASYNC_SENT from the lockless guard and re-check it under
sess_lock so the test-and-set of FCF_ASYNC_SENT is atomic with the
list_add_tail().

Cc: stable@vger.kernel.org
Fixes: 3dbec59bdf63 ("scsi: qla2xxx: Prevent multiple active discovery commands per session")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bb0cc71de37b..515a7ea4299d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1158,13 +1158,17 @@ int qla24xx_async_gnl(struct scsi_qla_host *vha, fc_port_t *fcport)
 	unsigned long flags;
 	u16 *mb;
 
-	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
+	if (!vha->flags.online)
 		goto done;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d9,
 	    "Async-gnlist WWPN %8phC \n", fcport->port_name);
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	if (fcport->flags & FCF_ASYNC_SENT) {
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+		return QLA_SUCCESS;
+	}
 	fcport->flags |= FCF_ASYNC_SENT;
 	qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
 	fcport->last_rscn_gen = fcport->rscn_gen;
-- 
2.52.0

