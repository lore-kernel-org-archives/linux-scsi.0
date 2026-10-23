Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750608;
	b=xRERfoMuNbYMW2OE0l1dMME5gppoNmPV1U1i/kP9oOyx8LBKerFq9RqCeIMVhwuhXUWx
	 QXQu1cSJo6qTfzK9klLN0/UtE4uPDl8r80fh08mqzO0FLiuTLxSCG/V1nQOQJnX2PWIrQ
	 v7+Y5w3I0eh5wNKRlhQCIUtyWviPArpTBc6pf91gUWrk4GVa3p/i7OYVNJxkyd0F/oUhW
	 8CLulpCYlPdTDLbgvA+RNOgeFuwSK8KyOF13K5wIoyV5ci3722neagTloC/L1oNZ2kvE4
	 VZNK5VZqrRU+TB9ulKhFHISg8fA54mqCf0E4LPlDT5YwClpmvscPBJ/GWrDoF6W5ayA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750608;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=rD75VvYUjkwT7md0+QoIY0DXLQNeHxNZefQKWhgYZ/g=;
	b=U0Dokxoe3in5PxcWD2LBYpYEPDOcfVAUsoqOS0X5E533VjOt/36qTEZfVxGMse6Xkepn
	 42XXtFcA30uIDAqFC2/vgHb49jYarMJe6bDeRFBwZKX1OR5WtUL1R1+oukBueZx3K6IUa
	 pgzCYfVXjsG/HxAKQnpd7/P5rL2hbJDbgyGmuHfHG3NxjGJYtOCdKIrdf0W8sQgCkjSrz
	 qFvs7lk8L8ZYZ9928cr5x+qQ3aQ/ezVZASdn42U6u/LR3sxGIjoc1iXcf3EsBBufXEW+o
	 uweGm4ap7+iK/X3w21LLy5yYWVXIhIvE9Mg7EZMxi7fBNPtownuuxZQmoJWNdziFkvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=Ry6r5Xej;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFA7606A31D
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CAFA7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=Ry6r5Xej
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADXY33273147;
	Fri, 23 Oct 2026 03:16:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=r
	D75VvYUjkwT7md0+QoIY0DXLQNeHxNZefQKWhgYZ/g=; b=Ry6r5XejQ0NXBASPv
	NTKoZctWZWHanxxg0bbWFra/aYTAb6YZzhA7BvhA8DlGJ3q3LqnoxeyyZVMXrTmW
	xiFpTKQumYyv9R3MXxeEoBfVhDD6wiTZSFRKIREVZVonE/p4vc/aBYTWZ1etICgw
	FPKmX+wLnJth87SWYXx9lHLy32Fb7m3P2dNYZxBlpDTAT9lGZ9wj3He429iZM7Zk
	Le0bcs40PY19KlheF9A10lnm/MXHOWCetIBR9zT6ft0pj3CHdTcmbi155zytXXZU
	D8d0+jourTb0BI3BS7ezOu242U2hz+JGqZCbDJERsK2fVvS6t3mQPKKIkuw2UH2k
	AgOpA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hf94b995d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:44 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:43 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id ACE2C3F7069;
	Fri, 23 Oct 2026 03:16:41 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 12/13] scsi: qla2xxx: Fix purex IOCB copy size on non-29xx adapters
Date: Fri, 23 Oct 2026 15:45:59 +0530
Message-ID: <20261023101600.1431179-13-njavali@marvell.com>
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
X-Proofpoint-GUID: 3qn4_u8w3ZDB65F_9OLtT_hgwcmh8sDA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX7bTDLhT0nS10
 TqTyp1GZU2lzz7h2e0AetEqBEvZTqLC9AXKlcNG/h0VBg0UakDk9JkhrPN4NN+LTKkTfH4wtfuA
 I1uhm1CbNHCOJEB76Y7b4CWICin62TuOVnwW5z1NcMGuuD8r0/mfS/ayjOxeNrKhSHWjGrL83w4
 BCuap2DgRQ8gE0Srtw4Ltdz7trx7feaAlX4XE36jfLic634r6yZwWl4tHdhckh9TfvduBT2Snjm
 sEybkONONl2jjAFuLDE+yG8tRLMMOOReZFRrHBsgwOpKl67N9il6fHiCyZ6k45xmXkGfZDpBGkk
 i2T5QHBo2YL9Erk7QloDNW2wXY4qllNmpBBv5gJLR4Jd7S5polt+fjbIrGART+MkPzHJHy02QLc
 pt1RbiwvMFcfJjkIH84mTz5C8Pixl+9wlEOMrTCTIE2JsEBKQJgWP5FjcwPNmD6lvyLRX0bNdHD
 wuZSo8taMz9oKoqo64Q==
X-Proofpoint-ORIG-GUID: 3qn4_u8w3ZDB65F_9OLtT_hgwcmh8sDA
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX9JAe/FKotVAh
 qM4JESJrHbg3QecV4d50wQGvAVOQGayBBO9gnPXPPwfqq67QwtGLn6U6PDBvh/F81yKMtLgzglj
 ZKgcuDtH7CbPc+LKe8B/UFUg8MhwHDk=
X-Authority-Analysis: v=2.4 cv=OrDaWC/t c=1 sm=1 tr=0 ts=6adb340c cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=ooo6xw6B66PLRWSX0HIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

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

