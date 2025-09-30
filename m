Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8DA79F2;
	Tue, 30 Sep 2025 04:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759205520; cv=none; b=ugL02OuadIjRkqV3chnxl4wGREIcTIkH9CUakjQK2jkEKI7WY2y4iRHfGdt9WtqOBu54CUFtFRjTyBhu3covdm/NWWZjX0z0Yfet2HbCEmgEyUasPEKZShXm6vMKQbt3CuTWK1WU1LK+jRifXYZPqH+WZEoRR/HvFxcnTpih9Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759205520; c=relaxed/simple;
	bh=y1YuXu2FleNXB9ovR1NqWJMBfKBQbqScqoCm4fTNvCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j5FjcGG+guh/NCzfkluxR3M6Y9JdFSgY02NE51SfMmv2uk1ymzZy3SA3b33qVvupssg84l38LZzEG7yNZTP4THgPT1eNURm+xAQAplftwBVDhSIq7XEmT93JayAw85gJAaiQx/N1hm2SOzZnbSiRtZLoZuyGmz/kjnMJwWDgzNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GhJe8wLF; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GhJe8wLF"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58TNZAvN031939;
	Tue, 30 Sep 2025 02:37:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Q9SrjdEr6tUoJAHQSR9m7btb4Y82RHUspdQD+a+uA/w=; b=
	GhJe8wLFm2b64tTTacviAVeBBoTyOAINbGQwJ7U05v4rjJ+4QtV0QEd3XRNsme7F
	McfWtQ/LUs5BVLMFvQ4TGrnsHDQ3SMcq9JOV/lYNeEC6vdlCEwfnuE6rd/L9pSit
	VWX8Km9C8N+bLSI4rl0hAihcBRrFkaKZg073uRpsOukkInVjMUqftayYwBjH70dD
	XG3ssT9mRVToWX/81m/U9ra24vbh43R2GeKbLrxKSjzR2e30+OTzsJnuOJCS9TzI
	uuM9zUAERwrZ3PyxL9qML9Q1hWDZBYxTTg+MLBhfyYF7yTRSj7VNUhDcGBBsJuY/
	kfAKqA3Wu2Z+VnOXPhBPuQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g3wbr77j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:37:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58U0RdR4007727;
	Tue, 30 Sep 2025 02:37:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c86exa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:37:03 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58U2awVH004400;
	Tue, 30 Sep 2025 02:37:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49e6c86eur-5;
	Tue, 30 Sep 2025 02:37:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: smartpqi: Replace kmalloc + copy_from_user with memdup_user
Date: Mon, 29 Sep 2025 22:36:51 -0400
Message-ID: <175917739956.3755404.5877755795289804707.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922201832.1697874-2-thorsten.blum@linux.dev>
References: <20250922201832.1697874-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-29_08,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=825 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300021
X-Proofpoint-GUID: DO-Acsdj37O9JCLWF3UU3_q1-PgF3KC0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDIyMCBTYWx0ZWRfXwso82IoBAnGl
 h/PQ3uBHj2CqozfG2JMo9ZiIYewKk9MWH9SI1xzZHqCBBaD1DLu3/Af3wdj4mqH0mEW7OFnlBix
 a7Z54w1gY9sEVlCsThOjx0+yNOwRl2BsOTGsC/IXC0IZiRH42MM1oioNgK/qCu+FPLpBj3K/7Zw
 3BA4/8Fpxz7MWw3VszI4Z9vq8T5ay+cglFhk6AcK/r8E1TtuCNdoAiZwgdRrkpgA/LUjV/XoioQ
 AdcgPQqh42xPvLMo8ngVU+trpNdXlYoyTdPYB005WlUtPgrPh/xjBVxsMJtAVpz0pDLZ0g77ETZ
 appMdVv7xYpF9IA7pW9sxdbHFooZF64RUkXDk6aAz9z7zA1ju1TIL4FeHrobbJwZj//5HHW7xDU
 Y4nlCQbBWWnj7jBBv+SmlVWspoX7qQ==
X-Proofpoint-ORIG-GUID: DO-Acsdj37O9JCLWF3UU3_q1-PgF3KC0
X-Authority-Analysis: v=2.4 cv=WYoBqkhX c=1 sm=1 tr=0 ts=68db4250 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=VjWpJ7GMu5s1FRr9CgAA:9
 a=QEXdDO2ut3YA:10

On Mon, 22 Sep 2025 22:18:33 +0200, Thorsten Blum wrote:

> Replace kmalloc() followed by copy_from_user() with memdup_user() to
> simplify and improve pqi_passthru_ioctl().
> 
> Since memdup_user() already allocates memory, use kzalloc() in the else
> branch instead of manually zeroing 'kernel_buffer' using memset(0).
> 
> Return early if an error occurs.  No functional changes intended.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: smartpqi: Replace kmalloc + copy_from_user with memdup_user
      https://git.kernel.org/mkp/scsi/c/0ac3c901fbeb

-- 
Martin K. Petersen
