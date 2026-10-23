Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750611;
	b=ERVNyw0b5yhnH7w+VgpP99eYiAifwKN3bCLnMSoIxbs/jHx0rDRi/4+0+ex7pT+EPisL
	 FGpUT59I7i6qY+h32pVoVhUtLZFAOe0XQOM0QfmFRl4dIVfW0Nk1HWv8zUyzkPmtCosXW
	 VKEw9CpoNgeZT3sKXFB6e9gCWdOIhg9S/VLNJuRkWUfWUgxxOYAIHpdpXcLEaMfl7iuuA
	 kuYyrA+hUnnGhNdK3IS19GKHVXF0MH3irngkGdn2e3iPY9zxYkdIiX6IB3FQQUio4PL0R
	 SNM4MZ46ycgtqwvteuGeFDCP3V+BGKzbm2CtprvTDWDuu2sTsPhq7XY2itTmAZjz5FQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750611;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=EnwpNC7BUnxrE0+kdQKgHwdmMx2EXO0LpIqryXaA8No=;
	b=1f1rgWKa5n/V2U89xr5wfymuuxxRLeQWlg1QTrjRULxDSoE+8E/lEhTUDcVYSK75oUqO
	 KZcRd1opMZLFnJ2MFmwBizWbDUgyB6gf3KI6weW5Qj47wdcvTu9VfJ29jzbPVPjF1QoC7
	 upBqm0Xj4LXoo6G5r1Vz130mkdPInd+ja6rs8zQATuZerM+cGISOtcpLCVLDH2W57ULnU
	 VIQwnUdOuuan6R1/xR0gcba8A4HdY40bdgFuo8Cv05YW9GTHMQ73wvl2F5D8a2r0DfiiX
	 NcOxl/TEZbjIJT9XYsCTumimk/5wpynRudKFmrn5MQ/6YAjC1gfEc/lgN8jPAbZbSHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=YBU7R0D2;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF7E606A31F
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AF7E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=YBU7R0D2
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAE8X43757735;
	Fri, 23 Oct 2026 03:16:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=E
	nwpNC7BUnxrE0+kdQKgHwdmMx2EXO0LpIqryXaA8No=; b=YBU7R0D2b18eFP6E0
	DVkRtnrxd+sTwSkFKm8pi3Geiau+kW06CAocQV5p037yD3OiuyAb5DCwZGN1K1b1
	O53ZyK6tDccjYV0QNugV1RyHHST0sKQKnn8zq1rxTzWSt03yHe4c/DCTSBiRvlmn
	fWc1mQCHMdsSrNp9JNrUFCtsLrip52pzyuYtcG2njrn91l9WB+4GuJNB8qNlOreG
	6gtSwKMlYEzuEX56U3BVI3rYbV3hsXcFunS0jR+SlWJkGePwKQaMgH91gu34vDzH
	9pgr+TVdWwG8xTJPvVQqk8rcNMKSU5Qq3wYaAKOcvWp4TssuV/YfOenAIY4owtwS
	8i1AA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hfmdtn9xx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:46 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:46 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5A7543F7069;
	Fri, 23 Oct 2026 03:16:44 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 13/13] scsi: qla2xxx: Update version to 12.00.00.2610b1
Date: Fri, 23 Oct 2026 15:46:00 +0530
Message-ID: <20261023101600.1431179-14-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfXzd5QFSLjdZzd
 jR9LgdY0YC0Rjm+TaFad1/JIDmVlHh9RDTauLTaT107nRl4LfHEEjgNv5iulqLpXZqGeJREdT5O
 2MfPbovZbYsN+J2RZ3r1wtDBWBQD+/4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfXyIFoCTIG79kN
 8V5wxnIpcQfrunaOstNxAT0fS5G78/2RfleUlrdfFyxMpnALQlHhN4zVSFqcyJ8EdRINlPZEhCM
 cBmd5sKnA1n51gL/knzCJ/oPSvAuKLjcbwRidwwZB11evU4122DUZlJ417anuPtYXgfjWZgjg4J
 bVeClFZr2lnbyVZnmpe+jBSq/x9jon4U7wg6Lxj6SMb83GETxTtf5PepMK4E6KgzXEejRJnsl5O
 Sz1iAVjCCfT/1WzWwKtxaIBbxdwVVinzTsPGez9bJrNb6E7Uv+bi+IiSXjBS57+dljhK684CYvJ
 4+jVXBD5VDypzJWf8N2aPllHQk8/7SpnJiEnI3MRQYelE2tzt7j7dXVJ+aB9iRHt7GuK3yHHJi9
 0Xq5Y5sxWDba8jl2IMW7J5YhaOWU25zt0sqquQntqq2d8VjUwXVHi7QnNU4l7w10B8TXZf0iqmJ
 GBKYs7b8c88KS8bEaOQ==
X-Proofpoint-GUID: nm9mPDEsfA4VoP3KCp_shd2dfTnZWQBj
X-Proofpoint-ORIG-GUID: nm9mPDEsfA4VoP3KCp_shd2dfTnZWQBj
X-Authority-Analysis: v=2.4 cv=PalqFShd c=1 sm=1 tr=0 ts=6adb340e cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=d6pNcW3h3gfQQoDtdDAA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index ef9dc88221c9..0b0c7a3d23b5 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -6,9 +6,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "12.00.00.2607b2"
+#define QLA2XXX_VERSION      "12.00.00.2610b1"
 
 #define QLA_DRIVER_MAJOR_VER	12
 #define QLA_DRIVER_MINOR_VER	00
 #define QLA_DRIVER_PATCH_VER	00
-#define QLA_DRIVER_BETA_VER	2607
+#define QLA_DRIVER_BETA_VER	2610
-- 
2.52.0

