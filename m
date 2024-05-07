Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DE7139F;
	Tue,  7 May 2024 02:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715047317; cv=none; b=q8QoNVzS82BJrXkQUeKAGvQATdsLM+w9fU2xeJB1Q2Mbs/T0peFM1KCxbtM0rbD5aISUfsOrqT3GX6kDAiPSnr3vZKXu7C66cf8FTgK+c+pgj4UhNYSfTFIBWeyiiNGtlB7S0YSbW5VsntjpvZyQxOg7CePkpotCemc5Yxl4LLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715047317; c=relaxed/simple;
	bh=zUyhYe5OtN23P11OszwOjjX3edmhpjZvIm4gW+1NX44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mKurhEluiQshidXN6ycCShDMmupoIDXR6jR9oxX16YZSZMi8t8wstVZZ8ZcL8toCUoJ9/c2xYY1hXqoxWdsKEW5EcBw68RaNuss8zP6CQyLmNarE7Nh3jNfT5lpo5YHfFz8aebkE9FmiSxAO86jwzgyqZMDTk9A4Ssz9e3SpByU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mJBjUcgW; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mJBjUcgW"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 446MqT3J026857;
	Tue, 7 May 2024 02:01:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=Dwin0PvhLjskOeJ53Iu+NpuUxl1I6Q7LfDccU18EjIA=;
 b=mJBjUcgWLsX3HSnNilMwSrMCRs2U6BFIJDaoxsWAg6UdXZMnrzkyy9BENFzLcirq8j3M
 0mvwMAj0YPock63iC+pKfENHqRgL4VwmnQGLfkVUVXxI1ShSS2+xNxwvKwXhX0Pn2wSd
 etAytKbSNmvvgcZfLbWf80PlPW45C6H6y2lDWte/OdpvgQquGduM9LiOwlpd1RBUqmPs
 uZyx4nu0tJe9lumbGUP61nu03oSvQPQ5e6anBnTz8SfsAOhZLQVojT2f1prF4FW23cU9
 Ey+inp3eIlbO9LrBPF/VwDYuymhs1xMm7jjrzvKQy583MOtaW6caA396uNlKGQ/hU9FG Ng== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xwbxcux8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44701JhA006890;
	Tue, 7 May 2024 02:01:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xwbf7dc2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 May 2024 02:01:25 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44721EmF034149;
	Tue, 7 May 2024 02:01:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3xwbf7dbvc-9;
	Tue, 07 May 2024 02:01:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Don Brace <don.brace@microchip.com>, Yuri Karpov <YKarpov@ispras.ru>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        storagedev@microchip.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] scsi: hpsa: Fix allocation size for Scsi_Host private data
Date: Mon,  6 May 2024 21:59:56 -0400
Message-ID: <171504445051.1494912.9967167091221671734.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240312170447.743709-1-YKarpov@ispras.ru>
References: <20240312170447.743709-1-YKarpov@ispras.ru>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-06_19,2024-05-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=895
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2405070014
X-Proofpoint-GUID: ygi42Gwqwt_b9k4GuN1ED3TF2YWjI5Hf
X-Proofpoint-ORIG-GUID: ygi42Gwqwt_b9k4GuN1ED3TF2YWjI5Hf

On Tue, 12 Mar 2024 20:04:47 +0300, Yuri Karpov wrote:

> struct Scsi_Host private data contains pointer to struct ctlr_info.
> 
> Restore allocation of only 8 bytes to store pointer in struct Scsi_Host
>  private data area.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: hpsa: Fix allocation size for Scsi_Host private data
      https://git.kernel.org/mkp/scsi/c/504e2bed5d50

-- 
Martin K. Petersen	Oracle Linux Engineering
