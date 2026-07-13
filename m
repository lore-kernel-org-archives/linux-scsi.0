Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA7D353A8F;
	Mon, 13 Jul 2026 02:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910031; cv=none; b=OQJh38ArfFtmiPaCqCkPEi7p3ojhI6/3/zI4b0+ybWcVef9e7yGIEvtSDiqcupkhPrZ/XXOLxf3S6nN1hpOoPjx3u5V7Jej0/ZSjdWIXmDsxCXT/vkEP4N0qtur/bEN5TuLUlDSs0pBnnq5u1azr4Qjqaj1TSQmpQstsJvcNcsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910031; c=relaxed/simple;
	bh=eyxg+9NgucY375rVUctbqLkX3lYJR8HysPZjiVJyREo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q02TiD4bCtCQfOYArhZN/vn9yH1qkEp9isQwBfRBEiLh2bKLsnFuw9srh+gdSB+r4ukMeBCFFhwsP+0kA3/xie9CzfF7KfxupaZt8pqh1VivYV7R4xkICNN3chSMLBTWq61bcx6bsT/mr+acVhLJwjk1kHM/U5+MaIWUZClTNdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VfHjr6k1; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VfHjr6k1"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66D1Smsj285755;
	Mon, 13 Jul 2026 02:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZTqOFTrBmCMqF9+g6xAwXqKVrMMx7tnPxymZpU1C89s=; b=
	VfHjr6k1P0PHz8C7KHMBY5EpoNCtPrJ6hBIM0AYtFej+BQvXTTFL5lHqZELQG4U+
	zmYefM2jz2ekpI6kNk/nsnCysHIiZx/Ps+J+QoPExnuUMjHaAOEjFqZUkh5a3y3/
	XSANsmEaRKD//Yboz3I4OhocjQwkiWpdjLw83usGFvsv1VVlDAaeK2I5xQAahuq8
	s5CmDb5XFH8YYTBHp0Z8gqCs82soW/b9mQWJBLlSIkK6SLzGp4CUzjNSQ3wm6Ln/
	Kq7F7WnAHYVK8n30LfIF8lkamwVY6/28o8A4ZNder8w/uhQO2L3P9Rluof6NdmWy
	mnEOlaObSWJVIkFbVqLbPg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed29cgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66D2XV1h029168;
	Mon, 13 Jul 2026 02:33:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9fssuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 02:33:35 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66D2O0cr010878;
	Mon, 13 Jul 2026 02:33:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fbc9fssh6-5;
	Mon, 13 Jul 2026 02:33:35 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: dgilbert@interlog.com, raoxu <raoxu@uniontech.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] scsi: sg: report request-table problems when any status is set
Date: Sun, 12 Jul 2026 22:32:36 -0400
Message-ID: <178390967059.3399387.6058053013796540106.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <54B60C19F7DB8889+20260707030845.970018-1-raoxu@uniontech.com>
References: <54B60C19F7DB8889+20260707030845.970018-1-raoxu@uniontech.com>
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
 definitions=2026-07-12_08,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=611 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607130023
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfX4dTVlJbiEg+c
 f6D+T4LnsuWBx/1Eiaq2ciqMyElfc/QcL8ugZ/hFxFYjHL9wBhqfmdBPI/wknrFXTqLOzCeZqiq
 ak33eo9ezHn1brsafQzMmpijfEo8K21HcA5u/n3rT7ifoH1MtbFkMQwytEATfrQsZifcoWsLPE+
 f7D/JBUhI5IrPafT9XeCX9taXqHQi6EBzF7v3RG7x9WSqcmGOwsqpe4GcBiXibVxFnOAx753r4D
 zEfqbCwA61HiJ4ibalEJs1je6NwoOfNPeyX8UtsdcMNGrMo/NlgBrdvSASDP15fv59oiEXNOOm6
 ti3OX50/s72D83s03EEvB0cnJB23ZYir7RbkUMy+yPxrTydON/uBQM6v/0oV4zHMHVHwdQ3JtTU
 3lRm8USTI+Kr7UIKBneO/fOUNXYeh7b/kbm1grMSG2SMaS5mrs3vZxqx0k1+QbEIkPWnV7a15jV
 ee3EEvyZZwk1YOowXyJyWQyM16o9DU0CaHhIAjXw=
X-Authority-Analysis: v=2.4 cv=GcknWwXL c=1 sm=1 tr=0 ts=6a544e81 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=9hHxCcKdQvOF-1PyUdUA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12221
X-Proofpoint-GUID: 7kxWbRcA4zjRwkg1X5HQBBAAY2GWemNA
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDAyMyBTYWx0ZWRfXzTRdT0PYwraW
 5caw8qu3ODf0m8z0etclBqBZiBJsRq8XxZ1f/pLzRMZB45ggqzAPgGqn6pFGL77LL1gfkclm5E0
 UoRdUFLuSg+6zz4QeNcXVyCuTlEv/mephxMzeT6a/kUiGKDmtEYA
X-Proofpoint-ORIG-GUID: 7kxWbRcA4zjRwkg1X5HQBBAAY2GWemNA

On Tue, 07 Jul 2026 11:08:45 +0800, raoxu wrote:

> SG_GET_REQUEST_TABLE reports per-request diagnostic state through
> sg_req_info::problem. The field is meant to indicate whether there is
> an error to report for a completed request.
> 
> sg_fill_request_table() currently combines masked_status, host_status
> and driver_status with bitwise AND. This only reports a problem when all
> three status fields are non-zero at the same time. A normal target check
> condition, for example, has masked_status set while host_status and
> driver_status may both be zero, so the request is incorrectly reported
> as clean.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: sg: report request-table problems when any status is set
      https://git.kernel.org/mkp/scsi/c/1d3a742afeb7

-- 
Martin K. Petersen
