Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEE716C69F;
	Mon,  5 Aug 2024 21:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722892716; cv=none; b=cWoYTSQr2w9+PNc4Py1pydy8OsWkWsGuIkNk3PuyU9V1CUyxe4CbyXmmVSJlY7a4XIFGIjBsH+fUNbHO9oEFq0vQJPyEPmgD04bcl9IRXd/ovDBJeJhl3HFPn+2X2wcI3TrDGaICBp6+VRTafIkHBvK6LGPC64XXxXNM/Q9sW+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722892716; c=relaxed/simple;
	bh=9bKOXx7zlE2D4X6iNWclWvZ9B4RETG3gRghEUvdl1E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UUPOdawkcAtI9/dU3n9XaZG174daEGsQIartxmQbaHYMcJvB5ZuY2nvwuobeFNuxuKLc3Wfb5ZfbLKWXHmKlu9/bfhLofbhXdGge7x6ODHRvhtUuj/pWRYrTNDuC85gmDPoZapLGxQAt37jEYNkWxI1fhqrYHff1i8ICBXDCf/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EACepG2y; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EACepG2y"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475Kix77028466;
	Mon, 5 Aug 2024 21:18:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=4FcTsLMoTxvUn7NwMYzaVDNf85ztOPLiquLe5/FItgg=; b=
	EACepG2yIY28JcHL2NvSJZGGAFSX5phbyEoz3oB0bw1f++5jdnrBFgTCyCk2df6y
	F2BripIlw+9vjxtlxK435iuQ5EFVS3B9E7Kp5wnLmqqM6qhedr7lIZUd+QwTHuZb
	MZVPwcnWJfwVUQdONgHWAa+kvLhRGBnMRqq/AHdw7BZMZsJDWyNWVwuyhhzOw9B5
	oxm74LHnIJGs1ZPCr3Jcza2Y38iuJaSiMTtJwT6S1abypW7uvP8eSKgQzJI0IYbW
	1FUddANSDLuG5COBroJ4jLlWnDFcbYL6elLI57u0XfmaAHV4XMwZwrZ0ah0b21OW
	RO4vZcloZzxqNSyRnwUysw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40sckcbr0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 475K2CER035059;
	Mon, 5 Aug 2024 21:18:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40sb07ydk7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Aug 2024 21:18:29 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 475LINER035403;
	Mon, 5 Aug 2024 21:18:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 40sb07ydcw-5;
	Mon, 05 Aug 2024 21:18:28 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>, Kees Cook <kees@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/6] scsi: message: fusion: Replace 1-element arrays with flexible arrays
Date: Mon,  5 Aug 2024 17:17:29 -0400
Message-ID: <172289240512.2008326.777489686385326849.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240711172432.work.523-kees@kernel.org>
References: <20240711172432.work.523-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-05_09,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 mlxlogscore=948 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408050151
X-Proofpoint-GUID: KngozOHO89qEW5gCxFp_FPUn-KScHmZv
X-Proofpoint-ORIG-GUID: KngozOHO89qEW5gCxFp_FPUn-KScHmZv

On Thu, 11 Jul 2024 10:28:14 -0700, Kees Cook wrote:

> Replace all remaining uses of deprecated 1-element "fake" flexible arrays
> with modern C99 flexible arrays. Add __counted_by annotations at the
> same time.
> 
> Thanks!
> 
> -Kees
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/6] scsi: message: fusion: struct _RAID_VOL0_SETTINGS: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/8e76c9c9dd11
[2/6] scsi: message: fusion: struct _CONFIG_PAGE_SAS_IO_UNIT_0: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/14c1f88c7f62
[3/6] scsi: message: fusion: struct _CONFIG_PAGE_RAID_PHYS_DISK_1: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/dc8932fbf6a9
[4/6] scsi: message: fusion: struct _CONFIG_PAGE_IOC_2: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/de80fe29ab53
[5/6] scsi: message: fusion: struct _CONFIG_PAGE_IOC_3: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/70631322dbab
[6/6] scsi: message: fusion: struct _CONFIG_PAGE_IOC_4: Replace 1-element array with flexible array
      https://git.kernel.org/mkp/scsi/c/f296cc1d7f5a

-- 
Martin K. Petersen	Oracle Linux Engineering
