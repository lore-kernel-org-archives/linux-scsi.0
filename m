Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A2914C5B5;
	Wed, 16 Oct 2024 02:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046456; cv=none; b=G5RaIrpvPCYtLVTtImKTnT0cohlT7ViOnyrvPhwwWkifaIJ9TIRJkqZvgc2JnliFjXaSFwi00/a3MgBb+shrIEvGJr9UmQeNyx2R4FRXohVPIdtPb2H2jRMnHVeQt3m4QzZnoMlVEF0QbzID1tyq2PtPxzp5NN48vFLVId7f20Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046456; c=relaxed/simple;
	bh=U2xBWw6wGon8pqqapj8rMnETS1INr7AKC9T3iLRm4zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Al0kbwlkcRbXogDHriRDB0JAIKxrHt2UgmRIMMDZJmbAC/rxZeJF6TAemg43B9bYGcsDDIUBIg0JfP/p0SphjBZ+ndB5DlqAr0R3hesZB5CPlQGskzSJfwsv2uxdhFlwmQT3Ms7Zbp46aotkNSnVOMBYX37rg/770WJAGwDCGWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vrk3/GvN; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vrk3/GvN"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2ON2o022882;
	Wed, 16 Oct 2024 02:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=+TjPqgeEh/tDqK+8eV+2vJUKhGvUZPfWF8FSTYflACY=; b=
	Vrk3/GvNWl9Iin1AeNyEhuEVjvl8joj8xV3ckoiJpyucB3X09JFotCWD1QXseqFZ
	ka22a8o7Z3hMbKNSR9ycTkWroXYXC4dio7QannfGso0M+yJVqJ+9TMisxfEipw9N
	QwBzilsEEvcmgnmHyYCLecGKdHuqOrkJwNlzi0tgM4XMHtiI4EMDhLnstQP3fy1s
	0Tg983iZGivfQEXzO4vKuYjPtfFXHaPpmptgFMpW0dYexRCD7DOqFYoUadlOcnHp
	jDTGZnCMtLx9aoXWZ2Ijj8ZL7HtCProiH5SnnKmJi2mzx715B81GhlgxWQugdgub
	pkN+WMnIgvFWKlsf7YPrGQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427h09j6yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G1M4WT027143;
	Wed, 16 Oct 2024 02:40:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjesy06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:49 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49G2elg7001510;
	Wed, 16 Oct 2024 02:40:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fjesxyf-5;
	Wed, 16 Oct 2024 02:40:49 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: anil.gurumurthy@qlogic.com, liujing <liujing@cmss.chinamobile.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sudarsana.kalluru@qlogic.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: fix cacography in bfi.h file
Date: Tue, 15 Oct 2024 22:40:06 -0400
Message-ID: <172852338078.715793.16722401492826125661.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240921104537.14843-1-liujing@cmss.chinamobile.com>
References: <20240921104537.14843-1-liujing@cmss.chinamobile.com>
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
 definitions=2024-10-15_21,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=823 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410160016
X-Proofpoint-GUID: NqFCgKRUA1x1JsZYNp_cR4k2R2TruoRu
X-Proofpoint-ORIG-GUID: NqFCgKRUA1x1JsZYNp_cR4k2R2TruoRu

On Sat, 21 Sep 2024 18:45:37 +0800, liujing wrote:

> 


Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: bfa: fix cacography in bfi.h file
      https://git.kernel.org/mkp/scsi/c/aa948b39ddc7

-- 
Martin K. Petersen	Oracle Linux Engineering
