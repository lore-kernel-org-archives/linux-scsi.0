Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B7C1E570D;
	Sun,  7 Sep 2025 19:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757274044; cv=none; b=Fe3JMM5ZmhaPTf/W2BJmb0Bc6d/6j0CT/4mjZuSkRJBjTAPRjYILH71PMJoEOPVqmKSdCIopS5Ef4AXSZtC478u2pWv7DGgnEgqLBuvRH5cEMfyF/HJ0oz1Ol7w7Z5735r7zoTcUQMfXsw63Ww79rTmFB5YMhjYLVm4IZ+BLJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757274044; c=relaxed/simple;
	bh=foXEDvxRdYb1cqWJtE7ar5tn1II8p/JCdTJ/kw3hAZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uC/rGmPA9Azz8mL8hacKpOsEte9QBSWpOQZQLq+JheqPXZYtTO/KckC9GveKGEXvo9AGRtVmCGDcT7Dkk2G3LWtwqfuXjAmRj4jg78fWdzJZl2UXRf6Wi1JADkRIdm5wi8uksGm5UZXpAVJ1FtLcMrPzGiwu0XUS44WzVqzQHbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OhCOlstg; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OhCOlstg"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 587IP1dR006414;
	Sun, 7 Sep 2025 19:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=BPWd/FAbs+AjycjqLSDdyR8sdpYBr
	IgTonUOud8xsy8=; b=OhCOlstgy/Xcw7LKPZT9C2U+tyeM5AbNeO8qgqgoMVe9w
	fykWAq+ZK72tQl6H4lOx9g8Hb0oEwU0EiXfU5VX9nyjJvkLOtEyVlNTZzJQ2Xwna
	GKXk72PvcAUJ0Bxrpii9ijH3oLCYfCxpmrK3CzQxOZKZrJSTsuYIN+OKw4YuAkxV
	MJwD0dcyDszY8qeVQoWnymzCPsIADQtCYJX0APcKxPdspVXov7s0aBbxMA376v0x
	5iopHQFrqKuxNCR9UqEyrEUBs1gl0v4Q2F3wgw5prFakYsG5iQuueojHA2k1yynL
	TPHhpMMMRLQbeiJNxC0xVSjV7LaO2QUL+6GsVzunA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491f5e81fs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 Sep 2025 19:40:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 587F5FDh030242;
	Sun, 7 Sep 2025 19:40:28 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8ctk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 Sep 2025 19:40:28 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 587JeRT0002865;
	Sun, 7 Sep 2025 19:40:27 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bd8ctk1-1;
	Sun, 07 Sep 2025 19:40:27 +0000
From: Alok Tiwari <alok.a.tiwari@oracle.com>
To: mani@kernel.org, quic_cang@quicinc.com, quic_asutoshd@quicinc.com,
        peter.wang@mediatek.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: alok.a.tiwari@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] scsi: ufs: mcq: Fix memory allocation checks for SQE and CQE
Date: Sun,  7 Sep 2025 12:40:16 -0700
Message-ID: <20250907194025.3611607-1-alok.a.tiwari@oracle.com>
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
 definitions=2025-09-07_07,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=866 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509070204
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA3MDE4OSBTYWx0ZWRfX7eR5bETvhaMU
 EeDy4kr+hUqTLmQzRnMjhiWzIZ6mDNGsY7S79n07MaTjJXy+0BDTePjzC550Im4WHQvB7Jq8zTe
 Pr0CjnnohPMZ8hi53CMZksamPs8vbdXiGQHd5Oca3beslwU65+uLt3EfuP6DNCHXybXvwvsr+RA
 L+vij5sCOn0b7onWlxh+Y4X4vBcnAmZ/6/CezQPQ4f6sSSo1XZdH5EWEgsd7bMVPOnxfPrZHh1H
 HloWEm+H1UPWfoWfxYa3HnQymWgqCHuN3GMPIqNlkN/QKdVxdmheRPUOLYC91YLHlKSqI34ILL4
 2AzXSS1afXk3aRJc0tQVRj1g0Jv2u+Z7E5Soi9om6IM6ve0YS1O/+WWUsxtXuO0tUZV/tFVv8/X
 JDw8exNi
X-Authority-Analysis: v=2.4 cv=CqO/cm4D c=1 sm=1 tr=0 ts=68bddfad cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=hD80L64hAAAA:8 a=GesvECoXrJs119_16ZgA:9
X-Proofpoint-ORIG-GUID: A0C0WVHy9ZvQCPwA144Q-P8sIUUTmSOg
X-Proofpoint-GUID: A0C0WVHy9ZvQCPwA144Q-P8sIUUTmSOg

Previous checks incorrectly tested the DMA addresses (dma_handle)
for NULL. Since dma_alloc_coherent() returns the CPU (virtual)
address, the NULL check should be performed on the *_base_addr
pointer to correctly detect allocation failures.

Update the checks to validate sqe_base_addr and cqe_base_addr
instead of sqe_dma_addr and cqe_dma_addr.

Fixes: 4682abfae2eb ("scsi: ufs: core: mcq: Allocate memory for MCQ mode")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
---
v1 -> v2
rephrase commit message and added Reviewed-by Alim
---
 drivers/ufs/core/ufs-mcq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 1e50675772fe..cc88aaa106da 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -243,7 +243,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 		hwq->sqe_base_addr = dmam_alloc_coherent(hba->dev, utrdl_size,
 							 &hwq->sqe_dma_addr,
 							 GFP_KERNEL);
-		if (!hwq->sqe_dma_addr) {
+		if (!hwq->sqe_base_addr) {
 			dev_err(hba->dev, "SQE allocation failed\n");
 			return -ENOMEM;
 		}
@@ -252,7 +252,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 		hwq->cqe_base_addr = dmam_alloc_coherent(hba->dev, cqe_size,
 							 &hwq->cqe_dma_addr,
 							 GFP_KERNEL);
-		if (!hwq->cqe_dma_addr) {
+		if (!hwq->cqe_base_addr) {
 			dev_err(hba->dev, "CQE allocation failed\n");
 			return -ENOMEM;
 		}
-- 
2.50.1

