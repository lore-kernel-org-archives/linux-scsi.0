Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20177462;
	Thu,  2 Jan 2025 22:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735858041; cv=none; b=MFg2VtuupNMKgpRu/lSlA4Kj8DlL/VfgFjSwf4BlNTq00qL5yeJ2dSsT31SAx3jVJjgietptTw4EhbanuiFqzfKeCboXrlP56SRZc0v+3MtLgoVy+gIKty5SXbwHVaD4pJPsu+q7o53sUjTe2oA0PanAnYQzRcAULfbLO02L7/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735858041; c=relaxed/simple;
	bh=xn0Gvxmpq3sCJlFD5wLuUjhPP0d8tS+FiaplLijnHUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ayi6C/2ZNFMiArBjnkKudhZnB10HFFEoRO45Va3ZCXnjXpB2ayvYpDWeeVLGwlC08+hQOqaW5bixVCe1NilKkZXITZ6Watpy0LLJ9ODAXw2oCeH3e4f/zSIep+VUKg5YiXI7SVZcsUjeojmR3u/aoF9T4ZjPdhY3V0dBo5pYBtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QgAK14fk; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QgAK14fk"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 502KfuQ4030631;
	Thu, 2 Jan 2025 22:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Gjo6fdzrYE4PhFRTs9ndQrk9WC3uUCywnJRN27P3lsk=; b=
	QgAK14fkD/Q23UEitKGnGaZR8M5OSkPWvRB5IpNjA4ln4tu1BpefyZIAnNsaiX6I
	tJZ6jcEiakpQ2vQQ6OkAlY5gt67xbO5Q+lTA9w2xsjY0sPPHZcUllesWrXPYV8ik
	G2RdE139HVmUahKXENVtz1vzEYwxhRCK8VLIynd+iWkuX1jsvFWI1hAtyXwwqZt1
	It6c4o2uxW8F2bEhnEr6XMxryY3Ia4PIEdg70bh0qNLYYup0ZAzRh7rS2DjRLosd
	5+WuRL5mL6L3iLb56nLgLjDJRECUwcdbHPQAWlKn8NXyYjv3w4PM/FyoJl5VlSPE
	r3yl29N6eCLbG2HWqRVAZQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43t9chfdr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:47:16 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 502K72i5009443;
	Thu, 2 Jan 2025 22:47:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43t7s93nxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Jan 2025 22:47:15 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 502MlAth004461;
	Thu, 2 Jan 2025 22:47:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43t7s93nuq-3;
	Thu, 02 Jan 2025 22:47:14 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nihar Panda <niharp@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH 0/3] zfcp changes for v6.14
Date: Thu,  2 Jan 2025 17:46:39 -0500
Message-ID: <173583977784.171606.5545700115595892014.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241205141932.1227039-1-niharp@linux.ibm.com>
References: <20241205141932.1227039-1-niharp@linux.ibm.com>
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
 suspectscore=0 phishscore=0 mlxlogscore=968 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501020199
X-Proofpoint-GUID: hGrceDJC0iwHuPCHy6FCtfMStzE2PQWs
X-Proofpoint-ORIG-GUID: hGrceDJC0iwHuPCHy6FCtfMStzE2PQWs

On Thu, 05 Dec 2024 15:19:29 +0100, Nihar Panda wrote:

> here is a small set of changes for the zFCP device driver.
> 
> Fedor Loshakov (1):
>   zfcp: correct kdoc parameter description for sending ELS and CT
> 
> Steffen Maier (2):
>   zfcp: clarify zfcp_port refcount ownership during "link" test
>   MAINTAINERS: Update zfcp entry
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/3] zfcp: correct kdoc parameter description for sending ELS and CT
      https://git.kernel.org/mkp/scsi/c/9fe5b6130baf
[2/3] zfcp: clarify zfcp_port refcount ownership during "link" test
      https://git.kernel.org/mkp/scsi/c/32574fe6e19d
[3/3] MAINTAINERS: Update zfcp entry
      https://git.kernel.org/mkp/scsi/c/bd55f56188ca

-- 
Martin K. Petersen	Oracle Linux Engineering
