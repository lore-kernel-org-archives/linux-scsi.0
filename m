Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517EC33FE36;
	Mon, 13 Jul 2026 02:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910042; cv=none; b=MnW/Ci7t2zhQyuqA1U7GSO//YFO6WO2S9/l5vo+R43/nEwko64RtYFkwWgOxAZgBKggZzIhFErxqIEpAFa7Xgj2KJ1J3T//miRSkNWYXP4AkXrC6JS9l2zRrPqGKSBaUY253sPXzVAswbLtloeRB4wbbum40hFNDT74nqoezGuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910042; c=relaxed/simple;
	bh=i7l+DsE3M7lkgTed6tv3JgCKekBu13I5A6hykWR1PbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m0O3OWkvZ3JvvwgoXnenUEhDEN/CHA8+QvDPqqtiF6NlHEea2ByEcRLFbrqRIHLQ0/BxLZTv65dAZB9FMttKzwAEa+XeTohDsGTrUcy7hW3ay85P8K/M0iAO7HVAJk82LRLEURpYqcy4QeS/BYpJt2Pxeais4MMfilA/xdlPhSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XhR54rmR; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XhR54rmR"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D0VAaK203497;
	Mon, 13 Jul 2026 02:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ov1F8iDEXh9YsyR4wr8EG+X7y6VZUh7FlWItDqgUS4U=; b=
	XhR54rmRHf6s/61f2aE1TAWYaGek0F4HD6olSTktla2oguDmTzaTRXIzf/qXn4/A
	FgDv9QGe6ZSGqljugJLEUrtbbofiAbYSR9y7KIbOcCljb5vtg5+YZNXdcETA6OH8
	u21eQKiCCdxlTP9fputEgAm3SeDehVOlHDXQS84K2Fzgj+YqJkJ38/XL7UaO3kXR
	fUltxaIX3Tc7XujZyx7l6+tt5wodgIw60I8LbTZkeGx9dvVfggcOMviHSBFTynhq
	iUT6HfQZ0+GG7Ct+qKxd1DopkKxPswjSQov08pKSNDtrG0s385JPcIlJPcmrCcSx
	WVC77h2OdSAc5LFTau23KA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbef0sc9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66D2XV7H029146;
	Mon, 13 Jul 2026 02:33:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fssu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:34 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66D2O0cl010878;
	Mon, 13 Jul 2026 02:33:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fbc9fssh6-2;
	Mon, 13 Jul 2026 02:33:34 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: ram.vegesna@broadcom.com, James.Bottomley@HansenPartnership.com,
        dwagner@suse.de, jsmart2021@gmail.com, hare@suse.de,
        Haoxiang Li <haoxiang_li2024@163.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: Fix IO leak on unsupported additional CDB
Date: Sun, 12 Jul 2026 22:32:33 -0400
Message-ID: <178390967066.3399387.5180904413460605455.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260622075844.832871-1-haoxiang_li2024@163.com>
References: <20260622075844.832871-1-haoxiang_li2024@163.com>
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
 mlxscore=0 mlxlogscore=683 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130023
X-Proofpoint-GUID: H_cEIjWXIKY--MicIh_ozXo_8c60mClC
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX41bKZXT2UUYM
 pghNahsJvYG4KJoeoOlFl4nNc9jQFE04qp/ACrJc2MLVI0bN02ozLurjw0hQvFf/fZduNoHaqs7
 gKpZ5kSbB174lR7qYtP6NROMtlu7CN+VNaaOLnuRY698yUwRUHAX
X-Authority-Analysis: v=2.4 cv=KJZqylFo c=1 sm=1 tr=0 ts=6a544e80 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=J1HK1kQR0btAqx97QA0A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfXzb3DON21cNR1
 f2RZfOc8SYjRUKrU2BPkETUzKhrdJi9zELp9cRK+KmLpY8EW5DvzbDflHJi8NhSnYeJhjKcFJ9x
 N0ef77Ayus3r8UywNNOCAQFgMkOoxa50zZO2f3kF/kWBS1ggZR8grfZAA88n5rLZ+99s5KBqko8
 +Rec9tpGSOu4Pe1Ahnw/uEuyrB3OctbAGiGWtRVNk64HegYgvS5yr08JP/6dXDTjsr+CyeVZk7k
 LHy3Hq6Kw7AxzOGrVkzDZmTBg4I0ZPNOZpNwkULMHQiaD+liZSGtBV952+6a7PUfFc1TkyWCJtp
 S9a0dq74qsp2D6Xl/YXmFCsgMKg9PB0Mm5BoiEOijW7G4XsSRQpC161ZsIZUMWljab+bUkKaAQS
 N/eXadjIch3lAFvCPWo1UehbRyRIm+gI5An30RGFG3gMi5DVNf7bfp/JzuXFynfUfp3JOs6IZof
 TBuXgn+ADMPECXLn6F7nFjIwzKhE7p8VzcbdIbBo=
X-Proofpoint-ORIG-GUID: H_cEIjWXIKY--MicIh_ozXo_8c60mClC

On Mon, 22 Jun 2026 15:58:44 +0800, Haoxiang Li wrote:

> efct_dispatch_fcp_cmd() allocates an efct_io before dispatching an
> unsolicited FCP command. If the command has an unsupported additional
> CDB, the function returns -EIO before handing the IO to the SCSI layer.
> 
> Free the allocated IO before returning from this error path.
> 
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: elx: efct: Fix IO leak on unsupported additional CDB
      https://git.kernel.org/mkp/scsi/c/9cb2d5291dbf

-- 
Martin K. Petersen
