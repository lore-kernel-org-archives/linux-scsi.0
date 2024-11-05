Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D813D0D5;
	Tue,  5 Nov 2024 02:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730774034; cv=none; b=Rk9cG+JqNwU4m4jlVoVUb972Yr+ZhOdpGBznLxWRraLRn1Uj7lMPh2U9Gp8PxPb7xzR1TkXJslXWokOwR4fm/8XSBlPuCg1geVHp1W5ZOQT1UYM49hzOt+lkTCQd0cqaJq8NVywouPsJktkcEWle53w50ZSOH1GroMzGjWE9dc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730774034; c=relaxed/simple;
	bh=Z9+To1r72kOymNV2hztmPDQ7n8Eqfg485YJ24O5I4CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KD1SDC3VDP83gjPGQWlXkhbv6j+Fc8ZPv93js4HEVkg8t9CRJwjE93eqpWpGhYuAjIfsdbTB0rcFFm0GBQitIKcX095TrbNZLaMnfjNweZso1knG+26VIW08MQ6gS0mC7m0eHRyOPMLaSlDUittHs8Y79Zv3iZSbHTaZX4DLhck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LfXenQIV; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LfXenQIV"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52Ofcb023094;
	Tue, 5 Nov 2024 02:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=pML2ykXqoEwg9YOxW7yFOaC2/tXlaBeDG7q5EqOJBm8=; b=
	LfXenQIV1mIB+OdXH4y94J5sBufN6K7YgKyWDXqhMWqx0VLwbhlekEORRxko6GwH
	+4OrWXyoM2PLHjsXaGXVNKhFjSfDAoeWyebWNfoDxSo4DWXsW2FQM6fCYcWtbBs4
	xbZJblgBeaYstmGefWyIC40vC5dooh3/zAQ1SPAleCT3RsE4Z+4/Ta+39sZlNVNg
	/W1rQK7lRNG1yf/u3BSkYsCwnnk0w5OeUszDFn5uYkXwsZeQb/h0FKUSce6Cm4u/
	CldGZthcKywG3GhmMWaXQj4XEyJadSOIfImE6MnqFee5HmaZCMIyUzbbq44ZQNtI
	MmEKLWs+YhDAiMj1HpRukQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nby8v7mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52LqYi036844;
	Tue, 5 Nov 2024 02:33:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah6g2m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A52XVFw017503;
	Tue, 5 Nov 2024 02:33:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nah6g2k1-6;
	Tue, 05 Nov 2024 02:33:33 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        beanhuo@micron.com, bvanassche@acm.org, kwangwon.min@samsung.com,
        kwmad.kim@samsung.com, sh425.lee@samsung.com, quic_nguyenb@quicinc.com,
        cpgs@samsung.com, h10.kim@samsung.com, grant.jung@samsung.com,
        junwoo80.lee@samsung.com, wkon.kim@samsung.com,
        SEO HOYOUNG <hy50.seo@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/2] processing of asymmetric connected lanes
Date: Mon,  4 Nov 2024 21:32:52 -0500
Message-ID: <173077364676.2354920.5375785901601330949.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1728544727.git.hy50.seo@samsung.com>
References: <CGME20241010074222epcas2p4278413120c00584d83f654dbde6c0f49@epcas2p4.samsung.com> <cover.1728544727.git.hy50.seo@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050019
X-Proofpoint-ORIG-GUID: wZg2YJpFUcfSs1vLlDS-5wspScirAnsH
X-Proofpoint-GUID: wZg2YJpFUcfSs1vLlDS-5wspScirAnsH

On Thu, 10 Oct 2024 16:52:27 +0900, SEO HOYOUNG wrote:

> Performance problems may occur if there is a problem with the
> asymmetric connected lane such as h/w failure.
> Currently, only check connected lane for rx/tx is checked if it is not 0.
> But it should also be checked if it is asymmetrically connected.
> So if it is an asymmetric connected lane, an error occurs.
> 
> v1 -> v2: add error routine.
> ufs initialization error occurs in case of asymmetic connected
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/2] scsi: ufs: core: check asymmetric connected lanes
      https://git.kernel.org/mkp/scsi/c/10c58d7eea44

-- 
Martin K. Petersen	Oracle Linux Engineering
