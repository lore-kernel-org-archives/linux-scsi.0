Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1851FF1C7;
	Fri, 20 Mar 2026 02:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773974215; cv=none; b=d/qgN6LNcPAVHodRHSuzr28uKlzTmVpTAH70sfChh7FFox0+pkmXAiHxelLQlw9gdjKtfAGAFSmt0wsjoTD567luwYYSVII4QRxmeUqCoJoKUsP7oOn437VuOP7TUTngaX6XplVMwVdMNXOOH60vg5zyQh4dZvoqXjTxOYiNG6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773974215; c=relaxed/simple;
	bh=c7qBdSsRfy5COr0XMFNBn/zBTWyIIx6y8s+ZvywmDAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MA3JqNrjrsZRB7g6gSKSD4cysxwdBOxF8BuckSeYbOuQO6mIiSCcwLzLauRr+YPc6f3z5usFEdgIwhrI/jILpzLduYyq3+ihB1+HG5+vVwqyxcWOVddQj08M+j3cWU8ojXrjiMdN9y9d/C8ErLlDcQOYj1dfp8dWp1W0Tsk7BDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NafOMorg; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NafOMorg"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62JGEAHh2009238;
	Fri, 20 Mar 2026 02:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5h9/9hUjHwJlW8GHjK2I9vk4Hx+/2Gju8NLEoZ1l6B4=; b=
	NafOMorgpRN/r4A/CxMULY9fRWLkW5nQsi8Lt1zl4e6+z2dS6dHPVNJr+fcaUbkG
	/aJQiSJlQo0Y+3Ohu6lgVp1rks6pLHCMZzrOBYjRa2CguSJcifDCQv9lXr5BLDlx
	MnCilitB449PZ6LB5ILayf1CoYave3vLQVkQ6++w25tn7k8YXy5ouLMD9QC0mdeB
	MWwwCtlf/7I4SIBdoSWplKRjePyLsV5ddlq0KOpn6SWZufn3aHNgBXNtgp6xUoOF
	76yVppHpp1ssG1UsoaT/IuqpGKD8wyF0Bex3qXDc1uFUpwEKWNOcorHmP/hGknVa
	S05KXdOOiNrXVeA3NGJ7jw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyqc0v46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62JNGYvo003336;
	Fri, 20 Mar 2026 02:36:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4dp7c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Mar 2026 02:36:14 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62K2aDRL020555;
	Fri, 20 Mar 2026 02:36:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4dp7bq-2;
	Fri, 20 Mar 2026 02:36:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: tcm_loop: drain commands in target_reset handler
Date: Thu, 19 Mar 2026 22:36:01 -0400
Message-ID: <177397393954.2929898.7554458925697922587.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <27011aa34c8f6b1b94d2e3cf5655b6d037f53428.1773706803.git.josef@toxicpanda.com>
References: <27011aa34c8f6b1b94d2e3cf5655b6d037f53428.1773706803.git.josef@toxicpanda.com>
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
 definitions=2026-03-19_04,2026-03-19_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=826
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603200019
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzIwMDAxOSBTYWx0ZWRfX7wrDyZujsUir
 qHE1PMdUeTRtNudAGDDkXH0PUM1AE7OBSkMYx4E9a23CvuQYmDV6IXwNv49vks13OhoZgfCDM7R
 YU8f6Fp5MMv1FCLZnOKWtGRe2tKK4rQJisgaE8t4Cp6jQ8lrdNdYlJKZeeflHQcvQwAfm1Rchu3
 46/rZbmnausQIaPyQ6M4HjBOWsS31ydypSlagK3C5WNHe5l/o+0vh3msBvIQUqKd9STcbyO8RfM
 OKaPyJyI61Nqfd6znO3AuULAWFO5xLCdgcemOhc5bkcJ9IsFABriaz31cTgZydBJcNDIUA02p5b
 FiDDEzJpqCmfEJctAlUe9NPTJsMrtoPlypixJ59+yy2Tl7ZuyJ4tyoiOxB/UdSmYefKdA4U9XPX
 3HBUHiLX3+Z0oPPtN59tfm8MIa2ix3hDUmM9DTjz9zteOl4hgjjMijsLAf7/ymbBazhflbL+0I2
 Ad5AeLcFyqxScm+MpYg==
X-Authority-Analysis: v=2.4 cv=J8WnLQnS c=1 sm=1 tr=0 ts=69bcb29f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=tgYQ3KPRjoK8v3f40AkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: iCNyUhyGggWiYLZ2D6bKYXaPnkemGyEi
X-Proofpoint-ORIG-GUID: iCNyUhyGggWiYLZ2D6bKYXaPnkemGyEi

On Mon, 16 Mar 2026 20:23:29 -0400, Josef Bacik wrote:

> tcm_loop_target_reset() violates the SCSI EH contract: it returns
> SUCCESS without draining any in-flight commands.  The SCSI EH
> documentation (scsi_eh.rst) requires that when a reset handler returns
> SUCCESS the driver has made lower layers "forget about timed out scmds"
> and is ready for new commands.  Every other SCSI LLD (virtio_scsi,
> mpt3sas, ipr, scsi_debug, mpi3mr) enforces this by draining or
> completing outstanding commands before returning SUCCESS.
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: target: tcm_loop: drain commands in target_reset handler
      https://git.kernel.org/mkp/scsi/c/1333eee56cdf

-- 
Martin K. Petersen
