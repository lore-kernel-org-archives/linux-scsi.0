Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9489F320CBE;
	Mon, 13 Jul 2026 02:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910034; cv=none; b=mRFqZ9+UYnjcL+0dVvYTspcTRmT/BE2IDrViRyR865pkFNmTLHtD4CWeMCEv6TIhN/9KIdOt2V3jH0D6tvdxS7DpftK5pO0mUczWV4CnR5ebujNrzQBPqPOF4NMpkHuO0fBzJ8HIZ2XHikdUbi9qgwBA3ZpNP+tQtW77/uc26qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910034; c=relaxed/simple;
	bh=JwUGr/Ti7iE1Mw2nLj6Cs9pZRcQsvTUTvjK84S/nkNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DyCJkVplaDF59HRqxXka4YHUc7yfAnMQkeGsl7mitG5cwfGdKnlKVpN+xRUSiCjgpA1Zxp7VjL9E2Vn5diGJ/fIXMhLuSMznLK11sx06Po8PIxMrdzlWHhVSZJ9Gb48ZeVz4qWJEWIH8JV7n6T2z5szInceE59+fWZYlKxJuC8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U0joJC+l; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U0joJC+l"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D1aetW312292;
	Mon, 13 Jul 2026 02:33:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Zs0KwdaIrpht3M00//i3ltWrOOqX3uEqhvLOiLXuuwc=; b=
	U0joJC+lqaIrZU7raDpDbuMORuJPf6/W3tw+V0oIU3qTOjqwz0cP5eUSuS9RCyOE
	anC2yiJK2b9t5bwSM7z/okOOewMX3ry+kcyeSKdCY77PMo6dt/T23pZF9GdJvwCC
	m4wJrSBkSyibScby93GMpSP/DyVGm3vyVxit6HTqupEHi5x0cnkiuslxvYkeF2WH
	ytdwO4CPicusK/sNPLceGPfNc9OjgWpAlVssetellWzZosm4TG6MhyzaltRLeKFv
	pQqMB7Eie7sbOSeanW6uwcgCY8V8LuraQ9aHlOYMZc6av2NxaF0ALFHjJkfUCrCJ
	B+yI73RUSK9BkkmhmimZwQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbef0sc9p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66D2XVhb029118;
	Mon, 13 Jul 2026 02:33:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fssua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:35 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66D2O0cn010878;
	Mon, 13 Jul 2026 02:33:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fbc9fssh6-3;
	Mon, 13 Jul 2026 02:33:34 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, david.carroll@microsemi.com,
        justin.lindley@microsemi.com, scott.teel@microsemi.com,
        Haoxiang Li <haoxiang_li2024@163.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset path
Date: Sun, 12 Jul 2026 22:32:34 -0400
Message-ID: <178390967070.3399387.4792832720199841376.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260622160028.1240496-1-haoxiang_li2024@163.com>
References: <20260622160028.1240496-1-haoxiang_li2024@163.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-12_08,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=874 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130023
X-Proofpoint-GUID: uXdT1ndXp7OIpmv25I6rVT6_3mv9tPCc
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX+QYCb3MZpolp
 QHIuQ35lCud97vRwQNVZ86T6PnV4NXmaSUKKGSlcAOIP1feHnvLZoB7qI2EX3gcdQQJbjaxGC5E
 dE6FH3AoT+21t1ukLrJqXc8vtO1BcCFrpfztdapUxP73kzhRtR5M
X-Authority-Analysis: v=2.4 cv=KJZqylFo c=1 sm=1 tr=0 ts=6a544e80 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=2s9cdLV0ugMkmbUsbZIA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX8/e2hFFimTEK
 r2Zm4hLgSoFXEd4SMB+oyX3F+IWsB1gqYUBBY++rgZQudohKHng4YJZ/v83L0N63c5O49WSj28o
 Kr3Xa/woAt3hn0fIhnrzDxPFsxX57hsBej57YWngoDnwmlh9xwDbux8uh2ixmcUGKVoeScZGBdH
 SV1HutfCxfztanMe5Rg2QPXo92OZLRhBkaKaFuhOAy1T5CP5wZvKhndOtl/ai3aRt7PDTFR2c/f
 Ey9o6FqfXQmqcxncqc61mNH2d2e4ylGJ/xpmVdQmPMO5VKQBOgyO5M2GPiOLO0xmbMyTY72LWA4
 cGWAu/Wp3e5kF7QpicC7g+J3DE3nKdgMJFFaD3y5O8lN2iukTaYvCGgQl2JXC1MOnKFJfY/FMOy
 aFuayfqiTv/Rr39uLWxkRWK1EYi+C9cPiMTs3XWePVccLNEPxHVmeH2QUUYf6vz/1rs3sbVA2Lh
 vcYelvbnr300RlsW/pf2oiDcqOxdxy1eq9FA3bxM=
X-Proofpoint-ORIG-GUID: uXdT1ndXp7OIpmv25I6rVT6_3mv9tPCc

On Tue, 23 Jun 2026 00:00:28 +0800, Haoxiang Li wrote:

> If phys_disk->in_reset is set, the function returns directly without
> undoing the resources acquired for the command. Add the missing error
> cleanup by unmapping the IOACCEL2 SG chain block when needed, unmapping
> the SCSI command, and dropping the outstanding IOACCEL command count
> before returning.
> 
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset path
      https://git.kernel.org/mkp/scsi/c/e166bafc483e

-- 
Martin K. Petersen
