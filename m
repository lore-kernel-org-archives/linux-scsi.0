Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3756B1E8854;
	Thu, 14 Nov 2024 02:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552671; cv=none; b=ogdFHLK0XAXmZbDx5+Ca7mJ69iTWL+jneWkUAfPjudNCm0b16uHFAb76BIMe4IxwARD312i75Y7qnMKkvgWotcet+JyQ86GXOp4ehKSFXhWSxoMSrU9N0RF5RF7iAIVrv/PUoM3Ibwm4gbtnq8goV9gyXDMmx2490AIld9yAjWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552671; c=relaxed/simple;
	bh=nH2HFpSxMZw3GJhCNMu8XpK8bYpJ8Np60qvvYQf9YEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CH+E5LeZukLz3fIb/sPbNFlXGMdFWYRxH8qSsv00ZZJO8lshwvwE9FpNMLvYzSSQ6i/IfQHLIn71OuI5ODn672IE8UzwlJDW6zjj98hf4A7FQGCYnvW9G3U7r/BtHOXfKD18K+F4aFQzqFWa9MdpraX/oQFvpNf+ML2I2EBg72s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A8qrc27z; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A8qrc27z"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1h1we008864;
	Thu, 14 Nov 2024 02:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=CAS+L6E4lnQZemfuAKEryjyEu57X0ydbY3cOes44Lxw=; b=
	A8qrc27zCkWf6mj2KGutiaqyHoMHvBk6Ex1kYWdm+X/mnXoA/dVTbAEi037oBJ32
	0WDzRfnWueeewBxALs4S0yYQGUGaDzKtrLM9Byn4AIiiIrYmCL81v42IQVL6undO
	BrZ2ErVLLbKnITvmN0fz4b7U9Y5UdU02jDAJuh440qUpZqwGxEsdyfr1ZYAgJD3H
	b2l4pY1JIEN7ENhza8zyagqGf5dPnrOfR5zIJXwHWd0h6EhTPTlKUBYDIZBHRFuY
	c4cq9+m+OvqGwDniLu2ZLk8lNE3J4hxyuHQJ9LYJdGzsDqFJJ8l+vUuZieYJHciC
	E0FoFG/MeIWzBAmdHewTHg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0nwr8gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:51:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1AUWK022725;
	Thu, 14 Nov 2024 02:51:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p266-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:51:03 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojZC003527;
	Thu, 14 Nov 2024 02:51:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-15;
	Thu, 14 Nov 2024 02:51:02 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sreekanth.reddy@broadcom.com, sathya.prakash@broadcom.com,
        James.Bottomley@SteelEye.com, eric.moore@lsil.com,
        suganath-prabu.subramani@broadcom.com,
        Zeng Heng <zengheng4@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        bobo.shaobowang@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: fusion: Fix not used variable 'rc'
Date: Wed, 13 Nov 2024 21:50:08 -0500
Message-ID: <173155154799.970810.15502982361144591172.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241024084417.154655-1-zengheng4@huawei.com>
References: <20241024084417.154655-1-zengheng4@huawei.com>
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
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=966 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-GUID: 5comLe5-PlgwW_hA-2a4qudQZynBVXCd
X-Proofpoint-ORIG-GUID: 5comLe5-PlgwW_hA-2a4qudQZynBVXCd

On Thu, 24 Oct 2024 16:44:17 +0800, Zeng Heng wrote:

> Fixing exposed the fact that improperly ignore the return value of
> scsi_device_reprobe() in _scsih_reprobe_lun(). Fixing the calling code to
> deal with the potential error is non-trivial, so for now just WARN_ON().
> 
> The handling of scsi_device_reprobe()'s return value refers to
> _scsih_reprobe_lun() and the following link:
> https://lore.kernel.org/all/094fdbf57487af4f395238c0525b2a560c8f68f0.1469766027.git.calvinowens@fb.com/
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: fusion: Fix not used variable 'rc'
      https://git.kernel.org/mkp/scsi/c/bd65694223f7

-- 
Martin K. Petersen	Oracle Linux Engineering
