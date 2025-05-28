Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815C31C7009;
	Wed, 28 May 2025 02:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748398868; cv=none; b=j/5ohVFI/4OBcb884gNUh0Cc1KRaj6bSB41uUJGEdYmgJpXbuJxLiF51CJhZ1VhtpofGc0z8O6CiTPbGD6QQsqHWk1BXVhJ82O3ctdjbLTub9ec48HQJEt5MQ8sfgTNPGPJzwdZgrNrEq5E2AXaJW3Np5sQ+jr9ln/Lku+VahC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748398868; c=relaxed/simple;
	bh=Ak5Hz7ySwoawTAB9jnr+deRsUO/+LzLPe7lJ/WbDhSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ndc08cLEeX9VKTWUe5Ip3mGkwrs4kBpTf3XLd9Mmi8NKofzmwB6W8SccZCZKiGQLRKqH0T0ZX4YstP/wtaqraNdXj78iB34+I/vZ1kxXtioYeUiTb4e+ZJtRZPrkRjlAQRQuK9KAn2MGYCReCRMJiaUgg40sw3zYk+1/xYpJ3tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jUKiUvf1; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jUKiUvf1"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1fxcY004057;
	Wed, 28 May 2025 02:20:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1amKNhQJSWBSRK2RUnPymTAPohi2bmMw2/ZZRthPgXc=; b=
	jUKiUvf1D1LEFLONPGIaKoABWFoeFPRWKGO4q9G3jt+0dkXZev5bMaV4Kx7YpsI2
	SG6HvpfAUfymxOcRnwxGBRUNWfnFT5ZENM6ubpsLdOHig9wse9Lr9vfyDRrbs59k
	05P3/R+jlVpvPP2gsknQWj7l7c6geiirIMOTiEbZiwRFq1Rfyedpa1vT59eGhl3u
	NSbEL8mefRfGcYZ1oVwg27FP3XDTcDJToJm2SVA0eary/5HxdqMZ5kvkXhBmxVt8
	V8kPO/ojYZNGhSeTts0NdTRc8y3j92Kdy7Y4o2139NFJTAlB/jqyz03s+tNZPNyj
	8SlC7ARgRoxC/YPBTuu7qw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46v21s4t0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54RNuYDP021151;
	Wed, 28 May 2025 02:20:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jgb221-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:53 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54S2Kq14017834;
	Wed, 28 May 2025 02:20:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46u4jgb21n-3;
	Wed, 28 May 2025 02:20:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, prime.zeng@hisilicon.com
Subject: Re: [PATCH] scsi: hisi_sas: Fix warning detected by sparse
Date: Tue, 27 May 2025 22:20:17 -0400
Message-ID: <174839736818.456135.15596308203178922163.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250515013504.3234016-1-liyihang9@huawei.com>
References: <20250515013504.3234016-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_01,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=843 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505280019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAxOSBTYWx0ZWRfX0g25MXLKo4Hh bPtosbPkaFQ6wlWt3P7j/f5GlBZP4fdVP3i0BS56vjuYh/f8jlKHnwwD7o2XTz50r8hDorZ5Mny cZ0xpWkKfLNFhdYRRrboq+zMLPq+ZAzURXErGRUlszW6xaM/gF7bI4rXc1aM2+E8RfrJE/fwnvQ
 IKOFbqWkT0zGQdrRaNEzqRgyCI8AFapzENPtkf+M6m/oq0Pi5cmQ38b+8ajwS/wekBzn4KAVmvu YG9lK1EZSS6fnu1brW0oTc/dXUdxB04geB+kijR51/UY3+NpnLx07yhcVhNLrSmthPrivFNTlGN 16EKNAkJUmvRNz1jqGyphqkBYk1wZjfrCrjGqCmRXr/288nlhwTvhMpJ0R1973ZPnpLUn1fEbJ0
 h3flCNwSjHYDZnXPeqqVrrT//VbwxQy/2rzW3FbI3pTcVchcQ3aasjRdS5Dmc5Cdgr+pap/S
X-Proofpoint-GUID: w5BjhZewdKcN3_NaqcLiFeQB1zmuXNXo
X-Authority-Analysis: v=2.4 cv=UvhjN/wB c=1 sm=1 tr=0 ts=68367306 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=iokzIp5D8f8EORS-6NQA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: w5BjhZewdKcN3_NaqcLiFeQB1zmuXNXo

On Thu, 15 May 2025 09:35:04 +0800, Yihang Li wrote:

> LKP reports below warning when building for RISC-V with randconfig
> configuration.
> 
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4554:25: sparse:
> sparse: incorrect type in argument 4 (different base types)
> @@     expected restricted __le32 [usertype] *[assigned] ptr
> @@     got unsigned int * @@
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: hisi_sas: Fix warning detected by sparse
      https://git.kernel.org/mkp/scsi/c/0c52f621f5be

-- 
Martin K. Petersen	Oracle Linux Engineering
