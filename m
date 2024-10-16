Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BEA15B10E;
	Wed, 16 Oct 2024 02:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046456; cv=none; b=aevcv+zPPTkSn7WT7/PNFPGFcQ3G01P2K+n5hgqnFe2R9cEzxBMIbnYsy7cu8QsmS8P9eQvw3yyn2296jH5dBjl0twbapXPSyVARyRrL7NiRQj2Vo504KtQ59Hauui8WJP5UzGxE15rNFENKUBrHiD+RxmI/ZyiqiPppqYtOMKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046456; c=relaxed/simple;
	bh=Q+2+Lp+c/9Msd1H7XAI3DpQgBAJTvQMExiqqraH+lRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gIPAJ3KTNfhJFJ72xVqfXyt0t6rsXYjCpgc/Vmt4RKbbrLNNTC5WpEoZFVqNJ1zQ4SbAqFPJuMWFY4ZEwBgkFr2it3UnnZqFR/EZS+slXou35wW3hJDLVlqxBofM6V4oia/cAOZykNnJl+JepDsu6X7bJ3JBif0TGFcvPh250oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aeVJlqlK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aeVJlqlK"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2MeXd011172;
	Wed, 16 Oct 2024 02:40:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=bTNdTCbEfiYQlDlHpyIfuv/Z7v9LUM0qP5w1l6HlrMI=; b=
	aeVJlqlKRJ8unjTE3W6s0ATP98dEioRZ6H7O5TfYw1g2IwqvyeFL7xkJ8LkRwG+f
	osdr+FUvtWGZXNgIuA+VI/IchGoN6zOztIKHC9r11+/iBIifu9qt3cCQzIT0QmW0
	6F2NBXVN1qLOMUeeIbv+TxMtD0KrBBrHCKJcW0n+r2n0vJk9iN4n7GLydy6Ab/pq
	9dvLEANkjTh9EvFfW81jYR9LE37DIJdNgFmOcDtg/A1Wq15THRQnsxkRpn8uCJpR
	qMNodzyKs/awdGXfep/K3IND/UFuWnRCDUEn4RV/O57v4qPV2Tf8+/AIp1FPfTyn
	Fs35PT5Jh4EQ/ZXJU8rvHA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427hntaqv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G0cfeO027269;
	Wed, 16 Oct 2024 02:40:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjesy00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:40:49 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49G2elg5001510;
	Wed, 16 Oct 2024 02:40:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fjesxyf-4;
	Wed, 16 Oct 2024 02:40:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: hare@suse.com, James.Bottomley@HansenPartnership.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: aic7xxx: Remove unused aic7770_find_device
Date: Tue, 15 Oct 2024 22:40:05 -0400
Message-ID: <172852338082.715793.14728102435625386723.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20240913170116.250996-1-linux@treblig.org>
References: <20240913170116.250996-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_21,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=868 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410160016
X-Proofpoint-ORIG-GUID: HCwsRidyHkLA30B-EFrp4FAJAKvI2PCj
X-Proofpoint-GUID: HCwsRidyHkLA30B-EFrp4FAJAKvI2PCj

On Fri, 13 Sep 2024 18:01:16 +0100, linux@treblig.org wrote:

> 'aic7770_find_device' has been unused since 2005's
>   commit dedd83108105 ("[SCSI] aic7xxx: remove Linux 2.4 ifdefs")
> 
> Remove it and the associated constant.
> (Whether anyone still has one of these cards in use is another question,
> I've just build tested this).
> 
> [...]

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: aic7xxx: Remove unused aic7770_find_device
      https://git.kernel.org/mkp/scsi/c/0b1e535598d5

-- 
Martin K. Petersen	Oracle Linux Engineering
