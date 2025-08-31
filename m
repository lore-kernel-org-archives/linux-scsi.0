Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEE16FC3;
	Sun, 31 Aug 2025 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756606313; cv=none; b=SiTP+waYg5gjEvj/MUSKx4DJW2YPASYnFnDyr2ctYdP5ykEqGabBm3hlMrsZwDVn4QMWHN1JivAN+oHaOi5ZL4hdZ5ynBwY74MAmt3/aOKM68xDapM0UdduRwcUbZm/WNxVsV1D/ifOtR9XGgpTrXSveLxPFg7klXg8B6ehmKT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756606313; c=relaxed/simple;
	bh=LS8rK+htD6Wd/I728Os5FQOxQDK7u3NUusFdKSPNFlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HiQGN8eI1OyB32a+l8DpAeCD7A0s2o/tasGJuppMoACTESYtOC3nU/IHwTIHspi5qjVBAVHfNhgRX7oRClXLHq6+YWjPnqMhgvX37XA2rSL6KisxETE9DWM7vbT97k2wOanhJuhsrEUfJ2Aw4lKk5kJ4ibnV007m8FOj3PO6sL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TNBLjL9v; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TNBLjL9v"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V0GwHX002351;
	Sun, 31 Aug 2025 02:11:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mASnUL1qE/KYNPaqVLgaX65Q+PlHToHTvFRoLec0nWc=; b=
	TNBLjL9vOZnU74T1LsUURPn6Pzc41AYDKS2RlkjrM+gw/fJK8yYkOFA4OmN7yi8A
	0wD4c9hjchPf55S1JD4yTNiGPyyTQ4bPcm1C4BZ/Ez6r1oLsuxH5a+cX+4dE2KhJ
	/Fp5ZZWWNPI/tMcwaVT1EtZtS0x8Ro6bfgAsfqzeTtBWRxjB+ioz5FyWBiq2HIow
	j6QrAHoNNaO3ZrEq93UgqDjpEAzF4D8TZ6HROODTz7b0u7QD0heYyaLhsm0VDepV
	Hv9iZf1SK5ZHnq3BEyKWENgkFUcVVnejtOq3i5UJli3TaX26okHgTPk9nB3PZJYD
	CscZVKINmF2pABkqm/GWuw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usmn8mhk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57V20XML028751;
	Sun, 31 Aug 2025 02:11:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr72m58-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:46 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57V2BjAs019355;
	Sun, 31 Aug 2025 02:11:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqr72m4v-3;
	Sun, 31 Aug 2025 02:11:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Francisco Gutierrez <frankramirez@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jerry.Wong@microchip.com, vishakhavc@google.com
Subject: Re: [PATCH] scsi: pm80xx: Fix race condition caused by static variables
Date: Sat, 30 Aug 2025 22:11:42 -0400
Message-ID: <175660145358.2188324.5895394625284903617.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250723183543.1443301-1-frankramirez@google.com>
References: <20250723183543.1443301-1-frankramirez@google.com>
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
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=907 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310022
X-Proofpoint-GUID: IGiOHhU7gdupc4-HhqJHfcspSJjmiXt0
X-Proofpoint-ORIG-GUID: IGiOHhU7gdupc4-HhqJHfcspSJjmiXt0
X-Authority-Analysis: v=2.4 cv=Of2YDgTY c=1 sm=1 tr=0 ts=68b3af63 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=XgrK7BegsIhlKM8gjBYA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMiBTYWx0ZWRfX4x35rzpoGDEE
 Bd9MieyZx0XStNJtbCeF5j4oD3FgU35POxl7+ZM6WEAGPtMf8oMWeZ5irfS4a76bFzN8apdI3un
 20/9KcTR19BQChUKvgYA0+91SKin5gpD2nJ6dCc/NjeH86u35cN0tzwoeNM31ZLeBOp8CMwzmD7
 JWoJgzg8AwikvBr0NIJ+WwRCfHrRw9kQ25gRXLtBHoU4Vg07+EvB7w9leBF/OBoooAEf64EA0Nj
 6+OQa4zGTIMpnBsQplwwHqaIVRwGf2N/UtkAN3uyepelCNb3liuwwYZUaXEKp4oJd56Os/s//mp
 vnTrySH++zfJNTPMNAvA6FX1Ql5oyDXApD++hMpt7hvx3zRQ0MJoWC5mghjdFISa6yh1pYyX3wd
 vsYV13xJ1F0b6MCCUK2pR5YwvUAsjQ==

On Wed, 23 Jul 2025 18:35:43 +0000, Francisco Gutierrez wrote:

> Eliminate the use of static variables within the log pull implementation
> to resolve a race condition and prevent data gaps when pulling logs
> from multiple controllers in parallel, ensuring each operation
> is properly isolated.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: pm80xx: Fix race condition caused by static variables
      https://git.kernel.org/mkp/scsi/c/d6477ee38ccf

-- 
Martin K. Petersen
