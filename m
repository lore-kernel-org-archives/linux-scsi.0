Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600D22DECBF;
	Wed, 11 Mar 2026 02:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194806; cv=none; b=P8+oMsic58fypSzfCHPsi+BR45+z3zLXyxv/1hFokUgPfK9dxGtxmSEPmmYSFVqx+LOe+EV2tIpVK2/RV3eB9C/ctQILPiLvfsqL+DK2fo/MK6C4vZhgTjgzrsk5kXKKxk/LGKA80E8BqT89sMpL2SHJp/CO1AwJOrEOkIZ/CmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194806; c=relaxed/simple;
	bh=muskFpltGwGmxl1QAAOv16y0ehqc4s/A6VHnrjh6gUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I6vf58NC7jb0P7YeY0cBUc9EYMdRubDPRSXIhvOD8v4R7o25mMm5XV0aCBNU0bY5pwpqpUsKwFummlyZO/X0L4ucf8YBTXFvSHH0TMSRkCefXJFq/ig8UBTm8xanB5TUPs8gsxT5UPZcu4Y3W9Ms90kCWLfTDYp6xHhbKGXRtP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H7QEsWpd; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H7QEsWpd"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIo1cp094045;
	Wed, 11 Mar 2026 02:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=M2mL5OZ0G0yoICFGwiOvJEt27kYgWpBwyIrkpBqDVGI=; b=
	H7QEsWpd9E5MZF8zlY9eM+Ci5tRidp3dxgT2q3JBzzZFKstmaMvTAWDxdTP8j9oq
	1JLQGUh0lt2rkCy9sBb0C9WOVl0G2/Izoex7Y41aAGtSZvkqaYVcS1I0gJiroaWl
	V6Y6zG9VxgfHODrPzJVypmjIiEtCjHy2L/R26yDbxzLuGbz3vetwpqtLxQt8Y0gB
	X5IF8iQd/PXWeJCD/TciJLpRzM4YAMPbJeueRw/74Ri/LODNHV5sE28SbNS19gap
	o4YjN4XZkr4On2jV4n5czLcruRjvg6vfBSL6wIL20I7IExmO+tnKkYj36w2YYkbw
	MZ8xgjhjylWdPXbI5kvUIQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmdkm432-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B204iw020274;
	Wed, 11 Mar 2026 02:06:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafewwkm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B26M5R002770;
	Wed, 11 Mar 2026 02:06:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4crafewwj6-6;
	Wed, 11 Mar 2026 02:06:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        sw.prabhu6@gmail.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        pankaj.raghav@linux.dev, bvanassche@acm.org, dlemoal@kernel.org
Subject: Re: (subset) [PATCH v4 0/2] enable sector size > PAGE_SIZE for scsi
Date: Tue, 10 Mar 2026 22:06:17 -0400
Message-ID: <177289787699.2131580.15221991163805183568.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260219043741.276729-1-sw.prabhu6@gmail.com>
References: <20260219043741.276729-1-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=769 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Authority-Analysis: v=2.4 cv=MuBfKmae c=1 sm=1 tr=0 ts=69b0ce21 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=cgAREEJgfldQBbQSYj8A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12272
X-Proofpoint-ORIG-GUID: Mk-WMoaiufGiQ3eHUqfyTrz1MBm1Yq1L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfX1o9+PYF6Qb/J
 +B3l1RgiUqsj0Jy4sw3UX+9uw21LUWw7zqmDDJujFWQ6Bngdkjc5/HzU0ATuRj/r+RYGjdZor3z
 zT0PsIpYNpiJ3DknwXC6gujTc6Di8HITp6PoYEq9Qrwq7IsTGEBPKTMCkSsPhXE4A7OalbT6hWW
 SpB2rwb9Cl8kfcwg+bn/5s/fWcX7auYnWjzdSSaMPYRjQ0o71U50K3SEZIW5SAwjwyaqRU94GMI
 ry/pGP0qRNGP1xnXKCEVKJc/32+xyex2cwPfvMipUo8jRowvWBITAOh/rI5QNfHzyeGGoi6P6SU
 /zG8Ea7tVhK4xzX5jU58jcmuzPmwYEbP+fcGgqJMPaqhjvyhjjCFWQScZIl3DGUVTNnLsUk05Jz
 BI4pi13pIlI8Ze5zpFHvJ1bjvXNDmnQMhSR7cLUBmpebsT7TZzat9Vw9fQp/Lz9BP/NNOiZWHIE
 gKzK3/r3JPjxJAVQz98WcEl76VkbYT7XpOOn5aSI=
X-Proofpoint-GUID: Mk-WMoaiufGiQ3eHUqfyTrz1MBm1Yq1L

On Wed, 18 Feb 2026 20:37:40 -0800, sw.prabhu6@gmail.com wrote:

> This is v4 series sent based on the review comments received on v3 [1].
> This patchset enables sector sizes > PAGE_SIZE for
> sd driver and scsi_debug driver since block layer can support block
> size > PAGE_SIZE. There was one issue with write_same16 and write_same10
> command, which is fixed as a part of the series.
> 
> Changes since v2:
>  - Added reviewed by tag for scsi sd driver and scsi_debug patch.
>  - Modified the helper function name used for safe creation and destruction
>    of the large page mempool.
>  - No functional changes.
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/2] scsi: sd: enable sector size > PAGE_SIZE in scsi sd driver
      https://git.kernel.org/mkp/scsi/c/7179e626b76e

-- 
Martin K. Petersen
