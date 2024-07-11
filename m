Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8CF710A36;
	Thu, 11 Jul 2024 03:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720667367; cv=none; b=ezqywsGjF1Wygzp1XTxte41Dl22ZnWuCa39BzJhz+jCNPo1BG8cJN6vSohazO4bxQwrbmH4MCd3LagU9rTsjf1bZVAnVtDrJ5cf1okIaitNyJ+A6ua3C6KFI0mEi8PO/0WYsZTQylycWXlF+zmgIrdJEevRzR2P+rCAYF9MAoyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720667367; c=relaxed/simple;
	bh=XUstL11BeDWvPWznWt06Pq5fKndnRoflKrUeNNgbCnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XDiXXEc0jCQdm1X2hXSOSgo5gnSXPnoRjM1U9gxoO94EB9lUYVeRqvZBchpxP9te0qTfOultjvOaYbEvnmTcOCp3bi0LN04uMTq3TqztTUkKYFM7OJLUtgmTUoqllUrKhm+byjh2zYgt3r8y2IHCcwpWWh8BuJilCTWEyABGNTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RfdlBg9u; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RfdlBg9u"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46B0W2N6029600;
	Thu, 11 Jul 2024 03:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=QZt32ryLc+2mLGCiP6px8XlN2AI/SprGl4vbMVzIvzo=; b=
	RfdlBg9udxMW2W3CN9Te8lB86fEcErkxuvfX8sqqOzY//HCiDT9QK3j5Qx+g8thc
	cmzHQSjbzDWdZutBrNjs52BYjkXHTtUsQqkbSMRwDnPTmes4Mg4wayjBGnLS0JdR
	1yf+aTBTvsVzIBKLLAOUGJcDksD3vJYl2H7Fs/cXz54rCHYvDfsov3ZWKcNDKfFw
	sbjO21xDiu4WZB5Qz6HiUagtqGOMUK3NFKiR16pG0p6lLrrPr9wvtA4rvuLA8cFc
	e9uyRf0yGHwIv3My4Bz+4Qkpcl7IdPlrecBqJeR9RmNJXzAWgxEGlRzC1BE/hJNI
	YBelx6WcG+TaLsGU6TU2fg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wgq0p89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 03:09:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46B1MjXO008691;
	Thu, 11 Jul 2024 03:09:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 409vv3x4dd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jul 2024 03:09:18 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46B39D9n006490;
	Thu, 11 Jul 2024 03:09:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 409vv3x4ar-4;
	Thu, 11 Jul 2024 03:09:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        TJ Adams <tadamsjr@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH v2 0/2] small pm80xx driver fixes
Date: Wed, 10 Jul 2024 23:08:35 -0400
Message-ID: <172066369904.698281.13143387624330894977.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240627155924.2361370-1-tadamsjr@google.com>
References: <20240627155924.2361370-1-tadamsjr@google.com>
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
 definitions=2024-07-10_20,2024-07-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=748 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407110020
X-Proofpoint-ORIG-GUID: pPaP-5VGD87VHVjliNFyiv4pr4cPxjfl
X-Proofpoint-GUID: pPaP-5VGD87VHVjliNFyiv4pr4cPxjfl

On Thu, 27 Jun 2024 15:59:22 +0000, TJ Adams wrote:

> These are 2 small patches to prevent a kernel crash and change some
> logs' levels. V1 consisted of 3 patches. One patch is being dropped so
> it can be reworked and sent separately.
> 
> Igor Pylypiv (1):
>   scsi: pm80xx: Set phy->enable_completion only when we wait for it
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/2] scsi: pm80xx: Set phy->enable_completion only when we wait for it
      https://git.kernel.org/mkp/scsi/c/e4f949ef1516
[2/2] scsi: pm8001: Update log level when reading config table
      https://git.kernel.org/mkp/scsi/c/76a20140ef76

-- 
Martin K. Petersen	Oracle Linux Engineering
