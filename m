Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84226302741;
	Sun,  8 Feb 2026 02:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770516127; cv=none; b=I/fAQHFy8ieN9KkoFSJjXOrymbbW68oE+hXF7Vfmw2JswqypuoZdohWfZrTVQnvJ7An8Pd4xT+aKp5M5iW+jqH/bUhmL87Nlu/NSNKDGai2LMRYcJtEoGmcW+cCOPEbrkgripNs7gjacspg+/L1w073IEeuTRM+1pecYxLi8qhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770516127; c=relaxed/simple;
	bh=UMkNyF8pabDul+WPVdh26ZwxeLz8oUfMN/BK3SLz1Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oxDEDa6RN1BbO6weWtQfYqcAyGXS2UYZn5U5LDRXkG0aMzFzrNsBlN0G5V/o1HZMhDENNiiYLgYPhJVaJtFnQmsA/rqmjShdN+E49leBiOZEsubTsqcDoTYz/F4VT/jtFyxo4iAAs8aYxhtmAkckf1hLRDlkB3XqfSw4QgSpLnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DHKTdUHQ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DHKTdUHQ"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6180fB9q1772052;
	Sun, 8 Feb 2026 02:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Sht3yMh7VfZ+A/rOVutnrwTV+BMcvQ+u9ma4XM65taA=; b=
	DHKTdUHQSxRqLSV7shH2AyU3HS778Cbtl3PsUlNtvYuAnO2MH181npkya5kTHzkS
	U2XROtUqZcYQoOs9eO9CoqDkyzYT6wAOa9J/oxGtRL+L5WHiHQE3lbUB3g/gO89l
	cfEjdnfbVlPvkn/8MDPozNKECuU3BHjVMrG0UFQWDfLNFapsdAa4Fuu0hlJJ1X/9
	zXcxaRPsHhez0+sRqqQVO/H+CF38XB1caXWoWLoGun4riz3o6Fkwg5IJ1rw+zmRh
	3E4TrHqchLswqItgbCb6Frw2U8XcGhriDFoele+1nNIt6mywmOTLp7TB/t42D6Df
	ncoGWAqHKXOPgyClmCr4gA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xjyrhpc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 617NUlqk006419;
	Sun, 8 Feb 2026 02:01:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uubuk56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:58 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61821sxT016745;
	Sun, 8 Feb 2026 02:01:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c5uubuk3y-5;
	Sun, 08 Feb 2026 02:01:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Naresh Kumar Inna <naresh@chelsio.com>, linux-scsi@vger.kernel.org,
        Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: csiostor: Fix dereference of null pointer rn
Date: Sat,  7 Feb 2026 21:01:46 -0500
Message-ID: <177051564512.3805738.5081274265175542279.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260129155332.196338-1-colin.i.king@gmail.com>
References: <20260129155332.196338-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_01,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=708 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602080015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDAxNSBTYWx0ZWRfX3aJt8fCUn8CM
 Hc2XOZ8sj63JKWVtaN7C6T7TV/oGxbfVnr0Q4gcUPGfAwqs36XWdwDlH6fKr545GLgAkqzrGRbY
 WTA2Zn5x2ZZGX/3jIZQbhAtsjCGSYl5rLZtEGFzAte7opBKl/8IO2KtKNA43X+6f5pBtawaSC3j
 qnMqOciBuhfNxBwPra7tQRF53ZjRVXL91oCCGV7ciomgZcM5258ZC3kR0BPf+Ykthh7YPNaLx0g
 4DN6R1VfAC0YBW4J4i98uOCvWh5T8HUNijDFVkg8rP/tM+U0PrFEgKB5ibfdW8RVyjkexU0yzPi
 9aZFrVJitk7wNLKoH5v5hcHJMgnS6o0bNVKW0j9SwCqfFSYpRSrdydSSs0uvkA0NSGrHBu99X4y
 aDQLJYrfg/Nt4nQEXbKKits8uPMbHfXbM2jhTVXKBn11un3eqO6dVh9XIAwycIsVrIFWN178s2P
 I8BsOl33ivBOXXVLYa0zMyRbMp7J3nkfcVyPQWEs=
X-Proofpoint-GUID: JRiXaBtrQvwCI-IIJIBSjtUNWkieUt88
X-Proofpoint-ORIG-GUID: JRiXaBtrQvwCI-IIJIBSjtUNWkieUt88
X-Authority-Analysis: v=2.4 cv=VPLQXtPX c=1 sm=1 tr=0 ts=6987ee97 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=3mJz-fqBnx0cWqyjKMcA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10 cc=ntf
 awl=host:12103

On Thu, 29 Jan 2026 15:53:32 +0000, Colin Ian King wrote:

> The error exit path when rn is NULL ends up deferencing the null
> pointer rn via the use of the macro CSIO_INC_STATS. Fix this by
> adding a new error return path label after the use of the macro
> to avoid the deference.
> 
> 

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: csiostor: Fix dereference of null pointer rn
      https://git.kernel.org/mkp/scsi/c/1982257570b8

-- 
Martin K. Petersen
