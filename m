Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9C34436;
	Tue,  7 May 2024 02:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047279; cv=none; b=O+pio0ZDRW6jAqMSbLGJ2UFIlTDGxb37dFVzObOa3p1ti43/vPzEParzPtJfmBL7ZyN8vtYveG20s7hOclELz7xUAkiVQENK2gts0u1NeGPmn0FDylxqIWT+O9djQc/uwpfDKSGdFuQFx2PV1gZAmePUxsVDQ16lmNeLv0wZKLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047279; c=relaxed/simple;
	bh=tnOpAGDJtyArCO6SMoyx0VgTyknxh1CeIy4yF66KaV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pBhYMtE0ZxiNVrT5tZfw0Zz9HncqKGmAWmUWqqpIMpEIiSWnMJaHZHY8NasyCvFgOoVcmUjzaspDU2UYSIbZP1Yp0ZTv4r5nErwvvRC+CDvRBiwRIeiLstsCjORiaCmO4xACKsrZi8dmgHWK0MacLzLdRrrVXjY6grvSTs9008w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hDqMXfQX; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hDqMXfQX"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqQTs031533;
	Tue, 7 May 2024 02:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=1C7X7yH3jIjyIskdlcoVFrQymIyuIt+SsTF+ZTvp9lQ=;
 b=hDqMXfQXdB5FzOG7HxyWBGtyIQHTqwnzH7Q0dwqluwOdrSTvd8P1UoFTq05pt+ydbhZC
 JrbxE56pPkdiJOeJEHUtBBnnI4wZ1rZu3JkKdPE/cemLsLDRAmxaW3NQKWi58L0cxQes
 aIQOQ0mvC2YzY8IjNK/vohi0lcX+pLFwUapb7+xRKifGzTuBcn4CCSsAYUSXSm6UL/1L
 qyK2P2h/l7XAUiwJcGyRLBpM67P+oMrpkddBTIaNLDbaXPSJMs9VltCD+WpXpO+lrgut
 NMFFQtSa7Byjtd6n/6IVrY/tz5pTYc86GyFRO3yXFkfpJpD+4PKI4NIXapMqF54KtTTM cA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwdjuuuw0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4470Ge5K006999;
	Tue, 7 May 2024 02:01:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dbvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:15 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721Elx034149;
	Tue, 7 May 2024 02:01:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-1;
	Tue, 07 May 2024 02:01:14 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v1 1/1] scsi: Don't use "proxy" headers
Date: Mon,  6 May 2024 21:59:48 -0400
Message-ID: <171504445059.1494912.2618353960474358487.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423211843.3996046-1-andriy.shevchenko@linux.intel.com>
References: <20240423211843.3996046-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=895
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-ORIG-GUID: lEPzj5qJiiPqfIkrtvt5Op4oliPwKc2G
X-Proofpoint-GUID: lEPzj5qJiiPqfIkrtvt5Op4oliPwKc2G

On Wed, 24 Apr 2024 00:18:43 +0300, Andy Shevchenko wrote:

> Update header inclusions to follow IWYU (Include What You Use)
> principle.
> 
> 

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: Don't use "proxy" headers
      https://git.kernel.org/mkp/scsi/c/2a7177a80457

-- 
Martin K. Petersen	Oracle Linux Engineering
