Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFD71DE891;
	Fri, 20 Jun 2025 03:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750389580; cv=none; b=joWAfJ3bwov8NmRbPIJJv89FlFqUwRmAZCVtGNo50A0gfpkV77eGOraAWGwP8A9K7GZf7bUpSFfa61yUqLYhF9cZ0PT0CTlfPgy3xYGL6zBtjbnFn+dcWX3VRICi6hau7wySPAg1UhKu11uVPl/T0+xtn+ICTLUSnVFoSN014Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750389580; c=relaxed/simple;
	bh=lghr8TA52TXj4Scrmt4LWlzpRWyRKiM9kSpz/Zih4Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QzTAIrgbem6MD94h1vhSjMllcb5VKCf0xz9+NeQEB7zeeJjEBpZcZPWoaHCMP7OrzWCjuWeJak2TF582zyF8T8gsiBL+mXqWSyohyV6RaIkaqTlL3q5jbXgB3J5yq2jHmIVnmUQjOnCuG0bxNrc1tvwNa1P2GdK/sXbmwhpIC78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k/wObMAj; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k/wObMAj"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55K2uG0D012766;
	Fri, 20 Jun 2025 03:19:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=X6D3vUT2LpoG95sdE9gTR2AlRRZ81Cszkf/mEC77MJg=; b=
	k/wObMAjfQ4LQud+h87TrdYzAwBc+5wLD8lPzhHZAAvFrt7Y8DAZCjYbfd2lMdqP
	7kgdKfTdlGuqG/WNdyn+uir3moa9eV+EWjkWnB+eRQ3kYSj6XHx2HStCmOU5v7jl
	ZMcUTDo/xfGBxv+LMjMVoRiQIvr+wktdtDCare/rMi7Y2tmWa+m8wlSG72YZWW5f
	Y4SFXmPf/JkcOZLLVwSjSHt8+hUzRtRLzLtHoDkrAtzh3j5FC8HNSFAoMLXAUh6z
	YvEuNRFZUSimmLHERDvpdzJmn3Ukhp6eOWaUHUUoPj//lL8Oe/9jv4aDwRPPAWes
	K8gUMOeS7UyEqQ/hTxBoug==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47914etvkx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55K1jXhR037574;
	Fri, 20 Jun 2025 03:19:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yhc7d62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Jun 2025 03:19:33 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55K3JU2E013310;
	Fri, 20 Jun 2025 03:19:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 478yhc7d52-2;
	Fri, 20 Jun 2025 03:19:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sebaddel@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, arulponn@cisco.com,
        djhawar@cisco.com, gcboffa@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jmeneghi@redhat.com, revers@redhat.com, dan.carpenter@linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v6 1/4] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
Date: Thu, 19 Jun 2025 23:19:10 -0400
Message-ID: <175038952905.1692313.12305897434919215152.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250618003431.6314-1-kartilak@cisco.com>
References: <20250618003431.6314-1-kartilak@cisco.com>
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
 definitions=2025-06-20_01,2025-06-18_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506200024
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjIwMDAyNCBTYWx0ZWRfX0M5xlVV6LYP3 hFEuBawDe0Y25cjcG5f9qUkKOfTdYHF4+PObKJE0k9aSPxF4Vt0DySWeag53Jx/ogoS7mVor+w7 qtxTt96+0zqaXJZLZwrb8rHU2ZchsXTTeLR+xOXogXmL35o0g03RckO06XUmA5P/dn+YxEWCv26
 YIHlGzz5+c7ra8FCo/vtUIZdoaN8aWlzH/XegGsKTQUX/S4xmjsYug0q38fMqOOUwVmvLLHZiTi jHP55iRfDN/twqzMUFgJu7ELg6lqBIz4pGrv/Wd4dZKswrCKdlJ2P1V0d9ow2PNDYfSYGRCPDoa mfU9FQpOiPz2+5pnyhJsc43ErQD0mTl3vCCoe+zvdyTqsY7KRrCsuHI3Vo5acdt/3Xv5GBvzh2S
 FZjndkJk7SjsBFvKt2sgXHVdIqsvh7ZMP0KJGHU5+xuSarMIgiQSP2utHhXqB2JEcnMlcDCp
X-Authority-Analysis: v=2.4 cv=U4CSDfru c=1 sm=1 tr=0 ts=6854d346 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=FcHpEmpoaH0EPt0JFngA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: KO4GcaCySiejxfdA9YwxXlHijg4EGblI
X-Proofpoint-ORIG-GUID: KO4GcaCySiejxfdA9YwxXlHijg4EGblI

On Tue, 17 Jun 2025 17:34:28 -0700, Karan Tilak Kumar wrote:

> When both the RHBA and RPA FDMI requests time out, fnic reuses a frame
> to send ABTS for each of them. On send completion, this causes an
> attempt to free the same frame twice that leads to a crash.
> 
> Fix crash by allocating separate frames for RHBA and RPA,
> and modify ABTS logic accordingly.
> 
> [...]

Applied to 6.16/scsi-fixes, thanks!

[1/4] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
      https://git.kernel.org/mkp/scsi/c/a35b29bdedb4
[2/4] scsi: fnic: Turn off FDMI ACTIVE flags on link down
      https://git.kernel.org/mkp/scsi/c/74f46a0524f8
[3/4] scsi: fnic: Add and improve logs in FDMI and FDMI ABTS paths
      https://git.kernel.org/mkp/scsi/c/9b9b8594654a
[4/4] scsi: fnic: Set appropriate logging level for log message
      https://git.kernel.org/mkp/scsi/c/18b5cb6f1fdd

-- 
Martin K. Petersen	Oracle Linux Engineering
