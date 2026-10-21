Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578255;
	b=JTsC8R1O+RC2ZTkuscEVAkDwLnSnawRBw5YZ4gzkzqOJUK8X9ihFB+kSkAamPrvEKve+
	 Gm2SPAIAudAMtX7RdAj/4WoQL8USHufMDaYQ2ka9NLxTjqsScYvQSAsmS45IM7JzCNpcv
	 8i6KKyJJ9CvqKTFj7nr1o0Crk21eZI8gbHiqOqXJh2fhmEkfzBluSvY4SgVrwaiSM3HyX
	 AEwoPrEaO77DCpcFkwYnw2J8bYFFzubtdU8BiTPb0mFREGlFFTJiOfjuJyA1Rl7O5/bDL
	 93laXrwxn3pcT7EeBL0hdoCUO8UH7Ry8xszPBUZ55xtgmbJRmdo//3I4oFgPZeel9EA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578255;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=rD75VvYUjkwT7md0+QoIY0DXLQNeHxNZefQKWhgYZ/g=;
	b=b7EHoc+awvdoK/pPbWDSQYg3nxYbhyvV+6nVQ0ZUT7hBeR8v6EqiMzzIjSVc61ypxVnL
	 YOLsk6yqUaSJIvZTppdYStCmdgmYl17Qi9PJrWggwzkCBc9CfxVG/XWzjMMskuvuNuQQq
	 Bl5BTSX5GNLSrcbee2v1jULcSsvAVtgglElVG1PYR6yNy3zwZozKRhl8srzzuDYWTDrFR
	 patLY9D3m2s61VcuUjbw5HOCU2PMSm7q5AzxmzxFqhczVg7RKd0tK5KWDUDO4kEJBcaRM
	 TanImVx4RwZKWEiLZtxw4AcYkzVXSjhf+pFmm1B6pRJiURETnCtYm+UWYhLCxpc0amA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=GQVXeyBc;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A790960A2608
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:24:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A790960A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=GQVXeyBc
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5fTp1763793;
	Wed, 21 Oct 2026 03:24:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=r
	D75VvYUjkwT7md0+QoIY0DXLQNeHxNZefQKWhgYZ/g=; b=GQVXeyBckPJsqao05
	5nkNU2WZcRRr5wPnoGO4cOz3e04xswjTMk6cFKGUfXiuGzZ4xhlK6zh7XDI2mnDl
	ZcnYbCDODEsa9GT/O3Wg/I/yEe92GsTwWo6MKDgEutN3BJALcFgdVc4UjglfLMPP
	w6KXZv0bww8X6lYCeK8jYmaPir3jH8IUZmOPePlCwm/3rE9ygjYIlb+ECAq9dt5H
	W5GF5VdD7AulMflkFw9H8kqBW4HoraxCPQTn72Dqk3OTvu7Q5WaiCxbxtho4Ow/R
	0nE5eTucth20a8trj4zbTTEI1p4g9BO0gSWpwUWijz/WWTRk826L6mCWoSzcLmOH
	NPt1A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hepyxh2ky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:24:10 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:24:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:24:10 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id E1DA93F709E;
	Wed, 21 Oct 2026 03:24:07 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 13/14] scsi: qla2xxx: Fix purex IOCB copy size on non-29xx adapters
Date: Wed, 21 Oct 2026 15:53:09 +0530
Message-ID: <20261021102310.3854868-14-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: 9FqCfBScxHYJSHlrtbn3jtmiD0TZkBRi
X-Proofpoint-GUID: 9FqCfBScxHYJSHlrtbn3jtmiD0TZkBRi
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX25UvPTlFIRIV
 XKR2E0paahfW1vfN01FxwhvdLS4y+ZoXuDV8gyBjR8XNChO8/3eS7oPd+W+fDkFOORk927l78dU
 46MXghcSHD5Y3mkhu3kEFg14517PqAM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX7nzCOgMj7Xxa
 LQlCHD9pntGc+vn24a/pq0tp8/wBjf9DBpp1FN3HVEUl6YPNxLfFbtMftFvkgtdXBeBCXdfLadb
 sx7EAzoDfHz4zunIfRH+BFfw0a2FjoKxRVVBk6gXozqHEW5k1jkSmrjrR913I4RSPBPAlOx5FOP
 RIyLkO55xSKL05nK/R0ElfneLQAQRzKBzHcxPWNPhIrqtl23ZkJh5cttdahwHgeg8zSCjFVg7+n
 GYb2kCuVCmjjB0CCqyYZS5qUnhZsTQbXkZqHyhM3NI4olNPmhF/KM6urv+jFpzPxO5z974qX9VU
 xWGs9wT/EbzjTL3MCKmI5hpzyC3eNPfJMgTJVrqGwtJ8deCj14UMU5zhpQkHHDq0IaN9kZ0Lp+y
 rPEcAHfNsysqMrpE+ME6A4entAmSRwVm7JguZKTk9AJjRvSIO8cOIuzftsVCGUF3QNc0epSeN+v
 6BtFAJ/XppUR1EI5cmg==
X-Authority-Analysis: v=2.4 cv=Jq9kP84C c=1 sm=1 tr=0 ts=6ad892ca cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=ooo6xw6B66PLRWSX0HIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

qla24xx_copy_std_pkt() copies a single purex IOCB from the request/
response ring into a purex_item. The source entry size depends on the
adapter: 64 bytes (struct purex_entry_24xx) on 27xx/28xx and 128 bytes
(struct purex_entry_24xx_ext) on 29xx.

For non-29xx adapters the copy size was set to QLA_DEFAULT_PAYLOAD_SIZE
(128), causing memcpy() to read 64 bytes past the end of the 64-byte
source IOCB in the ring. Copy sizeof(struct purex_entry_24xx) instead so
exactly one IOCB is copied on these adapters.

Cc: stable@vger.kernel.org
Fixes: 150a29ebda52 ("scsi: qla2xxx: Enhance purex_entry handling for 29xx series")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 1 -
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 97e2a1a9ce3f..da5ca604d99e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5005,7 +5005,6 @@ struct active_regions {
 #define QLA_SET_DATA_RATE_NOLR	1
 #define QLA_SET_DATA_RATE_LR	2 /* Set speed and initiate LR */
 
-#define QLA_DEFAULT_PAYLOAD_SIZE	64
 #define QLA_MAX_IOCB_SIZE		128
 /*
  * This item might be allocated with a size > sizeof(struct purex_item).
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7bae26d4404c..2a4eaefdcefc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1220,7 +1220,7 @@ static struct purex_item
 	if (IS_QLA29XX(ha))
 		copy_sz = sizeof(struct purex_entry_24xx_ext);
 	else
-		copy_sz = QLA_DEFAULT_PAYLOAD_SIZE;
+		copy_sz = sizeof(struct purex_entry_24xx);
 
 	item = qla24xx_alloc_purex_item(vha, copy_sz);
 	if (!item)
-- 
2.52.0

