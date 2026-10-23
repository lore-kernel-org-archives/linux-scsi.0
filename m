Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750595;
	b=i2ggBpNs0Mcd8onbFuTs6UITZlLP1+RNC6vUGASWJin2f7hkw6vPA2W+1Qa2ZbEU+5Yv
	 MuTXtDmlJhOMuCM0iJQmzGN2YOgR+DsBswLj37YLoIkLqL+QJlqJ0FwQpzvZXqfpytCZp
	 mcWICS1TrYG8verFL7SvT+1AN4Mul5fTFbFM/xzKcE2xeIhR/hJzZyACz5mqJrrr+QQyF
	 gDq9eapCgDhih2ldNBWZ5QTpW3cjeC/kUJ3yZm5QRjEMWU927qrfgVvhjkvdrH9yFG7Hz
	 /ypYfOe1IkJZwqU28+idZyEbAEJnm/iYfD6ylchFbBEgdMpdA0/LCHxbJlmq09MPUzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750595;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=vnSIXYvTLDV9HejAw0cNRoH3jUZmkN7M5O8TZHvTXMA=;
	b=ocd1qm6Px+D1svWZxThSihBvSc6DYV8PIUnnLNlcda4VLfbUOxdTHylrg323cYIoK7BS
	 DO8hTpYEUrM9CI0LuB4WXAzagkwr/ZoO0QXu8Xj5QAp1Rd5W6YAAb2YACsXbt07zS9d5i
	 ycJMrpwmM9/N39btyeSJEH6zoyirWYYljt9/YitPlYtutncsOKswvV1KLtUFlyYyy0fKX
	 vOrS1bv4pXXGzhANgmT564cQxzLSM+noWhG0jJP7iHYeuOe59EL9up+zXvq1c6n34h0Lg
	 IWwwtbx1xbaq00QFynCjrCBczyMijdmpqTt471DCC1LR3TXghQGwHgmoPbFKLD1kw0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=i3TvfYgC;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129A5606A31B
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 129A5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=i3TvfYgC
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADKrZ3195548;
	Fri, 23 Oct 2026 03:16:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=v
	nSIXYvTLDV9HejAw0cNRoH3jUZmkN7M5O8TZHvTXMA=; b=i3TvfYgCZn4b4IgnH
	m1QhBCceUdBGFOGWSZWX4nCkRlQF5Hx6x5fXQX6AJVIrmGcfxsDMEZfm5qodK3TZ
	o2NlSmgNdmuo13Sth3rQIHkbnY6rhCi/Vq8RZasRvLdyt/PsM1O1rTi+yEu8OZ++
	mlseTnsMmowelWvEyZtWCTkxRviChiV4pY5dU8H4krrIpLwjz8kvVT1/TDXEfx2w
	ocavHH05HHFpSHOB018764Jt89unotJD/ESgvJWP8pZJN0w1QQq9rmgePPY1C/oK
	JPSdYTCGDha+SJmnX3yNQm5001PZvaxMDI8k51WNvVnE/w9sig2Sh7x44WeP4jZF
	2OxlA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hfn6ccvx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:25 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:24 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 91B823F7069;
	Fri, 23 Oct 2026 03:16:22 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 05/13] scsi: qla2xxx: Fix double addition of fcport to gnl.fcport list
Date: Fri, 23 Oct 2026 15:45:52 +0530
Message-ID: <20261023101600.1431179-6-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=Se9i5fRu c=1 sm=1 tr=0 ts=6adb33f9 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=6q2e2AqKrR5IR0yc1uQA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX3+LByIdsQBDn
 Pv/jRJwA0D8Bz6g2PMGOHJw8vvI4jd8WPaOTashxp6mCFF/8ZxZSIfCptUufZ3oNEl3S1aS38Fk
 dCIYDz1egIL1UCg2mtMCaF63sQIZ5jW2D+64mSo7T3+k5/nEWOR+PmbNMkbUWyS/upY09WYFeAS
 T9FI/gEJ+PQr93ZwaGUJb0aB7TTMKni6Jf8om10k/bPEeXtW35Ctx1utWLhFutrYAfg82KLoDkV
 KMNbECuymd65FGb8PDE+bnUpxH/AW7ZCwhwY/qJsHvCE3NCCDJPeuMtOgCbR/EPe/uYlR8jl71G
 xt65Y19CL3eOPK6F6vh3P9NiR4/cucVnqA+0nwQBr62BrTDTKQwtbiueP1cIdIjQMji/2uOqJtC
 zEM0KyNVz9QRUkWrmanTThLP1kFxvt5UPlNtP4WNmcWMDJ1WyPnDbCCz5/3Zje2kO0QKoYNET/B
 RdDbk0ChTanJ83NsRSg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX9UVrlpw6amC7
 CO/UykBbSQcNlZQkgpNnX30QM7LgNtVEKwyQKKNifJXK3h/5PqpHknD43gD7jKEGRAykqo67nBo
 /es3vijrK9CFtxO4PbcnNK6g5i1IPSc=
X-Proofpoint-GUID: BwMoLuNI1cAFRAuXsLGzBvwyhGz3A8gR
X-Proofpoint-ORIG-GUID: BwMoLuNI1cAFRAuXsLGzBvwyhGz3A8gR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

The lockless FCF_ASYNC_SENT check in qla24xx_async_gnl() is only a
fast-path optimization. When two work items for the same fcport race,
both can pass the lockless check before either takes sess_lock, and the
second thread then calls list_add_tail() on an already-listed gnl_entry,
tripping __list_add_valid_or_report() and crashing the kernel.

list_add double add: new=ff47fbf2d9b34158, prev=ff47fbf2d9b34158,
next=ff47fbf28788bca8.
[ cut here ]
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

