Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578251;
	b=EP/DhCPib2PDzRhh0ISpJL/jRGq6gUt/RCTb0TTHUfahUwPNzsrFJ/vs8utVgFhcJMvq
	 Vj7sFjaeoGp/0U1Gxbs2vLPeS+XiGJl/qZIddmENaxb7of7NLPB4Id2rTmujDLzfQSx/i
	 w7ZmOxguT2cQcXCFWL0LrdzMMxRBRdvnDKScjCG2SY0Gu0+qnDRoTOMlLcGvaOOuq9w7o
	 pXxsg061ieMDcCvxOdwtSnulmriHzgLjn4RfyIEwI5dS7Tqnly0bj+aNDu0lVovZj8jpV
	 XLA8jk6Fzvn3xOElen6E7ur1rxpk3licgLRroGpUw8e8jtjYgrMlmak/lPUun4NU1xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578251;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=JEL1znbvtqv3BbDywnAAuYmPaWsr1Kmv089Jqila+do=;
	b=JrK/J+K8xt68lmLYYz9oXuJhU7x5dROGGPLEpT/a1UWOhy28dvrhMBU0ujqt4mAu3t78
	 pjr/M9HUd8cVFKFOw6RbfqtlC7jeWu8TbmxxgLDK40Suj9MfLNHlzSsYTbA4LMQNBgVZ7
	 U/ZRa7uOE+sSoUwdeZGb1JWYZ8NrthI+1pNjoDiVEAXTLn/t8E92jDL6TEhNd27cteU8F
	 boY4933oNh+MBZMTcFZ2KdSPp9fjw4yNupY/LfOY462OtXZKqGaW7bbAnY7iakhf+kUAM
	 A8xj0+WLXNmqzRWt2qpuf5HqGuP8T9vUwIecADcfqJGcmtpHYG1limZCox7kDuqftLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=TiRpCmEB;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A88606A338
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:24:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0A88606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=TiRpCmEB
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA6JYN2174797;
	Wed, 21 Oct 2026 03:24:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=J
	EL1znbvtqv3BbDywnAAuYmPaWsr1Kmv089Jqila+do=; b=TiRpCmEBxPvcFpTMn
	rSB8tfJVGTIhp2/qn2BA549F6ukC2H0AAi5Z2O9y33EJhE7J35m+QN7MkQsVJTJW
	3tHRfwobrRbQEKcnYCDpE+WUTKH2FflyQTM6etuqPCcoLtqYhA8nwcKVm5aG3IkF
	2f/tleQ141hA99mah2FD8F8UsRpsSDsc0em2sYaINfm8TvKto7Y3Pw8MhjNb8NsC
	+z7gxSxKWtRCJxw+Ces8JkBRN+jvIYpT89JnpeGVtN2teW05e6DVzLylnRT5quvX
	hOZkuiiJxLPzuV4sofuSt84XKmCEC0MUr69ZCHttntRfvAaVjGpGd8an2EVEHkr5
	0vD4Q==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hemfbspp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:24:01 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:24:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:24:00 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E41B93F709E;
	Wed, 21 Oct 2026 03:23:57 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 09/14] scsi: qla2xxx: Validate vport before deletion
Date: Wed, 21 Oct 2026 15:53:05 +0530
Message-ID: <20261021102310.3854868-10-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=AvJ7T+9P c=1 sm=1 tr=0 ts=6ad892c1 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=iGaDd4Cl2BsU91XjCMkA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: KLTPfd-IqzcXk7OTdz0JWUpqpwQUijGd
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX33aTPH4nOT5O
 l4Hwwn7P4pel6GHiNx/kDmnYPfWamod9orU20p1VMphHpbClnU5ZN7alU2EmwYbeBT28shF7DwJ
 4cI0Rx/uBaIldVI4+slSOdRwshNefbQ=
X-Proofpoint-GUID: KLTPfd-IqzcXk7OTdz0JWUpqpwQUijGd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX5aMzBOuL3aPc
 RA4Cy+OIcJpC35omNwtmkZPg3gZJQckEk4ndoR3wEETBZHesTmVii6CEcFHC0Fphy+A54kwluW/
 uQOGHjbiO4GKkKxSHXWEnBJybIaMfoEPptMMQiAbnbJiZGkMBBHDGxpiwqlpZLuN5GD3fCpdE+U
 5sA5QxFlMuh6tDhkZlZ1t4UXl8J0A13duhb7BOb4wnQDv7zG0U1Hysgjc65HA029q2SW59lURv3
 iDBvz9ueeAqNchKOjuHa/lOME1Gc2/SqbQOdXK038GdUxY/u/TUBGx9iZWcKLOcFEpRtNdx+zdv
 DAnvQd3CDNNBSOfR6LvICTr3B+7s+SlGGO2XyJ4HQicOwGfsSuDuydmCqxa3Dq9qQDo1YRqGYEW
 wTv/wSiQdpx3Cg8GlYxWyKTNHWeEqvUFb1dHGfLPRe3Kf6Z7AbcW+bwFqbC6HnusKD1Mx6sQh36
 Lf5/qLNmW0gHrK38vyw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

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

