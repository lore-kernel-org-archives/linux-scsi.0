Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2232A1A3BA1;
	Thu, 19 Sep 2024 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761245; cv=none; b=DWz3GhqnCws+yAA39Xm4l9LbMn3g1jBahthwkdKJVHM1pYwT2Pr6JCc0vtOEiQVIsSyNKRyog1NgtobYphY29ZNiUKi8CwCzSq75v6qSHErpd6lqvKjH6ovcLUSOaDlWYd3pVcVTZr1YI3jOPYKelmiEt01nDlQvMiOa6XyXpRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761245; c=relaxed/simple;
	bh=e4O0mV46+H35amX1/StShGWVbRRARIfLs/6e4YAbR8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ernuUBZIznTnoQ5Wr0WkfS+Hge2Gk8leLLexOyh8hg/RTJ83cqza7hCYhzpHOM+WQtz6+5mPJKX5LdG2k/0V49RLk9jAMOG2kGaXBB8rhHsFzqT3DKHQVaaSXdhXbXwlOL8K2Kj/OHo9fFI6gxc4JD27+sD1fj8nOvHHuXRs2ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ooyYcaba; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ooyYcaba"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48JEkQp2014398;
	Thu, 19 Sep 2024 15:53:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=PR+ycncIBWQljPvLmGtqgbMvqi4WAYy5HPHhALJjzSs=; b=
	ooyYcabaj3BBCAcpykOIedlSmxs0hlElBWghY0O4gIvnymAPTRmy8Jmak7ygR1Xs
	YIXMSlnqMmObL7dBBXibsPO2kN9BOjn9FNN0lVMEn/EPGAbPYncrTNbtt3R9ywr4
	DPpqpJiqXG6pqe75SUYWPdIFKH51dZbv/2sd9zfgnbyYXoARa/W8nOCCpgzO2hlD
	DWA4rxlpBZJz0iak6Pnm+yomDCCFwJ7SqBlBEMOePdH0rojEk9B5aCO+6CFhF6uM
	3Q9y4RrfTjgq344naEulq7aQoY55ME4644HKgwXwHIliUVANtYg9xjxPwVxvK2S/
	mY/Bchc/fIf0BD5sw8I51g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3n3mhye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFmK17010351;
	Thu, 19 Sep 2024 15:53:54 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjf6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:54 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri8u031813;
	Thu, 19 Sep 2024 15:53:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-10;
	Thu, 19 Sep 2024 15:53:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: John Garry <john.g.garry@oracle.com>, Daniel Wagner <dwagner@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: pm8001: do not overwrite PCI queue mapping
Date: Thu, 19 Sep 2024 11:52:56 -0400
Message-ID: <172676112051.1503679.5778708159769110686.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240912-do-not-overwrite-pci-mapping-v1-1-85724b6cec49@suse.de>
References: <20240912-do-not-overwrite-pci-mapping-v1-1-85724b6cec49@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=859 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: PMJNlVckM87RYiYMwdyBFu73eW0XBKZx
X-Proofpoint-ORIG-GUID: PMJNlVckM87RYiYMwdyBFu73eW0XBKZx

On Thu, 12 Sep 2024 10:58:28 +0200, Daniel Wagner wrote:

> blk_mq_pci_map_queues maps all queues but right after this, we
> overwrite these mappings by calling blk_mq_map_queues. Just use one
> helper but not both.
> 
> 

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: pm8001: do not overwrite PCI queue mapping
      https://git.kernel.org/mkp/scsi/c/a141c17a5433

-- 
Martin K. Petersen	Oracle Linux Engineering
