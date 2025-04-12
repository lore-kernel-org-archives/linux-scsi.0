Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695965339D;
	Sat, 12 Apr 2025 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744453795; cv=none; b=rm7FqX1eZBKbxRajoa5/GsL+mKcJb6qty2L7lREkeoQhCdYb3c6o+6+xb3hzfOa4i0cDDPROb+m/rtr1NUadIK3luMOB3ZADkeAMVRkNeO8G4I8dTRZ2hK8m+9+zxgle28yAcipFUVcBgK0p7Om7Lm9rEuHfBKpM5+bUiJNUqTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744453795; c=relaxed/simple;
	bh=DfiZ8h8pxXi6PEKdDc9EKvyLdmzPeSkt3+jW9TIozNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X/xKrrkWwtW4tzc5U2cf46Gp8bqOGZ/UNr730UC3nsOf0pIq/C4NyoH2VTX3AQgbVn69disMp0qme2W/JPe41YpIjvIAwWGnBWzRFO6wfJLS3/xdlgv4OxW1alHolLqKx8AW4mDmS9wfAkhJPdBlHOZMDBgBL22TaqlOcHTbpT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FhRe/8YT; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FhRe/8YT"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53CAN7OA028580;
	Sat, 12 Apr 2025 10:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=gPgqoTIGqj5+L1srp+y4+XFzxkZ4VE4jSTvXjKEzxqo=; b=
	FhRe/8YTD2ZCGX85QNmwooaFS6IgwxksEq1DWtGaNaPXJRk6k/OHdm/R46bQ62Tu
	LIkUHlr6iKcAWf9k3vSxl+rbQtSOMc0EX4smZpM/Bm55uUtmVeiVtp9Ptt2xtbGS
	DCPa0ELXyqbZQtBJogGgi7znKYitEYDfOg3QyAOOHbmJUnUb0nkMop/0hjXHse4W
	dBJmUtccF5u9iSk0o7AgUB3NTDjHhXR9PhaiBTK/pHZ4Hoz8KEUwIZ151yhGQIVx
	P4k18sSsMkWCpo/WY/LjDur34emaAR3knuv+8PfmpN2QoeOr6paf7Tx/O2OnC6FO
	VSDoskmhMbY77TPrjwmnyg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45ypbu803q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 10:29:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53C71Fj3032204;
	Sat, 12 Apr 2025 10:29:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45yem69s15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 12 Apr 2025 10:29:27 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53CATROc038043;
	Sat, 12 Apr 2025 10:29:27 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45yem69s0s-1;
	Sat, 12 Apr 2025 10:29:27 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, peter.wang@mediatek.com,
        minwoo.im@samsung.com, manivannan.sadhasivam@linaro.org,
        viro@zeniv.linux.org.uk, cw9316.lee@samsung.com,
        quic_nguyenb@quicinc.com, quic_cang@quicinc.com,
        stanley.chu@mediatek.com, Chenyuan Yang <chenyuan0y@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
Date: Sat, 12 Apr 2025 06:28:53 -0400
Message-ID: <174445370235.1751018.17269242214304693746.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250410001320.2219341-1-chenyuan0y@gmail.com>
References: <20250410001320.2219341-1-chenyuan0y@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-12_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=655 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504120077
X-Proofpoint-ORIG-GUID: 7jqC1S_svR8jCKup5NgRjxybuE2yH2Mx
X-Proofpoint-GUID: 7jqC1S_svR8jCKup5NgRjxybuE2yH2Mx

On Wed, 09 Apr 2025 19:13:20 -0500, Chenyuan Yang wrote:

> A race can occur between the MCQ completion path and the abort handler:
> once a request completes, __blk_mq_free_request() sets rq->mq_hctx to
> NULL, meaning the subsequent ufshcd_mcq_req_to_hwq() call in
> ufshcd_mcq_abort() can return a NULL pointer. If this NULL pointer is
> dereferenced, the kernel will crash.
> 
> Add a NULL check for the returned hwq pointer. If hwq is NULL, log an
> error and return FAILED, preventing a potential NULL-pointer dereference.
> As suggested by Bart, the ufshcd_cmd_inflight() check is removed.
> 
> [...]

Applied to 6.15/scsi-fixes, thanks!

[1/1] scsi: ufs: mcq: Add NULL check in ufshcd_mcq_abort()
      https://git.kernel.org/mkp/scsi/c/4c3240850629

-- 
Martin K. Petersen	Oracle Linux Engineering
