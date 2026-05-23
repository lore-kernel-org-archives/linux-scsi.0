Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7618D3064B5;
	Sat, 23 May 2026 03:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506158; cv=none; b=IxrQcnEEbq2ERQbgZfB4twXAJ2eY+OlqTUpNwRy3dPGD5iV2wJv4SJ30mgwTopHH7r9jn9VKH99QiFdmBwakWUTp+62boekYXGxJEpIHWk0ft0LjuSj+wci0UaY38SCG9UA+4ouhMJ+tQeV4uNMx884DmpnlLzXk9g6wJTJZNco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506158; c=relaxed/simple;
	bh=6QdnE50gKD+tD0QjrDjYqrv+GzTNJTCVGiBEnMarYUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZDa0qqtCdViZGZpg4UBYx2LleMG5da8u36/lE1pi0Byf1CQoC7YLuNLG6b1TW672WNtSFeAGGVE2GIXPNzVzipDhxzTd7Qu4nV2XI9SDY1v+N8mJJqjDOQfbjgqZ08FF0k2QLN/yLUCnMHsYmpvQOZ9K0tUfaY88RnsGXyQCYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Bs4hWhIM; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bs4hWhIM"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N25WfF2306715;
	Sat, 23 May 2026 03:15:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ktEyyfLRRFdMxrVEwuRXgkrGd6j3WoLUViZhfjdpIzI=; b=
	Bs4hWhIMzslsm+RWhy+hphFROIoTOhhATkMRnqvyaqITdVIvhR9bJfYiYa8UYX77
	6GSACDcuiS3lu3uKJ8Io/MABzTlN3P76qgtOpvomfmpHvPUn2E7WtSl4Rxc7NgSc
	dae6MCdu7wps4FaEu6vo3InaL21uX4AAyqKiWjT5pH/0n9lqGtqLfxacPqySusUv
	UwDFXg7PWLxNAIF5UHY3ijDhHVQkiCmBzWsaSc7lIvdLAGfpryKtTfCIlouTtJj9
	IqeJRUGHuucnmw7QdtUHdoEE7PQuj9dBy2HL275QfxpUzQdmeMuUegSCf8pmZssZ
	mK4fg2/dtXqmVSFbAweEqA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb35904mf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F7ai032598;
	Sat, 23 May 2026 03:15:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:10 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9ds032824;
	Sat, 23 May 2026 03:15:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-1;
	Sat, 23 May 2026 03:15:09 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: avri.altman@wdc.com, bvanassche@acm.org, robh@kernel.org,
        krzk+dt@kernel.org, Alim Akhtar <alim.akhtar@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, sowon.na@samsung.com,
        peter.griffin@linaro.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: (subset) [PATCH v2 0/4] add ufs support for Exynosautov920 SoC
Date: Fri, 22 May 2026 23:14:15 -0400
Message-ID: <177913641756.1181900.3954359823694090087.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260417121452.827054-1-alim.akhtar@samsung.com>
References: <CGME20260417115813epcas5p40234b872c221ce28981b17e42ca48139@epcas5p4.samsung.com> <20260417121452.827054-1-alim.akhtar@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfXyFX+vTF4Zt7F
 18aqXksxvYMFfeQCkjwTt4Mlpg/XYFyGL0L5m/TCFSryNhK1EXwpVpmsdUtH7kO9dgvokGiZHAb
 vIrX1sEtmS9IZxBAKSkWqch24Qd2cH9iNlacmlSQ69mEjRKAX1OQuTN/9kGnplx1jDcWPPs/gBY
 PYLV3MsxTIboJN7tARSbW0g2IT6rnLreR+/JU9+S/qyGhAlbVSNU+WmOJe3e2cu3r+tfGoiymbc
 T0OVsm9u5nsfCCC1Lje5gUcwEM06YXO8/WzcAap3uKE2d5dBampn2l15L+RSykJxBIqvKx3COaS
 tJvHv3rOuay09xSVKZfZolpNsDTV40rAMclpJoqaLXQjTy4opq+O/drHlGXQz0n7rprZs8/azFf
 j6kZp37LmcMNgHBBuCQyNR7jzAnAqlu+rsXxRz5H03zrgdyn0zdrKw3SzP2Vm/H/jkAydS/00xb
 +3tKnqom5140bel3Cwg==
X-Proofpoint-GUID: QrLFBChcJdRLJx10MBLFfMdrcPYcSPO9
X-Proofpoint-ORIG-GUID: QrLFBChcJdRLJx10MBLFfMdrcPYcSPO9
X-Authority-Analysis: v=2.4 cv=TJJ1jVla c=1 sm=1 tr=0 ts=6a111bbf cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=UCUsExACdNoqk4LCDqkA:9 a=QEXdDO2ut3YA:10

On Fri, 17 Apr 2026 17:44:48 +0530, Alim Akhtar wrote:

> This series adds ufs driver support for ExynosAutov920,
> ExynosAutov920 has the UFSHCI 3.1 compliant UFS controller.
> 
> ExynosAutov920 has a different mask of UFS sharability from ExynosAutov9,
> so this series provide flexible parameter for the mask.
> 
> With this series applied, UFS is functional and basic I/O operations are
> known to be working.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[2/4] dt-bindings: ufs: exynos: add ExynosAutov920 compatible string
      https://git.kernel.org/mkp/scsi/c/45c9dee6d653
[3/4] scsi: ufs: exynos: add support for ExynosAutov920 SoC
      https://git.kernel.org/mkp/scsi/c/50349bd5d0ab

-- 
Martin K. Petersen
