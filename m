Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9989D208986;
	Fri, 10 Jan 2025 21:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543859; cv=none; b=YMhrBmYq7GSGgBWibqMeWOIi/ijRDpCnH5wJJjrpj4lVKB6d9ms3TBh2wAmwYRUsGcpT4j8HFdoAArtq0q+BGyoBegJmCkd5Gu7FPUw7RjRNnYiOGP7I59/q+j6e+FsHyir+ywXXXOCyTjTJ+tdSO/asiislU1rZvcvd+iqq9vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543859; c=relaxed/simple;
	bh=cx5Qo919KvcGWlYYmPXzAPvqI9JBs/kK1w/32WKh60w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pA0E4QnHfkQ3IreVvM0k/m55EA57koTYbpX2tRMeZYjoQ0HLS842GG75wl3J8qUXDFpQoRXZieagmgVezou284h+nhNLDl6lVJH8DIuho7HIgK9hWBNLnPe4kxA8MX+PoxFdiktUr22AOKwOwgBRkItGbjIZ+ZVhTy2ixEA2oy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CIKv8p8z; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CIKv8p8z"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBuZo015604;
	Fri, 10 Jan 2025 21:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=aFHoH/Imogqe9IPskBCTEq6eLTfK9A1oggfiADBecpc=; b=
	CIKv8p8z3J+f+nX0LiVXis/YefJiTOiEJbW6cAadHucx1AjoHdaHOPNRqph5oEUs
	8i7FFVmfx1ZcaMZbvAMr2D7Ah84RmJStLXtfSsWbGvMwjqOL+iS9PrJPoXwiDPp+
	fAKKkYtFcRbNxF6wpCEJszXNJL+1hF+ND/3wpB+vFnyepddEMPonKoz/aaiEQsK9
	RfJm73w+ghu8XsHkRwaKuywfIymaT96494zAr/tEkavLHQ6R97iY6E573JaBtW2u
	sTzZ+uymlOCMhpcdSzP3qa6bRpQSLR1c06Mu7BWK0lZOFtklL3Fxyn0UUHMi+l68
	myJeDQUxjp4OY8IrtK7m5A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442my6261n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALFOBU027463;
	Fri, 10 Jan 2025 21:17:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:33 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ20034137;
	Fri, 10 Jan 2025 21:17:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-6;
	Fri, 10 Jan 2025 21:17:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: artur.paszkiewicz@intel.com, James.Bottomley@HansenPartnership.com,
        linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: isci: remote_device: Remove unused isci_remote_device_reset_complete
Date: Fri, 10 Jan 2025 16:16:48 -0500
Message-ID: <173654330170.638636.8821257150404113284.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241223180218.50426-1-linux@treblig.org>
References: <20241223180218.50426-1-linux@treblig.org>
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
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=707 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-GUID: lohTME6pECIpyvMZiRpDdJt7FEgPDGg7
X-Proofpoint-ORIG-GUID: lohTME6pECIpyvMZiRpDdJt7FEgPDGg7

On Mon, 23 Dec 2024 18:02:18 +0000, linux@treblig.org wrote:

> isci_remote_device_reset_complete() last use was removed in 2012 by
> commit 14aaa9f0a318 ("isci: Redesign device suspension, abort, cleanup.")
> 
> Remove it.
> 
> It was the last user of sci_remote_device_reset_complete().
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: isci: remote_device: Remove unused isci_remote_device_reset_complete
      https://git.kernel.org/mkp/scsi/c/5d10344ab652

-- 
Martin K. Petersen	Oracle Linux Engineering
