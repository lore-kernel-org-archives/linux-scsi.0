Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B269119DFB5;
	Tue, 10 Dec 2024 02:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798200; cv=none; b=S36kboRXVoBNxYil4C99TqaxMPNbHKChPpwiXThCQZzoM1xjKjT8pfUvrj6lyPiyXI168zTvPPEtX/5vs4zi9CQ1Mts1EmNxkkc9Ip7SiLnjXIKNkOAGpBDkPkJFaxaUoAYoi2dsECju4DfxDxn8RohcJ7gN6AlB4g97SJRKA0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798200; c=relaxed/simple;
	bh=U+65QawTMA++yvBpbKoHV/UPNTcbc0hpe1nGaq7rWDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UVecSzjCrEuVQOVch40Pxf9a32xYn//w4NfWu22/Qkes0tzMzZ6dVafns0fVdT+7ld30qmJrkRZWdn/J+r8OjWuuN863VGcpy2sBQaMxQ8uFPH2Qr+PyhF9aesQeGCjKnYNawMWmo41FSmTyesxTCuuFhzA5RztaGY4uOX5SHZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RlzU5rmr; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RlzU5rmr"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1Bv18005036;
	Tue, 10 Dec 2024 02:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=VZ+y8JShapF72EwjS+CeEUo75VrzC1AcESLZgxxUIRw=; b=
	RlzU5rmrlqOYUiFPmLl2p0XxpeIKCax9fkVI3MzlMzyKj1XDvskjUdCAOxEpDs/E
	dVz36kKa0XqWyaUIOSuJHeDLYayaG/yL+u/A00jtPLrYl4ts7tNHpfHjsr4U4P9Z
	dyKTlxVG2x7EZB0dYjoGOniYkV9hB0HKm+lkO23NDzXuAMVK7UC5VkDEzwAPO1Bn
	ir1JjKDP6mYUfXzXEfMvRiVDHaelQMsSjcfNdsvfm2DzLxhJuf4IkccGvdz2pk+a
	nX+WFqe1i6C5NvIzaNFXngnhEfYYpUwG9r67uK0hD8ZVgsr3Vk1jjHlEZxecCv7o
	/A01iFUYhxP7nYmzm8FlSQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cdysvp3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9NrR2I035038;
	Tue, 10 Dec 2024 02:36:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:19 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIuj010256;
	Tue, 10 Dec 2024 02:36:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-1;
	Tue, 10 Dec 2024 02:36:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v5 0/4] Untie the host lock entanglement - part 2
Date: Mon,  9 Dec 2024 21:35:32 -0500
Message-ID: <173379777408.2787035.14259305456500332981.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241124070808.194860-1-avri.altman@wdc.com>
References: <20241124070808.194860-1-avri.altman@wdc.com>
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
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=667 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-ORIG-GUID: L_7hX2j5paIZYLqgXhanzizoh5JEhKZT
X-Proofpoint-GUID: L_7hX2j5paIZYLqgXhanzizoh5JEhKZT

On Sun, 24 Nov 2024 09:08:04 +0200, Avri Altman wrote:

> Here is the 2nd part in the sequel, watering down the scsi host lock
> usage in the ufs driver. This work is motivated by a comment made by
> Bart [1], of the abuse of the scsi host lock in the ufs driver.  Its
> Precursor [2] removed the host lock around some of the host register
> accesses.
> 
> This part replaces the scsi host lock by dedicated locks serializing
> access to the clock gating and clock scaling members.
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/4] scsi: ufs: core: Introduce ufshcd_has_pending_tasks
      https://git.kernel.org/mkp/scsi/c/e738ba458e75
[2/4] scsi: ufs: core: Prepare to introduce a new clock_gating lock
      https://git.kernel.org/mkp/scsi/c/7869c6521f57
[3/4] scsi: ufs: core: Introduce a new clock_gating lock
      https://git.kernel.org/mkp/scsi/c/209f4e43b806
[4/4] scsi: ufs: core: Introduce a new clock_scaling lock
      https://git.kernel.org/mkp/scsi/c/be769e5cf53b

-- 
Martin K. Petersen	Oracle Linux Engineering
