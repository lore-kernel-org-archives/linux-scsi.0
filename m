Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D099450;
	Sat, 17 Aug 2024 01:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858744; cv=none; b=BygwRJ+Z2OktHIwdaxEHklqng+fO2MEIgofuopoRG0h+snHidPK16xYVs2U/aMSddbeN5RMPMgL0TbUpksGbpcszU87VzbGa8aoEO0mTCaJ2LhAST1VlzhBLvkD8YHnNQym4N25qZ/kB81x55bxsSnkP3mHHesgQ34KibACSY94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858744; c=relaxed/simple;
	bh=QMm4nBlxCMPZGMzyCl41OFoOZDFhwAA8P34DGXBOTJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L4JJFmAFT1KF//Bm1mE0EZjhc4c0KDzaSbaCl1Go5Ley62gQE+JVL2d+wIsJRPHZNlJvo6xlwslFInKKRcmWqofOeeYaSJJt4l8x8oi7Nr+hsr9udjGWm2WFirB+Kz8B+ugQi3X6UwA3EqA6+RqAqpxD0h6PCyk0f9KOQaLkIV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TA53SHjR; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TA53SHjR"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLCq4m015242;
	Sat, 17 Aug 2024 01:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=LcapOyQiE+5zYtdayRFV28BEHqVbkdOXyg++ZCIH1IQ=; b=
	TA53SHjRAbH0tAYjSgQswaUWWXM9oM50LrDpcxK0lPX+5eKZRi5w5cuzIhBP9zef
	8FDiPc/GIwkyYd9eimRYmrpzS0YQoM9JwpaQAI+IRft31Na/rckHUETKoRhRVkwm
	8zO6L4cCzoHnP06OdZYXLUxxC7oYOHq/m2Amlsr4Mhp+A3GH0pH2BzkzUbNs+Kqh
	2cuhvKYnwhb8nHF5APlsJKQZpRMyXFf6q1mUQ/xkUCmojw5nfcxivU+1YXAf+xBW
	5gQ+Fif1+hexPS1YVjBwrxZcgH1ahAOm6UUcSf6bfiAA9WkY2lEIxn/NI3b5Nl1E
	GbU6+r8AVywMZsr76RK7Nw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x039dhtb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:38:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H1XT9x034951;
	Sat, 17 Aug 2024 01:38:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 412ja5r21s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:38:57 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1cvkd003271;
	Sat, 17 Aug 2024 01:38:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 412ja5r21q-1;
	Sat, 17 Aug 2024 01:38:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Rob Herring (Arm)" <robh@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: ufshcd-pltfrm: Use of_property_present()
Date: Fri, 16 Aug 2024 21:38:22 -0400
Message-ID: <172385819628.3430749.4587403453049798462.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240808170644.1436991-1-robh@kernel.org>
References: <20240808170644.1436991-1-robh@kernel.org>
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
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=857 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408170009
X-Proofpoint-ORIG-GUID: ttY2dSS-7wBkMT5z3P2J3mLSyGzUg4W2
X-Proofpoint-GUID: ttY2dSS-7wBkMT5z3P2J3mLSyGzUg4W2

On Thu, 08 Aug 2024 11:06:44 -0600, Rob Herring (Arm) wrote:

> Use of_property_present() to test for property presence rather than
> of_find_property(). This is part of a larger effort to remove callers
> of of_find_property() and similar functions. of_find_property() leaks
> the DT struct property and data pointers which is a problem for
> dynamically allocated nodes which may be freed.
> 
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/1] scsi: ufs: ufshcd-pltfrm: Use of_property_present()
      https://git.kernel.org/mkp/scsi/c/fd9cb9615fca

-- 
Martin K. Petersen	Oracle Linux Engineering
