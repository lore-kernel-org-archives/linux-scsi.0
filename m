Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.156.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792745503;
	b=WaUgg7uqm4pO1OZpQknwQ46iHT5qmjQRmPq7AVykHJxUEBD6K8nrCoZ4sNJ14hjpVKEr
	 L/FuxJlmnB0CBtSmOMety015JcJynFdHMDZV9u4Mm0R7pXwSKi/ZMfWENRJmwxGW1usAs
	 l78opw7tT6nRFMiT156pH7/36hsJXsFvH1C9dyJ825xX1vjs/pjtxtZTXMCJB78+QWk/j
	 KmvnScnV6twraNyeSuQRvE/c0ydy93srngexUGrs+yc0vhAlD0nKyJUJZaWgLDS8vv7sG
	 kJVbcEM1lyean7JZ1eMoGEVB2RaG8vdWvNBuXCvWGNOQHtaC+bwQU60N11FrXFy73SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792745503;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version;
	bh=VUJ+oHOVSLtyBWv5kBkquxwai/EoTA4pvAWMjiQBk2w=;
	b=ZH1JAzA0jJYTqQDOSOSXzsv4F0XW72VMp1yz6W5xpr2etMAYq/caYIAR+aNaMUyY2s5B
	 r2VHt6cFGKFRfUeDONnX1wnk4tTLKIGQ1b+biCplsZSMa1IEy3WvyDhFLnfPEQCy7gzWP
	 mSPdVNvgjrVeI3rlnsMQq1z4zdP3H0lQV9nVElcBadK2yV5K2l7cWV+6ujTedy7aiK4nI
	 CG2gEEs0RAvjZ/Tf1+8bCYecvRJzvOk0OZlRPLtVALrCm4dgXiWun+85nZe7t109STDU+
	 bcQm7HdkN8A6YbH75FCkcnjZSlQzRndUyTQQ7kYq6ixUkRGU/WuUTvBpBr2rLfPSn9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=X0d8KMsq;
	arc=none smtp.remote-ip=67.231.156.173
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D661E606A31A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 08:51:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D661E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=X0d8KMsq
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69N7EE3P2928756;
	Fri, 23 Oct 2026 01:51:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=VUJ+oHOVSLtyBWv5kBkquxw
	ai/EoTA4pvAWMjiQBk2w=; b=X0d8KMsqpGh/UoFFl0CQEMdvHd3PY7tDmNeWw89
	IvEQ3kSNyeC4cx4y6232PvYytlQczknj9+ONL+eBgeW6cZ6tBcIs5FBpN6SaCYXP
	Bl1Rs+82YSz4NM10/yGP2Pqp10H8kj8kbIRxp5cOgD9KxMTRSTBToyy+ThZ4ss6M
	a2GYr+RCinf4JNQwFjVaBU8aiU7y0hG1cox1hTLze+21stmXJTHI+MFWc7UM8/yA
	5merpFsM3qKJazVS/4wjiTcd2kogECyM7zwftdXjbjE6ri8LJnU0DyROz81CRHaN
	j4jnryWsvK2NRZDluajBpo4OS2yOUY+e6wDopljugBudoKA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4hf94b8y31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 01:51:31 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 Oct 2026 01:51:31 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 23 Oct 2026 01:51:31 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 6FF683F70A7;
	Fri, 23 Oct 2026 01:51:29 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <jmeneghi@redhat.com>,
        <GR-ETH-Storage-Upstream@marvell.com>
Subject: [PATCH] MAINTAINERS: Update Marvell Ethernet storage maintainers
Date: Fri, 23 Oct 2026 14:21:12 +0530
Message-ID: <20261023085112.1378540-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
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
X-Proofpoint-GUID: TE3lhjUETkePFsB13dpV3skYsMoMlMkK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDAzNCBTYWx0ZWRfX2DWxmiDXPk/P
 Ynh8A+6mY2AGlogo3A/viIM/UAR3r7pYWgj82I9offbmmVlzx6JURKmT0i5tbxpivACAHFmnyjp
 S39WFuPZ4TeLRY5VyBMD3pV1E2DVSM5OGEfCcmGN4fDyO9b/CUZbzW5XtQWco0K1xJuxhhEk+ZY
 legUos+EvCKdqFkZU0wDZz9kcd1EIPCkQcLRVG81tp9x4IwLqbDyOEx3gI39yiwnC8SJmvIpZz6
 a31UiiZNj2WFOJvCiHaeHjCnwHQzxhUhjciXnS/0/7oFTrbjxXf3nNT/4NMS9aANIC8Qm+JXE/W
 ffVlhwHmjJx/4QtaZtaI8P32oXVumj6Ij3WXy6PBJTmhXvgxIO6UDCgIJy/q/uqoVJnOZQbRTij
 gKkp5XbVKuSmEcUTyTDH7GV8wJ52WOtfz1krfuDUuywCpiRM8WulOh3SV4GiUIXhrdIB9vDepyI
 RQLJJd5cnX74zXOiYvw==
X-Proofpoint-ORIG-GUID: TE3lhjUETkePFsB13dpV3skYsMoMlMkK
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDAzNCBTYWx0ZWRfX6X8+GQKKs2sK
 g0oPezBgWbcTYVyYNZktCg8u10Kr6oN4N5dD3tsUSow1DZN4E3LD0CEJhDyuPQnOD7QunQXJyMg
 y+xDNJkCxceOG6hUEONGUsFpmEzudP8=
X-Authority-Analysis: v=2.4 cv=OrDaWC/t c=1 sm=1 tr=0 ts=6adb2013 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=uDZJPa9GCa60il583OAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_02,2026-10-21_02,2025-10-01_01

Add Nilesh Javali and Manish Rangankar as co-maintainers
for bnx2fc and qedf.
Also update email alias for bnx2fc, bnx2i, qedf and qedi.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 MAINTAINERS | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 776eb78deb63..a616bf595b23 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5281,9 +5281,9 @@ F:	drivers/net/ethernet/broadcom/bnx2.*
 F:	drivers/net/ethernet/broadcom/bnx2_*
 
 BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER
-M:	Saurav Kashyap <skashyap@marvell.com>
-M:	Javed Hasan <jhasan@marvell.com>
-M:	GR-QLogic-Storage-Upstream@marvell.com
+M:	Nilesh Javali <njavali@marvell.com>
+M:	Manish Rangankar <mrangankar@marvell.com>
+M:	GR-ETH-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2fc/
@@ -5291,7 +5291,7 @@ F:	drivers/scsi/bnx2fc/
 BROADCOM BNX2I 1/10 GIGABIT iSCSI DRIVER
 M:	Nilesh Javali <njavali@marvell.com>
 M:	Manish Rangankar <mrangankar@marvell.com>
-M:	GR-QLogic-Storage-Upstream@marvell.com
+M:	GR-ETH-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/bnx2i/
@@ -21933,9 +21933,9 @@ S:	Maintained
 F:	drivers/power/reset/qemu-virt-ctrl.c
 
 QLOGIC QL41xxx FCOE DRIVER
-M:	Saurav Kashyap <skashyap@marvell.com>
-M:	Javed Hasan <jhasan@marvell.com>
-M:	GR-QLogic-Storage-Upstream@marvell.com
+M:	Nilesh Javali <njavali@marvell.com>
+M:	Manish Rangankar <mrangankar@marvell.com>
+M:	GR-ETH-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/qedf/
@@ -21943,7 +21943,7 @@ F:	drivers/scsi/qedf/
 QLOGIC QL41xxx ISCSI DRIVER
 M:	Nilesh Javali <njavali@marvell.com>
 M:	Manish Rangankar <mrangankar@marvell.com>
-M:	GR-QLogic-Storage-Upstream@marvell.com
+M:	GR-ETH-Storage-Upstream@marvell.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/qedi/
-- 
2.52.0

