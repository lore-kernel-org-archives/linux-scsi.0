Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0A11D88D0;
	Sun,  7 Sep 2025 20:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276886; cv=none; b=XYvlGKNQ/9DsCy/XZIJUA6qOkIQ8TalF2DS/hU+18XYdXb4g1RQT6PStesaDJbLyhl7K/Dt2R38yxqZ9ntxf4NJR0gjxOW3SlX30dVG4Q8gyjAEpVKyk5UPd7Mi3kVuRDtndET5bNpYAERnNqUO65NWI9Bd9k0XjHNF849Jbkvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276886; c=relaxed/simple;
	bh=8TQkgCKty2YVfN+St0YaHga2YrJ1lTbBbncd93Mr0OA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ILn51lwf+V1iQ8qPQqpacVBSIllkOTyQd8wgYcXg1pYlqoq+8IdmYztwamf06TnyGGuQMGEqmr+O7/BZS/f5OQ9LGHodtYucxvaCNP2P3KC2OYwvbqNLIL1bjnkSMK7CBE376HZGrc8foV55N1z0PGeNLL+W563JvGEeaKHirAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SDa86pr5; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SDa86pr5"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 587JQfDe002038;
	Sun, 7 Sep 2025 20:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=nmDlQERdSOXnir4NGhI1dR5qcwx02
	qQwlCj5SprR4PM=; b=SDa86pr5p08rwjFbqFrEiUUEBBMoeG8BEb744iL7RK99n
	6DDpkFz3Dpd89nGiidlhlSginJuhssWO8qQg43FeIf/Qkn6ktRDbsJksT8AJYeNs
	srBu0SgYq6badZ910cDVt3Ovkjz69UL9dSCAc7tlLJP118x4L11LAsfgQ4Vy0PGl
	jlzz5+NFKcjdD+sD8/4+Notrh7K2adkakT1VUMG5HzYPQuzVg0pXojaeo678mSX3
	aGRrhtYyPgqTrM7xIql+5FbE48HE8TksTtNJF2v+hzw3onxX9m9yKly+ty0E9nky
	jXE6gTkGOCKlh6ORs5y/Wi4NkGV7IcqhvLE9WxP4A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491fnug1nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 Sep 2025 20:27:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 587H3mNL025916;
	Sun, 7 Sep 2025 20:27:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd7d581-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 Sep 2025 20:27:55 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 587KRtUA017327;
	Sun, 7 Sep 2025 20:27:55 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 490bd7d57v-1;
	Sun, 07 Sep 2025 20:27:55 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: alim.akhtar@samsung.com, krzk@kernel.org, peter.griffin@linaro.org,
        martin.petersen@oracle.com, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: exynos: correct sync pattern mask timing comment
Date: Sun,  7 Sep 2025 13:27:49 -0700
Message-ID: <20250907202752.3613183-1-alok.a.tiwari@oracle.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-07_08,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509070212
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA3MDE5NiBTYWx0ZWRfXwal4JroHskso
 IM9j+47Jpo4He0948KKf4t46KtJc66BNgZ0rtqIfB/XOxmEJWAvTO4cz1lIphAKfie5DXkXA3GS
 P5iLSH/eF89HYcnjwWNU1qZPmQd4d6ndeQbDQdr5SOwiu4RpRwMY1eVWNe3Z/lPq7O721itIu9w
 X4S/iwDavIbe398v4N2nj9aJhziBc49lzwPmoNRdL4JsFHGOz9f5j+58HyZCPWN0dHTDPj4rH0l
 sd7mAt7mDwpXefYQ2H+ZgEgokZbsNI34GL1Nmt10D6bVv+6q3Kb2iTNNKoK2sqeeC1xaFdmvkrm
 fO1z+fI2VyydGN3evUDhIzpf0EbKBh2UOVdfnU4Nw8R+rY74TufV5TIjn4lPJGSNvYdebwI1IDN
 JzqFz6j0r1QoVuh8bkeKh0lWQU7eLw==
X-Proofpoint-GUID: h9X0dUTol4snrS75rdOUG_br4sshWGXU
X-Proofpoint-ORIG-GUID: h9X0dUTol4snrS75rdOUG_br4sshWGXU
X-Authority-Analysis: v=2.4 cv=LdI86ifi c=1 sm=1 tr=0 ts=68bdeacc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=xlVCHxDqw-qt9YOnf0sA:9 cc=ntf
 awl=host:13602

Fix the comment for SYNC_LEN_G2 in exynos_ufs_config_sync_pattern_mask().
The actual value is 40us, not 44us, matching the configured mask timing.
This change improves code clarity and avoids potential confusion for
readers and maintainers.

No functional changes.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
---
 drivers/ufs/host/ufs-exynos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 513cbcfa10ac..70d195179eba 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -776,7 +776,7 @@ static void exynos_ufs_config_sync_pattern_mask(struct exynos_ufs *ufs,
 	u32 mask, sync_len;
 	enum {
 		SYNC_LEN_G1 = 80 * 1000, /* 80us */
-		SYNC_LEN_G2 = 40 * 1000, /* 44us */
+		SYNC_LEN_G2 = 40 * 1000, /* 40us */
 		SYNC_LEN_G3 = 20 * 1000, /* 20us */
 	};
 	int i;
-- 
2.50.1

