Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094BC241CA2;
	Thu, 31 Jul 2025 04:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753937097; cv=none; b=Mt6SyYKiocVwENBocpuOZoPhQGHXzdeTjMQyqC/lxCKBQ++O3HHq0tlqokHF4FmgC18cDytfmIupo9IMbpnT543ydhyRenNbrm0teWJRC1UlRTYGsxp20eW+D5Vlp8X3NqK+W7eIDRuEqPCQxjzpmtC2yDvNcJcfEcZ7vUm4dgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753937097; c=relaxed/simple;
	bh=oiCFmv/h+Y+1THGKJCqQGLIDfIP9qLP1dbLDajIHc4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BYBiU9MOEnefYSq9xwAcacRDojjAeHz4sBye0f8wN8ySh1o8S2NUgsC27VRls3ecxGgCy199Ibypcg8oYQiJMyd2vyq5AfJ9QaN6oEPxLtoZcVMCdC6+W+61jb7iMAWkxVnYjOjnPlfJ0z5QKfY74YtL/+xJJ0j4TygMQ3DxvRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LySAnhpe; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LySAnhpe"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2fwJI031484;
	Thu, 31 Jul 2025 04:44:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Z9kfqpWmBS94BWzzY+pv56iBpWCKsILOGx6b66Y1m5M=; b=
	LySAnhpeSERpkUA1aq8OVFItddeGsvT/gVUj5Ysd5T0ZHVg6vqBTYOCI7puKvWxQ
	cBfMF5FgGCLDiJ3e8yq/8lkQwiTofhh40e6KlRyQkK9/c+BmC4yiaBROL84z0dlG
	7NLaU852vE84rzLfl/O20GFNh0qgk9nuYA+efyoPif/C0AY5X/cc3TSDw9r9plla
	9EVelquMSWAU1Lmr3Iz9q0kKPU1mHvPCBtwfQ1MEeZQNECNTOuRsOctSL3f2MpOb
	RvId+F+BXB5hMCXwWoqYOaRgMecuB251bFRF1qwVUzf/1Dq+ILjD4SMiHn0qzlbU
	EMjrsz/BBT3QViZADXnzLg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q4yk9n3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V4PLsN016916;
	Thu, 31 Jul 2025 04:44:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb2u7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56V4iX41035411;
	Thu, 31 Jul 2025 04:44:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfjb2tg-4;
	Thu, 31 Jul 2025 04:44:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        Yihang Li <liyihang9@h-partners.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com
Subject: Re: [PATCH] scsi: MAINTAINERS: Update hisi_sas entry
Date: Thu, 31 Jul 2025 00:44:22 -0400
Message-ID: <175375581107.455613.17741974679196185329.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250702012423.1947238-1-liyihang9@h-partners.com>
References: <20250702012423.1947238-1-liyihang9@h-partners.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=868 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310030
X-Proofpoint-GUID: nHHJAaBOGPxMdxlhvL3cC01Er8J3kM1O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMCBTYWx0ZWRfX5rEOXFzq7CY6
 +MVL+y7ag2AMqF9bw7rbtmDhsbN8C6SM6OLv8lBpYKM2AerNXBAI7TZiQyRb68Rn8O4KpqURMKI
 jCceRes9byaeZGT6oqwDsgd5H8pRisAp4A3v0u/U2rP4RIMu5HWraDjOxanBGRK7wBA1lXFDwio
 rNda6gqiMzvmnq0WkzvmwAKt6hvjpBO6A07JZfXc3x3o1VcrLOL8C9Tx1Ws8R0vakyI/Yb8JiP4
 tWgxMuvou6npPu+yGUYy7jKB8/7n2i76D/mj8yOQD5oQCQ5p2r8bukHK4x/S8UUEp1JeOlO9aJ4
 W+VM8AlpesOVXlagE13UROD7FHV88vIjSIXXFV9a82Hq3LeOYjWRkNiCcflkA0fV0zyM3EDnUlS
 pNaIU6uJ/0uZ+1SnURRAa+mqINJTY+LBCtRGM3eq2ENqOYowUJvfxDascdZMZNE/1U94EF4/
X-Authority-Analysis: v=2.4 cv=ZMjXmW7b c=1 sm=1 tr=0 ts=688af4b4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8
 a=megPdkAjSJULifGC9oAA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070
X-Proofpoint-ORIG-GUID: nHHJAaBOGPxMdxlhvL3cC01Er8J3kM1O

On Wed, 02 Jul 2025 09:24:23 +0800, Yihang Li wrote:

> liyihang9@huawei.com no longer works. So update information for hisi_sas.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: MAINTAINERS: Update hisi_sas entry
      https://git.kernel.org/mkp/scsi/c/220e6083e8bd

-- 
Martin K. Petersen	Oracle Linux Engineering
