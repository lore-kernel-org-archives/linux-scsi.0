Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578257;
	b=xHm7d5ajyKmmEx5kTNdKSZv2mAMwk77f9XV/bZMnr+RcJEldthMdxM1bbVhX71gHMRi8
	 CpR13EeS3Zi/179876aIJj3u55RIDtBZA+Ql/eYMHVu0oDetV8g2MKw5Qs00fuHpXO3Yq
	 Yf0KxVp3g+I8NHF1JB8C+Js/MTGwSO5wHratPkN/RgxzBxJZkAQfCNWVZonEy15mphGTF
	 8xvpf5TOFQP0ocNsPhdT0idjXRUFcwWTf5y5My9Th2Qwosh5Tb+4yewPcCvlQnB8Faf1+
	 IAIBjFeAWWejTyBjsXnVAj6rseu5A3cdQdibUNz3RmFYLGgt9RbJtIA0SWoP6lC41bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578257;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=EnwpNC7BUnxrE0+kdQKgHwdmMx2EXO0LpIqryXaA8No=;
	b=qHFm15xP4ByQzgrJQpTkB0FBeS+7UmaoqL9hXPokXK1RN8YICZyCNSoebViWojQ0QOin
	 /NIhzs9bWgfoymMyzUKOv1i+lF98eQJYAU4+oT3gkXAh/fZ9cjD0hVocyT5B668xIUF0W
	 KoOtwlencUsP8+D08JyBCgTIhKmvz208/nJ0dge4TKPj9OenCkYPqlAfoCOBy74h13vCC
	 SBjvvVNZNy1sREauP3vLYUCkTlL4L95Q9ghRhSPOs0UzqfVJc3nK+PFyBBazNxoLPM0EF
	 9lYS2doU3fCRhkwkThif3OTmsF/wQSdcCmMraAWhC081CTdOjNCLB9YOkkSlcre/LJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=gE+XXyDv;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F41E606A329
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:24:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F41E606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=gE+XXyDv
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA631W2174349;
	Wed, 21 Oct 2026 03:24:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=E
	nwpNC7BUnxrE0+kdQKgHwdmMx2EXO0LpIqryXaA8No=; b=gE+XXyDv/6BRjUwSG
	3mlTAE8rP/ZbAIsT9GuCxIKDTk9CasGHsT5vn+ETTUu1H3yVt3DlHCF4AUPmnsfO
	ejmP22L+UNQPtmsq42VJlgnUVjQGMAIJiLKLuWSusSC+zOIHpJlHaROSqWwEufte
	TMNNogu+DGLughmOr5Yawk6wTVQtBNPWLyKbxrLzg9EiHeHFgDJtp86v3iZSCCMk
	AliSnipjThS83XJapVHRSoF/6380kXVbvnNoQNAjo6UO/vzmv32BISClKBJ83cUu
	Ffgsu7M55pi3dYKxXNwSuV9iRqn5rpLLivIzqbwOvo/I5Isp1N8GSBUQwaSb0zA8
	sKdZQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hemfbsppu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:24:12 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:24:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:24:12 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 48E683F709E;
	Wed, 21 Oct 2026 03:24:10 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 14/14] scsi: qla2xxx: Update version to 12.00.00.2610b1
Date: Wed, 21 Oct 2026 15:53:10 +0530
Message-ID: <20261021102310.3854868-15-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=AvJ7T+9P c=1 sm=1 tr=0 ts=6ad892cc cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=d6pNcW3h3gfQQoDtdDAA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: JFzRogVJ5-9ATuoqtAiPLKYFSM6vG5zx
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX4eTcBtSZGjgN
 3Sx0ZgjXXmNgd19K59svX30WyB7K0sBwvtoG9T293Y8ELpk6kxGkmjdmDpylzqpL755KnQfPYdE
 WwuK75+NHOwdhQ5v5qyQWop5OrR/ViY=
X-Proofpoint-GUID: JFzRogVJ5-9ATuoqtAiPLKYFSM6vG5zx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfX90+d11uwUA+k
 c1HHKnSFkhHPYWmkKx02UjTJ/ka2/Cmbsx8zI9Iqj74lraMkc893U89NBQYDKW1v6MNmJeXh6uK
 ZtlPH6TI+v6dXCzOyLpSeb+EFnBBZNZhbPM6+MgkOVG/fM4bvS7unwAzUj7XoRIDMNEdDUSA7hb
 9Snz/T1/YoEHXEEkuONgmKERtM2mzi8CCBVC28zHs0mIgOzyL6PZ+0JQopXsnLzlkd0jk/VWNGf
 jki934gpwzztZS3l1rSASYBsMqSURfcrs+oaC22vFj20FQtvFYAjXsRME30fItmPRpLOpOXiUb2
 vjyP8Xh/m3NE3nOyCs62TYKKANN5Qk5EqYfcVW94/yPYEeF+bUO5youYQGGt2Jwc4tRkRqqXyOa
 ys4+zkM7t1iJ9ZLnABkE+CA1zl5x6iWQHpgb5sS7YlqUzsnxr7clCfsN3xQJNwxnMoWqWJQmxVc
 xJj4jNAgy7AiRd2RK1A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

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

