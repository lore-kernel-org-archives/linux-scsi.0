Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3FE2459C9;
	Mon, 16 Mar 2026 01:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625315; cv=none; b=IBepawFqq/NIJ4iZJzib8fmf0cwXxl01Dgn2ede2ycMNDU3LDyGi7AwpsVDnRROXUxsHCOn4pUxB4WAYFMTudgGrXKLu45XvAp4L9LTpXzKCn6rGVCaFfHlcBA+KitxsX3ZuD6RccEV3GFKQriZHksqpwCEnYuiP9gE84IBWYdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625315; c=relaxed/simple;
	bh=y7tclLjDWkYWEPx6oIfqnfKUe+3VOHmHEQZ7AwGuA2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g57nOxeTKYQB3xrYEkwkpSW5+VwZaj6v4C3Eoy/vjB31YbB0UlBm8f2+2yqsYV4Oxpct/XG8lNEUvKkSnUGuLEJwe9FzHztVAfLcCu9WePbQLScpxB6xyYdXL2v+dDvoXUO/LcH7cvgzKpQzV4q1QjadiQwjMJ4Kr7+NOjbA8B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B4Ylz9dn; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B4Ylz9dn"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0dAPo1910558;
	Mon, 16 Mar 2026 01:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zDzVy1xNv++WhA1zmgvHcn0JamB8JOaqfCsCgbHoT44=; b=
	B4Ylz9dn+ruxdm9luBptU/vnfWR3fULsU6Rb7VAjZk2CQTnTu+dP+nD8M7mOqlnU
	7/cWRhMTzmlXjWSNUoVyI94Y82EDWD6nb64zlPR5C/bDZIsNuI/00BRCkJcfrKUS
	PaEy2+cGO4QmLD96H0kdO+3aHZ66Iz6OONma242BfQObBSzGAowBSnUS9qsVFI+e
	xN8P2IzHnFDCb/06x4/YvPaSCNtuurGzoNiLN6Uzx+XUKPUBJyg+oyhuIIw+SAwD
	1DM9H9CxfmDiXuK4lPloC71IklRE+Sf8+qxW87IYWGeV3SkiSLO99v4gE87XRgAq
	5wcIvH4p1k4dFcS0jFZxSg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvxf41bgr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62G0mbxh002900;
	Mon, 16 Mar 2026 01:41:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j86nt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:36 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62G1fXhb032070;
	Mon, 16 Mar 2026 01:41:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4j86mp-9;
	Mon, 16 Mar 2026 01:41:36 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, dlemoal@kernel.org,
        bvanassche@acm.org, hch@infradead.org, Chaohai Chen <wdhh6@aliyun.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] scsi: core: Drop using the host_lock to protect async_scan race condition
Date: Sun, 15 Mar 2026 21:41:28 -0400
Message-ID: <177362524465.2599440.17953436562715540427.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305025125.3649517-1-wdhh6@aliyun.com>
References: <20260305025125.3649517-1-wdhh6@aliyun.com>
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
 definitions=2026-03-16_01,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160011
X-Authority-Analysis: v=2.4 cv=ftrRpV4f c=1 sm=1 tr=0 ts=69b75fd1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=zzhHhKhwZC4IQR6QcDYA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12271
X-Proofpoint-GUID: fuXwdEeqY7WuPOlruJ-jfHVUvHDJAya4
X-Proofpoint-ORIG-GUID: fuXwdEeqY7WuPOlruJ-jfHVUvHDJAya4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMSBTYWx0ZWRfX46Gtr55cXpAt
 h2S48JwT/RFpQ/nOOLW1QqoSu6JqxxekprUw6O4HR4PTPehcVpJl/Pk1LHjaZLokNenfm4V3Kg8
 rBeZc2gPbN/smKUE4MnV2pAPWm+ye9ftz9VBHtjyULgvg7p17vRt5KJz3ZGJA332xiNa4IMM3NW
 ayj7qxFWJlBLtx0h/N4R2qFNl5LXxtvdLBv85TH6urkM2ykjzp/FobOJoZADq4J0YsPri59I3PR
 zOz2bHNXU5V7zxagRwu14J1gfr0lRB1FFORzQOVqDeQeHVcCKHcmpU/YQIf66R7qoq2Tl8bYtMh
 tBUr1oncDM1JOO8ulWgETi0juJyRs0u0B5LKchn7/9j7mfyNrdPdSYZRNwo9yzuXliOKXefadLE
 09PZCHY8ZF2wx0CiBsfL/HtLkRgDG9w2p3aaUgecHIGmob4J+8wke3DfQ5aQSkilZNFTQ25yRKV
 SYNBoRHfr9FV2nx9sN1R60ze9/zcEj2tdVklMz9M=

On Thu, 05 Mar 2026 10:51:24 +0800, Chaohai Chen wrote:

> Previously, host_lock was used to prevent bit-set conflicts in async_scan,
> but this approach introduced naked reads in some code paths.
> 
> Convert async_scan from a bitfield to a bool type to eliminate bit-level
> conflicts entirely. Use __guarded_by(&scan_mutex) to indicate that the
> async_scan variable is protected by scan_mutex.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: core: Drop using the host_lock to protect async_scan race condition
      https://git.kernel.org/mkp/scsi/c/7a3aff163c77

-- 
Martin K. Petersen
