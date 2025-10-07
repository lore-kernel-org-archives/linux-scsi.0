Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAE11A0712;
	Tue,  7 Oct 2025 02:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759804726; cv=none; b=Hdfr2vTC/mZCImUX5SJTfgwx4Quz+Oxrn4ieiEnnjeKH/W/6OvmpJX5amLHlD0m6wBgwxoaWuZALtoyYt+DFp0elW9LLG8IwJIwXsF+0W6NYLLo8T+Hr4kb+j//xiR5rf71xV1C2zNReFr2YMsRhoz9xbw5BcK8DWi7jpYBQCm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759804726; c=relaxed/simple;
	bh=qvqbhabbqNdj3zI0s/BIypEvxrHCHVSTNX18AEcaOGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xr8w47j/qVdWYd1K3mvwCnYSpo1rDhxrAps5A4tbhOaOFdeEm/WgaMIywXd8dSNBJEuLV0rqaSOWb8Qoo6ULTXh5wXhhQau//ufuezCH5GSeu/Rb2b3DZxO1Bmx4dl7BOzgllE6AwU5aVajiXnAJ+prrxW95xq35H/Ddy3yyWwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rGjX1Bkk; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rGjX1Bkk"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5971C20G008089;
	Tue, 7 Oct 2025 02:38:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3AN5YGseDlWLx5BbOTtRQeEDE0upcMqfW7ZhTuw4mSc=; b=
	rGjX1BkkUXRsIxQ3Sq1z1FedN3DEMh3oYBFEoiwgRPHLEmCiZVoXheEFtXzULcaQ
	ibXI8sXvABrjsMHc3zixN2WSthnTT1zlu5mGaBcZu0TVFgWX27b1UVmSnkj2tTnS
	WvUrVXHjI5MueinHaGaRabgYVRK3kCcPHcOjB7bu3BIZMIR6CDeWwvm0tPGlsblY
	XiLfl27uoKAZ0ZSocZIZ/OleA96GX5kEGQOC7gBd9lh5jLV23SnoQ7PRfkyjjQ45
	U7IOxorlJovSmIXWYr13JP/j3khpaejq7OCukBxmqihQx3tKvc/ZZG1wWV0SBREJ
	xSI/sMIIuPKT2chTS7Vpig==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mq6mg6jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:38:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596NB8C0029855;
	Tue, 7 Oct 2025 02:38:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17ktvc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 02:38:35 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5972cYWF013646;
	Tue, 7 Oct 2025 02:38:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 49jt17ktuv-2;
	Tue, 07 Oct 2025 02:38:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        beanhuo@micron.com, bvanassche@acm.org, kwangwon.min@samsung.com,
        kwmad.kim@samsung.com, cpgs@samsung.com, h10.kim@samsung.com,
        HOYOUNG SEO <hy50.seo@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS
Date: Mon,  6 Oct 2025 22:38:29 -0400
Message-ID: <175980238056.149901.2679786294881236536.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930061428.617955-1-hy50.seo@samsung.com>
References: <CGME20250930061604epcas2p3f341c32c50f267aa6bd3ae0e82adfbf3@epcas2p3.samsung.com> <20250930061428.617955-1-hy50.seo@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070020
X-Proofpoint-GUID: EKLeStZWejjI4qQGiYSkRJR8_lEHhWDR
X-Proofpoint-ORIG-GUID: EKLeStZWejjI4qQGiYSkRJR8_lEHhWDR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA2MDE4MyBTYWx0ZWRfX2DcZ1kw34PnU
 ZfMUImQB1iauA878gI+Z7fhsospDIrXrKTzJW2cWoaI0fVoeSJ8EqemtGJvHMKFaGL5ZmdtaR7I
 pb1UbfwYAnL8p2CXZrkUDbvAjnalBrz7vMyztDtZSgDpGFPUSluwJ4mPQQjNH8Ln2TvtGEKnXvL
 VsZHjyhYdbK8SdGMTDFMYaNK25c/DoWWXzxB3g67yw1fnot1/ncr1O8BehjwvKlKfR7nW0ECmoA
 GSgzq46sSvay0aoQ/pDmtM9D/dcreJqbMFJY4380hRksPWnEijB+5DhCG1IAiv1vdWmXJsCpvBD
 6Iy3/ggTzlwCIlSDGynKAUMlnocojU6UxR+cDcYSVliPtUyUjEGzcU8/LNxHFivp3KSoQ00Qc7i
 M18mMhk9U1cPigI06BYJXqILfRKcEDlc4q1Wz4GO9DY47+cjJlg=
X-Authority-Analysis: v=2.4 cv=Ue1ciaSN c=1 sm=1 tr=0 ts=68e47d2b b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=y78s6vJUZ22gG4-LBH0A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13625

On Tue, 30 Sep 2025 15:14:28 +0900, HOYOUNG SEO wrote:

> If the UTP error occurs alone, the UFS is not recovered.
> It does not check for error and only generates io timeout or OCS error.
> This is because UTP error is not defined in error handler.
> To fixed this, added UTP error flag in FATAL_ERROR.
> So UFS will reset is performed when a UTP error occurs.
> 
> sd 0:0:0:0: [sda] tag#38 UNKNOWN(0x2003) Result: hostbyte=0x07
> driverbyte=DRIVER_OK cmd_age=0s
> sd 0:0:0:0: [sda] tag#38 CDB: opcode=0x28 28 00 00 51 24 e2 00 00 08 00
> I/O error, dev sda, sector 42542864 op 0x0:(READ) flags 0x80700 phys_seg
> 8 prio class 2
> OCS error from controller = 9 for tag 39
> pa_err[1] = 0x80000010 at 2667224756 us
> pa_err: total cnt=2
> dl_err[0] = 0x80000002 at 2667148060 us
> dl_err[1] = 0x80002000 at 2667282844 us
> No record of nl_err
> No record of tl_err
> No record of dme_err
> No record of auto_hibern8_err
> fatal_err[0] = 0x804 at 2667282836 us
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: ufs: core: Include UTP error in INT_FATAL_ERRORS
      https://git.kernel.org/mkp/scsi/c/558ae4579810

-- 
Martin K. Petersen
