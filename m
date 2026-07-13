Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393D730E85B;
	Mon, 13 Jul 2026 02:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910037; cv=none; b=ZGsY/MyrdWHdrAZ0xjPVwMJukw1hWznZS3mQKnLzSHPiPwXaP/BI0TE/HlnFrai3a8zuY5y8x2IZUzqIBn5PjodIdKDtuDRbv7gjzrw0Q12JnjXPqoCFEwbO+cFGXY6zwS7WRBYc+ecCr8OCw4Ym7+5hpwCj7OhLa2EmTCO0vmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910037; c=relaxed/simple;
	bh=jscg61bydUqM6wfltNVbpf5AxIonxBvFfhZirBzcZX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjhFZEuSnel5likxwyLo4vc0CTC/MTrtfjsm/n9sNc7kB1gGHQ7zBvcFNUXl7dNoBLLr4wKVO3mfMy2Bprhlw0ntSGPWpgK1ETUs0FDGWky+zhiUayYk7bMw68lBUwmhsNe11JZvo3Vjn11E1sEgl2D26bDWuZzAGvNt7a1HMoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gvaHL6Y3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gvaHL6Y3"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66CNLBue074633;
	Mon, 13 Jul 2026 02:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JNrsmax3B2njcPmxIOmnTOdMWLtpd//Nu5/E7TuksVk=; b=
	gvaHL6Y3IvIP5Svb4K2/k21cz1jMaOTxG2F5wkDPjrTzi60TlhmLnKhsSq3OEtUG
	8NaNrJGUWVlX+M8zu6GJGBaGVIKSuPFALTCYTdnCDVr5L1spDH+jgEfSWpn53d+k
	n0mYseV0Z0OxsapdeQ5jtdVNzkJU2jaT8Pu8jQhzF8/irwo7CWoS2QIP7nvwCQQ/
	aqst/Py+QIbf7WZrguzfNamHH17oPS8s26Ra3EJT2D5uuecx2Hv9pirbwluIUnY4
	1U0qfkk2VSGCqASbeigeBAI86I6Zew8eHHa8VfiiLCKryv4ScX7b5BxOMvDjC6jC
	YgJDO9coMzVy8k1cQqJRzw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbeedhcke-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66D2XUQO029106;
	Mon, 13 Jul 2026 02:33:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fssuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:35 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66D2O0cp010878;
	Mon, 13 Jul 2026 02:33:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fbc9fssh6-4;
	Mon, 13 Jul 2026 02:33:35 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: justin.tee@broadcom.com, Abdun Nihaal <nihaal@cse.iitm.ac.in>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, paul.ely@broadcom.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Sun, 12 Jul 2026 22:32:35 -0400
Message-ID: <178390967061.3399387.10575322287465735663.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707065304.949135-1-nihaal@cse.iitm.ac.in>
References: <20260707065304.949135-1-nihaal@cse.iitm.ac.in>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_08,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=504 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130023
X-Authority-Analysis: v=2.4 cv=d+bFDxjE c=1 sm=1 tr=0 ts=6a544e80 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=28YL1Oed_R0FaK7JHa8A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX6fsJdTBQrZWN
 sHW8n7U2AEk2KrEejuUjthZsfWAwlAitA6DcH4TceKidZOKF4p3EVfhieS/ZOUpzmzOzbTLx+de
 Ec+q5ImKjk6XESbgp16TniKfgFyrhVO5A1nnRCINNFrcA0pVAAP4AfkoREOEBeNgsyMjHIivdUP
 5zgAqBZqSvJ7n7LLQgSZw/LdzM/NSjoW7kN3dyUTzKzFb7EN6CSWrUI2Ows8kWvuKrGVrcbaA3a
 iL2O6p9Sa7FetYBlBc0Px7TMqqH9yzwc7rKy+lKHAYmvt23nw0olFPL70GWhw9LfoXZDy+LqjnC
 l6R9cX/od2OO9Z/mcgBgVOf05/mtdqNPavHhd//XsUd+MdF8NSWc7hWeQ/JJs9umWx61PKEgbiT
 ZCVeFcDzSEe/pIW4+qSWIqS/tbQwPLqyLpd2rOOuGIbqHYVTQszwjE6A5hDT/0G8oeKamRWg7H1
 19/b4nbMwicmyzju2dTXmrdvo55nyAMKxBvkX4mo=
X-Proofpoint-GUID: sXOcxODMJvVTFwPOufvrxQC7-l9_2D-W
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX0UEmzsuPtndl
 SgIkMzTRV0AyZAmv7ZaWvPWGmIY0P6zhxnIr4ep1lRcf9ddxFzirSRepjcG9QW3pOhyBcGQdA62
 IZ9r2AZtTS+Sd9JVUPiNE22TT3DPu8D/GZPPsE8UBFT16iEU9e00
X-Proofpoint-ORIG-GUID: sXOcxODMJvVTFwPOufvrxQC7-l9_2D-W

On Tue, 07 Jul 2026 12:23:02 +0530, Abdun Nihaal wrote:

> The memory allocated for mboxq using mempool_alloc() is not freed in
> some of the early exit error paths. Fix that by moving the
> mempool_free() call to an earlier point after last use.
> 
> 

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
      https://git.kernel.org/mkp/scsi/c/1bd28625e25b

-- 
Martin K. Petersen
