Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC9D30146C;
	Tue,  9 Dec 2025 03:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765250487; cv=none; b=eEzod+8dcBdU5pNeYwnas9yzoMQtIgdDEEgKVmf85Bz5b5njquEwzuedgYnQiIbejR1dIqFS0Yyck6jaY8bQpo6F3l0XV37E0dfUs5mWot7i01PIxdIEowuerbbpUHvZY8VX249+eGKio7DomVJddyH+LCVA/ZEh1UQO8yXpDt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765250487; c=relaxed/simple;
	bh=1uKzdL+7291xLk02/UwsVPxNOoBC6RW0QT8AUviuRKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i0OVUrZ17ALekJTPib0sEBE5YML/XnFr6YNpBEUwlo1H90haM7ea0tngnjyL4qTFCwnITKRg3eTz9ixxmS5axi81ju7PZAWVY+SvpIIOO91kvfhMn+eOGV1aGSYxV5TB6pXwcKhU3zEFlvzxe3jtxDenpn4ohhhK2w/K77Za+GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dXuPcGjz; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dXuPcGjz"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B91vJ1f3883315;
	Tue, 9 Dec 2025 03:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Fh9Yf5aMPzzQWV6DqYkZ3Z4x0vfjCRcp4nB+XAvfXDo=; b=
	dXuPcGjz96Er2c3ug65LTbKoklC+SydYMQGye0MsPcHLlmnfC5L1ISCOw/baacpe
	KavrNWsUkTQOJ/cd2G/7o7g8+C96eFKqHhf4o/m+GReXD0k/naGPfrCkwDaKqjDW
	3bwqKDlmWkPzVCmHvxl0kN3QRckJxvHzgauoB8O53SCx016NfLulHOKFRbridUEE
	+qd1+NV2fyvtPHt1Dp1pFCMxQCCu+W5cbPM5IMR44hwi4MudrcZ9k5z0AXtUATP5
	k66K5rhuBw+0ptE/bxxTDuHNiUTtdjrPhJcK9eH3k3MPikZT+uSZXKaGErkWgC42
	Piy9BVYmlFny6sU/6QNx0w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4axaj6g1yw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5B91WAu5038445;
	Tue, 9 Dec 2025 03:21:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4avax8j02c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Dec 2025 03:21:22 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5B93I4Fc022652;
	Tue, 9 Dec 2025 03:21:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4avax8hyys-8;
	Tue, 09 Dec 2025 03:21:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, ranjan.kumar@broadcom.com,
        chandrakanth.patil@broadcom.com
Subject: Re: [PATCH] mpi3mr: Prevent duplicate SAS/SATA device entries in channel 1
Date: Mon,  8 Dec 2025 22:21:07 -0500
Message-ID: <176524933124.418581.4165861558099763589.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251120071955.463475-1-suganath-prabu.subramani@broadcom.com>
References: <20251120071955.463475-1-suganath-prabu.subramani@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-08_07,2025-12-04_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=876 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2512090023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjA5MDAyMyBTYWx0ZWRfX8Hp38NQwZw7u
 eoFsoaNg3zUcnkDZBYdob3LPMHmbZcIojcsgawy82GaUhN7AqyGle985k2edkN+vP0XtGuMzyCx
 vflAbFBkrGf3ACSpIaYfBoya5zO2nJ9VonEk76B752ATeUC1CKG4CDwKhtyoDwK0/R+jJeLA2Z7
 oAb7VvBMuAIVUcVV7/yGQ8NUBP1H5ZcXKbl7ElmcHHpFzIbB/48vciT7Q7lFzJTCSgZkKq30zOl
 apr6WcNisg1jaR5M2hJ8D/gWJXy2Q3cCDSHWrsJnfDswIx3pWp8jNvoqxu4E5LqYuEiVI9VxSb8
 EdwBUZjZJwElG6Mz17atEIhBkiuibLunEMO7vNTPRd5NM0hghSA+eoaGoyJetTSmGWJebL0mFq6
 EHVDzezamCqIhvN/l7gTPtv0ghzsSw==
X-Proofpoint-ORIG-GUID: Schw4QMt3R6OpI48h3RcDiJvPkpc8NsH
X-Authority-Analysis: v=2.4 cv=cs+WUl4i c=1 sm=1 tr=0 ts=693795b3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=bwOc7vOLZU9KT1K-0XsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Schw4QMt3R6OpI48h3RcDiJvPkpc8NsH

On Thu, 20 Nov 2025 12:49:55 +0530, Suganath Prabu S wrote:

>  This fix avoids scanning of SAS/SATA devices in channel 1
>  when SAS transport is enabled as the SAS/SATA devices are
>  exposed through channel 0 when SAS transport is enabled.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/1] mpi3mr: Prevent duplicate SAS/SATA device entries in channel 1
      https://git.kernel.org/mkp/scsi/c/4588e65cfd66

-- 
Martin K. Petersen
