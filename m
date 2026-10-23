Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792760063;
	b=OY9IlhJV3nkCwJ9tv5bi5OtG+62Q0zO0mIb2UZTIVDvirDA0V6h4aHq29foQBCB1F0wh
	 Pd4HKmc+7ge3OF0V9yx0VGgmbTefKByaa+fn5+EkexUS5DZIoNxhohmOn3tsMCSj8EUJu
	 PsZtjXD9WOEyhlpkGhFFRKCWWn9f+Fd25/jHYzVHTVUAkNX8lFlD1c2fJrDak4JWSXNp4
	 xl6iIoTmr083PLKaP501POylLVh9OW6fVWHxFkmbZykZ91RGXHcbqEjVuM5/eOHJjW5eY
	 RRjKqnIkMMAoZmI0QC7J8faNFUnEI6SsUXG/uoJiuh6Xl04/s4wLY8yui3OSLW3YE1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792760063;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version;
	bh=KxDDx24IwThnMt1R6B5OHjmL9MgnUIM99BE57WHqO2o=;
	b=fIGhk+RlURqwnB54Jg83NFnq5KOJrPKCaPaSoZ0fsryXU8nqAHTb/M9kMV9hGqbu4c36
	 F28VlCgNr5lxOj9/ncQl+BbkPeMrJ86Nhc14vLbJsVoonfGYT+gdZq+x2r7Yl5dkb3hKx
	 tbLu0yESYP0Bu2stYoAO3Kf5D7CRzJvsG22acqZBgklzDNHe1+fMqjRvMKdPaHpCFpRGu
	 Sm83hep4oWBTGDbmzbt1iz1Wg0KwE0n7tzReKdGVNMEL3HbdBC+2xeAXgC95m06bUzadU
	 W2Tws+KgicrkIHD5+SkQ9MzNNlixPK1ChK/DhlTe8lyyQstn4HkpyHJbgvn7hBSglzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=exkgpT2O;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C88C606A31A;
	Fri, 23 Oct 2026 12:54:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C88C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=exkgpT2O
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADoj43110230;
	Fri, 23 Oct 2026 05:54:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=KxDDx24IwThnMt1R6B5OHjm
	L9MgnUIM99BE57WHqO2o=; b=exkgpT2OOdaVDwVozFdknmOG7ZdVAX83eep2D+q
	f5PWtFqnEhMDkZnXafnvgbfoxWXsV1yNGnssAWkxKaraUB8Vaff4JtjapqcYrxU8
	CncAouxW6MZ99/iKR3COwUF/6ZdP0HKDH+bZDa3QFTqxyTTXVwYmb0ngN/UFAb0l
	sD0yIbXSIrvRLEeyfxyBJ+3AFjv1F1ZwofyKX5uR5VZVPqSRZeyH8Zxm4UQZBXK4
	Ph4NqIkYfiupkCItnH/wo8TBfTZ6umnUR+/bnHbqctBu6p+Y712CpawTh8pUXrA9
	1dC1f+H1v4GTXz8QIKaSt+0rOHiRvJYPTLpHHnnw3BkuLZw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4hfv15u6ye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 05:54:19 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 05:54:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 05:54:18 -0700
Received: from PE-LT7841.marvell.com (unknown [10.28.165.186])
	by maili.marvell.com (Postfix) with ESMTP id 04FB93F7045;
	Fri, 23 Oct 2026 05:54:13 -0700 (PDT)
From: "Nimal Prabudoss [C]" <nprabudoss@marvell.com>
To: <linux-scsi@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <jmeneghi@redhat.com>, <mschmidt@redhat.com>, <manishc@marvell.com>,
        <palok@marvell.com>, <spadol@marvell.com>, <jtaubepe@redhat.com>,
        "Nimal
 Prabudoss" <nprabudoss@marvell.com>
Subject: [PATCH] MAINTAINERS: Update maintainers for QLogic ETHERNET drivers
Date: Fri, 23 Oct 2026 18:24:08 +0530
Message-ID: <20261023125409.1989-1-nprabudoss@marvell.com>
X-Mailer: git-send-email 2.54.0.windows.1
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
X-Proofpoint-GUID: GDCeoP31oRJ5ZO9Ff3QVQMj9o5HTio2_
X-Authority-Analysis: v=2.4 cv=RPQmjIi+ c=1 sm=1 tr=0 ts=6adb58fb cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=q1_EPlUX0R6ygB9ete4A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA1MCBTYWx0ZWRfXxjW1pxaf4sYO
 RYrSOrkMe/2k885VsGSg9SVfKE71LK7cToIb/gebFYXRyzAJ7a5k69r9/vn0nqO6IwB1gJ2LxmU
 CB9bdUF/NSY2h1D8k5BiYPf1W2nEsWQ=
X-Proofpoint-ORIG-GUID: GDCeoP31oRJ5ZO9Ff3QVQMj9o5HTio2_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA1MCBTYWx0ZWRfX6rDhBmIrRhcL
 MXwufDnOMj+a7UJ+ItqeBsRFgME6Ip5edmaJ1MLEBJB/LRONRoqnZH/7DpgHJNztmZ0pOwKXPqT
 WHWZ6frc8rxLnwuZgWXJhj1qpyQB8bySUqnhFc6mVsj+qpUA8hrHPsxiQ/8r0uBLB8jTmr39QbM
 TmA97qvsBAuAiN+qeEKhWhffAd4k7eqK3U+YwgawSUcXPJhB287x28rPV38rvqrUn429gzX3yAT
 kgvmr66BsBo6BA89PJGuYaw36MyBZ205ndvHIfzJLudZ20uLa1Da5xuuj2EGEeYtavUIWs+dKFq
 DkhUGZUSqya6XpzG/h45y9q86JulyqmcO5lGMVkj1dtx/K98E16DVSpEswL7Ky/+5uoGFa9hC8V
 irUfoDk6jcHy4lTAgLQ9hLM6qlv1r3RF9b571UYZjf/nM0UDx5XSCsM1dx6RfYl0iZT14xQ7Z6r
 XA8fkt5hXgATVWXd78g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

From: Nimal Prabudoss <nprabudoss@marvell.com>

Update maintainer list for BROADCOM BNX2 GIGABIT ETHERNET DRIVER
and QLOGIC QL4xxx ETHERNET DRIVER to reflect current team structure.

Signed-off-by: Nimal Prabudoss <nprabudoss@marvell.com>
---
 MAINTAINERS | 7 +++----
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3cb12243b636..4fdb0c2be63f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4595,7 +4595,8 @@ F:	include/linux/bcm963xx_nvram.h
 F:	include/linux/bcm963xx_tag.h
 
 BROADCOM BNX2 GIGABIT ETHERNET DRIVER
-M:	Rasesh Mody <rmody@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
 M:	GR-Linux-NIC-Dev@marvell.com
 L:	netdev@vger.kernel.org
 S:	Supported
@@ -19067,6 +19068,8 @@ F:	drivers/scsi/qedi/

 QLOGIC QL4xxx ETHERNET DRIVER
-M:	Manish Chopra <manishc@marvell.com>
+M:	Nimal Prabudoss <nprabudoss@marvell.com>
+M:	Sharad Padol <spadol@marvell.com>
+M:	GR-Linux-NIC-Dev@marvell.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/qlogic/qed/
-- 
2.56.0

