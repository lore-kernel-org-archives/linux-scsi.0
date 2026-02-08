Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B772630BB8E;
	Sun,  8 Feb 2026 02:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770516130; cv=none; b=MIH345o8OgExevz9wwnsLThFZuHJzdvcjczngkQO7iCRIykC+Ng8E9JrDtSPquAN+iDHZBXzyeoGSMdnu1pzQMrT6OQjEBN23FSom4xM/qGhayV6o0iNcp8zXNjDsToZFzRxWRqVxQ2VTwTO0nst2qKGeS069yq+zidB1acrgmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770516130; c=relaxed/simple;
	bh=mQhp9S8xvyS1ptk26aX4IOWrR5hWIQ5P/n+WaFpS3hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aFtTKwVAnAj4043ZhwGTumzV0jAdDqvjYdCFEor07PoNl0NLuWnhaiqKhRkkk9fNYEGZIPYkQ7gbILeKK7uqKoGeAogpDoxyzwRU16/T6X0xsaFWOBGOQQE8oND1fyA8brs7gAR99CUvnakl5a+DF/1fJCQCsIFh4TbJnJmSWhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BJFgV/l4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BJFgV/l4"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6181k3YT2334074;
	Sun, 8 Feb 2026 02:01:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8SZ0XWmGVVZ4NvN0huBGWfu3wRmrPlrKiGTm8cokbmw=; b=
	BJFgV/l493ez6tC+Gq05zTMvuzy2HG45eAjd3tHN+HbwtnpXj1+ETpmHGdtel4af
	PTDCZsxP5UsmKACOVs0RjhiMkWGfSzNo0eLX/CQdAO9X6sbEru1VC9PJ9daq1eJ2
	v75XGet7ja1ruvaHgXVUx+f1Lxe4Gi0lBoBYSBFdvPkLg77SYSMKN2SEXSXV7p0V
	/ulvsI6h98JlbbkMUfq4H21iJ3S1Ec4xhx4HXqNQtxY9DLjle4IrsVuB2GWILgU5
	ohk+lVC1r0ak7PQXKD705+6Fed3U1jEnioHsvYJ0QD0xgGTm2EOJ8nFCpzXfkdUM
	60ZPPR2WwgF7AgO476U7sQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xh8rhm8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 617JLExh006492;
	Sun, 8 Feb 2026 02:01:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uubuk44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:54 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61821sxK016745;
	Sun, 8 Feb 2026 02:01:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c5uubuk3y-1;
	Sun, 08 Feb 2026 02:01:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Alexey Gladkov <legion@kernel.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SCSI: buslogic: reduce stack usage
Date: Sat,  7 Feb 2026 21:01:42 -0500
Message-ID: <177051564508.3805738.636294649190494202.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260203163321.2598593-1-arnd@kernel.org>
References: <20260203163321.2598593-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_01,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=953 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602080015
X-Authority-Analysis: v=2.4 cv=YbOwJgRf c=1 sm=1 tr=0 ts=6987ee94 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=6lXOnaECx-6xDiqIlNEA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: FeXZkRzLSuHwgZloNpLRvmCL0wqCCKyx
X-Proofpoint-GUID: FeXZkRzLSuHwgZloNpLRvmCL0wqCCKyx
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDAxNSBTYWx0ZWRfXyyOaJc2RAQgg
 Zgn1FNDA2hKAzXJ2zM7g1+STFTSIFGNts0kjmNqVIvXk677wotWJsvfCyqrBovenF70DhX9eGG5
 xZ98TgpfRa1YeS4lXfpEsdjsfn5wOvp4eNQmjDwgphfmUBSYpcgXsWHjcbm9TnBg1hvuQMnbWTC
 Ha2lCSrOksTvxTGvhFBy/f8fhTCitykY7va9katw5nBK988zF3cbv8a1+GHBAAFfaTQK3OvKcdE
 vv4IXqNLg2eTo/XOTTBg0i+m3BUdnN9ZaxpE1w0GXji/N/0y0n0Y9rFFAJ/jcI+RB91D/veDNx3
 2R1gdqzmrUG8UZp01M/xZS8I2n++pVZPJBCGgUi0lFdHyv6yNJusVRUaqno15b9Ib0AgR5Fcl+S
 sIfbIiLtG8VuSuSDodRNo9MAHMSvcB6pYewvniiDkWkR8GpxSJz4NJqqJau8h+wuRcAK1ygRv9E
 aWxYtg16PAGLsbvcpLmKQ9SkxYxEv75vN27dcxpk=

On Tue, 03 Feb 2026 17:33:15 +0100, Arnd Bergmann wrote:

> Some randconfig builds run into excessive stack usage with gcc-14 or
> higher, which use __attribute__((cold)) where earlier versions did
> not do that:
> 
> drivers/scsi/BusLogic.c: In function 'blogic_init':
> drivers/scsi/BusLogic.c:2398:1: error: the frame size of 1680 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] SCSI: buslogic: reduce stack usage
      https://git.kernel.org/mkp/scsi/c/e17f0d4cc006

-- 
Martin K. Petersen
