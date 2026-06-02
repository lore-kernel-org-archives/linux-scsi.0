Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C595E34C140;
	Tue,  2 Jun 2026 02:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780366269; cv=none; b=jMb/1UQ3l+yq61tl2fdUzIm5JIUIJNuWzaT7qJo5TB8yt2+VpnJTO0KBBulXyB86Fz6JyZoMkhvwA47RTr3+CuOIgqpuacaFfjxk4ZQMjm/lYmlSlbD95DtYdCIILikLzhRRZQrmewZuyn+8X1F/Uwom6uU3EWmt62yMsjg6iDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780366269; c=relaxed/simple;
	bh=52N5KQ9otOEcRHHVP9Fj3c1UeiauMnKPqnLJJdOQSlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJ5B8i8M5pwVcLklQdJA+v14jL7k/kOv4LxSAFeUhT7E8Y48EynYMCd5bbhdsiOMvCD6UZ57I0SI7kQbpf48xfPigpu//fd1E976Pt50G6Sf/M5VxEulxBS/KANhHAN60TaVaQsZZAA7y3sR2uNcVXKAZsWYxHW0U9wBaZWufZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d/5yCeTo; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d/5yCeTo"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651Gu1Ya4096124;
	Tue, 2 Jun 2026 02:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zGZwrxpqCi4yo3z6uRooM9u+vER2+ZyRFgNG18W8gjU=; b=
	d/5yCeTokypBUJdY8fOROkhZXMh4GwyKeqmsVwSjHDBOlf70rypvKgQ1ejkVODqe
	/MiLn7tHwx+O9aFr3AV4TCefzUjL046omgVbhmpZS3GF814GArKdItYdnxIoFqAd
	kAFMvTEYlA/QwpEgxLjUyjah+LArNimnz/mGuMwUYpig4gJ7suaSQZfXxZvR75RL
	uTJfUchhTH3D63dC5jHpPNYlBcxi6O1lKvUW6+5xw0yG8u9xEpLnaVCdejH6n20/
	NV7Wgtwsv6f/qjXjs8NVkYNBu9eB3aoFzgw3DAW+/6JSsVLjdx25jgrLkzcJtluS
	WuQvomxtHVsQaDj9pGO5ag==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efqs6k7fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:11:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6522A4rY020168;
	Tue, 2 Jun 2026 02:10:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc2x0y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:59 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6522ArCE023303;
	Tue, 2 Jun 2026 02:10:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4efpbc2ww0-6;
	Tue, 02 Jun 2026 02:10:58 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: scsi_ioctl: use strnlen in scsi_ioctl_get_pci
Date: Mon,  1 Jun 2026 22:10:47 -0400
Message-ID: <178036282190.1628204.8067454927827602432.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517171546.2304-2-thorsten.blum@linux.dev>
References: <20260517171546.2304-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=726 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020018
X-Proofpoint-ORIG-GUID: AwkE7c0ggqTlb8t8Vkoh0AcJeeMgKO0z
X-Authority-Analysis: v=2.4 cv=POQ/P/qC c=1 sm=1 tr=0 ts=6a1e3bb4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=R5yacfBFZNKIx484Q9kA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxOCBTYWx0ZWRfXxQvuaSVY+Ghl
 EiHfdxbz3TK5pdctu432A4m07GZORZEJicT52YpI8ez0fbDGecp75072AdbbARtQAlppYyHTnEb
 Q9SZTSgPJLiAxoslb7sGDAW8935IFRKFujgG1ae9dFp1o4h9QZrzrWEZeRY3SR5TnOgffauVmwm
 k9NBXe4U92dPyWGNyygyOmXl7zfOcxm3EDy9jtffi+DbWZa6Vec3L6AcZlQvHG9IH7fDuYutQxM
 6gn/Hv5hV8mfQIh09d8FeOFe0uTZjfeF34bGDvhitTW7FV1HOgYZyLCuRuoQCQlarEVn6JsR5An
 8xEU+k//EL/GpyRrOZiXXM92B8oELOhaBY6A41yy+XnG5AVO4Z6HXK1LWDGVAM5H5p9c5Iy/sH3
 Ld/7Ty5HhkKmwe8rRmDLsMb1uC6Z7y0yg7ilcc+kDE0DInXF/nEvdOZ1tm8QqKuOEq5/uHrTA9R
 3jFRJDCQNaTBlmxFN9w==
X-Proofpoint-GUID: AwkE7c0ggqTlb8t8Vkoh0AcJeeMgKO0z

On Sun, 17 May 2026 19:15:47 +0200, Thorsten Blum wrote:

> Use strnlen() to limit string scanning to 20 characters.
> 
> Reformat the code and use tabs instead of spaces while at it.
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: scsi_ioctl: use strnlen in scsi_ioctl_get_pci
      https://git.kernel.org/mkp/scsi/c/09be9d404f42

-- 
Martin K. Petersen
