Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B20AE567;
	Wed, 28 May 2025 02:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748398857; cv=none; b=Q9WbFokYqV9d7WBwqUkhO/xbzcfleGAqFh5ZrpE5mZiBApw0cEyRkQmqSTFsOf8dgRXxruei7lc8er1uDZwj6siZt6tqr9bw6NUP9RLTRUz4ZkchfjH35gnjwqKCJvryiHrZqdt4Jk0TmMPWc8h1gU+2/VPvusUFaM7d3LnP+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748398857; c=relaxed/simple;
	bh=XF3yvPRPL1NDaELu1am/GZ993wzepWtWoBUwMQNlHi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iKKY/EseChfWgOuaS5zYCxzRqiY3tkvI7cVJc+2rNJiS/3m7vt776C0vjHx7WE9acIe8jAn6QQ1UQHa/Gsj9+ULXPWBTWurQAzF1SalXy5q/PMhWXLoxaHODrTZirGJb1HYNnCe58Ouk/PuUf2ooC9CFriCmGra5lKn42iEHbHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=no33KxyT; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="no33KxyT"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1ft9q016679;
	Wed, 28 May 2025 02:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WcitE8HrvwbKeH+hmuIRyiZ2UX9b2Y8GMgMAXJy54RA=; b=
	no33KxyTyIqirEjcThvnRfU3m9BFBxGt+OAkRrkLT/V8pWF1ihGpdqmp+d8tamA7
	bwoq29brqHwNu+1OyqnGDFILDjyuRMr+Y3Z82t6gfkFx86dZyL2wL/+GtO2aWdOe
	Uoq78iC62qrLQCRej2127G1woFvyGVbpLW/ql9QLP0IWLOmghKaCcLsiryum/QV3
	dWBg1FI2rGsY07yb4a19uUBATJ7ueau0uMPJQQWCVbITRFSahWWDGEHaKULV/6Tn
	UQ6z3q+a8OiVPQNwLarnYNCrIawUxY8/0h4pcYwcbOlvLMtPQixIn29qmTWnv+SI
	jJbrWYZJuk7fnIktUW1jrA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46wjbcgx0c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1CJTt021226;
	Wed, 28 May 2025 02:20:52 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jgb21s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:52 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54S2Kq10017834;
	Wed, 28 May 2025 02:20:52 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46u4jgb21n-1;
	Wed, 28 May 2025 02:20:52 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, darren.kenny@oracle.com
Subject: Re: [PATCH] scsi: mvsas: fix typos in SAS/SATA VSP register comments
Date: Tue, 27 May 2025 22:20:15 -0400
Message-ID: <174839736796.456135.17148269561940749197.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250517192422.310489-1-alok.a.tiwari@oracle.com>
References: <20250517192422.310489-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_01,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=891 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505280019
X-Proofpoint-GUID: vyi-VI0AqLgHAdwXAPK55qLPITyrNWQE
X-Proofpoint-ORIG-GUID: vyi-VI0AqLgHAdwXAPK55qLPITyrNWQE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAxOSBTYWx0ZWRfX5riihf++YVUe i9Qh99GQThheFsib3RpOh+tQswUqPaef0pp8HJFKaapcyrRC6Em77pz8M0CllseMInt6L7MU78g gljeFqIQGdNJ1vpGvEchROzx7TEDVXgJcdD59ESyt6N2VRknsuj0irPaisRTQ5F7rmd4jydJJrE
 6aJQtyFLQtLZzPJYTzLv2oVnUEtouEjkz+2ih7/fq/d+YLjHv5hXWXC3nAL1k6pZ/VL6WxTDdfu Fz09W9plaIV95wcyeFMuQG9iKLWDPrRyui2LN1sa2u6ICD1YU/GrnDO5ilqZBcG0IBo7ez8uSSI IeQM3yINiaO9XR5VDdo0I1Kr/N2V2Mba1drCVX5jJ1UYgsk7EUYikjzD/GeFmo/zKXuWv/a4WAD
 enj9cj1mZVB0I4jdRUHGIGPoj+HpqjhRLNI1nuL/+A3+ZJXJQHa0eXVjORk1DNoggrbpNneP
X-Authority-Analysis: v=2.4 cv=c8qrQQ9l c=1 sm=1 tr=0 ts=68367305 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=OadDIfMhQCwyUzP0OLkA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13207

On Sat, 17 May 2025 12:24:10 -0700, Alok Tiwari wrote:

> Correct spelling mistakes of the SAS/SATA Vendor Specific Port Registers.
> Fixed "Vednor" to "Vendor" in VSR_PHY_VS0 and VSR_PHY_VS1 comments.
> This is a non-functional change aimed at improving code clarity.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: mvsas: fix typos in SAS/SATA VSP register comments
      https://git.kernel.org/mkp/scsi/c/934a5c3230b9

-- 
Martin K. Petersen	Oracle Linux Engineering
