Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62A21EB180;
	Tue, 11 Mar 2025 01:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741656008; cv=none; b=EaKGM4NRyKHqnzVOa1dlN9P/EHnKR6cCrsVpEDpMvpO6zTjWXjCKboHEQer/QVmwTQ4ttHzKWg5/uG/GLk0AaaatVWIgXh+a7pIuHMuTvYpdDdLCHHMKI2jcxePjYmyY1ZvNEKs5j3WoqN2vX7jCo0SjgQ5srVE2zmoiO6sAsoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741656008; c=relaxed/simple;
	bh=vdt9UaBpmeNtU8mFUX+rh2tW850BOjZMXqdUqdTNKHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BTfym5gSAosM4D6+NR1x24bhGUYU1wbSLlymIxoojTyqPX1m/fBf366DzpvBRiPYcpalLFiOyhe2vn17rcMnYyijZPnRVSlG1xsMgrlKONhtcDJmG0WGZew2BI72lIGnbLaAxAPTKa9wWMBUEsctFARnOrbvW8uYndhWvD4rOwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jJx/vPlq; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jJx/vPlq"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALftdU014742;
	Tue, 11 Mar 2025 01:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=u0DPz6MAEu7rcqUz+wc5x5MEZMdWmiHK5w/xmr9u2rU=; b=
	jJx/vPlqb4fO6VpFjbS6b2le/bj+HmexOdgXYzEFM8yhRVtZLxshfKBY40t1TEjD
	bHalrS9MzARz7AUEB6zrSVBjdJKsRkv2muztyHn70wCPWyXdi5oORwzaXCgHQ16x
	6WF05mtM6lGZCdWu2fuilxseQO45omJ9Z52RCUSDDjHi5W0aXreuY2EhML8kQDtr
	rGyoPybm4El3iXUki9NcbYaNO0vVJN1V2uAmjGqWiAYhK8NTGM9CISHrKwDwcxF5
	nJrM+c1Skj/CgLcOifTCAuQ0zkghLNuvDiwZK/GJPgKhPQfn1NwsPFLZk/kDdbG2
	0FmlqoQK72qDzmvx9walvQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458cacbvdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B09KMM014954;
	Tue, 11 Mar 2025 01:19:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbencnx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:47 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52B1JfrP014960;
	Tue, 11 Mar 2025 01:19:46 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 458cbencm8-10;
	Tue, 11 Mar 2025 01:19:46 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Chaohai Chen <wdhh66@163.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
Subject: Re: [PATCH v2] scsi: fix missing lock protection
Date: Mon, 10 Mar 2025 21:19:09 -0400
Message-ID: <174165504932.528513.4044722537769473774.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250221030755.219277-1-wdhh66@163.com>
References: <20250221030755.219277-1-wdhh66@163.com>
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
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=941 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-ORIG-GUID: 7sfyr7MNZSi7pjhnSbO7xEYbPveNz9cw
X-Proofpoint-GUID: 7sfyr7MNZSi7pjhnSbO7xEYbPveNz9cw

On Fri, 21 Feb 2025 11:07:55 +0800, Chaohai Chen wrote:

> async_scan_lock is designed to protect the scanning_hosts list,
> but there is no protection here.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: fix missing lock protection
      https://git.kernel.org/mkp/scsi/c/ed3e4842224f

-- 
Martin K. Petersen	Oracle Linux Engineering
