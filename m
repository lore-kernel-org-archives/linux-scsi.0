Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862A2301474;
	Tue,  9 Dec 2025 03:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250508; cv=none; b=g/ZZJ1YcQEoJX6uIhhMvqUM8Lc1yG8+RiBhwdYZ8Yu6TbGnrMyG11OKr53EtSOdPSaUKAbW8RKfo1us7b3rck0X+4lFEsrCpClkcDDzBHNkp5WMD4Qz2FhuWbm0ZjV2rlGnB/ICze5enzbcTrzVgUtAHI79N113JPeaBPiMjSHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250508; c=relaxed/simple;
	bh=IIJOOQJ4SBcH6Wh/ORQiB10CODbVmCvIQnWYNW+rz8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ShAe+bb4fogtPwHNRpQw8G25Q1utbwEUvbtG1SlC8+uXvf2v8TJGnWm2MRnn19QeGRh3JZASin2P3zrdg2uTgWnvGvjtDI+CdGKgV8OIV/1haFJH7A8/EMV/MFV9Yt1hn7nPqqlWoDK5LK61Dss62ZcOIn6do2SdryBd/fdTtO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eDOETSu2; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eDOETSu2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B92fkQ04149799;
	Tue, 9 Dec 2025 03:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=MTOQFFyyrU05TrLY5ueV6KYgJKupo7zsDhm2NVeLrPE=; b=
	eDOETSu2kpcrl2lMl6v5Lu61J+jIHZbS3NBljOREPF1YqVM8GIAzfZHxzzQnPF9L
	GXCQB/HH+qMHvGJ67R7GD6cu03yA1RICVRkCABz5aG5pwiwcfUDXlvRfQ9PFC+xY
	b/OgUKKUlWOzBN9lJBVTohLeOrmc/FXKnzVJp6IS9gqoIDVdo53D0tYysvGPJVK7
	dFNv7wVePEiQaWaWTYs9JJCpy8Rm0E1Qip1m+3BGkbLEVhhUb+gpC4K7OJLgn8WE
	5x6RathWs+6389P5/rdPxIVbfoq5o3Zh5yqYTxpzGMIf/8ca1gXM2pmZXrDxwpo3
	srrCcko+HnYOGLKEqUttRw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axb7500ra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91Q2qY038257;
	Tue, 9 Dec 2025 03:21:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j03b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:24 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4Ff022652;
	Tue, 9 Dec 2025 03:21:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-10;
	Tue, 09 Dec 2025 03:21:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: john.g.garry@oracle.com, yanaijie@huawei.com, jejb@linux.ibm.com,
        Xingui Yang <yangxingui@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liyihang9@h-partners.com, liuyonglong@huawei.com,
        kangfenglong@huawei.com
Subject: Re: [PATCH v2] Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"
Date: Mon,  8 Dec 2025 22:21:09 -0500
Message-ID: <176524933147.418581.13273074674404945283.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251202065627.140361-1-yangxingui@huawei.com>
References: <20251202065627.140361-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Proofpoint-ORIG-GUID: Dzw4nTIGz-9WShvPnKTYoZ4Osi418jLl
X-Authority-Analysis: v=2.4 cv=KqBAGGWN c=1 sm=1 tr=0 ts=693795b5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=3gF-LyXLwZgIZm-5d90A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Dzw4nTIGz-9WShvPnKTYoZ4Osi418jLl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX6hxe2cdcFP79
 L7jsleoKuJgb4deHvGYdYZJVOKvBiGm79sHlhKLiuU50ynDgcUSPjP8z5MocCwf/TTqqsfalAFR
 B/hr68nRd2idIfv6yBfA7Itz85f9uHppAwowwwu2RUysdQAlf5vvGLlHlgu5fpy1zCZVr3bz5Bw
 UezlT4qjpC9UdqlcdFGULKxx4JTktbr7Dvp67rlAtF1cN+ifWfDrzZiof6EZwkZrIMJKNOzH90a
 hPcpLZIvo6Y88rDnkjKaHyjUR0CxgLlETXmtJZXqlodcLXkIUmuZmxFa62eBcGVCX7cqWDP2qyR
 vR/syh9Cg/IeKxgSC0HU+kZeYT1s7/K+f5MIdp5FByZfOZ1FTW/wvSYMznd59syZb/45VTnyW86
 0zv0YA+H3z7w3qNcZK5fPczB/NyBzw==

On Tue, 02 Dec 2025 14:56:27 +0800, Xingui Yang wrote:

> This reverts commit ab2068a6fb84751836a84c26ca72b3beb349619d.
> 
> When probing the exp-attached sata device, libsas/libata will issue a hard
> reset in sas_probe_sata() -> ata_sas_async_probe(), then a broadcast event
> will be received after the disk probe fails, and this commit causes the
> probe will be re-executed on the disk, and a faulty disk may get into an
> indefinite loop of probe.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] Revert "scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed"
      https://git.kernel.org/mkp/scsi/c/278712d20bc8

-- 
Martin K. Petersen
