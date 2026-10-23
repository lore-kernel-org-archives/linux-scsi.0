Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750595;
	b=CgsJmPeZiKWchwux6tz4AlsfgaXQnKfebCpgzym2ssDfEoz2bWudLncLRLDMrGs8A7y/
	 7oj/dJ0rbbsGY0LWNq+Yvjemc2XsvYaQBgTpvukhUfrf9tNILlfVOjPDh6R0Y2EGtPOUS
	 pfl32M+Rh+l+aTCMWqb0dv4dvZRWMxU+RHo/qRWLcT1IU1Vpl+6vWOVRnRNKcHv5esPzI
	 SwWXaGbot7W/V0jv2hhCihnxmTmNtIFDK/xYOts5UyTslO7m9s7LyTqn4dk1ktRmBctFI
	 jRxjq3l6FtmEcdRIH19HOLTlNPyFdfZNRKje9UMO6DvEKaZU9n62RZpN61NybriKJVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750595;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=ZRMTuAfT8WbhN7RyhnvZ7BzCUx+VPw1SEYv+6NpIkLE=;
	b=buY0AiODNrVgRBD6bbwqRGiFAEQyGcZU0/nMxTu+MKnyc/Sc/hvzVGTP6cU63/0uuwmw
	 kS0zRus24xCM7Pu0/95lgC1G9QslfVi3wGlTSw7nPpp8xO4XTrvIYFDBgrvh+a74UsshR
	 SE6KZcIq0U7aidTsVup2gqdrJ6DS2hhpR2hoiYdcUz0hbx+Fa3nEzhFfM2ywmjpF8xiWL
	 Eub8PcDXZ4uvqvWQJVDnS9gbdhwFrlm0R7zXnsXYCm6xCQgVgJNXgUZfxiK4GLECMBzI2
	 KBIBVpOHWtBPk7ulXNBmJ+DPpp71RnCXjjcVDIpJj+XjJaBXReWwwGiz3Dz1OCn1FWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=KyJ2r3Kc;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8F4606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C8F4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=KyJ2r3Kc
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADoUk3110231;
	Fri, 23 Oct 2026 03:16:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Z
	RMTuAfT8WbhN7RyhnvZ7BzCUx+VPw1SEYv+6NpIkLE=; b=KyJ2r3Kckr0U8nFTC
	vjoiRHBHgnRPClPC0ytWtT6p+Jgpa06CG9bFCf2nN1/8Ir6LWtS0TSkiURxxiYR5
	yzrNIXI/VobeHKrLmRzTQlMZ4FWjKyH1o6TtBfXtKSpZtEN1jAochdZbV7xznRcy
	Yr4chCQ0QwRiDQoSLrO7Eo7IRJ3tz2wEiEMf3qdm4gvMpcBl1fpeXbFD+DdSLTTI
	7clo/hS3aQ6zSl3q5BAX1d8ng35OMV4BD1zmDdRtlcZ9kp1mMioCGy63ujJJ9Usp
	i2YVoinLQG6O8Pglh+M2rZuEAR3GMP9/rlwUI9C70EYpaECPbR0g0lM/rWm2RJmE
	E1v2w==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hfv15th2b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:31 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:30 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:30 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5FCAB3F7069;
	Fri, 23 Oct 2026 03:16:27 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 07/13] scsi: qla2xxx: Skip vport DPC processing during vport deletion
Date: Fri, 23 Oct 2026 15:45:54 +0530
Message-ID: <20261023101600.1431179-8-njavali@marvell.com>
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
X-Proofpoint-GUID: TofOU1khP8N68KrqCRAF32GnPgN1Qcr6
X-Authority-Analysis: v=2.4 cv=RPQmjIi+ c=1 sm=1 tr=0 ts=6adb33ff cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=T_y5r7KGU4xGUugxkgEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX2Skjbr67fR/3
 fN9mHNbPSvHO0fbdDutQ9COzIG2m3MXeEEpCaZ7I804SNbNDz5kbWCrLVsDY6yKI4I0bJWYnTQL
 lOYGJFWxNfFiRX2Hu5qxyROIX1SquoU=
X-Proofpoint-ORIG-GUID: TofOU1khP8N68KrqCRAF32GnPgN1Qcr6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX8RcYOhrwMTJF
 BElEGdOwi/1CySmiqjAQ4ZkvqSAT2gO22ycHBHXhf0x/ZQFeny7OfcIUPO5XIt6UcrqIKA6DLzO
 3IpI8u6wiFiwy3TG16bFp7bbRuPkVP4T9tcTAZ55VD757z/xJqljjlfv7gKBoQW/GXRIC6CG73O
 lbruPEMRa0LHpwePclFkgfvsgci1qVHBayk13E1VQSYJFYkCxW0eYjo+SnjmyzMNs+X3r6sk3JD
 uGDTtt+lb7SB3Dd/RYYrAy2KLGDU5VmMXrBjuWacIU7NZsCRxEBZ/hJlL1t/i1iz4pw765ruKp+
 lZYl/lyPneFCdoN4hpMEE740V+wgS0EFrk/VPdKdZj9hcJvqZMVpzqmgRxTMfKE3rS9UZ+AWGUy
 1Tqz0ry9AXK5VA/gO05U2Y/0tmuQG27ZtWARNsAyifWYKQDxRCX0IgsOmg9g3QY3L9q0z94Orfh
 YhyDQHu1g74KmOS8L/g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

A race condition exists between qla2x00_do_dpc_all_vps(), which processes
virtual ports via ha->vp_list, and a user-triggered vport deletion (e.g.,
fc_vport_terminate). During teardown, vport delete may free resources used
by the DPC thread, including workqueues and fabric-related structures. If
the DPC thread is concurrently accessing these, a NULL pointer dereference
or use-after-free can occur.

Skip DPC processing for vports that are in the process of being deleted by
checking the vha->flags.delete_progress flag.

Cc: stable@vger.kernel.org
Fixes: feafb7b1714c ("[SCSI] qla2xxx: Fix vport delete issues")
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 4ad23d206add..f7a08bc0093a 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -439,7 +439,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
 
 	spin_lock_irqsave(&ha->vport_slock, flags);
 	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
-		if (vp->vp_idx) {
+		if (vp->vp_idx && !vha->flags.delete_progress) {
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-- 
2.52.0

