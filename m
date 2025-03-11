Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762D61DFDA5;
	Tue, 11 Mar 2025 01:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741656003; cv=none; b=fssj03D7/gEnO2dxyRxY0GTBLOvxPJy+7XbWM27pcCzfQS5WJ6goobsis+fgNdAzCgnuJGJfXmSIF1noa0X/5OFUPA9UIQqXgZysbAgtVYuAMRy5OtbbBJjXZ1hm4THsaBzHKTeAQXfaocq50MDqftPDGYHUEwIDzkSLXUAOBRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741656003; c=relaxed/simple;
	bh=FLbQEvhF8ubBfLttByiZmBGi3tS4mdgB1neecBcmil0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVGqww7McKjKAFVa4f2C1kkyYbvDbvJ9s5E5JtkOkaWXdb4HpmiobxvKcO0MVXQgjB3ssVx6CNkwaePqZLvrXV4+dLPyNoMnNTyF5proOPkuJcf2Nn9ErYEpF69QqzdZNeA35fRiwiTP3myN6080pbJlAid5mWC9kuFK8h81thM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K1P2F3c/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K1P2F3c/"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52ALfnxD009456;
	Tue, 11 Mar 2025 01:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=UY6hKWRH1OcurE9yCs8Mf01957RBXLxna40vIEFmDyc=; b=
	K1P2F3c/ep9CuCK7iB3rlpI0gQWLUyPPjWHwNOnxofdj0DZw8MixPvxLOsSGATJv
	3Bp7xreue8qgJhLJtm9FBtAMcLxkg3h43RxIx2swWIQizSGo/0ETvW4FbICfNaW5
	24Pzv6S/yKtmi85GeGACklDk5xCRZOIysxGww05lUtV9IqBPY3L1SvLBbzCIdnJy
	cLtLDfHUaVXaoOizBi7HCEzGOTZPLbPpRAuqvCihFg04Kmgj83tTcck0R3Z2qy41
	GX9s4xHQ5JHkvkGa/ksQOkIE2XWvxlDNYoGhXG2D+apk0SfVZwycZ3YV2gaHwKoh
	bjDkHZK8LnTLVRSbJIfZrg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458dgt3u5s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0J0Fk015052;
	Tue, 11 Mar 2025 01:19:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 458cbencmd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Mar 2025 01:19:42 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52B1Jfr6014960;
	Tue, 11 Mar 2025 01:19:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 458cbencm8-1;
	Tue, 11 Mar 2025 01:19:41 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Yihang Li <liyihang9@huawei.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>, Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
        Jason Yan <yanaijie@huawei.com>, Igor Pylypiv <ipylypiv@google.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: hisi: remove incorrect ACPI_PTR annotations
Date: Mon, 10 Mar 2025 21:19:00 -0400
Message-ID: <174165504943.528513.10440203351356285832.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250225163637.4169300-1-arnd@kernel.org>
References: <20250225163637.4169300-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-11_01,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503110007
X-Proofpoint-GUID: ck-SAzov044k7wxaCZu7iscu8IvIxWaK
X-Proofpoint-ORIG-GUID: ck-SAzov044k7wxaCZu7iscu8IvIxWaK

On Tue, 25 Feb 2025 17:36:27 +0100, Arnd Bergmann wrote:

> Building with W=1 shows a warning about sas_v2_acpi_match being unused when
> CONFIG_OF is disabled:
> 
>     drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:3635:36: error: unused variable 'sas_v2_acpi_match' [-Werror,-Wunused-const-variable]
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: hisi: remove incorrect ACPI_PTR annotations
      https://git.kernel.org/mkp/scsi/c/7a9c0476d407

-- 
Martin K. Petersen	Oracle Linux Engineering
