Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792750578;
	b=x2zEtz68Ar9ThSIS0U2I58YVSzIaPCZYqdvUSQ2ipfgjWJlHky5AXdfqx+Q9z2/j1Hpg
	 gQtklAjT8BDexsDcHV3f4vl00twQipUq979GmSEqYXIl4y+aFqr1dMg9b82c2oPIK6g5L
	 mnsosAH4HNstJw56erG0UlGQVlgis7DaEg+2GfJgNyNpzpa1Rbst/H6Z3OnuRZztKZOVb
	 yNmHSN8Wk7UehML4qIqFJNgIbfvZtre8wQaIWbALbyDb520C7scgenS+3k7ub19/ofjZn
	 dKhwygv4MwFRhJMTN03YDSHoqOIY3h6eha4qllr2E44Z0ixYUrFo7/lfcrqvK4WlD+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792750578;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=mQqe1VdK2pK25OCPjhwiocpRCJwduSsKdoWrDThbVzU=;
	b=5IPXdALV5sIxgveUl268W5bn83tDN+GQ+R2rzuQBRO8mG8S9V9tMcOeUyHVVgbWXM7/S
	 soJQgtuNO4uNqowumJ1SA0VTDT0N+mWNBWagxlMRk9RHbGDy7ZFtywAjSgI4rFVWsFSQg
	 lm8XTU9mFvyfkkLYIXh6+oxAF6CGOhVDIuEm2X1wmLih73L3NrClK/GFGmwyVU48ojFN8
	 RKQycxQxsym94AZqrXVXHcLI9SwsraidPFR9HRRzJr0ZRZRMOQLhdFBFCqJ6ykzh9Gh7e
	 gcFcwpBMxcMtho/Cg4FKSLUeVagqhEeGEWsdZRkpv3O5GMdEAtGMlAOdEhf4al7BYnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=B5c0TWhJ;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579F9606A31B
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:16:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 579F9606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=B5c0TWhJ
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NADXkV3273150;
	Fri, 23 Oct 2026 03:16:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=m
	Qqe1VdK2pK25OCPjhwiocpRCJwduSsKdoWrDThbVzU=; b=B5c0TWhJ1Z4XOOVxc
	Va8Mj5Rf0G9NsGtPB0mI4Rpm07EYiPXxMF4Q2vR+L3E1hcgaQyQkaFWNjDLZwQM5
	A/jb96uXg3JPInWopYZENLBe1pHtPAA4QRMQ16oRyhidWP1w/hqn+oS2Xr+Pboz9
	XBrVskRQrcwUca/DrB9vkeUyPKc9sEBpz87vl//eehpPk5z8a12f42hiqvx15SAU
	mpQweqzNbVyty3Rl+YoqR+18hfgrVAkpdf3/stBjxj2PP6Sd/BRV0Qfg5zusEj7e
	fByUYPapC78O0S4xdgQM1OiHCpSL02wkr/ipP2jI1eM9qvYOqxh99ES6Ug/HTG5b
	6U8NQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hf94b993g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 03:16:14 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 03:16:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 03:16:14 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B46703F7069;
	Fri, 23 Oct 2026 03:16:11 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH v2 01/13] scsi: qla2xxx: Update MAINTAINERS with new FC storage alias
Date: Fri, 23 Oct 2026 15:45:48 +0530
Message-ID: <20261023101600.1431179-2-njavali@marvell.com>
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
X-Proofpoint-GUID: Z9QOI2J8kgJI7qNHIWQTgYlL2Xh5o6S5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfX2o/lW30nTBdH
 ZvfK4wDfrmtO2UQ8NpOojN9ULPblzDhRRBz0kL55Mfm3Rg/sfLX/2WeQO6KbDClf9O4yYH/s7m+
 Ij0+e2b8kCK2XbUR5EeRNCcjmMBP9E5r5ZveqAi8Rt4TrUEalh4MJTGMSQmrqTwU6VFvMGHJgEi
 Ovb3xjte3mobJd0n2pD7oZrc8S+g95A97S2xGUX008vxilpT/PyRO8e3TOGx2JMgeF+vvqZlsby
 MhWGgdz1jRvo+uNu9/3hqoZ0AqmnWNpQznzM/NIpRjl1Y5eXxk+0cnVdq6SUhC0iM9/OZW6juSO
 ZQnajlXHjdC2er+rhlVLjtJ1M6j3c2CQ2iSpp1MyFdhxpFvJCf+SQsqbZLWT2ClR4wCF0gmsBfV
 X6XVf0rkqlKF510Y1g+IjL+WiPNOyTJNkpMg8NnxvW1i4a746ADsi2YT97rFyggmR/b+zd9hD9L
 bmUYvu8qmXQ3jih1Qsw==
X-Proofpoint-ORIG-GUID: Z9QOI2J8kgJI7qNHIWQTgYlL2Xh5o6S5
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzOSBTYWx0ZWRfXyJjmowJ3X9ZG
 D4NXZW91wfSJG5w7f/ADg0tS0p5C97erfaARk/XxYMQyZa79tiRnWSgDWcSMBx/Mkc7xeunl1pX
 vPcbb1YAfoSpwaBAxWkr5PAcEob0oh4=
X-Authority-Analysis: v=2.4 cv=OrDaWC/t c=1 sm=1 tr=0 ts=6adb33ee cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=7J84mRsLM548UZCnXY8A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01

Update the MAINTAINERS entry for the QLA2XXX FC-SCSI driver, replacing
the GR-QLogic-Storage-Upstream@marvell.com mailing list alias with
GR-FC-Storage-Upstream@marvell.com.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9c768040658d..776eb78deb63 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21970,7 +21970,7 @@ F:	drivers/scsi/qla1280.[ch]
 
 QLOGIC QLA2XXX FC-SCSI DRIVER
 M:	Nilesh Javali <njavali@marvell.com>
-M:	GR-QLogic-Storage-Upstream@marvell.com
+M:	GR-FC-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/qla2xxx/
-- 
2.52.0

