Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D5C3911B2;
	Wed, 29 Jul 2026 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293727; cv=none; b=fhbzFc+xBcE6NhDUJoBLH4liEc85eu21LkSag1D1OrC7y1nZXSE2b5aZJWaqkH1BUm4XZzoH9JBAMkMqUdCLe412ItyOfDMLniV2YL5aDDOQI8je/2KJRqw1ME7C1+wHCYmZrm79stwW8xe2dcuVxeuKvZ9YUQXD5MxN0LBT3GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293727; c=relaxed/simple;
	bh=ZU+IkRrSoVnkaR0NUlJPqaxYgNrrKmOyqpXvPmlGysM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pkcSYCm6i72qtvvmkbOegj+cQ0xyAhLcUdVWkdI+X/OMPWzz2c6uylTxS7XyE6I/hwfvMAvTaDTfFigBrJ0+oid8lEgMFOMRJ+QB3ys9j6ajZON+oFq1C/YIRdyZ+pPpmkIuConXcJv5nuYoD/e/YlHKsl2d/KyCciG1I8AyeJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lbb0IQ57; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lbb0IQ57"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItqfl2091613;
	Wed, 29 Jul 2026 02:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fIC1OIrzOiPagT63y4YFGRglD+2v6/i+Tzn0/KPotWs=; b=
	lbb0IQ571KsYcFfvqhzVJ2AeEy3k4cLr3EY0DHrQzOFI0xVnU+HODOqii7kGsl6o
	LdM4+WnLZtmgDujZBBidzbswQKww/VUcnju1u0brfxNfAix+e3e2S2uO2wjEIJ0p
	Dpaneke6b3grNoQu+Cgvhqev3/lMi4HahAh1DyWjOcrybVgwuc7v0qJxf5gzNncn
	o0wxc4z8m6y40HDOYGp+2ZwSAUvhkEikt/VDkjz7LCjTWi9F9atTIT7qelvo2UJp
	pYoTI5WqdLRi6QvTLDsbOaydwWVT7gHsTtAqAXLXmAWgIjVisnCRrIecTJIFv/5i
	KJUJmxK6N/fOUxPMw0Ek+w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyyd83r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:20 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o6ZA001546;
	Wed, 29 Jul 2026 02:55:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:19 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jb012133;
	Wed, 29 Jul 2026 02:55:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-9;
	Wed, 29 Jul 2026 02:55:18 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com,
        Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alex.williamson@nvidia.com, Kyle.Mahlkuch@ibm.com
Subject: Re: [PATCH] [SCSI] qla2xxx: Handle the INTx not connected while passing through
Date: Tue, 28 Jul 2026 22:55:03 -0400
Message-ID: <178508193511.4027291.4543280548195278135.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
References: <177885270578.1573.14283751510936407585.stgit@linux.ibm.com>
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
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=990
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX38O2YEwoORQV
 VMt/MvDZf7lmdMNe/Q2bQMJOnPIREel7MW6gw5TfznH1HfqwUybQwTZpOl8oR1RUNsfrKipDAtA
 OYk12F4KSeqqLMYBZm5yuC2vtNVaBQt+/WPUV3jdcGaD3GhbvAfk
X-Proofpoint-GUID: tkfbNAnpu97oHV1GVcudN-UyiPXN2QAo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX0VnMrYDvG6Ms
 sh9LUrklkpGSTRd+4jPH8RPsYLPkyxEjOfp12LJ5WCyqzTq/2shYs1cxYT+aoohWithQ3NXibOq
 ePEujSzzobCRegTa45safPUe1gRGO71fJEjdU4gMI/XIVCz//KiRvDvNbVs+liL363vU5MbQmPT
 jmMK93NE02A8V0eW5RaERWdojXcW2UTgN7Gi//a18tFtWZ4HGd8EPuSb97/ONvuH3Ka++u6HtjC
 nKwdpa5CVHEIlP9G9SFRR4aDxdWlAarUzl8Gufxm/p30ynrJFwBjOnALEmSgLqgOqWjCES80E+0
 OJiEwIMXAJnsujmkzD//8/GATaYLeNDmOkcq5YxKorD6q6s67/kRZl9RVZIi7hPo0OR4nD6j7JQ
 7Vp9eoJIFz2phjZ41fcZL/NLSs6krfNPUP/WBOepVdDqrS73b1O3ppqDt2axTRmg/JVFt444pda
 9SiDq5HpTdqVV0DvuMA==
X-Authority-Analysis: v=2.4 cv=HNnz0Itv c=1 sm=1 tr=0 ts=6a696b98 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=Yf1Wy1mNssDpqJgCTTsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: tkfbNAnpu97oHV1GVcudN-UyiPXN2QAo

On Fri, 15 May 2026 13:45:18 +0000, Shivaprasad G Bhat wrote:

> The PCI_INTERRUPT_PIN reports if the device supports the INTx.
> However, when the device is assigned to a guest via vfio, the
> PCI_INTERRUPT_PIN is set to 0(i.e none) if the line is not
> connected and|or the platform cannot route the interrupt.
> 
> In such cases, the guest PCI_INTERRUPT_PIN is 0 and the port
> number becomes -1(255, uint8_t underflow) for qla[25|27|28]xx and
> qla2031 devices. The flt_region_nvram is never set, and subsequently
> the lun detection fails. Below warnings show the NVRAM configuration
> failure.
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/1] qla2xxx: Handle the INTx not connected while passing through
      https://git.kernel.org/mkp/scsi/c/7268e509b43a

-- 
Martin K. Petersen
