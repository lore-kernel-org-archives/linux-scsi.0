Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F71E15AC4;
	Fri,  4 Oct 2024 02:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728007739; cv=none; b=Djcjlq3ZB0q85Dn2ZcwRHerbDREJrfrqq+/gy01uoGtbZ6ykzyXdyC6TcUUUz+3xmy4GIiHBFbIpNXeu/FAZY7nGmK03SBuqWWOUFIiGCUDDftvgNAqsyOc8UdgcLMp4vQnzk3CCBfoxwA1hZLwb6SUKDiZl1PB+XIqEXv4QjEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728007739; c=relaxed/simple;
	bh=GQCsl0nTEYZuigMSMFbAP/YbO4W0axtA3iaJ7Myeh6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gstwb6eS/mVePh6yHf2wmeKuu8h3oQCTgerVqU6KuCOC7NG5GHq6FuEW0yLvjE+f3TYWrvFIe1Z033lPmDbGZ2vuvbHijj5+gjJM+mD4EeHvjZzj3BIZ786LNIypvDucOnwfh8JF8fdr5Zr0DN34DCJ1u4u2A7vhzaTyoJo9j+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Aj1LHVAD; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Aj1LHVAD"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4940tddj017997;
	Fri, 4 Oct 2024 02:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=D/3T4Cb8+YCqJiH4Uc+jzBs9VxSHqKLx4XNq+9wYumg=; b=
	Aj1LHVADPryGohL8Wkd4iKMDT5Zj84KEF80KN7iBqrtEd0/Tyu3IqK1DKBAphS0J
	ahXeslZoCEQirr014/EvpkOO0oGrdqMmy5dXa7rcTsMAltSh+v9Yye/AWhBPiP41
	7J9YE8vCBrwNfhdCNziYwPUyra/3uf9seYU38SKDNYDvOl6I7m9IRSobMAXogADp
	07CKPAXACDCUJzzXxtfbyfqLPKN+hzwTQVtIGmvrpxjMjVHgUThnFN/nymtNoguI
	3Ya4i8yPW7Qdkf+CaSt4Lcx2fEW6PXWqTavQtczYOSCKeMfp3Li375QDR9oE62xQ
	VWfnw97Tlb6j4HEVViND6w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42204erp0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:08:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4940F83W038423;
	Fri, 4 Oct 2024 02:08:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 422054pb29-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Oct 2024 02:08:49 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49427blg036075;
	Fri, 4 Oct 2024 02:08:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 422054pb11-3;
	Fri, 04 Oct 2024 02:08:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Finn Thain <fthain@linux-m68k.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Daniel Palmer <daniel@0x0f.com>,
        Michael Schmitz <schmitzmic@gmail.com>, stable@kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: wd33c93: Don't use stale scsi_pointer value
Date: Thu,  3 Oct 2024 22:08:08 -0400
Message-ID: <172800766876.2547528.10321922145414314849.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <09e11a0a54e6aa2a88bd214526d305aaf018f523.1727926187.git.fthain@linux-m68k.org>
References: <09e11a0a54e6aa2a88bd214526d305aaf018f523.1727926187.git.fthain@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-04_01,2024-10-03_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=777 adultscore=0
 bulkscore=0 spamscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410040014
X-Proofpoint-GUID: _eldDH_LTWwIby8pLy4ZPTCan4nju_tX
X-Proofpoint-ORIG-GUID: _eldDH_LTWwIby8pLy4ZPTCan4nju_tX

On Thu, 03 Oct 2024 13:29:47 +1000, Finn Thain wrote:

> A regression was introduced with commit dbb2da557a6a ("scsi: wd33c93: Move
> the SCSI pointer to private command data") which results in an oops in
> wd33c93_intr(). That commit added the scsi_pointer variable and
> initialized it from hostdata->connected. However, during selection,
> hostdata->connected is not yet valid. Fix this by getting the current
> scsi_pointer from hostdata->selecting.
> 
> [...]

Applied to 6.12/scsi-fixes, thanks!

[1/1] scsi: wd33c93: Don't use stale scsi_pointer value
      https://git.kernel.org/mkp/scsi/c/9023ed8d91eb

-- 
Martin K. Petersen	Oracle Linux Engineering
