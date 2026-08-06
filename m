Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F171C4C9544;
	Thu,  6 Aug 2026 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786043202; cv=none; b=tpjAudhkNQwOaIgFYJWyCMdo6pj7TFWhnvq6cerX7o38Snl76XYl/pAksYDjzw8H09FjyXWVFJXv3ghlnSGB8gZuaBCFN5jDpIZFHlFAUUzdavGtKSfNZg76j/8xEUlGpimXmCS2O1a6a2luS4z6UeQG6pnX+fSSIQRg0MDAfco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786043202; c=relaxed/simple;
	bh=qSNZXKN93GXHvTrUWyxunlT0hKra0MlUjHJyiKcQ7xI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fS7xZBvUDZEBzrBxNV21NtjN2ZSTinwkmn+nwNED/9GEJPGrWJh9BnUa3jK7RWYqTavO5XjIIpwXTJtMDBXcYIVuldpF5C0TXjlXZJZWrlnK1J2o+lPtJBZPAZI6P3gJKqVzPYlNmrUQTxulLLOfpHvqG67KuqI4SeqyMlpk0s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nX/gnC+Q; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nX/gnC+Q"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 676Fu2DQ3283362;
	Thu, 6 Aug 2026 19:06:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CcCz02SlbxvdpeOIUhhwwyOYadrbpEWAunIDKfY5CMs=; b=
	nX/gnC+Qnyt/SPhhHQJQ9pW25bkUQuMeSKdbN5L13GevbGlKsNiE+MsVqCnzv/Kt
	8YrjDdEdDVeItrsZGMZmLAHg8hQINSxVTKzQDeZiCbfkZhAceSQr02jxGyI9PT8j
	HrXYdj8G0h03U63Gd6Vx5O7JbfVFdyiPfjYTfNsIZs+lonhRML+vEmh08B3i1Zaa
	jXy+8tSEgUbEfgzrcU5lVFOcutHL5C0osl8d4FIb+SNsus4561yE274fTj3P0c2i
	pObIpCLtLoKwIRKGCppIOphRLLDric2EgsodUaSnD36dUYy+aBJO6nRodx0phInC
	bAFGZ2oNyhgi8DKEgOomQw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8p9e9qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 676J0fun024925;
	Thu, 6 Aug 2026 19:06:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fs78w56fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Aug 2026 19:06:26 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 676J6Lgh011247;
	Thu, 6 Aug 2026 19:06:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fs78w56b9-7;
	Thu, 06 Aug 2026 19:06:26 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: krzk+dt@kernel.org, robh@kernel.org, andersson@kernel.org, mani@kernel.org,
        alim.akhtar@samsung.com, bvanassche@acm.org, conor+dt@kernel.org,
        Avri Altman <avri.altman@sandisk.com>,
        Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: ufs: dt-bindings: Document the Maili UFS Controller
Date: Thu,  6 Aug 2026 15:06:12 -0400
Message-ID: <178589207049.336697.17562931814765417659.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com>
References: <20260719195833.136543-1-nitin.rawat@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-06_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=833 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608060149
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfXzCL+g7r53LBL
 fa6xxxl8xZbFLWy8ur7DmoKuEru6GUiwbfaurAfv5EFx8zIKUIe3Jqw9r50f/zmx7yVAWh8wZud
 2ZwwaLkVKWpX2ubniXBTET58AAqeiQUBx4vBY6uIS64mpUIL63HX
X-Authority-Analysis: v=2.4 cv=EPU2FVZC c=1 sm=1 tr=0 ts=6a74db34 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=_nN19owqToCkDWwEtBYA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13510
X-Proofpoint-GUID: lFByD_8fZY9wOq8nWJh9v2VQkIDYAHRi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDE0OSBTYWx0ZWRfX7O55gKVPleEN
 BItQuPCOgh8vJxVs5VxNgF/wHkFMgyZC8AoMWsHcAHfq41UMmQ9vXOGVG4NmnGgLL6/5DgZ+yef
 S56ZlWD2cHPhRDFQqe/Psx55wZDTWbYjnLTLLyYQqpAV67aDTdhDroccaklmcXKrsE1WxgEYi4U
 TvqV95n5HTKuOBhrApefXn48nCJUp0a9oq0DEAm861BVEPRgxiNoO06X863OcUcwykVZlZMUdgV
 smlGQEnPm5OhKq7RxzbyLhm3M5n/Fs+um53WKp1WroKuuXTAFw/RIyIhLzNg3wkKkC8JQrZz1R/
 ZFvf0ZRoPDnmhZgNwutzmTZpy94pZhNZmqVZmlxxHXi+qDT7YsBIGQCNH74UV7Nvv9K7EMaS57z
 PiG3mDVsZG4k2SkUEhYS/a9Rd3KazpjQNEr8kqa181Fo0Rfl4sFQOsSpSx7QZcvVd2fBL2OF9OW
 q29PERTkESI/axl+471V+SeEjSA3Ii5Zn/D26tc0=
X-Proofpoint-ORIG-GUID: lFByD_8fZY9wOq8nWJh9v2VQkIDYAHRi

On Mon, 20 Jul 2026 01:28:33 +0530, Nitin Rawat wrote:

> Document the UFS Controller on Maili SoC.
> 
> 

Applied to 7.3/scsi-queue, thanks!

[1/1] scsi: ufs: dt-bindings: Document the Maili UFS Controller
      https://git.kernel.org/mkp/scsi/c/e0329beb37ab

-- 
Martin K. Petersen
