Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDBB1F12E8;
	Thu, 14 Nov 2024 02:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552661; cv=none; b=tWLz52dIhd3pyX8RzMFS304x8YmPYQcBoBJbCD7CYCJolvTny9dNkIUKVDA5mliGfueK2aCzzBA/qlVO6ZhyOTZdqnsPR0ypjndYEDH5hgvPjNbIxVjlxVK/t+H108qvUz4UdEIT0CiuAL2gpR26HS2zK28ztll0GVX772F7mDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552661; c=relaxed/simple;
	bh=LItb2GvVZQqrVTFlevnsllpd3b+JLD8b+KwByAoRnoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=igCUmOTpA7ZSjJfldFFY/IT6cyJRJ3ZcZHwcROvSl1hda93tGDNa2qMkZWMwnnbQLmqc5PeKTUNBnbBXI762zRavaFBgpaY/B2WX0H2Nl0DeFMzVRAyD00Ff0xFuXgkkIERr6FpFSEJ92Xo2vgSMRehN6D1iWqaKDJ9C/Ow5Bqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NSzGbu1Y; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NSzGbu1Y"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1gE9m015748;
	Thu, 14 Nov 2024 02:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=r2PHX/OKkkAmcX+QNHRHtM9K/vQAXA7673MxUWQQ4os=; b=
	NSzGbu1Y7jX37Z58l4XJnM4Zk98He97I2Unq4+pXWQtFSvcp2o6uJY7ViZiOPdqx
	Oq0wRh1TKypOO63Lm2wVxCx8Glh4LAx37Uus/hMwwwxvEdYo5JtixOp6ceJ94SEf
	A+Vj3VS5pWAVxpN41cJn4xs4FzCN+icUVegQ3YctudJowwIsv5dsNZatqapGVowB
	ZyKKtbdZPvOV+k9XsB1v7zu+Ps2ToAHh1DqE9i2c4cGmKjDwRZ+jmKhOZdXPmPUI
	DvhZkMkmw6pN3Yv7dsaX2pU0Cf0UAxnd2P+62LHoPgzd3ouoU3xP2ws7YGEiir84
	WGeomhoZzMwUn692Ni4btw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k2873u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE13NV2022682;
	Thu, 14 Nov 2024 02:50:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p1yc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:50 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojYo003527;
	Thu, 14 Nov 2024 02:50:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-4;
	Thu, 14 Nov 2024 02:50:49 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Finn Thain <fthain@linux-m68k.org>, Michael Schmitz <schmitzmic@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Sam Creasey <sammy@sammy.net>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] scsi: sun3: Mark driver struct with __refdata to prevent section mismatch
Date: Wed, 13 Nov 2024 21:49:57 -0500
Message-ID: <173155154812.970810.11719080837489487682.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
References: <b2c56fa3556505befe9b4cb9a830d9e2a962e72c.1730831769.git.geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=760 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-ORIG-GUID: P3XbgDoG50FcEDGj91sMUoN7Y8ygOH8A
X-Proofpoint-GUID: P3XbgDoG50FcEDGj91sMUoN7Y8ygOH8A

On Tue, 05 Nov 2024 19:36:31 +0100, Geert Uytterhoeven wrote:

> As described in the added code comment, a reference to .exit.text is ok
> for drivers registered via module_platform_driver_probe().  Make this
> explicit to prevent the following section mismatch warnings
> 
>     WARNING: modpost: drivers/scsi/sun3_scsi: section mismatch in reference: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section: .exit.text)
>     WARNING: modpost: drivers/scsi/sun3_scsi_vme: section mismatch in reference: sun3_scsi_driver+0x4 (section: .data) -> sun3_scsi_remove (section: .exit.text)
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: sun3: Mark driver struct with __refdata to prevent section mismatch
      https://git.kernel.org/mkp/scsi/c/50133cf05263

-- 
Martin K. Petersen	Oracle Linux Engineering
