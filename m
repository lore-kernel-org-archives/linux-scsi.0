Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A731BC07A;
	Thu,  2 Jan 2025 22:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735858056; cv=none; b=c6Lgft1h0KGXXEK0tXmKBGX0st89/BdvF+X0P8GUyVM+DK5LAC3CLDUrgY+ChjypdbDhQMEmbw1159nVATbpvTGfoWBQmtoW++xlt7aWV2pqM9qxywpMyNf5q0s58bPkotpkni8DH2MdvrpeR3gIQ0wqbDRSkoaEAi0Q54H3pp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735858056; c=relaxed/simple;
	bh=yaP3ArhksUzcUztzm0RhgaJvyHWlGVks5nCkB6DNcBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FClX+CFxG1FoIUK2xgFkTq2jiqh1MyyDuYOsKngjVdhWn/KnVT9w8jv7Yh4TMTD8NbkEOGebv9aUI4sxyyuKICvBuc0bMpAPWDNsFMBEZ2wIEVh9DxZLFZNMzAHUPn7v+9PtyUpLY/FlOeokcN9c4I5+FF0BAaGXqBf5hGK9irk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E5ibsIqb; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E5ibsIqb"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502KgCAm011508;
	Thu, 2 Jan 2025 22:47:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=TCdeT2FePSqJUIMxy/jtROQLvufeSuYVOswtHDcMDwM=; b=
	E5ibsIqbLF9o+rS7Z6zZ9G79gnBidd0P8P0WlIISZN9JHPhncnECwV3y93fKEavR
	25faqdRkqJN+6+RCx5kZjbX4QA8hstU7v4dyVzLNbGIJ5RMfPq6tRcQDHuB1LBdS
	KJvE9M1+XBNoTljoUZtc/TzfT6tu74RnOsd3rG2GTa2bFj2NGJyzjPIiMEOZa0K1
	S1uOPiuNvM5S2dQfwQLiwd1aItjFYNb9k30J+1AjlQ5qJOHBHMHEk0G2m4kyrsKp
	IhvBWwoVKpylqxE/qxDYMXVYScdkOuD22U0lhbUvh42jQCe8hAT1iBFsekwcKC3S
	N5MtOpGZaKelXyJTjcjWNA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43wrb8aa63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:47:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502LUGsI009571;
	Thu, 2 Jan 2025 22:47:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s93ny4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:47:17 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 502MlAtl004461;
	Thu, 2 Jan 2025 22:47:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43t7s93nuq-5;
	Thu, 02 Jan 2025 22:47:16 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org, Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH] scsi: eliminate scsi_register() and scsi_unregister() usage & docs.
Date: Thu,  2 Jan 2025 17:46:41 -0500
Message-ID: <173583977779.171606.15732169812385582553.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241205041839.164404-1-rdunlap@infradead.org>
References: <20241205041839.164404-1-rdunlap@infradead.org>
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
 definitions=2025-01-02_03,2025-01-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 phishscore=0 mlxlogscore=768 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020199
X-Proofpoint-GUID: Cj2Y9qUjQj1hFk5--OK_ESiSg-sHo0MN
X-Proofpoint-ORIG-GUID: Cj2Y9qUjQj1hFk5--OK_ESiSg-sHo0MN

On Wed, 04 Dec 2024 20:18:39 -0800, Randy Dunlap wrote:

> scsi_mid_low_api.rst refers to scsi_register() and scsi_unregister()
> but these functions (or macros) don't exist. They have been replaced
> by more meaningful names.
> 
> Update one driver (megaraid_mbox.c) that uses "scsi_unregister" in a
> warning message. Update scsi_mid_low_api.rst to eliminate references to
> scsi_register() and scsi_unregister().
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: eliminate scsi_register() and scsi_unregister() usage & docs.
      https://git.kernel.org/mkp/scsi/c/c17618cf664d

-- 
Martin K. Petersen	Oracle Linux Engineering
