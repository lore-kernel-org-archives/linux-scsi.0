Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2F5230D0F;
	Sun,  1 Mar 2026 02:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772331413; cv=none; b=jYDD4yEKCbifKp8xU0q70B16zKNHqwPZ7t/PcjUtOPxBr5NuW0faEDHb0VOc3Lf1RqeHqKrriJ0ExfLAtbqT5CnW1spqzmnF06HW8a72iTdMmkUHCkdUjZFAD9KjBOdjQ+nE8jKJuH92+NM1onwc72izHwtll/8jRwJfFnsDyoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772331413; c=relaxed/simple;
	bh=fJZTwkE3P3m2ok+sM+wYSuZiMIzmevdJuIvhbT5f9k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9apnF6/Gn309P+BCel6pBEit96sMLxe7gB/0YPWsTs4XGZUHIedl5YTXDf4DIgKd063UEqQ/DEPufdzyjKLrNp3NpnJ/b3srmwvNdrPWZQNUMRZ8vUcx8fiN9efpRSND+jz57nN/28Lj25nM4Dm3MW4poR3/wR74OJTGuVToCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nfWXJpfJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nfWXJpfJ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 621201Nr2487192;
	Sun, 1 Mar 2026 02:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3vuVSVh28n28th73eyGAjigTNMpQssx3NIOnyrKZKA8=; b=
	nfWXJpfJ00zQ+jMQHzRDLvrqKXbXXGrVdTPvb12a8i1QsHgbK4fgsleFSJhrwghe
	dhsMGmWlQq36gZ2ecbIFXQ2cs7RevDcMCBfUtAtk1kp6F9qfpalRZ94Yhklu+npX
	BrnaOoJG4c/gXNf/OrNG7UGN9a3O00VJqcjhxnKV/NeE+7zcztixN0VpMdkKn5ve
	K9C9LtwwGV19xI+qOUIzXdaVvxllj3GUpfN+o5PK/DftGDjQ8EOHppAfIjBruYyE
	oz5bfiNWxJMg+7hmWIM5oWNynUWkueWGiQpiOX6GOy4IhLF8ucFW0vaBKIw0oAjP
	4kmKmTWtWP9NqfPmZ5c/4Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cksqu8qd0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:16:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61SL0g5W036951;
	Sun, 1 Mar 2026 02:16:37 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt7ehgb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 01 Mar 2026 02:16:37 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6212GXt0019643;
	Sun, 1 Mar 2026 02:16:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt7ehdg-3;
	Sun, 01 Mar 2026 02:16:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: sebaddel@cisco.com, Karan Tilak Kumar <kartilak@cisco.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, arulponn@cisco.com,
        djhawar@cisco.com, gcboffa@cisco.com, aeasi@cisco.com, mkai2@cisco.com,
        satishkh@cisco.com, jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmeneghi@redhat.com, revers@redhat.com,
        dan.carpenter@linaro.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH 1/5] scsi: fnic: Use mempool for receive frames
Date: Sat, 28 Feb 2026 21:16:16 -0500
Message-ID: <177231727985.1778274.8891985262905640044.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217223943.7938-1-kartilak@cisco.com>
References: <20260217223943.7938-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-28_07,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 malwarescore=0 bulkscore=0 mlxlogscore=936 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603010017
X-Authority-Analysis: v=2.4 cv=DqJbOW/+ c=1 sm=1 tr=0 ts=69a3a186 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=MKO0JlC4SyYoFBfRIWkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: izr-JkMX7fW8aU9jcLX1Ap2HUGuP81bo
X-Proofpoint-ORIG-GUID: izr-JkMX7fW8aU9jcLX1Ap2HUGuP81bo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAxMDAxOCBTYWx0ZWRfX9KZoR+xm+eqM
 yu8FIWctmiyBEEVfX002OR54+5KJ4TEoZnDogAEZT+2np7+C2N7f26B3lBoBtsUJssoD2gc1HY9
 WOCWLR9iEGdIoANE3Wm/e4vBoM4Uz/eu6L24dgPg5Gd4g0i46SHQJwEb3si9ycxaM3YAUIzckyg
 ExHSgenoI27lMyIwri/i50JY/zL6eI90FhUBAmBvy694zYcyesgEAdzTAdgsJ3eUiIZXq1JJ7X3
 +AcwAEMQ8l+8plS+7qFy9kl9mvvGhWtL/5S6L1vPV+vLzYxeD5EdGuVI53KJVWUZFda/E57CuMb
 HrC/oC5/wdZeAilKzDzPIsjsH4CrWe8zxgPwg5RpBZjDeWnB4mj27Fjx8xkG3eMVOSPyiW0uDTo
 FcxeEqqWPzq6Vhnn8KgK1gYjjLmhhRCw2Gs7b2DvBjVreoIJhVKkT6sQHpDQ17CozsgSFCEsBGm
 3CKPMqiO8+ZuhaB+iWQ==
Message-ID: <20260301021616.f0WlhCQTfg2jbr7NvOWUCcbxso6waqSu4bsQd0jqK84@z>

On Tue, 17 Feb 2026 14:39:39 -0800, Karan Tilak Kumar wrote:

> The receive frames are constantly replenished so we should rather
> use a mempool here.
> 
> fip_frame_queue is an rxq. De-alloc it in fnic_free_rxq.
> Incorporate review comments from Hannes:
>     Modify fnic_free_txq to have same arguments as fnic_free_rxq
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/5] scsi: fnic: Use mempool for receive frames
      https://git.kernel.org/mkp/scsi/c/0e07baae55bc
[2/5] scsi: fnic: Do not use GFP_ZERO for mempools
      https://git.kernel.org/mkp/scsi/c/a59d1caf1ded
[3/5] scsi: fnic: Rename fnic_scsi_fcpio_reset()
      https://git.kernel.org/mkp/scsi/c/31eda39bfd46
[4/5] scsi: fnic: Refactor in_remove flag and call to fnic_fcpio_reset()
      https://git.kernel.org/mkp/scsi/c/927b5282df64
[5/5] scsi: fnic: Bump up version number
      https://git.kernel.org/mkp/scsi/c/47e088c9d1a0

-- 
Martin K. Petersen
