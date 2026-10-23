Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750600;
	b=moZnBmDZNrqEI1S87MCl+UW7zvAkNX8w0HowDIR0iXi8MAuOfKDsQV4tbaV+oK78RIiL
	 uMIfdigau6l0tAS3hIE2kOrZXqxcZiGMRZMtzZPyzumRs8PiYtdOOLZsHNCA6VRulXzcb
	 GckDMc/sfdxIql2xj/K/yD0pfwVAVNc1M5MlYT9OKQ3JaJzpKXmrZiIkWgCNdwEbstRQw
	 MzI39NtStp+VLMx6HiU66SdoK1J2J0XU51ETQ3LN961hMS48sX0pp88MDsOLc65Zcimgl
	 LPNi4az3hYA8VV9aGs5XnwTiZri2pF0WWbQPpDWfjpZL8w7+/BXVmA16e93XUh6l3uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750600;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=JEL1znbvtqv3BbDywnAAuYmPaWsr1Kmv089Jqila+do=;
	b=xVbathagf2kOYoSEMdXkCO+cIWPQQZe380bZDm0Pn7IlPpYo3/jIwIWms1dxaG2TKkDX
	 UQ68sbm4d5nqkZovcm8UlPmxpWwpu7ZqLbUEuA4JI6l2w51k2EJ5ZrORJWu8YF9LG27Tn
	 IFbNW9Kyy+0BWbl+lJ7XQ0YZAavkIyiarcDrWTtIUq8zaJOpRpEPtqlY4pftvhUvi8Vj1
	 fwvgyUFrpH4KQxcZxdat/4KaxIgj78zr2J109Ptkh2chTEhDSiC1cSWKWV81H15SG3fvy
	 qC/wQlr7l0KG+ldmwtZLmbzGRtCqJbYEO11DpWyJfzGsyUo+yd4L21UKOaoljw3ESaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=aMvXD192;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C64606A328
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C2C64606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=aMvXD192
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADoC53110242;
	Fri, 23 Oct 2026 03:16:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=J
	EL1znbvtqv3BbDywnAAuYmPaWsr1Kmv089Jqila+do=; b=aMvXD192wHFlXRaKY
	W3frbruWtUVedq9zv9PSVb1jMhW3TO/z1kUpZjxXCK/Rt/m7v3K9z+2NNPvLoHKQ
	QqHC5neLJK4cFk8Jb9F14MclmR71JOBceJuJW4YN6Oq4Kzk9uHHX/bXmQt6Kx4UD
	nD/3ccgjvkGwKdX0uPGTpPdFRm+zdqQzhLILut6m+5cHfSn95u0fSWjIU3BGBfX9
	ZRY7I8+wtqK/SGb2YsuWhH39iOmbKxWMDgK3mbTvUfuDGBUzdZrzZ7TgKRnPFWdt
	U4bun6TTisx4K5XCCdJGQXRGJQOJk5Ufwfve76IrRFMdys62+p9Jh4S0n2W23L52
	pJWXw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hfv15th2h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:36 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:35 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B17F53F7069;
	Fri, 23 Oct 2026 03:16:33 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 09/13] scsi: qla2xxx: Validate vport before deletion
Date: Fri, 23 Oct 2026 15:45:56 +0530
Message-ID: <20261023101600.1431179-10-njavali@marvell.com>
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
X-Proofpoint-GUID: UhEsx4njM1LW7GgHNG3YUgUrGHwmOzia
X-Authority-Analysis: v=2.4 cv=RPQmjIi+ c=1 sm=1 tr=0 ts=6adb3404 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=iGaDd4Cl2BsU91XjCMkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfXxM0W9m1x3Qz0
 JFYREL56gd3GOHDhYSN67B/ilfLS6xZvnfFDcJn8d2dV9aWi96crwZDnyokIC1klajaCQ1QP6l7
 kJ9a3RvbChv8YY5pD8IIuDwpYZoOg+0=
X-Proofpoint-ORIG-GUID: UhEsx4njM1LW7GgHNG3YUgUrGHwmOzia
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX0vy2PGUFHtjS
 xjcm0Gr6qeGzoMIFuQ5aGgsB3vZ0eGYAd2v4Pnlvi6KRAKaoHDlJabcPOLBXmaWeWgIzV+IA+ES
 H50afaUdSgncmTMtflqn4OObsHYt6EcPcHS22qyEblUuuILZkKYQeiXEmzP5mO5SAXOPJRoPL/8
 AhnHl0/PG+bvM08eqSfgS+gEIYv4XvtFbMBAEyHoqv3NUhlA4XJCi41MqQYMy2H2T/QZb1tgIzY
 HLNHbpjGSs5JPeZbltndmtGLtxFzhnhHGO7llts+rJVj8o4wA8ALtI4tUOVe4kTUrCVQjkPd5nc
 wcJz5jQgb+xwX9zDMwCi4BwG28+qqHRelQLAChAefg5VKTuKIgJuUJ97vquNyfOc+sDFpZRd76k
 wNbO9+ENsLj011Z/hOYlfCp6IF6xzye6vV82pjXVsLqkk8+0DB4NYkuuMrBeSHczk5WvmRCVFVk
 I4UGfatrHRZUNf49OBQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

While the vport_slock is dropped, another thread can delete and free the
vport. After re-acquiring the lock, accessing vp->vref_count on a freed
vport leads to a use-after-free and a system crash (general protection
fault in the DPC path).

     general protection fault, probably for non-canonical address 0xdead000000000100: 0000 [#1] SMP NOPTI
     qla2xxx [0000:27:00.1]-2026:80: Async done-gnnft res 0 step 2
     RIP: 0010:qla2x00_do_dpc_all_vps+0x2e1/0x4f0 [qla2xxx]
     RSP: 0018:ffff9e284717fea0 EFLAGS: 00010046
     qla2xxx [0000:27:00.1]-2003:80: qla_fab_async_scan: step 3, rsp size 32784, req size 20 hdl c3 gpnft FC4TYPE 28

     RAX: 0000000000000246 RBX: ffff8a602408ca58 RCX: ffffffffc0ce40d3
     RDX: dead000000000100 RSI: ffff8a679b80ce40 RDI: ffff8a606bff0488
     RBP: ffff8a606bff07c0 R08: ffffffffc0cdc8f0 R09: ffff8a679b80cc68
     R10: ffff8a678643a898 R11: ffff9e284717fbb8 R12: ffff8a606bff0488
     R13: dead000000000100 R14: dead000000000100 R15: ffff8a606bff0000
     FS:  0000000000000000(0000) GS:ffff8a6f5f540000(0000) knlGS:0000000000000000
     CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
     CR2: 00007f6ebf576974 CR3: 0000000920ab4000 CR4: 0000000000350ee0
     Call Trace:
      ? qla2x00_do_dpc+0x2bc/0x750 [qla2xxx]
      ? qla2xxx_pci_error_detected+0x130/0x130 [qla2xxx]
      ? kthread+0x134/0x150
      ? set_kthread_struct+0x50/0x50
      ? ret_from_fork+0x35/0x40

Validate the vport (vp_idx and delete_progress flag) before decrementing
vref_count in qla2x00_abort_isp_cleanup(), qla2x00_do_dpc_all_vps() and
qla_pci_error_cleanup().

Cc: stable@vger.kernel.org
Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 4 +++-
 drivers/scsi/qla2xxx/qla_mid.c  | 4 +++-
 drivers/scsi/qla2xxx/qla_os.c   | 8 ++++++--
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 515a7ea4299d..7898521b76d4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7579,7 +7579,9 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 			qla2x00_mark_all_devices_lost(vp);
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
-			atomic_dec(&vp->vref_count);
+			/* Check if vp is still valid before accessing it */
+			if (vp->vp_idx && !vp->flags.delete_progress)
+				atomic_dec(&vp->vref_count);
 		}
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index f7a08bc0093a..90f09d36705a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -446,7 +446,9 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 			qla2x00_do_dpc_vp(vp);
 
 			spin_lock_irqsave(&ha->vport_slock, flags);
-			atomic_dec(&vp->vref_count);
+			/* Check if vp is still valid before accessing it */
+			if (!vp->flags.delete_progress)
+				atomic_dec(&vp->vref_count);
 		}
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0e5e672e81ee..0047c2bd531b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7945,7 +7945,9 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
 		qla2x00_mark_all_devices_lost(vp);
 		spin_lock_irqsave(&ha->vport_slock, flags);
-		atomic_dec(&vp->vref_count);
+		/* Check if vp is still valid before accessing it */
+		if (vp->vp_idx && !vp->flags.delete_progress)
+			atomic_dec(&vp->vref_count);
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
@@ -7960,7 +7962,9 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *vha)
 		list_for_each_entry(fcport, &vp->vp_fcports, list)
 			fcport->flags &= ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
 		spin_lock_irqsave(&ha->vport_slock, flags);
-		atomic_dec(&vp->vref_count);
+		/* Check if vp is still valid before accessing it */
+		if (vp->vp_idx && !vp->flags.delete_progress)
+			atomic_dec(&vp->vref_count);
 	}
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
-- 
2.52.0

