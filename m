Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.148.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578224;
	b=jcq3Kjrx/D5bJnasslYBUWGf44dQvnl9eMh+sHhKveC+PsTgnFMe5qqgoD0Mihn0H2qm
	 mIZEOs7LvZBl2lTyfJlMGYzo+vIOEZXnX/qkvOOrbzW64DobAzsRVFr2uILQiVHnNVMyW
	 t7kENG5Cy0uSwr9Rw/qpfZrqPZpYVMdRwFu5rYwEwc64h4Abm5hLUMzXo+Kvdebt9lWqM
	 HVz97faupAj8BGkAVWvtx8Bf0Vm4i/Bbe2lmcj8y8YIe/mvyIhlDwhq0mnxRV2U1H71PB
	 UrChttmZy2y0N7IS60vR07HwAU9Tt2b4ROlRkwefu6KLEmmV631cns7VAfRSpltZLQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578224;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:Content-Type:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version;
	bh=mQqe1VdK2pK25OCPjhwiocpRCJwduSsKdoWrDThbVzU=;
	b=Hk0jb2V/yDjq9Mz7qq6PjOQlrSnWgFAiQF/WvBpbDdK9DbPNrj8wYjc159E3nf/h6BKo
	 YZpAyA1npZuExEN//2kp3SRG/Lce9VrkmzdWZhoF2l/vIJPS7DnukvwJVCCXGBP30KPan
	 DVA26xbNGCv3Mhhx3wmo6XurK7TC0Cf//cXyo7KHxi0UODLN7jn+wXxhZtvYKCcjqDscD
	 iEz0To5Q9PG465U+APoYgqpu4ri5dRNYINiNlLF6TBTjjX0Z8lXKB3lA6zQ+7E8no+DVJ
	 BediIfmiRfMJDGbEng1pv/9QpE1CB3yHUX/2zxPLknelP28jc0QgIQNBfKV+n3SWlqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=marvell.com;
	spf=pass smtp.mailfrom=marvell.com;
	dkim=pass header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=gzvia3a8;
	arc=none smtp.remote-ip=67.231.148.174
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB7F606A321
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2026 10:23:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DB7F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=marvell.com header.i=@marvell.com header.a=rsa-sha256 header.s=pfpt0220 header.b=gzvia3a8
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69LA5Hko1715549;
	Wed, 21 Oct 2026 03:23:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=m
	Qqe1VdK2pK25OCPjhwiocpRCJwduSsKdoWrDThbVzU=; b=gzvia3a8CuCQL0lG8
	IRtKjR1CQ36wBxBSzJsxobDm+B9505J6W1xNwbNMRmKmrlppDPAexoAc+Fihqh3j
	dC/nHLPfuTHdoa5ypeQHSjY7suX/fSgIdDxeBmYJ6TzM4h6Fgc+xDHXSlVm96r/5
	I4xwMTcImv50Aas5orvMeJxZxplvfdjMh5Cbo+tIgRhLQHJo0FuTv0aN6S6oRDei
	AjpaIhD0bmlvnn5sAwuNnAwR3ohpVCIEjue3pNLLiq5ofvvGykr4jCCujZcYeUnK
	RGThEiEGGrGymmj6MZkGKBARxePb8wrIcu5eG0i5rDuqmUVoSWXOmUlzxZLJLFvU
	ErUQQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4heu07g4jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 03:23:40 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 Oct 2026 03:23:40 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 21 Oct 2026 03:23:40 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 686C93F709E;
	Wed, 21 Oct 2026 03:23:38 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: [PATCH 01/14] scsi: qla2xxx: Update MAINTAINERS with new FC storage alias
Date: Wed, 21 Oct 2026 15:52:57 +0530
Message-ID: <20261021102310.3854868-2-njavali@marvell.com>
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
X-Authority-Analysis: v=2.4 cv=DunDa2/+ c=1 sm=1 tr=0 ts=6ad892ac cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=7J84mRsLM548UZCnXY8A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfXwwL/mruRmrC0
 0BbotDTVKojcdTgIGS8JUCLmyL7vTsNKEpA4HEAqVzBUWK70u/DNJmYNpzPuhpofZnNZ0lGzmYK
 QLZpymkFUZjo73FzHk+NdzaoJb9l1+I=
X-Proofpoint-GUID: 00hR4sq9PpjuaAUJ5X-NxuDX-oUqqjQ3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDA0MSBTYWx0ZWRfXwwOFedKM64Lx
 /+m7FLiQG20pjtmqKifwRF4QImlkLwGJVsauirX9wRJDjJErsr3ALUaJJS5FYttwfmxMBqC+Ua0
 QSJSzLaPAK4pUR/h0fCWWijjFhoEMLig/cqutEoohCoCZOnPEdhIqeCV5oaboIO2gYyGMzbQ5Yi
 P5AFylkfCEI+e9fYx9x+Hts15ASqJLByJonEl81n40UvN8a+V2qt0DtFzIKilyLLoCblQmSlM+M
 IxI+EzC1pZ+ZVbHRkzxy4MKjob6mqIatywjy/7G1MELj0cZr3VTve9wtu1+cIxb5R6CbCYvh+gX
 5vTmL47ROqU6LQoWxxSHql0uVH8JaZfRpZBZHG+ywJO8pJ0BeGJUZ6VTbaiNYxJ0lhbmV+0ekib
 k7+loujhgnckTzryGJtsgOuGf2A6xXi2Tv8N/DIF7LOQ4qO/Z9aLgNm7EzHJUlVi2P+o3OTZ3jX
 s05Rce8hn0SM0v8kR9g==
X-Proofpoint-ORIG-GUID: 00hR4sq9PpjuaAUJ5X-NxuDX-oUqqjQ3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_03,2026-10-19_02,2025-10-01_01

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

