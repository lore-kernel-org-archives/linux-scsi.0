Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114D81DFE1;
	Wed, 19 Feb 2025 01:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927248; cv=none; b=l1+nt+DYinUU7Ei1rFv4MWQKG32tIBIUk8p9cp86OdqOOJ0EIStCt3KLRBjzcLoLYSS+mm58bwNgi36Ap7jRrvXcrjVT6oZrhysmZGf85874DDl+BF7ZbWiG/ZwVz+DKx+oWLAydmQV4orbdbFVHSBPP2KDF3pHH9UOtA1BJ7Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927248; c=relaxed/simple;
	bh=1kYpNdNswqEKqHoA7xUZIEZTpC/TVQMSfLkBfXk1KaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gMxr9yLYNCfvNcHYhO7/s/2VNdztlb26ZFXDE4Wd35OJ5dxYlcgelwi2FKr4qW1H19x6XP8zU1TPh4FSG5jdqpWDSmCFMSIxcqSQEygNeYo3OuOKtVWeCWlC5AOkH1BI0qwWDarIVMawphlXUaG0pbFGxb2l0lwixFEh2WJF1qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f4ke4FVD; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f4ke4FVD"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMg7tY007173;
	Wed, 19 Feb 2025 01:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=vC65oQ0d9y1/m/p52u5CLaY0PWXZTDCshaVJaUJwIiY=; b=
	f4ke4FVDSqCjG1aZHFaNTl64eetvs9dUKysIC+pn1/8+PmGBYm8lkBqXxL8+m6p8
	IUlc/ae5wRQOyiHf8VrPB4iWympF0xPsdU2H2tfIHxKb0ijbP6gqHHBpmTzdfT8Z
	aek4s9XQaDOkoSlgp7jRRZ3Y3pREXh1RIyVYXJbT199tYfB6BxUD7hpdhTczZCAK
	hV6fKYvJ1jekxzinS3RSYLwHQxF/AWycHnLJfxZmCFrY9Hsj6bV43HpzC4zX8Py/
	x2C1JXG35t3TZaqhNwRRaCDnTGNA4xZJLcvo8ZHFIUM1pSGhc5wiRV58fcML8Kie
	3/dbd/QarVOoCruuVpxvtA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00n0jy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J09Yom002048;
	Wed, 19 Feb 2025 01:07:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tk1rqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:21 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51J17KeJ000669;
	Wed, 19 Feb 2025 01:07:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44w0tk1rq5-1;
	Wed, 19 Feb 2025 01:07:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Eric Biggers <ebiggers@google.com>, Ard Biesheuvel <ardb@kernel.org>,
        Andrew Kreimer <algonell@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Fix typos
Date: Tue, 18 Feb 2025 20:06:49 -0500
Message-ID: <173992713066.526057.2711978174410450492.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250206084905.11327-1-algonell@gmail.com>
References: <20250206084905.11327-1-algonell@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_11,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=802
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190006
X-Proofpoint-ORIG-GUID: lKxiJP9NB8igtyu8-npPRq2NsGbM3_kZ
X-Proofpoint-GUID: lKxiJP9NB8igtyu8-npPRq2NsGbM3_kZ

On Thu, 06 Feb 2025 10:47:03 +0200, Andrew Kreimer wrote:

> There are some typos in comments/messages:
>  - Nin -> Min
>  - occuring -> occurring
> 
> Fix them via codespell.
> 
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: target: iscsi: Fix typos
      https://git.kernel.org/mkp/scsi/c/035b9fa023fb

-- 
Martin K. Petersen	Oracle Linux Engineering
