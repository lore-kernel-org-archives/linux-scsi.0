Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34584C63;
	Wed, 12 Jun 2024 01:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157601; cv=none; b=q1CAtoIhZoc7VeBRnj3Bys8TjYB0V9UWrEGqgcI9YIMylTYX6OxZPNZBEpg/luM/zsfsrrielDCgLOfNR9lluvpFUfbKbC4Yj06nSa8pL9CNkNt+Wu8l1RGCkzcoyImckKo/f0zMbm9bUPY0ibT9x0po9nwYUtFhZ4XcE1JNils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157601; c=relaxed/simple;
	bh=2laTD/gr2ws3Bq063zMCVoYUIkFJmoBHsc7n7gu27TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/McBmMxd9pVTJXMffLviDqs2bwQ12IMWGyU9B+b8QmFYFoxWyI+/90XIjWOuBCZn3XC1mcRYvk/wuGGrI05GvcUdlDpLc1Uo+HqznP16Gj7fO8Ho4QIBtRUoglxHb1A0G9qHVbpWmb27+1SPBcDStatZr+W0OHZYXT3e86iyjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GA6RsYza; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GA6RsYza"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C1u0b3009858;
	Wed, 12 Jun 2024 01:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=5AG8/9k6Mx48uSNG3x0C+EhfYLMl0swRusYC/0j0CLw=; b=
	GA6RsYzagDi+4tAJWW9nrWsU2eH0gNQszKcPl1EicWEnGBjIobNKz3NXNFyAp5UL
	1FAUeAvTjOpOzgHwFS6N2txn7IOSDx6ghp9mfb6L9JWVbD8nCorXlwprNQPx90Jd
	cnQACDSGWmT7kbTWagVTZ2Eo7il4wmIeP/IcLDd2hZ/Tdq3iUJULiZRSeU81zZE9
	LeuOpx2RcAxvb+TVKuOaUXIlHNcaMeyAiS/c5Y6zjQM0amn/Cww+qbQPf5gIqwhj
	WDb+hbqVuav72S8AOw0Qp3Ca3q8o/cavCCNZ5rTqiXjtTfPuz4xcZkXohncvOrqb
	Aqw7ltzOhEgUp68+InEPiA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1me44a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:59:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45BNLBZx014400;
	Wed, 12 Jun 2024 01:59:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynceusgwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:59:43 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45C1xfbg034029;
	Wed, 12 Jun 2024 01:59:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ynceusgvu-2;
	Wed, 12 Jun 2024 01:59:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Minwoo Im <minwoo.im@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeuk Kim <jeuk20.kim@samsung.com>
Subject: Re: [PATCH v2 0/2] ufs: pci: Add support UFSHCI 4.0 MCQ
Date: Tue, 11 Jun 2024 21:59:03 -0400
Message-ID: <171815477639.111825.17159475816474314158.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240531212244.1593535-1-minwoo.im@samsung.com>
References: <CGME20240531213424epcas2p16d7360e12d310c9f299d449e66af07b3@epcas2p1.samsung.com> <20240531212244.1593535-1-minwoo.im@samsung.com>
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
 definitions=2024-06-11_13,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=601 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406120011
X-Proofpoint-ORIG-GUID: h1qfzA1Y3wWc4bdS-OOMGn-7THkqihc4
X-Proofpoint-GUID: h1qfzA1Y3wWc4bdS-OOMGn-7THkqihc4

On Sat, 01 Jun 2024 06:22:42 +0900, Minwoo Im wrote:

> This patchset introduces add support for MCQ introduced in UFSHCI 4.0.  The
> first patch adds a simple helper to get the address of MCQ queue config
> registers.  The second one enables MCQ feature by adding mandatory vops
> callback functions required at MCQ initialization phase.  The last one is to
> prevent a case where number of MCQ is given 1 since driver allocates poll_queues
> first rather than I/O queues to handle device commands.  Instead of causing
> exception handlers due to no I/O queue, failfast during the initialization time.
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/2] ufs: pci: Add support MCQ for QEMU-based UFS
      https://git.kernel.org/mkp/scsi/c/175d1825ca4d
[2/2] ufs: mcq: Prevent no I/O queue case for MCQ
      https://git.kernel.org/mkp/scsi/c/a420a8ed0a92

-- 
Martin K. Petersen	Oracle Linux Engineering
