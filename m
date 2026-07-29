Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAF038E12D;
	Wed, 29 Jul 2026 02:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293726; cv=none; b=ijlaaFXlgk9Kczckdm2bbRex/+ALNVfgMU+Lt7v2YSBfCLzai4XynLFXZktRMiDcKnC73Hsc3DWOG54SdDaqdPksYag0F7WQSDN+PtNX+K93RHNkkcsBWDybQuEEIVN0VjpFMR2uiCUNMZrBZ2BktmIesD8NW/HYZ2vP3kK4sAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293726; c=relaxed/simple;
	bh=G+nTK6vq4CrNpKtVoDvfjwyvIrXLrVO+Dvq4Hu05C1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkOefQs8+ferC+ibFlkUW1O4WdSUgo9Wh8jHemPlSpkLgovE5PNuL9RGRg2QUUt+Ep8KJUiwpBPt88dGNngEd5W0CrX0tRPCyd0JmhvO9VRaCsf9pPP/9MMWzf0NOA7Cx0WrgWUrkLsf6ETXtO/tVsWA/C3yafH8hqtTT7eh+GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ho8G+eoh; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ho8G+eoh"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItYuo1401731;
	Wed, 29 Jul 2026 02:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5sEXNRMqfuL2nXdpW5cQtDoE38bC4t+nUyH1apkfU9c=; b=
	Ho8G+eohvxJyk0gSQRGbCfA5kE0S40zgG/ojdffOZEbRcPHpny5T/I6PenPAcqh4
	KQTrZg2mH47q1+yH+cn3TCg3r0L4mji+k93vrg1IxmTfcQiNalpfFdrNcE+iRSVU
	cIhxb3s2oCR8eC+ZRHPevT33X5HsyjG7tWPl6ldmmLLcPbgo/TeKS1w4gEAkdWHt
	cpzkSEnYCufWRw9Km75iJm6OV8CR3D52rD6cjeI2p+F2eEvMwlp+wQYP9LZ0CuZe
	2Guih6Dy+L/8vUFhRB5fbkYDdbeEFMmbRda7xQI51aHklZKLqnA69cnvINgl/kad
	WhvI+zV/X6mu0IOQWxlg2A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr0158k0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o6dR001519;
	Wed, 29 Jul 2026 02:55:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0nh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:15 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jV012133;
	Wed, 29 Jul 2026 02:55:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-6;
	Wed, 29 Jul 2026 02:55:15 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@sandisk.com>,
        Himanshu Batra <himanshubatra@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, vamshigajjela@google.com,
        manugautam@google.com
Subject: Re: [PATCH v3] scsi: ufs: sysfs: Add HS_GEAR6 string in power_info/gear sysfs output
Date: Tue, 28 Jul 2026 22:55:00 -0400
Message-ID: <178508193497.4027291.14888064521550466721.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260616100121.548759-1-himanshubatra@google.com>
References: <2026061659-enjoyer-boogeyman-25c0@gregkh> <20260616100121.548759-1-himanshubatra@google.com>
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
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX6HexS1LSyCmM
 lFvyDXHEveEAZnl5Ls+KxdYc8n2wkntPyn7HkKedk3F/5ctcNb3lpjP4Rk6y6XHu6NA6mEoVCRg
 n9mhpYvBfswhEMQrPkhxnSqOjgwIds/sqSJDeIgsc6EHgMHNLkDp
X-Proofpoint-GUID: 4EwYSoixLENgvMSrufpiHrV7_IWNIpBV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX4hVKDBGPW6OE
 Buq0svVDKs7i25lS4zVNHvfJRBmV4CXkhZRwRxRIofwKrc//tl3EbH2OhKMt7Hok/+X4uKRRDUo
 9BVg9jXkK6d0bZsqatwQshbanVrb0CEMzscQYIqLEdhlkUb/iT8ZPSP56TI2HnFI5jr5/MsdcWA
 IJYGNN8FXtA3ldUt8ziRa9sFcbvmtt6E2YqK6gy4s5cx/ZPqFt7JkWLbeLiR3fbFNFbF83cqncN
 wqPM/VGT0qCcH2C3LWjZrYtyMl88EOAbBaXbdmq7ozFGy0UDucV/pE/kQQHn6WL8uVm8d167z2Q
 uCuje2ReiYMcjW4hi4hS/djO18mnoDKD/+7ERGewV92uPrCwgp/LMKI1xliXZ6uH4lzEUuIMcGF
 TX2ebG71Ux3EDp7ebRKGJ3ZZhVijts6hL6ZRD/3hCbM1hO1Hcqvpnkaerg/ZbFKDdF3fgYwDmT5
 g8jh/36138ZyI05jXZQ==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a696b94 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=UE2yU_vtpRrW4_5CFC8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 4EwYSoixLENgvMSrufpiHrV7_IWNIpBV

On Tue, 16 Jun 2026 15:31:21 +0530, Himanshu Batra wrote:

> In power_info/gear sysfs, currently it supports output only till gear 5.
> If operating mode is gear 6, it outputs "UNKNOWN".
> Add support for HS_GEAR6 string in sysfs output when operating mode
> is gear 6.
> 
> 

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: ufs: sysfs: Add HS_GEAR6 string in power_info/gear sysfs output
      https://git.kernel.org/mkp/scsi/c/78f638ff3bc1

-- 
Martin K. Petersen
