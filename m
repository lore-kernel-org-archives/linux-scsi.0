Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D517B2AE99;
	Sat, 20 Sep 2025 02:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758335104; cv=none; b=nw/7IbuMHwIjDqGGbVH4mxU83xq6hPgh/n5MEZ32Wy72vpGJ7Egvq4zTr8/KU8JEHqByyePhr+8DgeA2sSynBjIefd1eac8tAA2Uv5gSOoAX8Mpa3UMjbRPRxttBoPf4JpNMwouBEGcdB+T7Tkx9uH6b7FiYXufa5U99DuCBxlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758335104; c=relaxed/simple;
	bh=We9iIzMmfZFbatTSaPpa/03n9fT5X9OYeMV2mNb0VlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nEyvxmkcNAaPUqx1szjlbO2S9sY94PBf74DcWBY4EmsbpqVbsbbgXYx/ZJqdWNxmtzcBJQsqGzVIYq3Wr1baSSuEAj0Vn0R3RFcOoMa4nqsdV7rBP5JKoawgk5cp5EILhXYsRlUgCFHlroFoYxYQS4Mt3yZUNBS0YEJzi53RqjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QCx8585W; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QCx8585W"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58JDun93010150;
	Sat, 20 Sep 2025 02:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LX79n5R/sHZ9aLkopBHTQnNGQD0BoaH4Ti10gl3Lw20=; b=
	QCx8585WqBCmfucsktqswSoDDsIiok8GgEATutpFiQYkUkdmuP8r7WsTF0tzzc+W
	UasetrbfbGVaDfns2uklvyAvvJAG6pc/NzYPo5N/wj55m0ctyW+q6X0yvpWZtULP
	9UYtSbqMvDW+j4YmBtVjBjn+BJVfwm6hQO88ZCuZJXWO0SUjOn8/H3A8wQINlbQ7
	Xf45HHKVSy2HHWv4Uj/MXvkHBcWZUj93l9Tapmom0g+11yUniGH0eSscmkH22lGM
	f56Ma56b1Z2S8MLxZg5zCDzI6Qdy6d3jumU8kIAy+aZI59mjdFmemHJ8GWHhjO4u
	ud+ytNH1vgSftvwtoVpcuQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fxb6jfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 20 Sep 2025 02:25:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58K1Y8wb019773;
	Sat, 20 Sep 2025 02:25:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jq50p2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 20 Sep 2025 02:25:00 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58K2Lxga016735;
	Sat, 20 Sep 2025 02:25:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 499jq50p2b-1;
	Sat, 20 Sep 2025 02:25:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: michael.christie@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: iscsi: fix typos and formatting in lio_target messages
Date: Fri, 19 Sep 2025 22:24:51 -0400
Message-ID: <175833431691.3341211.12584013704761747909.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250910190728.3783157-1-alok.a.tiwari@oracle.com>
References: <20250910190728.3783157-1-alok.a.tiwari@oracle.com>
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
 definitions=2025-09-20_01,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX6EqloaLIL/tk
 FtM5j7Aj4w3+PxsWtPKEi4MGuvd86D6a0HnXs/1i384ob4NOzeAV7IJNZsbT3yqLze3YpKkZ9+m
 iCmJAnCpfiHRO2r6R5t39fN4Xe6CK/wFIU8tjBmRVNdRhsf0TWTXfuINSq0f/Q0z5Bn8YdcaSpO
 mmu0KGL0P2qcuh8HsX6hcOhYtq63GW8cJdONZ2h27XgAFnmWCUinY0drxf0lVwDExwuSyFxsGHf
 7ypFnRWuDDMqzk2QP0xyMZ94PAaAZTby+xii7ueTUju179/s0HhcMWc0I6T2k+trd85ak9hwF2g
 CFt7StkL3ioPBTuucD3Q3aGjPE+ePJVM/0vKxRweMkxNUNRaOERE3d0OJqDlDDEVjeCG3TOEEjf
 9ferYFMC046iKdAmqxa7j4V+6LDpaw==
X-Authority-Analysis: v=2.4 cv=KOJaDEFo c=1 sm=1 tr=0 ts=68ce107d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=A8grC8wFmQRFXEc_IFkA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-GUID: cHQZwhgPntMv36ZiuXzDeGOwWDnpzgO6
X-Proofpoint-ORIG-GUID: cHQZwhgPntMv36ZiuXzDeGOwWDnpzgO6

On Wed, 10 Sep 2025 12:07:20 -0700, Alok Tiwari wrote:

> Fix several minor issues in lio_target code and messages:
> - Correct typo "locatel" -> "locate" in error log.
> - Add missing space in pr_debug() message for better readability.
> - Fix comment typo: "contig_item" -> "config_item".
> 
> These changes improve code clarity and log readability.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: target: iscsi: fix typos and formatting in lio_target messages
      https://git.kernel.org/mkp/scsi/c/f2d81dd6751a

-- 
Martin K. Petersen
