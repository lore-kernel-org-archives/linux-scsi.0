Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26E71E497;
	Fri,  5 Jul 2024 03:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720151653; cv=none; b=ehnFFnt2TkCENElcRnZCvwOUxM7iy4wa5LsRe2v1aW5j2zKnGQIY879auFR+Xlg8dBAkAv+le3tNcUFOS9Wo3atZdoXY7W+ycVrAzdfERGoVh/S7buN0Nts0fc7CmwdQMWGzvRvyFW874T/YpKZebg7zr3vq280to7lavoDjIvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720151653; c=relaxed/simple;
	bh=nr/jg1bM5MWzbzZpCUk6q0nfnrIohWu1g6YWDVfmhDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=htc39M+y1k8Sk5CD9lOf2ZWcAaoeSdsDZ8XyBCgk6QuM0K+dnwgp5DoiuEKAYPSgU0i+sjqXv1iVdZAEoMWdofi0Zy/17FbhVTANKL7M5mAOD+v+b89KOe6+d2RbK/80ZQTQxD/tTPbOnmAy/x3WN27Y4PORB2jA1bE8b4RFef0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=b3+rzgdU; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="b3+rzgdU"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 464DUYtw031309;
	Fri, 5 Jul 2024 03:54:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=lJP+fTmsnIpsDFX4StdlHbY310Ak4tkzHq97tBUesRU=; b=
	b3+rzgdUT/lCWyr3J/+RmsEXRuRtba+5Y3p8sojQ87Wi6HriIecJqEfjl+6tdIJN
	CSJN4cXGGeneqLvDg0hya7cJbRUASZnODsWmH1qMl8jh2RSrVJGvi6xukZi0Ztbt
	vj0887QN6Eu2XExQAylsbmp8jcw1hTqIdwlRDbaFrIpLIpcuwf8oAKHJnJ3Cigfc
	U7dXIz7kIRQq+L2SsFO7udlTNWv321GVuScSmAcq9V5vmyFIbplAVfCkAD83usBQ
	jm6LhIgJFVyRRujJvWHqg7fcwyP547lX5ZwbeOMNwA1YIqT6sLvJrLz9TBJ87BTh
	NQGlmtYgfEYoFS5PI8bqcA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4029vstxpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:54:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4650UGgI010219;
	Fri, 5 Jul 2024 03:54:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4028qh9xyx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Jul 2024 03:54:07 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4653s6dK010018;
	Fri, 5 Jul 2024 03:54:06 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4028qh9xyf-2;
	Fri, 05 Jul 2024 03:54:06 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: james.smart@broadcom.com, dick.kennedy@broadcom.com,
        James.Bottomley@HansenPartnership.com,
        Huai-Yuan Liu <qq810974084@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com
Subject: Re: [PATCH V4] scsi: lpfc: Fix a possible null pointer dereference
Date: Thu,  4 Jul 2024 23:53:28 -0400
Message-ID: <172014707934.1511036.12995216547242595225.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240621082545.449170-1-qq810974084@gmail.com>
References: <20240621082545.449170-1-qq810974084@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-04_21,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxlogscore=781 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407050027
X-Proofpoint-GUID: OW0g_4GgiflMdNT9q-pobmsi7beIcs4o
X-Proofpoint-ORIG-GUID: OW0g_4GgiflMdNT9q-pobmsi7beIcs4o

On Fri, 21 Jun 2024 16:25:45 +0800, Huai-Yuan Liu wrote:

> In function lpfc_xcvr_data_show, the memory allocation with kmalloc might
> fail, thereby making rdp_context a null pointer. In the following context
> and functions that use this pointer, there are dereferencing operations,
> leading to null pointer dereference.
> 
> To fix this issue, a null pointer check should be added. If it is null,
> use scnprintf to notify the user and return len.
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix a possible null pointer dereference
      https://git.kernel.org/mkp/scsi/c/5e0bf3e8aec2

-- 
Martin K. Petersen	Oracle Linux Engineering
