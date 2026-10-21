Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578239;
	b=yKewYOQ918yRQqJrSjbH7esXG/wJ3r0Isrsviw0sb3WPqHGwC85ti1OZdoaUh1apjyUm
	 4Wjblv7w6uxyqS4ZjCkFdUlFRPTICGDt2Kj7huhSi4aodAoxadWVAEMnjMqc++QZ+FRod
	 Nzxn2i0Nj3iGT9DBXbimA2uZ4mj8lo6mDGM1IspDSOCGgWb3aErVDRPKH3d6D7nNIPkW8
	 1Ju9qyKq/nq3q5/hopFaT0L2N5TMyxv1CROCmBT15l97+dje1kW+H4hFPYvkIGwDJbQG5
	 7nYYOPrRgZT3bz8PlCggPvWDseitSpj0uBaYcQwVUQ/JGqR44A2WRXGwLOzH/AvH0fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578239;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=ZRMTuAfT8WbhN7RyhnvZ7BzCUx+VPw1SEYv+6NpIkLE=;
	b=poxxi5FIqXJ3E+MhIh7ZKaGU10qTrW0uLVQ1fRTpYPRfeRiO/PujVDur4zMt/dljou5k
	 1eAbJYuKvbYd0mYTopBJ6EwNgutY2LVTyBFDXkdNe4d8Cgy/VHRgSAOXo7PZ53VRzv70j
	 xp9zuvsxgh/Wm26lOSjfpYRIt4exfy/FU+u6FEYynKbvggG+UOc943zEeS7OjnkXMrF6O
	 HxLykHDQ0rrhtmZMvKie8ZR34GsmMcAV+fpmyF7Of2ceJZxNoq0rRq+OReTmzkACXCHE6
	 mBNhOH/t75wqvG96w4RqljSUAGIhf2zPqPOIM4qoszOBLuhxVI4e36QlPMP+y6DJpkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=XR0GwQnS;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A37D606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:23:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A37D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=XR0GwQnS
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5dG61763738;
	Wed, 21 Oct 2026 03:23:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=Z
	RMTuAfT8WbhN7RyhnvZ7BzCUx+VPw1SEYv+6NpIkLE=; b=XR0GwQnSheE2Tfutb
	Apdvpkk+kqUYyHtH8MVyKhYGnWQqmOmzsMeqac0KkbCU2AMAgPyqobdCzuhvkJ0X
	f9dh72lHuzN+eqIMMMf3COijf3ypmyD/V1+ZY28p3HSd6RmFQwkwKULRk48N7jXg
	wb3trvKVr991zgkahR7GNewADcaEdZSkFJjGqTpof6bg8YJ4E74CMkoMg/zEZxAZ
	WM5B5KVHLlTl9Ijg20hooT3OiZ9ZXibA1Qlwe6pH+hU1zChTvYYgHmBaOleB1E+Z
	kRo2l7KrjI2mTSgBveQtRYfvhmXC2BxzNnhjEgp3y4e6Ud4xYVnVfa+TQu0zNMS2
	XuWJg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hepyxh2ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:55 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 2D8673F709E;
	Wed, 21 Oct 2026 03:23:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 07/14] scsi: qla2xxx: Skip vport DPC processing during vport deletion
Date: Wed, 21 Oct 2026 15:53:03 +0530
Message-ID: <20261021102310.3854868-8-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: _iuFh7K3V53e859bxeEu8872iYHKKxov
X-Proofpoint-GUID: _iuFh7K3V53e859bxeEu8872iYHKKxov
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX4U+fUxGYpKS+
 I/LlhQ55jHuhFqf9UGiYapqdoCe9AvA0M4GMM9AqkjmUpYnfvdjY4XwdoOkiE65kjCMhn9EIbn0
 /xEvImAMr67LIxxlOzMzYRB2u6dltuI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX+PD4f40NCBr/
 yJ7vh6PDWSEtlQ5Z/bFJ8mf5C0qLfEj6bHS/HxDY5SE3OCLthytz92qEmai/7nSz1/VG/Knro9e
 QvCo8fp3QNU76LOJN3KTAp67PvLNINUg+3jeUcpsJ6C+x0+qGr8NcUF0eUUzY7lfkcB/4F6mqi1
 MYgDb/0HFVNFA7OvvSzApwnnwZKVmsEalPguiP+6+Xoah0quR6+YS5A6Js68qjdUrFpZfaLlYU2
 QJHARaKkRsYOc2SNiouNDFRRdVo4sy6jUJuMeTOeaqsxmKKKy0T041kqUzV9Egmq6Z9jozab8VC
 Gryg2ncW1Fz9b26X/P6IlL+pnMRXKdo52wRxBouJFRnQpMSO7kvCzxWSBrPEX1Ds4x0oc/OmD2J
 /xsZQI84ts4gqH6oZBeNgRulWjjXFE6sfySbqn3qGMn94TgXCdT6/PGc609Wh2mTIJpvFU13vvg
 ifmhz9eqFzjNk7T6oxw==
X-Authority-Analysis: v=2.4 cv=Jq9kP84C c=1 sm=1 tr=0 ts=6ad892bb cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=T_y5r7KGU4xGUugxkgEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

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

