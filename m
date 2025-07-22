Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD35546BF;
	Tue, 22 Jul 2025 03:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156185; cv=none; b=REXZaizIv3a0ZyCtDGdh077grj5ZyEaN59Waks/QorYCNiiujsEphk7V4Dq+v8QcVwt4ojXj/EZxuv2Hz1X2x+tycvLcQ7WhG2utO4xX/b/6g1H+Z5Vu+R6iOUw/PG/VG8pi9a7h3Ha5Vn6X2bSSLvdfezCjfkgU+QtAj3wp/Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156185; c=relaxed/simple;
	bh=1sAJw5Z8pGpYqXjM91kFENsuF2VTncuGNJM3z2Z/HUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KH04ilHEDuxNps8cM7RM3ZaVdm2f/Sl0KbZOO6Saac1zqKi2jKEFTo3Gv+Vk+vfnuhynfoWck/s/RFxG3/Fm4YFdm9w6szh/+yOFtO3S+aO0N5oY75Ncg4W6sIK5LqWH2PBx9NPyNDaI+LWsiPGSzd16/7tqf63RpEU6A+DNGTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LuMsOPoT; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LuMsOPoT"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1Bx9J019815;
	Tue, 22 Jul 2025 03:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WMPnQJM7Rf6E+qkjuPWRmvwT+AvEva0iBF2oYQUQVw4=; b=
	LuMsOPoT0Fj0oZEm3JTbgTRGk3Pe8OT13s+Il88WA3EygGq4CZ7la1P1K5YEa9Gj
	mfzwKQJni7MCUanAXavEDW+fuRqMMr1uTyEtkuye9lKPg2qOps2sM7af1CO/vAyr
	9LXnGdgfQUhJqiDeoo+PKpwV9+TUCl8gQSmS+HI5h6djGi73xckEwXvN007aa8uC
	IwqG9bqX6ulzYtExjot9RX6434UFRfgqnn4lp7RSLSU0ulPwKy/0poUTpRx/nUP2
	0/J68twavzsMd6oTJIdif5apBuOJhaHI7iTgP84yRtVKpvRLDutbttxoYmZNGpJH
	dKDf4qM/SqdtptiGmL7/fQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805hpc8sr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:38 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1M4Ww037738;
	Tue, 22 Jul 2025 03:47:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8tea1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:38 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZj9031915;
	Tue, 22 Jul 2025 03:47:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-6;
	Tue, 22 Jul 2025 03:47:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Steven Royer <seroyer@linux.vnet.ibm.com>,
        "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>,
        Michael Cyr <mikecyr@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ibmvscsis: Fix dma_unmap_sg() nents value
Date: Mon, 21 Jul 2025 23:46:59 -0400
Message-ID: <175315388520.3946361.12422996243439246848.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250630111803.94389-2-fourier.thomas@gmail.com>
References: <20250630111803.94389-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=656
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Proofpoint-ORIG-GUID: ur1xi85gw-OwfzHkbqyD5E_f3N-Edvc8
X-Authority-Analysis: v=2.4 cv=YY+95xRf c=1 sm=1 tr=0 ts=687f09da b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=HazmFS4AVfT1MZ3w-mIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: ur1xi85gw-OwfzHkbqyD5E_f3N-Edvc8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfX6fI/t7ggWoFu
 +FMoF31Z/MmXltbLFurOX9cbf8bAllBf6N4N1cZu2oFOdMHITMCbVCU1sKMzJzf3B8kMVcr4EJW
 3j86eH0COP6oWYx1sMlgASYzRZ8ItMgfnYNlngeORRP+AfGNHuSFCkZpVEYRA33h1HNSYy6PzNu
 Q0Ps2KPdF0UsSS+e6B4Xp0TF7tklY7rLH5jmFCnlwg2wIcZplwTaLlc2DzmcoOYsSkMSDPecznD
 NI2qhsibgZfa0O47WWTL4697BULuB2rZPvPeEvwVBnhbjeUq+nc1/DCySz95M9ObC2tnJSLamXk
 JfA74MR0DhpcqI9F+vePbJaC+3LLekCoG9mHXdGy3MCAenWf5tOZVBzkRFf8nJjVGVt2IQntJSl
 UGlRegwexLmG5gF29W1rtONDG4pvT5QtksPpuhPZyXGBInC17nWOHK02Oo1ewkrH5B0ncSOh

On Mon, 30 Jun 2025 13:18:02 +0200, Thomas Fourier wrote:

> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] ibmvscsis: Fix dma_unmap_sg() nents value
      https://git.kernel.org/mkp/scsi/c/023a293b9cd0

-- 
Martin K. Petersen	Oracle Linux Engineering
