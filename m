Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578233;
	b=jJ71VMQkd0AenJbo6Yr5vyoAxWeEANo2sfZ9fYs71wiKi+QXhdqvCv+8qg7+wmU8T6z/
	 d6/T3Q11ABNT9tiXguONIAkZlaR2aQmPhey/31DdqElGG0KKL88h69t6OOf35UwmRtLaK
	 WNJb10DFOdl82J2FP9M6BDx3IckoUEZrp9jDEQOLCXvP33q/h27oFfXVSTjn9B1RHMrZV
	 iUwZJSPVODnMJKxtwK8sMC+/O36QbEH6PFLCb8eDerQFBZSfw8a4zXqTd1Sn4M5w578tX
	 d8OMAaIdn+KCl9WZTQhsqdDw60aKTlJ91zrgxewRTPWUiiExHb4d26rxO8xvDgZWX8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578233;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=zgRH3rlMCdmu9Gd3Usij2nqa9yMM3IRluppIu7hvJro=;
	b=DMwiD1yDgYufL1M5hdPrxRkVwiZapoIIVLRM9m6XED74neVDUbAzdLoF0uLmMoYapmfQ
	 278/MNEPRKBp+tSJRhFbeyNwwAZj9y76N4uN/dA/nZvcvOVhFalzRGTypPZj0ovx3W+82
	 16q+xPYcRCJTfDAbzokgoToUXqsFKStgfKxRD2/66LSee2e/6R3Bs0k3nli/bcQy9sx2K
	 h8RwMm+pUZa7VBJYTzmmAzhMmbjZQdhfrt0d2qHIn+pmg25GSRy1gk5ntW2+WyvogJcnY
	 skcRa9Ux1Vk/93QsCwEsiRVBeKIX0RV3qu7N5fRPKahWmKLoNoebDTSuEdGeeOdpDKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=E+XswasG;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A4D606A319
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5A4D606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=E+XswasG
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5YrD1715790;
	Wed, 21 Oct 2026 03:23:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=z
	gRH3rlMCdmu9Gd3Usij2nqa9yMM3IRluppIu7hvJro=; b=E+XswasGCxGrHilO6
	3UQ2BWRCLoyDKXYeG9n80iwxdCYs5Xab8KXcJThM3BkIvv/mh+mLaUgS4iKAGN2/
	uv2wRs2V2PapglIv/eBuQooPjKJ7+LbHoPjkn5LhYUxuhVkMJbsHYVj8odLmbuQP
	cumLYg+o+HKbdIbvJz8+xUf8MkyrNNx0vre6JixpQOSeyR4Z395XySvRYzv1GOMR
	4SftqUhDhPu5BqEpM1WzwbHUPni1OW0FpsmIB64U3oR5NXeo0Za/ShQJEUAMeAVf
	khbTi5uMSF/UGvqHBNyaV4xurOHmEYwwGqd0hVjYc72kEyqIvUKzdvd9eTITZTJE
	NPrww==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4heu07g4k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:49 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:48 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 93B973F70A8;
	Wed, 21 Oct 2026 03:23:45 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 04/14] scsi: qla2xxx: Wait for session deletion before full-login LIP
Date: Wed, 21 Oct 2026 15:53:00 +0530
Message-ID: <20261021102310.3854868-5-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=DunDa2/+ c=1 sm=1 tr=0 ts=6ad892b5 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=MtCq7Vfy4UkbfJX3u6UA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX0uqYS+bZi3ED
 CBUWgZfxAoUlTQ9O/xTMZPOVKbKFrp0boOlNJI8owjYAqGrsaMPH1P0skbcE7CwP3OVH2x/Az55
 HKYHR4qkM9097FpMKjqCn2b8zoyyzko=
X-Proofpoint-GUID: qMZ5WnU6GPGWEQ-6HmwDuJlFmRjuIyBF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfXyO4Kp+d2/szh
 3RcmiXwPTv/C1s97xFKzW0A4KoRwn4hQZAy6QBnDHo3tI8oiBpjXDZ//xmHukg0+nSqRjB0GFEw
 qKwOgxjhaQi9VRhN9pcmz1DIYwNOQDjsmQI1u0C+yWgHAxwwCcXyEsE3hMwnV6Q4nN6pq95ti8u
 NulvI0R6it9sb9W6loafI7PnxrNsHlCsyCCSVME/tni0yecE667wOGjiYXlvgG1t9MgpRWfT9hY
 R/BMzOW/hjZMOBJosR+k413erpryWKRG88vATHDzxLyilUbRxkFv0l5bD67ZRKtga5+l9svX2ZH
 dm1+aLKruJ2gGoqExzm0wNbTnoCfjtPmkWax4t4dGXxW/5H06f2d6C0UAgTxR6AvxsV6nxSwmYN
 LF9Zsgxo3yzyLVpMv0WcEF9M1yfeKGR04l1lu85bxdKn+wuu2EfQL20ZpXyNkgI/OEcLpxoC6bX
 2QB694DJ6q4f4BhFA7w==
X-Proofpoint-ORIG-GUID: qMZ5WnU6GPGWEQ-6HmwDuJlFmRjuIyBF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

In qla2x00_loop_reset(), the LIP_FULL_LOGIN path called
qla2x00_mark_all_devices_lost() and immediately fired the firmware
full-login mailbox. In N2N topology, when the local port has the
larger WWPN, an fcport can still be in DELETE_PEND and not yet pruned
from the list when the FW LIP completes and RIDA processing kicks in,
leaving the driver to act on a stale fcport instance.

Replace mark_all_devices_lost() with qla2x00_wait_for_sess_deletion(),
which marks the fcports lost, waits for fcport_count to drain, and
flushes the host workqueue. That guarantees fcport workers have run to
completion and the stale entries are gone before FW is asked to
re-LIP, eliminating the race during BUS reset.

Cc: stable@vger.kernel.org
Fixes: 3c75ad1d87c7 ("scsi: qla2xxx: Remove defer flag to indicate immeadiate port loss")
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c0efdbff5da7..0e5e672e81ee 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1752,7 +1752,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	if (ha->flags.enable_lip_full_login && !IS_CNA_CAPABLE(ha)) {
 		atomic_set(&vha->loop_state, LOOP_DOWN);
 		atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
-		qla2x00_mark_all_devices_lost(vha);
+		qla2x00_wait_for_sess_deletion(vha);
 		ret = qla2x00_full_login_lip(vha);
 		if (ret != QLA_SUCCESS) {
 			ql_dbg(ql_dbg_taskm, vha, 0x802d,
-- 
2.52.0

