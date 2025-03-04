Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26155B640;
	Tue,  4 Mar 2025 03:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741058393; cv=none; b=nckGDDkyETyo6p35ZofX/l87U+rw/jFSoSDY/nmN/yOd98Ff3vN0R0/lCbYgP6xfR+o9LoX0y7oK3TWP2bMgEBYDCPivlsJKPU1CFr30Ce7B61aUK69EEFXGe27Xh9rLkUDS3510fI4b1L+W/To5/g2QdIg0QPELoGvZuAWsMzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741058393; c=relaxed/simple;
	bh=etfsvUilZQK1L+JrGbi0zFhCgsTc7PDVSCBXuzZbZXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2PWrejzNxODcdblX7qvZJM6dAgBjPBQ2GeOz06wHAfVWm7mdikIadqIG7a40DI92uNQXFZHrvFtYzpn4AvjjIi13UDNSA9w2+P6axvMYK1x0ifIjC+f066NWl1czds3rQFpTFTEz3DpqGLmRn4t7GtD08ZWDEg9NXEHPld+e3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GnF9wvJJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GnF9wvJJ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5241MeKX023988;
	Tue, 4 Mar 2025 03:19:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=B8rwV3ZzyRKSk9aLnXPg2ctjjTtTzGVuHBNqsOjD/pg=; b=
	GnF9wvJJ2TrnraKzCPAjhur4wGYoJHbsLyYIt4WxUgeucakuVKJZQluYMiNDIaQO
	0LuokEBP3TOolNusxNVV1PtAYfaRi59YRG9SvW0dSPyoiH4AM0gnrrHavbWBQlGS
	9I8c4I3a6zGEwHTlsMsT6hTgqYFyz9mYhVT1HNxBU3XZ8bZ3jiW1CJFBWbimlTO+
	WsoDTkwGskL2Ky6b3kqxwNM+EAaRdjc0BS+JleFblYQJ2e72s7jOeFEWc+oWvXO0
	rDRKfdrlGF8WFgeMM5UEK+5SOxMfEUo7sqQNP1hDeHLePtP7a73XKAxfkL9aN2so
	7iPwKM0scrm3veFFKrQ6bA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wm1yj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:19:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5240U2HY039127;
	Tue, 4 Mar 2025 03:19:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp92sff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 03:19:48 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5243Jl4c029873;
	Tue, 4 Mar 2025 03:19:47 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 453rp92set-1;
	Tue, 04 Mar 2025 03:19:47 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix spelling mistake "receveid" -> "received"
Date: Mon,  3 Mar 2025 22:19:15 -0500
Message-ID: <174105384025.3860046.11487151743933866010.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250221083253.77496-1-colin.i.king@gmail.com>
References: <20250221083253.77496-1-colin.i.king@gmail.com>
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
 definitions=2025-03-04_02,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 mlxlogscore=880 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040026
X-Proofpoint-ORIG-GUID: YH8SxX585DzdPzeX_5SPuokx-Sn3gp8b
X-Proofpoint-GUID: YH8SxX585DzdPzeX_5SPuokx-Sn3gp8b

On Fri, 21 Feb 2025 08:32:53 +0000, Colin Ian King wrote:

> There is a spelling mistake in a ioc_err message. Fix it.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix spelling mistake "receveid" -> "received"
      https://git.kernel.org/mkp/scsi/c/c337ce64ea8a

-- 
Martin K. Petersen	Oracle Linux Engineering
