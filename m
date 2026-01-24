Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E835F21FF21;
	Sat, 24 Jan 2026 03:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769226820; cv=none; b=pndPHofWL/VWkuiiwFLnVEHwexiHJIvP8EkzZZjvN5bk/wIi1g4i7vdiKqI2myS4bV227CIKqE8PZSQw17xgpgH8VFZk7LBSIrSsLTmckGQJLhztiuc5DCSK11IgDmldAQuVpKTvcljXwIRs/qxjzr5xSHk1zqbTB/G6JJHb0sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769226820; c=relaxed/simple;
	bh=I+o9BX/d2ctAuwNXNZrEgHT5HARRlzxoitZu+mf1PIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GtUmLCXAr3aBLgsET2ZuEGUluhIdu1ID//zzSt0s7795TjNveDNKHcp7AaA4IdVvFnrPo91WFSfPLU5D1UCxfIvBjL1O7989We7/+dkH1CH3EIvJs43zrV1jXzTzdLqTAkzz9xPjRO0JgIXAHpRHcUrknr9sTbP1pXzJKgfxR1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H2i32+nx; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H2i32+nx"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O30S6p342768;
	Sat, 24 Jan 2026 03:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UTnRbbhfqB56bWwjF2sO5paDiKonankzp8U6fOUds8c=; b=
	H2i32+nxG2MUvWoHRTAV0Ejy4lUr7NFyj7LuCmogjhZH2ABD5QJC4TdpIxr1lNmm
	hJmNHjWx3A8SF4sBteHX2jgf0/UGUOVEFrFyfq1j86ltRRkh8/z+oErZx8Xr8WVx
	pCTOU7l2z7/51t/6ktAdS6oye3QW9xf38P5wtAGL6wYaizekYCoQF3w6RBfrgTS8
	AltlEZk1+h9hf4902bZCz4ry2Xg3yweVfTE2KGuim/ghRYneSmwRmcvmu/hfcwH8
	UzBbM4FqwBWlSA8i9Rt5vNXX7nbAhjRRLlaf+9qiwuR4GZBBpoaaCbAoK0E/0HbQ
	1rMRMNOxFbhB2wQxOs/buQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvmv2r1k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:53:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1Y9vH019829;
	Sat, 24 Jan 2026 03:53:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbak31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:53:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60O3rVib002545;
	Sat, 24 Jan 2026 03:53:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bvmhbak2d-3;
	Sat, 24 Jan 2026 03:53:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: ketan.mukadam@broadcom.com, James.Bottomley@HansenPartnership.com,
        jitendra.bhivare@broadcom.com, hare@suse.com,
        Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] scsi: be2iscsi: fix a memory leak in beiscsi_boot_get_sinfo()
Date: Fri, 23 Jan 2026 22:53:26 -0500
Message-ID: <176922663887.2974474.15556943791943692829.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn>
References: <20251213083643.301240-1-lihaoxiang@isrc.iscas.ac.cn>
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
 mlxlogscore=610 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240028
X-Proofpoint-ORIG-GUID: J_k1IJc2aDrWxSZXWoHLZhIGK-ceZ9pX
X-Proofpoint-GUID: J_k1IJc2aDrWxSZXWoHLZhIGK-ceZ9pX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNyBTYWx0ZWRfXxtcsONdBQWbl
 j21DtD9xNh2vy96pZ9ntDVTq36jfXHWO5YLkHN0HReqGVGs/rahEcbpzHlArcFKBLuQMtUAXeei
 zw62gPmfkagWY0kOnzo1dDMjZdXi4xtyaRDAVwCMXhLB/eiTjP9xCtUK50qSWLaF8jQ87QoyWm1
 GaHOLE/ddplK/yqGX1NhAgr1q9v4/KYW/N7voWkdZVQRxi1RNXfuiXVFaVDfXdfH30Fx8TaL152
 pQ98/Zrs0iiidCaRvZl5gM0UjR8xLc/rboAtPOxDmS8cbacR147ZnLwOyKkD21iM4sMB3zg5/2h
 bW/bqALPmoLygsUm7/5Uw7lQMH0Wv7AwHBPrU1liUqSUVp+6oF9eyZGlu++tQzqwhuvjvJ3DSAI
 4hdRjieqzk6ocQJNpoNUYFn3Q6JWdUG3tkdxlNiempgLw9fxRwxNkDgwbcMtw5LYxmUfABiNR7V
 Xj8EQ+RvZW2j7g225YkrmMArCfNV6gh8i2X7Y8lk=
X-Authority-Analysis: v=2.4 cv=cPLtc1eN c=1 sm=1 tr=0 ts=6974423d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=K_eg6-KxHybF2RbmVOcA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103

On Sat, 13 Dec 2025 16:36:43 +0800, Haoxiang Li wrote:

> If nonemb_cmd->va fails to be allocated, call free_mcc_wrb()
> to restore the impact caused by alloc_mcc_wrb().
> 
> 

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: be2iscsi: fix a memory leak in beiscsi_boot_get_sinfo()
      https://git.kernel.org/mkp/scsi/c/4747bafaa501

-- 
Martin K. Petersen
