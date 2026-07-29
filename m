Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92181389E13;
	Wed, 29 Jul 2026 02:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293868; cv=none; b=PiJoj7dCYwN+DFmsSSTpnBUBBxI290nYtVOJDFc8o4h60u8HJAZuOout12J17JsKu6084rGqaSBpVkTBjJ43daCXmHrZa43BIoyCTi852f3/hHbILcw2YnuJl6ee0xL2vcHHqt+Uu5luU24UfBnCE/oy7LK4qMRBzHstZSLzHZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293868; c=relaxed/simple;
	bh=LEPxcvO6Ahod9ma5ms0CoqoPZoJ85X9ztqyPcogRQjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GYv6sxfHS52cVP8gvTTP3Vgx3KpvQOXG+nsG6ohNiuH8+8A6YROgYRWvPg3cvCLAWnWK16cE99lk9U6xMMyieTZiIk4WO3M0JqEdTM47PhfzbZtlJ7WJj0VO1Ir9in4/ddzABJzcocyIoCDbJ0h78vci5FqYjeTA4ldHPz+JXdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LJgPLdxK; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LJgPLdxK"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItX6Q1074582;
	Wed, 29 Jul 2026 02:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PDyCty7zxNAK4tDIQs9F8rFJT4C/BQM3rjj346dw6KQ=; b=
	LJgPLdxKeViIPDwGojNmKyPuiYb1+Wf3w2vhgCB2bvLPugGr7GLaAhM8LrbGIBHd
	pcb5AvmcBSKxRoH4goIk+ClJEYp9ZLGPznaMqJDKZWwHx2y3SW5egx1LGauNr7W2
	Mhxiulv3PuS6eFp9wuovJREy4HipXaEmaySdtlGjWB5DXDzOo65pJLaRy6KUu1jC
	c5b/YitbenzVOwCt4ubsqpd0I6KeaM3v6TxNBF8HR/4hDB8OOrWMDjzLx3wVROX8
	wRtzKprFebz3VkINhbJz4nrdjgYR/2z+GWymGk1aItdx0jUI3gyVKHH8MbCaOdDV
	ePjoBdzAb58WUJSFDIiw4g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq548m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oY53034636;
	Wed, 29 Jul 2026 02:56:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkqr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:24 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMA1006812;
	Wed, 29 Jul 2026 02:56:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-4;
	Wed, 29 Jul 2026 02:56:23 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: kensanya@163.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        TanZheng <tanzheng@kylinos.cn>
Subject: Re: [PATCH] scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE
Date: Tue, 28 Jul 2026 22:56:11 -0400
Message-ID: <178529373851.132455.17343492235216423628.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724075850.280699-1-kensanya@163.com>
References: <20260724075850.280699-1-kensanya@163.com>
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
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=550 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX5RgUcUKBsmaR
 wQQ6nKCuP//zxOffeLfk74YqnOEMXzWoULDdo+hkRAL8ybnsicbJeTcs/WH/7zuwFdcYXpSwa0Z
 F4qrEU0S2ObWIzmqJLLs6viZzBEN1mfdJTZ3BnHkYX0QDWs8ru96UfErPl68M4dHOu84twIWqc3
 6GrTfEYD7VAiAuOKlpiZVg3gmLFiwkli9Mqqv3ulhn1J2+Ym11N0zQeHa6Yu3k51/BscnvfvTaP
 KiRSaGu1uyHGw9GrHyCiH4Jqck7rGqQYbrtLdBhTLl095dTLmr5/761WQocrJBcDvKnCTORxYi3
 0NFiN+v93PeKWT6oWNN7UcauIIEr3/M8F2fipivh07aDGgPeN7/fkRlhvPHr8y96v1/R7DWKAns
 hO/iz9MZ0zg4mBSRKUzKwPTpd4LZSZpKezhFbFtzx5OGQzf26TVJoOPJEs1501+gd7SGRoYfxAW
 SgYR0sPo+C8W0LHyeS3126NMOq45fVp6d2kxAE1E=
X-Proofpoint-GUID: HuJnV0z_FuMKpTJETC66buWvg4O4eAL_
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXxW7hm3MTSMq8
 EaYUh9eafnGFwPBvXHcoo+3qibjKNGPH7aHOqm1iBCPE95ThGPkP9n97eOyynOGo61rpTaf8Qok
 I8lLWY2ICCGQyZ1nLQcg3vSlG+hJPrZ+kszvD8EcY9F4ghMkHA0z
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a696bd9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=Byx-y9mGAAAA:8 a=gzltEgot3mvQ9GfFOcAA:9 a=QEXdDO2ut3YA:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: HuJnV0z_FuMKpTJETC66buWvg4O4eAL_

On Fri, 24 Jul 2026 15:58:50 +0800, kensanya@163.com wrote:

> In the iblock_execute_pr_out function, PRO_PREEMPT, PRO_PREEMPT_AND_ABORT
> and PRO_RELEASE all perform callback capability checks through
> ops->pr_clear. The error check allows unimplemented hooks to pass through
> the gate, resulting  dereferencing a NULL function pointer.
> 
> Check whether the hooks that need to be called are supported.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE
      https://git.kernel.org/mkp/scsi/c/9c33222bd387

-- 
Martin K. Petersen
