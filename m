Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551341E7C34;
	Thu, 14 Nov 2024 02:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552664; cv=none; b=jifL03W7sAuYvyAlCi3bHtKt93u5bj5m4VXhXd1iNjr/C+Uw9QGop8bvmaEPH3xKJgoz4cjtT+aTcZ5+UtNOERyT91gXt7BRJovUQP43x3opPAe7+wonpsIZ/8dzbTlBcpH0JJsUCXd//Q/woxCmkpg60RIPIwz/q99bH+ZjOJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552664; c=relaxed/simple;
	bh=p8AWcj8QrDoU5V0YKXJ4v0DZplBv958fJVAFp1sU4Tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWx9dOvZSVIoASIwGfgZci7kst3O0y0bEypmuDXrwk42b9g+37prAohMM4/Off1jhPeO4iaH/gCq/sJLUOO4ClkLazVNofQ4TdbvuHyrDi7Bune6vcKvLpvF6NN//aaZ2KCykti2rBY4/KTezqv2UTxzLPjZwDa892uQ3mSWSOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gH34ZjXv; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gH34ZjXv"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1fhSV008279;
	Thu, 14 Nov 2024 02:51:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=WkfP31R/7XluiquOLzTK5GOa7HzuGejPon6EZLbDMTE=; b=
	gH34ZjXvoYgvZtE6mKFVqV9yGbVKTBNBFGYpvGXoWjLCddtPMGPlS/DyQuck6GqG
	Q8Z54JdXdXqDk3Ul78dQyuJboRqQ6agD8WSPTHCpaaDl+nO0gKGZq8c1z6u20CTj
	SKx1GHEMnfRJs8WoGe3PpNJPwnRp6z28RWB4Tx1P+4F6R4Co/JvwZOes8lP4jxKA
	k+Nb9QFm2BwMgWF1cpmnqBALlz6FGcayzegyaM/+IBJyz3Lg2yaE9JcfswYbJaVR
	786cm+0om8I7+2Ftba7dlI/An97T/Jwu9mkNF6niQfrtj/PFWBxzBZ/7EIEVwSte
	FXxviaCmcvg0JpLXwZwPbw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0n508j0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1C1Yu022742;
	Thu, 14 Nov 2024 02:50:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p23m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojZ4003527;
	Thu, 14 Nov 2024 02:50:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-11;
	Thu, 14 Nov 2024 02:50:58 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        TJ Adams <tadamsjr@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH] scsi: pm8001: Initialize devices in pm8001_alloc_dev()
Date: Wed, 13 Nov 2024 21:50:04 -0500
Message-ID: <173155154786.970810.10385719120900461331.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241021201828.1378858-1-tadamsjr@google.com>
References: <20241021201828.1378858-1-tadamsjr@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=939 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-ORIG-GUID: WZiUcbnHXdADCpVBDSnnnAF0RPSsas-d
X-Proofpoint-GUID: WZiUcbnHXdADCpVBDSnnnAF0RPSsas-d

On Mon, 21 Oct 2024 13:18:28 -0700, TJ Adams wrote:

> Devices can be allocated and freed at runtime. For example during
> a soft reset all devices are freed and reallocated upon discovery.
> 
> Currently driver fully initializes devices once in pm8001_alloc().
> This commit allows initialization steps to happen during runtime,
> avoiding any leftover states from the device being freed.
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: pm8001: Initialize devices in pm8001_alloc_dev()
      https://git.kernel.org/mkp/scsi/c/4501ea5f0a5c

-- 
Martin K. Petersen	Oracle Linux Engineering
