Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69481315D53;
	Sun,  4 Jan 2026 21:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767563022; cv=none; b=q6e6k4FklPulQvFdAxGXccTD1HJ9z6qmagYxJ5vnPCvmyR6MVLGLIGaD+WWe+HrkSDe001J4ACCc7wbZefqoLVnWCu/Bz21oe3UAJVfUuSHvQ6GFi9Y0ALwQwtjtkDkGkuU8UM1IEQWOlTvHzHJLs+hnRVnkX7ZNlIX7aihT2uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767563022; c=relaxed/simple;
	bh=RS4XlAVtaDHz8Du2+tLxCwQjTSc01qcTnk254Ff+XqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FjkVwF+Q4zkONu4yydU4NSzAJT5yr3kSKBYijKwvjRc4feXVM/pfrjN/hbqMgxCwzBgw20RAGiXUK50E4Z14Tb7Gfvp0kWpS250MEhIE2PNxuwIdwL7O4dcRYb4NAPU/DIMwL3WLkFskQL8VdFuHQNCYtWToHR+Kp4IjidSGP0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QV3r2Ced; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QV3r2Ced"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604LdLai4166512;
	Sun, 4 Jan 2026 21:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=pSd8NFRRHtrws/sq1dSpXLcNde2tfzsNa1McirABk6M=; b=
	QV3r2CedODhfTzSlpmGgMi0iWfIT1NQRsLcHCeP90UqoH5DbspLxtxVJg2qXnwxw
	QwuBUmrefnzCymGVvbBL7NRF/fX+YjaSI45OoYRY4QNCGmQgPzcLa4vL1zfDe6uc
	+cxE4vJCoyA6QR90bx3qcshiR2Co0LMxHIsPvAa4S1Cgotu9V2fCkV2j/5J9LnRH
	yk1OC0zU9FPhg3nBk+BDnOwHrSKsK1E38tXzU5CxML+wKzlRyWrsCrJxZwWIBuW7
	dvFOl6iGI+nocDY2x3DRSwHUYtFyQXXVurYY9MRb+FB3TLH37qTEx6VrUhrV2Pwp
	6Kg1l8ul2Y4azZ9z2dL9vQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37ry2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 604GlorB026603;
	Sun, 4 Jan 2026 21:43:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj6gbhe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 04 Jan 2026 21:43:31 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 604LhPoZ007658;
	Sun, 4 Jan 2026 21:43:30 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4besj6gbf9-7;
	Sun, 04 Jan 2026 21:43:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, bvanassche@acm.org,
        vamshi gajjela <vamshigajjela@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, avri.altman@wdc.com,
        alim.akhtar@samsung.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: mcq: Refactor ufshcd_mcq_enable_esi()
Date: Sun,  4 Jan 2026 16:43:13 -0500
Message-ID: <176755562233.1327406.14849946433146315508.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251211133227.4159394-1-vamshigajjela@google.com>
References: <20251211133227.4159394-1-vamshigajjela@google.com>
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
 definitions=2026-01-04_06,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=614 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601040200
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA0MDIwMCBTYWx0ZWRfXwN/R9P9HvmnK
 bLzQGDtb444ZbQ2T43rJHt+NU6RX2nsLkT/0TC016qzOPgaIqkNuOCieoE4GlppMXZRU+H+5p7H
 zgdyV0bR6IdqXArHiJ5KtsQBDEVHSB/DE29jjLBWdC3nFbHtzHU75ejyQ6UEGJ2whlRsDd+Ewsn
 AHY2er2B3GC7vBpZpdbGyaHAl4G9UmGAUqOE3WSuc24cq/ber8LyXCeYgsnbTO6AlB6asKfxp+7
 ic6SlcrQWnodp9I7fId1NCiGsFMudlVmEuhYbLJflqQ1KWrF+nbP0szbKpR8WCKh+23rhchIsVL
 G4GTDiCTTtNacE4nVa+GAn6U8rcoTH/rvQcGS2hXcg90+vtM1nby2C/dcvsqWLWr7D02Q2IVEqH
 uDzD5sc0tkhadRn6SGmIbE6hNaJ/RVY3SUyOjEPmuSdnJg1YvEyCeJRGFbspd5bymEbJ85EGT/U
 UalgfkAmaCmJK/mEvZw==
X-Proofpoint-GUID: 6K-Z81sA-VJJloyMCroWbImYcY21Ewfy
X-Proofpoint-ORIG-GUID: 6K-Z81sA-VJJloyMCroWbImYcY21Ewfy
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695adf04 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=XxCRF_-3nFg9G4p_WkYA:9 a=QEXdDO2ut3YA:10

On Thu, 11 Dec 2025 19:02:27 +0530, vamshi gajjela wrote:

> Currently, ufshcd_mcq_enable_esi() manually implements a
> read-modify-write sequence using ufshcd_readl() and ufshcd_writel().
> It also utilizes a hardcoded magic number (0x2) for the enable bit.
> 
> Use ufshcd_rmwl() helper, replace the magic number with the
> ESI_ENABLE macro to improve code readability.
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: ufs: mcq: Refactor ufshcd_mcq_enable_esi()
      https://git.kernel.org/mkp/scsi/c/e642331c9420

-- 
Martin K. Petersen
