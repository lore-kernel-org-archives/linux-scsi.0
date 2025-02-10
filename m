Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D031C28E;
	Mon, 10 Feb 2025 02:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739156355; cv=none; b=oWHwqrsR0gocJQ9Q4YULblBqNxR/hnfYoag3FrW7/5uQbw4JxJHg4ZuAshm7NxZIsQ7VASXOjFWVMVk2G5k4K47cOdFU0mIiFzEcbDSpsTa5C8Uwh1ebOlTT5Gle80FdxILh84T+/TuRC7roS/RYeXVwN74js8n2pBHWyaltu2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739156355; c=relaxed/simple;
	bh=ADIW8EhULmmdOiOESa9L7ev8unjQQWRiZLsKbNU1knc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eT3QUJCRsbCpTee5rjOXgYH1FRO/nlOc4FfecOe0NVFLtr6M66FesbI9tH2wqEMrctKirXMAT1sSVe6bdHGTPMCABP7vEhFhaID3+hTwwauO2aq9i4VynZ7zg5p9QkPqS3Gu2eF1cpurqpEMLaywBAyt0fcsWafX8SdCJvkjE8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MFFLpbdU; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MFFLpbdU"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 519N0AUh000903;
	Mon, 10 Feb 2025 02:59:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=KkmOXOPKnrnRjig3VB+PLyr81En4MtOXpesCsJTOPSI=; b=
	MFFLpbdUVpqIIHgtOUbiICzU46/Dmnq2Hb2QSAUB/igFfK7MPEARh8502YfadOgn
	gBIc1fsxnaebSfQ6mYrXAXtw4pDt8ojUmmPh3r7GgNk+7dvvkV7xu23MNwWNxU4c
	l+QgzF1guz9kYUwqKh6ylrsSECJiH8FgI+GOLRyDMKaAVRU2gT3ImUUp4UsJARmL
	faSahMzfkgvz/dMjgD+nZYxICbpyO9mayC8fjMZ2ONQGaZLpWfEmW5Lue9HHldk4
	Qp4zjjxUasBhDvFZ34ThO4IJZFjh2h1EL58+rIyrOEm/fZ/yExQD+Ij9YTrUeZiW
	j9YCxxoem+zTcOhPkeYWIw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0tg239m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51A2EOrl012413;
	Mon, 10 Feb 2025 02:59:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44nwq6uafg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Feb 2025 02:59:10 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51A2vwAj033952;
	Mon, 10 Feb 2025 02:59:10 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44nwq6uacs-7;
	Mon, 10 Feb 2025 02:59:09 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvsas: remove unused mvs_phys_reset
Date: Sun,  9 Feb 2025 21:58:29 -0500
Message-ID: <173915612135.10716.11274802180175531809.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250127002601.113555-1-linux@treblig.org>
References: <20250127002601.113555-1-linux@treblig.org>
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
 definitions=2025-02-10_02,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=922 mlxscore=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502100023
X-Proofpoint-GUID: URmcsvQsjJ4FLM7AbRwu-NwZw8wYo2YC
X-Proofpoint-ORIG-GUID: URmcsvQsjJ4FLM7AbRwu-NwZw8wYo2YC

On Mon, 27 Jan 2025 00:26:01 +0000, linux@treblig.org wrote:

> mvs_phys_reset() was added in 2009's
> commit 20b09c2992fe ("[SCSI] mvsas: add support for 94xx; layout change;
> bug fixes")
> but hasn't been used.
> 
> Remove it.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: mvsas: remove unused mvs_phys_reset
      https://git.kernel.org/mkp/scsi/c/a307d6ec1239

-- 
Martin K. Petersen	Oracle Linux Engineering
