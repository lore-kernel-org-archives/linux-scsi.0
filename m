Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77175263899;
	Sat, 24 Jan 2026 03:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769226821; cv=none; b=msNlfsZUjkf1y3zgxx1KqlkQp6Anc0ZsSkCPdSVwDP9q9+Z5xyblNt9F3cAjR2Tfq4+LYsIxM4Nv9hniSUcJQhG5RZeTuHh71s0FtK/4lgbKS9GnTFa6p98b6CwaeTJRrRnXBaIWNTAH6L+Yspb+Nmx8X3aDjIChHuXHpxImbTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769226821; c=relaxed/simple;
	bh=DDqb3VFBx+NAo9HDB1a3tnAbM4UB3cb3AQTeGZr7YvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V7fiQgsav+ujbPWjE4xwKEW4H6DtbA4YKVPHkyw7XhaA7YgtsUsj29fNRFRHKf/nelcW5f0Q812L17Q87NxGXwTpi1BfAiebm5BZ7paSpwyIQZ3/4NeMT37g9imS5SICKBrIiInxz1Evib+7J+r/7jwjtEQOKBkFjMZlw1Ws4c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q1G+kYO4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q1G+kYO4"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O3U2SD4083928;
	Sat, 24 Jan 2026 03:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5ZNPuohN7yq/ZawOV8Y6RTBcfZmKK9ckaD0ypecRuzI=; b=
	q1G+kYO4q08EckUn2q8wAgLaUffIeYNzdw5vaSULJ4JtvE0Rxw26B9OMA/SbvofW
	tJFZUKVPysfwbb7hq7IxxldsKFvl+1IK5owU8kToR2i6NNDWXEiFtPvaoqng5EtJ
	2A8zetI9xAuMeh9zcBk8w9o59L1ndJgqVhiNRrkydYQY4LTocG0CqsueAjZORR9h
	L1CflYAxMeeT+qyV22jAgfidMMZbxU4um489vDR87mrQ8PY5I2y0DS/1Z9UlO/81
	8uEwyYheSZI309NGBaPMhdtomLh0wGNeiDb+u6+gGWE7yyySZ/oE9YEfOCPxhbZc
	RqnGDEc9xo8jRGBVuQ+tEw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmny01tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:53:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1Y6C2019774;
	Sat, 24 Jan 2026 03:53:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbak2t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:53:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60O3rViZ002545;
	Sat, 24 Jan 2026 03:53:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bvmhbak2d-2;
	Sat, 24 Jan 2026 03:53:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Duane Grigsby <duane.grigsby@marvell.com>,
        Hannes Reinecke <hare@suse.de>, Quinn Tran <qutran@marvell.com>,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: edif: Fix dma_free_coherent() size
Date: Fri, 23 Jan 2026 22:53:25 -0500
Message-ID: <176922663884.2974474.13177551100354910864.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260112134326.55466-2-fourier.thomas@gmail.com>
References: <20260112134326.55466-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=615 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240028
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNyBTYWx0ZWRfXy5wKHJdcEBS+
 WgiOk0GFIpl0yyGAVTa3vv2G5f+sVpHrCzNKHP9un9fMhuDftpBfusuKRAXGUS6+AsIq3N8jFUZ
 DU2sS3YSMFUenOPNyWov0tCKc5yoGt0jD2s71pnLz/7uuqOJT8JzUtMvD+WXnJoMGV/FCbADPSO
 bHhcgOSklqByehTHGo+59tucTX1p1xt0x0+AMmjfuVhyW0iuYaad9ecQuxjDKVNsWrJsoV2d3WY
 d/yxP3swxDFApkhnkJYoM1+XBOsaZ+c464h8WhQpYu08EE9Lb2qSFADROwtK9eE6acUlUyGJ3hd
 o7cJamBSnzIXgNLvZDgqCXNk2F7QcBlcgkr2wncnDtEAME4vnoMowD0/pvk/L4X/qvAMdN055dQ
 qrEUF8Ky+SJmJyx45l48x9THs0sICx01yJKPJ/PEZpxwoNnnT5wlOFYCX94bG68tWkQN/l1iG+F
 bt3cLZFRe72IQsbvExj7Fr8ZU2YBJ/8krzGJtPII=
X-Proofpoint-GUID: wenFQXKhAOD3VM-PLn4BwAxl6jr45QJN
X-Authority-Analysis: v=2.4 cv=cZrfb3DM c=1 sm=1 tr=0 ts=6974423d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=MSVSoqF83TM57_kvayMA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-ORIG-GUID: wenFQXKhAOD3VM-PLn4BwAxl6jr45QJN

On Mon, 12 Jan 2026 14:43:24 +0100, Thomas Fourier wrote:

> Earlier in the function, the ha->flt buffer is allocated with size
> sizeof(struct qla_flt_header) + FLT_REGIONS_SIZE but freed in the error
> path with size SFP_DEV_SIZE.
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: edif: Fix dma_free_coherent() size
      https://git.kernel.org/mkp/scsi/c/56bd3c0f749f

-- 
Martin K. Petersen
