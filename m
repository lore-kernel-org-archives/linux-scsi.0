Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578239;
	b=W3modCtm9dVCg+LG1Ay5J++EaTnVo1pPXUqaLLKGwDGmKnn4bDWTeJ+xaA7NyWodSE1w
	 U7KXI45jmvmkNikd4MdCI8z5nNHVfKHF34ibs97m3BdAzxi0rq4pChJdusOxLNpm0i+WD
	 Dkq1Pqrifr3n4MHQmqWa4V5fkg047hYuox4DTUChk2GUnDjQcZRzSHk8XmpO9IUQhGjsv
	 58QMEXRaAj2A6suWhYbkpkQGAN++ion6GJA70mcdathCxZ/pWN0cxvLKreaUuGpblzbI+
	 R4qt9jOweUcOOSkSsX6KyE2PhYdkprdfdsbKb7jVZmHDGu//g4uoE72Z45RjZV59UTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578239;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=nnaKold2DH9qG02smLLGgl5TTFUIzbS1ERBfXnmpwwc=;
	b=TVnmk1egyiQkxqVvhWBlQa77k/emEEgr0Aom+xH867sUw8kNzdNhgXBJuws3gPCu7/Tg
	 b/SB0Cq9F49z785ZpKEJqs5yh5+aMsUDvFfGvEwzRGAXRPijq+qMAiQ77/gbrusCW9+oF
	 pR9QvnN7tbl8y3u2XHCylmFBDuXN/KSf9DV7Xnf1Md1QvVWA/m4YWDvwn5/8+l4PZSP/3
	 ziN3Wv1596N0695pNDpJeEOMWwHnsApKyXhKdnwoI1RaH/3iKI3Dp7NDLlzlWI0kiQH7t
	 pH60vZNDSC+Kl5DmVI8aO2IZorTh92NeV/2LFGuvBGX8dNZ6uuLvGElgCDqqSSrwdew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=R5CytfJ4;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EC1606A31E
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:23:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23EC1606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=R5CytfJ4
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5Fde1715546;
	Wed, 21 Oct 2026 03:23:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=n
	naKold2DH9qG02smLLGgl5TTFUIzbS1ERBfXnmpwwc=; b=R5CytfJ4L76LcRQ6t
	idyfaa4skIdBw7nBZTHPPJZs9rwXAcUgnDRSdM0pzAd4T7tQ74hTYq0paGZQaecQ
	v4zDKXyYNuEFYx389Fx0n7PE+iaJhbPC4AheeyV+nqaWg2V6j7pB/Ayi5h0pQSQc
	/3oubR8xtgz18ytRXPcj1Ystq3g7bxQM1o4AUBKzbnlxRTwu0Y5LOFldgTOCo9rf
	WpXhdwClLktGv7apQ8BT40GdUCwBj6t5XWnhvbyQf8OwLPBB1nSLIoN1FgY8Ohnq
	6heOO30iyIqi+8zye2me1jArLJ7W99NzETRV154M5MhRco6zt+5PziNJxcsFHly7
	ZAzOw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4heu07g4k9-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:55 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:52 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id C54A63F70A8;
	Wed, 21 Oct 2026 03:23:50 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 06/14] scsi: qla2xxx: Fix scan state machine race and IRQ-unsafe sp_unmap
Date: Wed, 21 Oct 2026 15:53:02 +0530
Message-ID: <20261021102310.3854868-7-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=DunDa2/+ c=1 sm=1 tr=0 ts=6ad892bb cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=M381uGlLBhOuYSMaLXYA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfXzl7TI4eTFYK2
 JCnzzpAGLCiq4IzxblyOZJUT+8W5qi2Iw1hAQtD7PWlOhOb7I1Sei56hEZrq9WarbOhBzJiUXB/
 3DtEDmifuIDEtK2md+dnTMRfYgVmKGA=
X-Proofpoint-GUID: RIbPyg4M3z8JsF6BhFsXdwTW0C-rV7et
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX8tlm3DT5RBgw
 nhaDVl+8Orw2+ADEb7HIocC+tCiTaVVwPJ3oS47WetbHF2adTgCH+1/xFmHTLE/lErhSqhTA7hK
 sY4sgepV1lv8dxawtXj493/QaZluXc2GyUY18p2xehYi8Jd1VyJkgVl9c54HL7BfAG/1IYMHhLx
 HWHyzD+YS2gd02Ct/baAUVIWL1zLurS7anU3/oD2KAFg7yYKQbJWmWA7/ziFXja6nj76c0EIpIH
 L42YS0IJ3RXXTIe65ekGcgS9m55bRYnlT56q9fj+cnnWIFDzqEE/KEHjMWG6x8QWHy9OJgamCkQ
 DWuoxHs27kwKSKkbhZSplzpHdBq0+rUIyn4v89ExjQytZRXD7zW4WY2XIhZ63cy+iZWlkknHzAC
 JFgjkjIoObRyU+A3Qf93jPFTDPIILhXIE3Y9D7aGhMuOrvcOXlTIRNYCq2YcSH60qndNs9pvV2g
 0udHY9AHnxj5ydPbyMg==
X-Proofpoint-ORIG-GUID: RIbPyg4M3z8JsF6BhFsXdwTW0C-rV7et
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

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

