Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA53514A8E;
	Tue, 21 May 2024 02:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716258682; cv=none; b=KksRJy8GMVuRZIa2PHutQIJFVvadcOIHgZG8h7m3F/Og6y+7Dh5+i9ymB/aQzYIGJGWorEETXlSYGftpeQEMttDjli25VJbbeuYxq95Qls8PmATYjEXDxT3boRsONmux4+a8ezRxj/BNlDeILqi4qQx5VZUGoYix+oaa2pD/WsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716258682; c=relaxed/simple;
	bh=ZSX+wvOF3eqvyPaF2POW7kz2n72QyRVioknBx/xaoiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YK1w1DEVfrGTuC0UyL2DrcIIRvR5USlhWP/8UrCpKS58p7PAQcdjt2ekAyh2hnGwm5aN0m+nQY33eEGYAKC7qljWP85TGqAmKPLP+Nny1C+sli1yBW7RDBGWwnZ7wnf4jv8cEekdEVC1Z72FaZZBnkbJ3nRz/dHB/V/8VhysfOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mLbiSGXT; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mLbiSGXT"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KN0AcU006153;
	Tue, 21 May 2024 02:31:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-11-20;
 bh=jztGpo4CZLNydWCIM3JweZ/8H1o+ivOHncHsXRiVk8s=;
 b=mLbiSGXTjkxm2GQ6wG9WstJbvS7ms2YNYNhjlGtke+3bv8AKuvwrgK/Tsjez/O/tNfmJ
 NeCT8bcMNSh03AUM5+6KS32oCcdDKRHI/Qyd2nhGQ2yRyPUTXMqQr3dymuP7u+uMEDpU
 JOhNlalTnaQ7Vgk3ehyoe1UwjICcSmD1gBB5Lzz2f/AnmhtbVLob/4KgKiyPYPGF/5SS
 ZNNbBCnE/xXWafnbtxw4s2jBQ9n2FPchv0Z0JI01Y09wJgYoZkeucPLbKRHB4vHMwdNs
 lR7/qZtlGn0Czac1/gznL92YEg6HSDoKeNuZvp7r5lQgI6GQwwFUfXJ0tf7vGfaqpHdX Eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2bxyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:31:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44L02LEX035965;
	Tue, 21 May 2024 02:31:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js7320u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:31:16 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44L2UmN5040510;
	Tue, 21 May 2024 02:31:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y6js7320g-1;
	Tue, 21 May 2024 02:31:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org,
        Peter Schneider <pschneider1968@googlemail.com>
Subject: [PATCH] scsi: core: Handle devices which return an unusually large VPD page count
Date: Mon, 20 May 2024 22:30:40 -0400
Message-ID: <20240521023040.2703884-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
References: <eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_01,2024-05-17_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405210019
X-Proofpoint-GUID: BM5harIC2eKaN6T2WUWdoOB8o2M1LlUw
X-Proofpoint-ORIG-GUID: BM5harIC2eKaN6T2WUWdoOB8o2M1LlUw

Peter Schneider reported that a system would no longer boot after
updating to 6.8.4.  Peter bisected the issue and identified commit
b5fc07a5fb56 ("scsi: core: Consult supported VPD page list prior to
fetching page") as being the culprit.

Turns out the enclosure device in Peter's system reports a byteswapped
page length for VPD page 0. It reports "02 00" as page length instead
of "00 02". This causes us to attempt to access 516 bytes (page length
+ header) of information despite only 2 pages being present.

Limit the page search scope to the size of our VPD buffer to guard
against devices returning a larger page count than requested.

Cc: stable@vger.kernel.org
Reported-by: Peter Schneider <pschneider1968@googlemail.com>
Tested-by: Peter Schneider <pschneider1968@googlemail.com>
Fixes: b5fc07a5fb56 ("scsi: core: Consult supported VPD page list prior to fetching page")
Link: https://lore.kernel.org/all/eec6ebbf-061b-4a7b-96dc-ea748aa4d035@googlemail.com/
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/scsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3e0c0381277a..f0464db3f9de 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -350,6 +350,13 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 		if (result < SCSI_VPD_HEADER_SIZE)
 			return 0;
 
+		if (result > sizeof(vpd)) {
+			dev_warn_once(&sdev->sdev_gendev,
+				      "%s: long VPD page 0 length: %d bytes\n",
+				      __func__, result);
+			result = sizeof(vpd);
+		}
+
 		result -= SCSI_VPD_HEADER_SIZE;
 		if (!memchr(&vpd[SCSI_VPD_HEADER_SIZE], page, result))
 			return 0;
-- 
2.44.0

