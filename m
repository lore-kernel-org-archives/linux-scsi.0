Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58504380FC4;
	Wed, 29 Jul 2026 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293796; cv=none; b=UH17wD+BZfAERoQdrLgXKr2LBCVayAHKS2qM4CdMxGuec/5dvabD5qeYfljCwpEHkINpik2b10J+qIKpua2SyanIvbnBfLK1FUvvHboL5HqkjPMKI/m+jiVlHtVxDdqkqxiU9xkBAHkni+kWXbe/OKtUywRmYU8371NndJGYMSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293796; c=relaxed/simple;
	bh=uobTiaKS9d3yOTzn9dvqJQm9fInS6qnSd+PpkvLtVNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wkh9AlcGc1zMPpJfXSConeTBJUXElmc9/RfQQcNahsFttBLIqg0IOCHiiP/6mhGXz/Cn8G2qyFG5OprugZpuDMrBGyK+zRkvJ0GLUCtNRxkRza9V/LL0HnEWnC/7Skj3P09ogi82HyB/qbmXWbX7OxOfZ9k76azM41qK1OkNk3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FfOk4O9O; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FfOk4O9O"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItZtV1279355;
	Wed, 29 Jul 2026 02:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+HByTm6c/jlmxmlux6mN94d1bVoiUibTRNqXJ6rlZbA=; b=
	FfOk4O9OMJgY79wW0UUU3DawqML9FHvqfiCS24YYk+RDBvPAnlgbsREhKMKQ2Pu4
	e80bjVy05ccixc1XtDKLt3svxIZL77nHtE1XFoUSZ8XjtCGC1KgCpYLqptFR5qf+
	kMyMvOEhFHFmFpos05O9xR7niX46c6YdanGqd431yDVdn70vBoM782hyCMqCI31N
	IFGucqnwgQYt7VuF5b1KM2eKcKL1gxao1Oq4daV/ic1G5oMyxi3XmlFPy2ctby6u
	k8j8VT0HYus1D36+trLoaqiQSGjQGBlzqMpoe01Z+0OPl6OyBac6p3Bj1v2mUzx2
	ph6g31Z4R4bCkxi+qjtJGw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pn6pb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oY54034636;
	Wed, 29 Jul 2026 02:56:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:25 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMA8006812;
	Wed, 29 Jul 2026 02:56:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-8;
	Wed, 29 Jul 2026 02:56:25 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Mike Christie <michael.christie@oracle.com>, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>, HyeongJun An <sammiee5311@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sashiko AI <sashiko-bot@kernel.org>
Subject: Re: [PATCH] scsi: libiscsi: fix stale-data leak into the SCSI sense buffer
Date: Tue, 28 Jul 2026 22:56:15 -0400
Message-ID: <178529373833.132455.5035490797590781026.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714104934.1404423-1-sammiee5311@gmail.com>
References: <20260714104934.1404423-1-sammiee5311@gmail.com>
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
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=792 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-GUID: 2T4D3z0lmB5c-V1CFZ1crBDv-7QTF6P2
X-Proofpoint-ORIG-GUID: 2T4D3z0lmB5c-V1CFZ1crBDv-7QTF6P2
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a696bdb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=UdkRNMdTL_YeZbZmhxgA:9 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX4yJnq9ukwlwZ
 a54+jSUnP03t0mPtKbV3S4qWJx7OkEQ81xRy+iu7sz8Va5Cq1ZXQAQ+3/ye/0H8dSwcn0STiq2b
 tk4gpFTNjLNCJDRgqXiztIUiUtM7a1Qag4qgLUyN1OP9IUBQxc9kU7Uf51BUU8rRTdjWLHYJVjy
 mDpKSul0qDIxf9ayntQB9+eKaJSXn6wsN35MgfDxaRiV1xIaTyz+mwzwl5TVbnWzoSCsDOImpeS
 lik6uOVwidj/mQtMeSBaNTxf0pJ+oSi9nlHuUyaAcfgZKK0WomL/04u4/IofY78eDOjkoXyZYby
 gfpDNS4GLlNh6Lh0GtCNJcNBVzwzXpv8gC5T1gyqtD3/7SqxtwpqvUUH8V/MOAWu1b8yIN86VG6
 sLn0Uk9nd6gE65Wx8mdMQ41Tkrh5F+YXGXWgbb/pT7VWYrOEsTBwdDW6qhTo6X9uf/FMoP9Zzn/
 SyrSvHUPU102sZk+QSEwZdy86PCkHOLshMoy91HM=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX7uPIqeDJfEy/
 N+h7H0Sh52aPMvw5fYXP3sUMDOszmTXyy6mxFUXMuc85s2zkDffhCq4LnYMKxTwDhjNLJV2skU8
 ukiXOYaqzSFTb8cBLOxyE2jk+5hsDZRQfaGVkrdOHAN4WH0rOf6x

On Tue, 14 Jul 2026 19:49:34 +0900, HyeongJun An wrote:

> iscsi_scsi_cmd_rsp() copies the sense data of a SCSI Response from the
> target-supplied data segment.  The segment carries a 2-byte sense length
> followed by the sense bytes, so it must hold 2 + senselen bytes, but the
> bounds check only requires datalen >= senselen:
> 
> 	senselen = get_unaligned_be16(data);
> 	if (datalen < senselen)
> 		goto invalid_datalen;
> 	memcpy(sc->sense_buffer, data + 2,
> 	       min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: libiscsi: fix stale-data leak into the SCSI sense buffer
      https://git.kernel.org/mkp/scsi/c/98b87885de4b

-- 
Martin K. Petersen
