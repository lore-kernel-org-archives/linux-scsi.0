Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E363817E0;
	Tue, 18 Mar 2025 00:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742259320; cv=none; b=qnt5F3+avXGSQBWigHLisdIyGSc1Iwi25BYbDxC5Ng97TYnlQ84zFxpdrOxH0S5j8TpWC7OnaBdUPzAo/bzdCJzcVhbXgiqmRphvXIHpxt4oPcfKEi+ZeQBK+I+NzZUm8JXuGuWam6eUXzax6ogANrUesVx7QMQoS3KQSTBZDMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742259320; c=relaxed/simple;
	bh=Lz1n9ZMgP0m4bKXK0ehoY9GQiCJchKrBzsOqtq2O1Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9iPcPOvZEEBLRyr2gEx63D81tP4l+6jAiuQn5xYGoFd5HCP4+TpKkUzd8uNLARmxzlwlTmnqfxI7+ihQlOcXEAqHL9J/uk6roCT18YLaKCLg+oQotIAQDxp5wcB+RFu/MtNzsm/ZRg64DEuuP18Eg/Hjaplcm2k36bYrCRx1g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gnR30Xj/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gnR30Xj/"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLtrNU005446;
	Tue, 18 Mar 2025 00:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=4IoRSNY42BjvYZEXEZ/k8Hqn9CitPYFP4jIOsSFyvJI=; b=
	gnR30Xj/Ve4DHFn9wj115hcVGP/hF6Y7EUb/TXjJTDSAHuOreCLDkMVzm1QdD7Nl
	2VKnfRR5s8dSo1ePp3JlTAql6B43tuUCbsxiDsZphsMAbDcqM6qrFSss9oQP4Spv
	rcU4cCkjWO+A7vi5jcqON4eoHsIrs6shYHXT2EqBhVknVUtUey2PODeuKay85H9U
	nkc3DNthuuAyqSJeIdGNStWRdvXSgiGXfl0Grj2H2dMX4JHUsS2+j/wUBYOi5qsB
	OpCXfJiNiiR3fhq0fHmfg3NZg874wOx6cg1j0612ew5nb+VRU9msIgWghCtkbbcQ
	3btEOyx08MHhgi9jMHKKFw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1kb47eq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 00:55:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HNR52S022435;
	Tue, 18 Mar 2025 00:55:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeen35k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 00:55:13 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52I0tCZA013983;
	Tue, 18 Mar 2025 00:55:13 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeen34c-2;
	Tue, 18 Mar 2025 00:55:13 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: static most module parameters
Date: Mon, 17 Mar 2025 20:54:42 -0400
Message-ID: <174225924957.1094535.10992045643620590568.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250309145044.38586-1-linux@treblig.org>
References: <20250309145044.38586-1-linux@treblig.org>
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
 definitions=2025-03-17_10,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=902 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503180004
X-Proofpoint-GUID: wRfJCAek9_kHzFoM9et6NzRyzNy5moXe
X-Proofpoint-ORIG-GUID: wRfJCAek9_kHzFoM9et6NzRyzNy5moXe

On Sun, 09 Mar 2025 14:50:44 +0000, linux@treblig.org wrote:

> Most of the module parameters are only used locally in the same
> C file; so static them.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: isci: static most module parameters
      https://git.kernel.org/mkp/scsi/c/11c79df94b98

-- 
Martin K. Petersen	Oracle Linux Engineering
