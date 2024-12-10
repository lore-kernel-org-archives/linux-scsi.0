Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D9019E980;
	Tue, 10 Dec 2024 02:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798188; cv=none; b=fchWo7t/omjfkHtZH7alt0E2MqSTouCiOzXH2mMIXWHKTex2jAxi+RNJCmPQadPP+4Bf1jCNVyoXnYZh+uZ7oaDmcDxN70AZV5b6WGpoRwIzrK8v0uqhMStblJcZL5YhKrwfu9509Re5Ho5DKhAv64TdVhKA6/MN2AVsc9iMILs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798188; c=relaxed/simple;
	bh=ndq7o81213p96riLC2gOA1ftMsHfrlkktq3J84hkqBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TgUob0wdY3+5rzeZYJm2L31uBsz3VDOCEq6mI4xw08g4sFqxfyvn7/rYf+Hx38/UtpCVb9uSPZ2MXI84L0cP5T4Rk3bn16OcxaVYSGgNXOcfgLKwMo6YCGLNnBDU4tsvG95yRhem4F56fU5A7v/iitqT/wFe85WioeqenlnJyws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c222Lw3m; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c222Lw3m"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1BrMT012332;
	Tue, 10 Dec 2024 02:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=W84SVaMorpM+EWrxmstjQj5DNlaGj0lFOjIiNcev+I4=; b=
	c222Lw3mNyaCUNUzWbUbtSUhvWia7uvp55wLfnWZutc7cvd0HzlyWy+umOgx4duD
	Ug5OgaaLuYXq6rf3pWzJ825Fb7x4lTVTgfWkAiT4/Mn40IQPZiwizFpQJlxhCF97
	kZ0k3e6zXWRAvmIynqVt+FxOcgdQkVtnQB9fpj77JHs0Yq/gjzSSWWAeDmFG3JUk
	0F2G4HapCCYDshQ+CwsFPc9KNq7ARGXQeBNMlhs9pKZCuka6akBORIp9NjZEU1S0
	B+Qt5kNKZFZQkWJtQ3GBBomdA6MqmzNGTG2o77CYhG/mfmHCMJtmSoa+kKccjsE9
	SGvT2x4GlZab0NZH1oOPcg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43dx5s1uva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA18jlt034911;
	Tue, 10 Dec 2024 02:36:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIur010256;
	Tue, 10 Dec 2024 02:36:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-5;
	Tue, 10 Dec 2024 02:36:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Salomon Dushimirimana <salomondush@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Increase reserved tags from 8 to 128
Date: Mon,  9 Dec 2024 21:35:36 -0500
Message-ID: <173379777412.2787035.2116624888834112559.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241126224923.973528-1-salomondush@google.com>
References: <20241126224923.973528-1-salomondush@google.com>
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
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=879 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-ORIG-GUID: -eGT-7X5BbVF1uD5AOpWwJ31Hjk8gKHc
X-Proofpoint-GUID: -eGT-7X5BbVF1uD5AOpWwJ31Hjk8gKHc

On Tue, 26 Nov 2024 22:49:23 +0000, Salomon Dushimirimana wrote:

> Increase the number of reserved tags to prevent command processing
> failures when the driver is under stress. 8 reserved tags are quickly
> getting all used up leading to errors when command completions are
> delayed.
> 
> The driver needs ~512 ccbs/tags for maximum I/O utilization:
> 16 (max disks) * 32 (max SATA queue depth) = ~512 ccbs/tags.
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: pm80xx: Increase reserved tags from 8 to 128
      https://git.kernel.org/mkp/scsi/c/b64004dbcd23

-- 
Martin K. Petersen	Oracle Linux Engineering
