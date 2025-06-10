Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3E31C84DD;
	Tue, 10 Jun 2025 02:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749521248; cv=none; b=QKnguU9d6k7dezZroFhkBqDzEEvueBDegtlaAwqT9x3c2trrfcL+AoEdErKGtM16EP8FrnAAmcqwwhW1tCEY+uwufqsi+H3Y0tXl0+j904Y73ds9IB6pAmPxo3Zo8dyvdHXoH00fXqWEJroOtxzkGU4vFYP/wG/GYXmnpIifBXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749521248; c=relaxed/simple;
	bh=PTwP4DILR1ZgMLefVOft2PWLCZ2BmHDYdqe0+nXyBdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HNF4+dfab5A03tvvxwgllEOtQW4j/cHyLGYqmiQqeyonpHpQTqzZDlaj41p6anR9B1cCkqnXrDSG2WslROn7gjM3sIR+E6RMo2CVGAJmPq6rerO+LGAjOxSmmzEoE6yFFoJ97OEX5QYy+FDcaYEAIe6pilZjfrE34LoomQGY4Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PyPAi9X+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PyPAi9X+"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 559FiTiv011582;
	Tue, 10 Jun 2025 02:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Hcao3oqcJiTPTivIikuH7r93UTzBCV/GTaTzIqXzKSo=; b=
	PyPAi9X+ujv5vLKIvd9b2L9YQv6VT3vt9Rg5ESK4O5+RYoXA0ZM4mdw4WzoH2+kz
	2e2VkjeQLRiALfm46TEBxJvNw7RizSDUlsfgv5GVs0uounTOl2pNRkuLB1/OnCU1
	CVf6T5rKScLRoU0/GHm5J/Gw8tReBnvqePqc+uX/peQ5jzRFx6Lsn+xtF31B4rjL
	4T/O89ElfKn7eO/7SgkXXc0CVP9uIBn3OW1Wtewm2bT5s32xjsdunG3GgmkBjDt9
	JzgmN4mu8Wd2gU/NsCEsO+1Ttt7UyP6aDgq5Ace3iCTVMQspukPj4T77vN1UW9Dk
	eJEWG+Ct9Hmp90gHyojIZw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474buf39bj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 02:07:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55A0jJx9031998;
	Tue, 10 Jun 2025 02:07:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv84jgc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Jun 2025 02:07:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55A27Kr0016523;
	Tue, 10 Jun 2025 02:07:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv84jet-3;
	Tue, 10 Jun 2025 02:07:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nihar Panda <niharp@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Nihar Panda <nihar.panda@ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH] s390/zfcp: Ensure synchronous unit_add
Date: Mon,  9 Jun 2025 22:06:47 -0400
Message-ID: <174951883638.1141801.4092943028769739009.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250603182252.2287285-2-niharp@linux.ibm.com>
References: <20250603182252.2287285-1-niharp@linux.ibm.com> <20250603182252.2287285-2-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-10_01,2025-06-09_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=984 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506100014
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=6847935c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=iJjEDP7nYTzMqzp7gXkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: JWiXZBSr66StzwurPf3KoRj28AWoSXYa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDAxNCBTYWx0ZWRfX2EXxuT/ZQmWZ FKzUm69c5mw1bHa014r/dguU1w5EaXTYoYCaf6ogvXV9V3/vpPj2XQwVu4GdDKGm1wCRauUBXw9 XU0C+S/9yacX62OEzzMqGMIGE/GPw7NmQCyovKzdgJDCXa03tqr99TaLrPFjcHP0Zl2sG0itoUb
 ATC7afz/Q94GK+8sxHMKxHPLfcVyKLstzbZW4jc9Q+hsmdssGbFe5uWMzp9vhvQuz5iTFfAuEUQ LO8AYUIH3KAfuhS2r84wRFQZOKv3f1O3iMtX5xgWqnSjBguYilzNVUlQK+XoYSHjT0uJt3XLiq/ pJvUv0gHazI/XuJ7yopPJttsG5kvvbMPXyM+ZH7BT/x0W9uKWzuG+EhWmGG/DBR6kGbGwqMm4OR
 b3zvAZDXw7qyBNS4O4QmaXEfw1kXAdtUIylMXmDxaNhHK/2kCyW8Nw74r/l1iDtBOilHbleo
X-Proofpoint-ORIG-GUID: JWiXZBSr66StzwurPf3KoRj28AWoSXYa

On Tue, 03 Jun 2025 20:21:56 +0200, Nihar Panda wrote:

> Improve the usability of the unit_add sysfs attribute by ensuring that
> the associated FCP LUN scan processing is completed synchronously.
> This enables configuration tooling to consistently determine the end of
> the scan process to allow for serialization of follow-on actions.
> 
> While the scan process associated with unit_add typically completes
> synchronously, it is deferred to an asynchronous background process if
> unit_add is used before initial remote port scanning has completed.
> This occurs when unit_add is used immediately after setting the
> associated FCP device online.
> 
> [...]

Applied to 6.16/scsi-fixes, thanks!

[1/1] s390/zfcp: Ensure synchronous unit_add
      https://git.kernel.org/mkp/scsi/c/9697ca0d53e3

-- 
Martin K. Petersen	Oracle Linux Engineering
