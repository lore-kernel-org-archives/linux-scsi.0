Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750591;
	b=wqdGaZvzFKumOuW8g2IGjrt6u3rO0HWF3UbsRJfE9NPf1XuenDIMUkehSdmv0SZKcXdx
	 YT8chXsitnh3i6+l/U2Ngff19/iE00Z6BzUFyMHeKbnjV+9BRtWbmltewju0A9QuSQ4Dg
	 3HGys25L9k7BW0/zEdoRJP1q9pquTDDGIdyvUIceWJVQ6+dLv0vLG+ej4CzYtDvcjWF4X
	 V7fp9C1nzwz+/2yxGPr1JoH2teiPz/SOoyH+ZLGiXt0vJP6QDveivFXLyPTXP52s96Sbt
	 OISMOBiy81hxdE0niwIe1fC9dAqFBrg3tVsh13rSDbUCq4GqWRdZ2FyL/J4BP6bpakg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750591;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=nnaKold2DH9qG02smLLGgl5TTFUIzbS1ERBfXnmpwwc=;
	b=yvcXI4kMGZHgcFrhquZNk9qX2OZodbxI/g/nozi7gioHlMJbu4+iCTpLU8+1FjexVUTc
	 cPj5MBMARecInxCMdROva95bypfzIkIJZi69PEJN4s0fnlBWNpnwuK1IudMHiG8LgpU+c
	 BP4cnQWghFBWAD+mmKv49ZG1o4mpNk4ta87t2Ak44OyyTDjyIwRUdfsydMd/Ho9h+g9S8
	 rzLVjAbtYTEfGRBUALym7QzZPh+fVKTZjHaSmlvVe/3lCOU9nbdOqnJHYa+y4+JzU4bDj
	 uxYeUu2RmvRe05Y8npVhPz8KBMbPpRWfEUdCdBHXeYrHPxxlyRYPtwkQnieJ0K4uIbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=bFcfvDhz;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258FF606A31B
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 258FF606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=bFcfvDhz
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADdlw3273804;
	Fri, 23 Oct 2026 03:16:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=n
	naKold2DH9qG02smLLGgl5TTFUIzbS1ERBfXnmpwwc=; b=bFcfvDhzEGo6iQ1pg
	TYs8Rj0CfRpE7726wZQkO9o7s17hqQIoQbb80mfhuUKcz4L8kSuBvNvNt8H36on/
	5jWu2VQo0J7h3isaPQ28En7RaZnYj55322mX73YIFTZgEI6O+AC2GR2Ez/nVlbOr
	RXaCRzZJi9Kad6stPPfBXwTYpI7TEnTYSi23ySxm26cBH0CvxRbNkcRG7p8871Y2
	7XUHvZLkRIhCvm+VCfF6ImuvLTMwcLGkLLYuUBv0Un+dApQ8Q2cyuTWycJVyC0fN
	WY+t9qJ2Jq1WmmM0AtwarKQ0iWK6UaaAtrmwexafR1RtD71MGpAktUdkSyiNsORk
	0Fp1w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hf94b994k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:28 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:27 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3EF263F7069;
	Fri, 23 Oct 2026 03:16:24 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 06/13] scsi: qla2xxx: Fix scan state machine race and IRQ-unsafe sp_unmap
Date: Fri, 23 Oct 2026 15:45:53 +0530
Message-ID: <20261023101600.1431179-7-njavali@marvell.com>
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
X-Proofpoint-GUID: QDMrD5J3ReAV-GkYyEnHKQXFoxbcAaGf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX6jFlQ0TBB8hk
 oj1uKVvnVDR9CtL++u1up2I433GXBcNSb+qzUNfh+KQ498T1NFjT3gzA7671/xsFQ0QJmwMhDOy
 4JEjRzwwBKJ5w79io6FySkNLNBZdKJftEyK0N9ZOg7I/bvh6WUEVXZwyuvKrcqR5D9UwbtRV0SV
 5Xh0JZtxCAjNhSWWq17xhPsJE5hwZQX+2WC3ClvyfhAi1AJWwCGSK0HScRM+hlSU45/Y3rgVT3G
 tMqcMQtbRF5vV3h0C3Zcpl9KfiDbbwSjFHrsPMchadfaG2y6GcpGWIgwRKKu/tqV4MRhLS91LHq
 z/FNyxXOE2HGVnwSc2IIotAbLf6kv2OLug5GhRZBIDaGzZlsgNGNb0C9Tevw3gCXXm7amVVf1Lz
 wQ98hlLI1DRZq2bVEyIVxVItvO1peOr7lyWO+J6x95w9r4emS8+zEs6HMlhcYr6Qag+IbaEKNLZ
 XY9qBj6C06txdetNzaw==
X-Proofpoint-ORIG-GUID: QDMrD5J3ReAV-GkYyEnHKQXFoxbcAaGf
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX2UZkoCIe+/lU
 4klGStLXu8EKWIqhraBVB1pLSgnHo873h1CxmprlcQinCILYmH2LbwIyPKf+Ka6DtZilgXwi3nM
 FKUouERicsUDQOFHO0pSxckXbyP6+Ns=
X-Authority-Analysis: v=2.4 cv=OrDaWC/t c=1 sm=1 tr=0 ts=6adb33fc cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=M381uGlLBhOuYSMaLXYA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

qla_async_scan_sp_done() runs in hard IRQ context. Fix three issues:

1. scan.step race: the handler cleared SF_SCANNING under work_lock but
   read vha->scan.step outside the lock. Another CPU could start a fresh
   scan and overwrite scan.step to FAB_SCAN_START before the read, which
   is not handled in the switch and trips WARN_ON(1) via the default
   case. Capture scan.step into a local under the same work_lock hold
   that clears SF_SCANNING and switch on the saved copy.

2. IRQ-unsafe unmap (error path): when post of QLA_EVT_SCAN_FINISH
   failed, qla24xx_sp_unmap() was called directly in IRQ context. It
   does dma_free_coherent()/vunmap() which require process context.
   Defer the unmap via the QLA_EVT_UNMAP work event instead.

3. IRQ-unsafe unmap (success-path fallback): same direct sp_unmap in
   IRQ context when post_next_scan_work() failed or the switch hit the
   default case. Defer via QLA_EVT_UNMAP as well.

Cc: stable@vger.kernel.org
Fixes: beafd6924614 ("scsi: qla2xxx: Reduce fabric scan duplicate code")
Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 20b1aef455c4..efe98609c149 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3512,6 +3512,8 @@ static void qla2x00_find_free_fcp_nvme_slot(struct scsi_qla_host *vha,
 static void qla_async_scan_sp_done(srb_t *sp, int res)
 {
 	struct scsi_qla_host *vha = sp->vha;
+	struct qla_work_evt *e;
+	enum scan_step step;
 	unsigned long flags;
 	int rc;
 
@@ -3544,8 +3546,16 @@ static void qla_async_scan_sp_done(srb_t *sp, int res)
 		 */
 		rc = qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_FINISH);
 		if (rc) {
-			/* Cleanup here to prevent memory leak */
-			qla24xx_sp_unmap(vha, sp);
+			/* Defer sp_unmap to process context -- we are in IRQ */
+			e = qla2x00_alloc_work(vha, QLA_EVT_UNMAP);
+			if (e) {
+				e->u.iosb.sp = sp;
+				qla2x00_post_work(vha, e);
+			} else {
+				ql_log(ql_log_warn, vha, 0x2029,
+				       "%s: Failed to schedule sp_unmap, sp leaked\n",
+				       name);
+			}
 
 			spin_lock_irqsave(&vha->work_lock, flags);
 			vha->scan.scan_flags &= ~SF_SCANNING;
@@ -3568,10 +3578,11 @@ static void qla_async_scan_sp_done(srb_t *sp, int res)
 	qla2x00_find_free_fcp_nvme_slot(vha, sp);
 
 	spin_lock_irqsave(&vha->work_lock, flags);
+	step = vha->scan.step;
 	vha->scan.scan_flags &= ~SF_SCANNING;
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 
-	switch (vha->scan.step) {
+	switch (step) {
 	case FAB_SCAN_GPNFT_FCP:
 	case FAB_SCAN_GPNFT_NVME:
 		rc = qla2x00_post_next_scan_work(vha, sp, QLA_EVT_SCAN_CMD);
@@ -3594,7 +3605,16 @@ static void qla_async_scan_sp_done(srb_t *sp, int res)
 	}
 
 	if (rc) {
-		qla24xx_sp_unmap(vha, sp);
+		/* Defer sp_unmap to process context -- we are in IRQ */
+		e = qla2x00_alloc_work(vha, QLA_EVT_UNMAP);
+		if (e) {
+			e->u.iosb.sp = sp;
+			qla2x00_post_work(vha, e);
+		} else {
+			ql_log(ql_log_warn, vha, 0x202a,
+			       "%s: Failed to schedule sp_unmap, sp leaked\n",
+			       __func__);
+		}
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		return;
-- 
2.52.0

