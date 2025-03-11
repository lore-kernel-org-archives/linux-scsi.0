Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9101E5B9F;
	Tue, 11 Mar 2025 01:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655998; cv=none; b=MX9/QjsIwDoPPu5L9OWuXWFotwAEfPYOz46SaFckeQHUua2hClPfr2QVtBwf5e5CKCRQih6BtJrEji3AbFUWypBR+pLEZ1gGDsR+nX7z2pFS2GTEVoy9yBbDqb5jGccp1BvCFIXOymodFcNxTSSH8dITIQDiso9kpTP39kS4CFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655998; c=relaxed/simple;
	bh=p99/vEVmwvd7YrwsnIImDrZaKJtcHLiobJNQbvze0gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjxclhHWPJSrs8wdxd+ooEyQMiHA17DQZ8j0YMg5KlzT9+fxwq0sJqE4DO0ssHUXW87WGS6C2DXda6NWRbTcAujsAp+T7JdTz960r/nHiph1uQkf26jBgBgL/tVPl/zeO002U5zjKyvoPrb0D85rYQBhXxxfFvDzlMgnb104vZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oMi4pMx1; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oMi4pMx1"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALflrt016930;
	Tue, 11 Mar 2025 01:19:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=qorkEDO0a/0TLfA/PYRb+YsFk93PMDMeWwVa7QsTUYw=; b=
	oMi4pMx1gTc6yyX3riKUulW1d6zZS5wsX8FBsHOG6uk+L3HpvKKQj4KVpa5rO/v5
	jVhYFJvDAY8jHyJxSUglkWWW0fqymzDuVJmklXiZSvgjpKn+tWYuJXT9e91dinou
	OHuh96HmBo9LqX1teaCwyU7WeWGPIcijKipBMEbC32e8m3Ivh6kwbfD/KjQJKnVT
	6erADN5ZkusRDqew+H6y1R/IT0vXN5zw3IqIryOhVjeeQVcyUle7I9g0T8C7+Ycn
	hLSkcy6k7N6/pRPt6/uiQKhAxg5uqR2+fcbNJrqikDHbM1ypivrlbpH0kWSahVqq
	/OnpHMfa5RMNG5nFK7BJYQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458cp33vve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0knIW014923;
	Tue, 11 Mar 2025 01:19:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbencn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:45 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52B1JfrF014960;
	Tue, 11 Mar 2025 01:19:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 458cbencm8-5;
	Tue, 11 Mar 2025 01:19:44 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, heiko@sntech.de,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] scsi: ufs: rockchip: Simplify bool conversion
Date: Mon, 10 Mar 2025 21:19:04 -0400
Message-ID: <174165505002.528513.7169734727155329049.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250226021157.77934-1-jiapeng.chong@linux.alibaba.com>
References: <20250226021157.77934-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=815 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-GUID: 4rXadeu01eDMV_ByNcnfULWBEwCNg1L0
X-Proofpoint-ORIG-GUID: 4rXadeu01eDMV_ByNcnfULWBEwCNg1L0

On Wed, 26 Feb 2025 10:11:57 +0800, Jiapeng Chong wrote:

> ./drivers/ufs/host/ufs-rockchip.c:268:70-75: WARNING: conversion to bool not needed here.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: ufs: rockchip: Simplify bool conversion
      https://git.kernel.org/mkp/scsi/c/3d8256903934

-- 
Martin K. Petersen	Oracle Linux Engineering
