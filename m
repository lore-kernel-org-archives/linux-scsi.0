Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76C317E015;
	Thu,  5 Dec 2024 02:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733365075; cv=none; b=e+bvrpRDzYto3w/ksJ7HdNwGuurFph6p2qudvYgsd3fFNQiCQjVgISr/9Qgt60/2p5D6leUFWYJ54Emwso5DOf7kkmbstIXA+RA2mi44gItivaxfs47YTGj2/5LrKDeCuWzIitOdD9mc2mvOWMtpYzRMyZZcZdqVzmKO5wS13wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733365075; c=relaxed/simple;
	bh=I4QD7Y8cx4lnDe/uxq4YTREyJn+oSqI+X/zUrpWDT9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jDnuT9kAxqj2rsFAbPJOJT+0vY1+pBoNwwZa8VeXevtp/DiEUCtmDqPdDRVNeqDvbNB9m7ZZJn+OscU8NYXXC3X+T/3P5ar2z49Tkjl+O2J9zvKMQ3A5Eahs6+QLlfwVODg277e4syvC54eFU3GujFkku/u2iEPGUcZF7aeNjR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TrjJj9mk; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TrjJj9mk"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B51BpDU030160;
	Thu, 5 Dec 2024 02:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=rYrDbCNmBdDzx499aoGxgj3z42b/6peKzLPB1hlTzME=; b=
	TrjJj9mkdCv6RmLYmveLGGFOPkariJVo8L6cg7RvPlKfkwBqPceTRMpCDgT3GYoL
	lOVfCqbaRSCTnGllfn5s5kpdw/5PFA54B1z7z3qZMG4mmWb50axbz5rETV9bxhmC
	0m5arZmC8Tq2QezDhoI7f8jG24tDRPHuOEpWH/AqGf9b4dpNJwg1ArZiy0TbCzzo
	sTBK9+PLcb74QIsi3nIcr6sEuFiXy2lRq1m6+vJSdntro+1A0FQDBeYF5Yni+UzP
	onslLVWEkDmuGQ904IBJS9iTi8EUGhLXgSjRjaiN8VxEdmpqWpcTa4lvF3jZVLaJ
	vozSjA+oNZQgIsGL/X7Dxw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437tas9sth-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B50EBQT001368;
	Thu, 5 Dec 2024 02:17:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5a8u8y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:45 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4B52HbvU018742;
	Thu, 5 Dec 2024 02:17:44 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 437s5a8u3n-6;
	Thu, 05 Dec 2024 02:17:44 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: dgilbert@interlog.com, Suraj Sonawane <surajsonawane0215@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
Subject: Re: [PATCH] scsi: sg: fix slab-use-after-free Read in sg_release
Date: Wed,  4 Dec 2024 21:17:05 -0500
Message-ID: <173336487634.2765947.1842407236657188629.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241120125944.88095-1-surajsonawane0215@gmail.com>
References: <20241120125944.88095-1-surajsonawane0215@gmail.com>
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
 definitions=2024-12-04_21,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=674
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050017
X-Proofpoint-GUID: a8lZcI86tvSyOCptG2W5LPOuwzlxzh6a
X-Proofpoint-ORIG-GUID: a8lZcI86tvSyOCptG2W5LPOuwzlxzh6a

On Wed, 20 Nov 2024 18:29:44 +0530, Suraj Sonawane wrote:

> Fix a use-after-free bug in `sg_release`,
> detected by syzbot with KASAN:
> 
> BUG: KASAN: slab-use-after-free in lock_release+0x151/0xa30
> kernel/locking/lockdep.c:5838
> __mutex_unlock_slowpath+0xe2/0x750 kernel/locking/mutex.c:912
> sg_release+0x1f4/0x2e0 drivers/scsi/sg.c:407
> 
> [...]

Applied to 6.13/scsi-fixes, thanks!

[1/1] scsi: sg: fix slab-use-after-free Read in sg_release
      https://git.kernel.org/mkp/scsi/c/f10593ad9bc3

-- 
Martin K. Petersen	Oracle Linux Engineering
