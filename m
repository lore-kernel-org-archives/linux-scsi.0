Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4411E885;
	Wed, 19 Feb 2025 01:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927250; cv=none; b=Y1QCLhZXStbUDToojuJ0U4u+gZhsSAFhxziBPTPN7Qn0zJLbngzIgXm2xV+Nk7eh4HwdcUj7I97VEw24FzKLEm5AMwdyxLEUb8fkkeZMkeJGyzOnEotHLU5NKwgUUHUm6eT3JLH6xSXMgsAPZHJvqLBaq7PdXDha0Owe+7w5YU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927250; c=relaxed/simple;
	bh=PAJxY+Tfsov4+2wELn2Ss1eC8tj6qOLvX7vYB6LeJe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uba9Mcp9aiiJchQTJc6iM6fZzFcjKcb/BGyOQALkq7eTE3m7HwiFIrYlBhpsG3+uiCioQCsN8p6w+SvlESu75qYUWpvmLkoJ6EG5sJ+mhSHTXpcooP9M65uhzRWEChtKDD2x1ydtH00o1XUp0Wk5vikBQJ/s3jbLzzeEYdikDrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nVRww0ec; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nVRww0ec"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMgFdW028379;
	Wed, 19 Feb 2025 01:07:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=qGT1erGy8aaoapDYZFL/hBNS0RpnF3r2LBquubieRpA=; b=
	nVRww0ecQgh4M8uuUEJnumnaXRGDooYDEt20rIy89nDUEB7fwlZY2Elxtl74Zs+q
	UjBnITYT/ax+87bhR9ThwHJPX3/1J06pVdnrtzMt/Est/QhPKpKLJ0lNpEwZ8wlZ
	aIdIuJkt5/ih86y3Ac9lTQKem0ts/2UsZ2NFhViBdKIuFr7Qw6oQuOMu8OjrA//U
	YaCEDa5dsY+sgZWjq35Y3+N7SHd++EtBvw6nulByGYavybI0KMl38nE/zpKBKn4S
	mHATDVt59gfLcsjO3KXx0aYhfzymzHUCfEFBKno/aDGCcpv1/d9YG0jpvHkDqxJZ
	dEvNhd8t+fGhMKwrO8p2Sw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00m0k8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J0HZ3U002316;
	Wed, 19 Feb 2025 01:07:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tk1rqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:21 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51J17KeL000669;
	Wed, 19 Feb 2025 01:07:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44w0tk1rq5-2;
	Wed, 19 Feb 2025 01:07:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4] scsi: ufs: critical health condition
Date: Tue, 18 Feb 2025 20:06:50 -0500
Message-ID: <173992713072.526057.4039772020308663823.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250211065813.58091-1-avri.altman@wdc.com>
References: <20250211065813.58091-1-avri.altman@wdc.com>
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
 definitions=2025-02-18_11,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=638
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190006
X-Proofpoint-ORIG-GUID: P9c2PsaqbSN9MjCSzEINJ-TwXoera3SC
X-Proofpoint-GUID: P9c2PsaqbSN9MjCSzEINJ-TwXoera3SC

On Tue, 11 Feb 2025 08:58:13 +0200, Avri Altman wrote:

> Martin hi,
> 
> The UFS4.1 standard, released on January 8, 2025, added a new exception
> event: HEALTH_CRITICAL, which notifies the host of a device's critical
> health condition. This notification implies that the device is
> approaching the end of its lifetime based on the amount of performed
> program/erase cycles.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: ufs: critical health condition
      https://git.kernel.org/mkp/scsi/c/edfaf868f3ae

-- 
Martin K. Petersen	Oracle Linux Engineering
