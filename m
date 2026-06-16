Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2216E3C0A01;
	Tue, 16 Jun 2026 02:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781576787; cv=none; b=aDscRRiCe5hF+YM21QPwBubj7t/T0APoHc6WW5RZplUgK1iz6q9Wd1dlH/7T1bH+7gG3Sj6O3PoDgZw9hare0spm4kmN9wscgYNPood6oku2FwjP2hra3a+xkpXQES1eV1CM4RQjR3boYV6kAr1dRPlzJK/st2hyAdJ8xHAfKyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781576787; c=relaxed/simple;
	bh=AdeC3NSqcSaWNzTZm5Hk3h06vLes04C9fZl7cFo9SXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YenLXPh1XOerOW0K44w1aDcZ3Ma2+MnWJ3k/iaduEDSw4bJiiqKMM1psuwfRKfaJfAIwIRyDYttZ90JwYYR15OcVUAoCcacVpD/JUC/b6l2YX2gXAwACfzmj0CaxN/3nRwtqp8TNnEh6BhujGb+d3Oya0lSMeiM6whZXjFP0sNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lRmlseob; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lRmlseob"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65FJib4R1304555;
	Tue, 16 Jun 2026 02:26:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Xg8+3R8p2hiuv+Dgb3+kZxBgodYHsjzf265lTa0VWKs=; b=
	lRmlseobkN2RdOKdct7niCPz4VeFNaotJNpIgGjZAMTKUQ91G3T/3jPUXo5WzFbj
	b7uNbUrOVK03lb7Y3Ot+FgBDU88K9JxLxEPFF0uzveQnQPeonc307cV2RLtCJOVK
	42yJAxfCXtkekjllEsJSmHJcxszOFQyfloCVVPzfgA9kMexiLqju6gSWKCPzuJXO
	pzxd86o+fa60NA5zkHP2BfhTBZz5PgW7PLFlsbUF+GW3tXghssIql+xNGHlzIkeA
	zGIh7krAwAXtmrrZXakjsV1SpedqPsc9Iso0FxstPy2G93aKy7MPLFkOSUYpZjrO
	o2yqMBOscRFUf/QZ3C3R9Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4es1hxkjsv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65G2NZq8016523;
	Tue, 16 Jun 2026 02:26:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4erwnpnym8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 02:26:17 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 65G2QE2J023822;
	Tue, 16 Jun 2026 02:26:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4erwnpnyjt-5;
	Tue, 16 Jun 2026 02:26:16 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, bvanassche@acm.org,
        adrian.hunter@intel.com, archana.patni@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajeshkumar Sambandham <Rajeshkumar.Sambandham@amd.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: ufs-pci: Add AMD device ID support
Date: Mon, 15 Jun 2026 22:26:09 -0400
Message-ID: <178157184621.1899010.9908520099901744844.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602095931.2869516-1-Rajeshkumar.Sambandham@amd.com>
References: <20260602095931.2869516-1-Rajeshkumar.Sambandham@amd.com>
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
 definitions=2026-06-16_01,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=841 malwarescore=0 adultscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606040000 definitions=main-2606160021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfX88WAvnF9EDlm
 vjzjUGCDCvqyeoJqZ/DUk8NaC/m0OyC8I6pu7Pc3OGre5nnfhRLuZYF3CQUDWExMYuTmPPIptAu
 cWcBDp5pbYZLn+533ZvQsOjosBcqTSufnSEpJr8sAakIh1zOXZO9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDAyMSBTYWx0ZWRfXwOZf/tUh5EVZ
 5ye4juIpTmquM/G5GamLkK9KNvaQSUgRpDATguRy3HJf1GjIp6i4amPF5f3f9MkB1+BwujkJarm
 ZufZtTnu9gO/al6QzFTaT/SBl54pUNH4WTiLXb7nn7PhXQ1vJ3gqWprGmpblLw9+/tzrT7TbPRb
 tVaF2WnCIn6AG0RCkhRf9yJRH62pFdcmwPkRdEfA3c6KHzCZa6xOldTnOTxoVoeGciifiaZvRP/
 i8gXxM3OfbqLd4lJZoWnacs71ccIYYNpDsrfhbX6M4OxOAa3acaw5+Nr+b7JgwsrBCW0ldmAG86
 /7tpAUc82Pq3kpAFofjm12qCFDWkH1DFJukLguEXn2oZ9emETXDfcdlB8MRMv+SMsJ6rrJFBq42
 0VdO/UNOH4X3DHHURUNFTRZvuR1iE/EHa2spzF3gRt99qJW0J2DcUtVEbARwFB8Csi/0mLqupHT
 kEN50HRXjYx7qBE3XwFGPxhiFAYietgnlRs7HwJM=
X-Authority-Analysis: v=2.4 cv=I6pVgtgg c=1 sm=1 tr=0 ts=6a30b449 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=RiK9E27ONQb4QlSBX54A:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13723
X-Proofpoint-GUID: 0MTLYB9FnovH1orp0zWJxpQu-ahuEg1y
X-Proofpoint-ORIG-GUID: 0MTLYB9FnovH1orp0zWJxpQu-ahuEg1y

On Tue, 02 Jun 2026 15:29:31 +0530, Rajeshkumar Sambandham wrote:

> Add PCI device ID 0x1022:0x1B29 for AMD UFS controllers.
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-pci: Add AMD device ID support
      https://git.kernel.org/mkp/scsi/c/9d87e0db00e9

-- 
Martin K. Petersen
