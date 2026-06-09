Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A623546D1;
	Tue,  9 Jun 2026 01:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969167; cv=none; b=Pm4TeEHg2Der7O4LeWPvdREZIdXUC9FQB4NYS/yyLcyiVtoixGBZuvbjjQDZz3GNSTECn6gJF9pT/X6K3BMBhH+zejVbIouWLpYKQXKq8Jh5PbAVvXPtHUx5AgGwFMcWutRGgiOsixgedVcEhLkCdykD/lrjwbh7f4B1Ytm/QJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969167; c=relaxed/simple;
	bh=GpKRe8tx6cCSW+HLJhNO9qrr3H0FtxJVqoWkqmLi5us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K1b3/JqaaPI0g/YECGB+j7tEeBFgh4gqrcBJRYCWzdG5T+dgdWBIWfQFCMTEteOOcbkiNHKBAHbVSWnCbxvz6RVGLZ5JLgVgyLUrZwl1/hkZUNJuGqiK70mPV7N1uV0Q3u8gI7uqKTXdSx5vEHNi9WsivSC5X6cA3lnrag5cmWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Srg804+9; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Srg804+9"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSV7s1242853;
	Tue, 9 Jun 2026 01:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7JKq/xd4fEz29r6oWYLMMzsuEEoemIi7OGLLJ1J4Xgg=; b=
	Srg804+9H+WGVRdAgDGl2Fb6IHEjGdNqWe/lQHNGZArDukr3kQNnC03lPIf7rxo/
	hQ3AHsFEAOdTGay7yGp88L/8uTw7BOWK6GL1Ru+KEtYXyDQA/+dAmaoFA3aAznsa
	zG73YHi3yfnwikglkKPOfHa03kJeFXvZ8yT4QkkYe4u6fzSn3NQ6mSTxis93E4xF
	aLU9SMsJpZqxohNUcu6JhYmTCmBGyq90kLktmNIeJaGeGP1aE3oJdxRpKFoHSZIg
	xIqtOAoLycvWdN+Kyxd+56hZgtn4wsA5fJh3sAfMnEvnI0OerNAiCk4CHOqHopgM
	208Gb4+xl0kZIRj9wBJEsQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4em9ybbg8n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591caxX028109;
	Tue, 9 Jun 2026 01:39:08 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pgeqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:08 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6Ah030153;
	Tue, 9 Jun 2026 01:39:07 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-3;
	Tue, 09 Jun 2026 01:39:07 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo <can.guo@oss.qualcomm.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Lee <cw9316.lee@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: Remove redundant vops NULL check and trivial wrapper
Date: Mon,  8 Jun 2026 21:38:56 -0400
Message-ID: <178094912096.1810714.8594348985407535777.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529061623.301291-1-cw9316.lee@samsung.com>
References: <CGME20260529061727epcas1p495c499c91420790a225e66263f3fff52@epcas1p4.samsung.com> <20260529061623.301291-1-cw9316.lee@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=878
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfX7/rDIDj2beAy
 WJk/mLY3YY9waP+WR2Vhb/Fn/FcO9uzPnljKoNpEZmQHEiOaBa4OlSXl+u5jYfqq3KfEMWHADRK
 DdQLT/3QeGZ5Cdx3Ecj4N/YxfvEspkOOTZ89btj7XsGIjj8gZPx98CfOsO9kH50HNPeo6HsJZLM
 y7PJPxzLSTpsDkM6NnqV9S3Ny9e/RlhGdzQ/7VRONyCnyfsKC4QwLQKFWSsnleat9aoz5d7hmkI
 DcGHxl5v2Teal4Xu+nwWeo4zfk16qZ3yIA84v8SNLp7l+SgqqcXqjz9NnK48V2gXkmQgEa1hcsV
 WPnZn598XjGxO+on1mBDcSjuj42SbiV0/vZElVUfInXmwpO2Ky6lQkL1rEqVtooS6puSM/aBBDf
 EWAgenTLWNYFSh4MNQ5PAW1jwWUtDGkslg+PienGQy9XCbLAS9QLJmjiFVhjLYopubiMsQJDsda
 +q+8UKtXigmYDoHMFsvfr+1hIxUCyaYs27L0qjgA=
X-Authority-Analysis: v=2.4 cv=IYK3n2qa c=1 sm=1 tr=0 ts=6a276ebc b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=Vlg14O8ljXDgrsEdhGsA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: aP0D4lnFyUCIa5sdGH32E9oWUtsKUnyr
X-Proofpoint-ORIG-GUID: aP0D4lnFyUCIa5sdGH32E9oWUtsKUnyr

On Fri, 29 May 2026 15:16:19 +0900, Chanwoo Lee wrote:

> ufshcd_variant_hba_init/exit() check 'if (!hba->vops)' before
> calling vops wrappers, but the wrappers already do NULL check
> internally. Remove the redundant checks. Also remove
> ufshcd_variant_hba_exit() entirely since it only wraps
> ufshcd_vops_exit() with no added value.
> 
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: ufs: Remove redundant vops NULL check and trivial wrapper
      https://git.kernel.org/mkp/scsi/c/0600eec09ad6

-- 
Martin K. Petersen
