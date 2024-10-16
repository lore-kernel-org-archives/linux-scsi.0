Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1C914C5B5;
	Wed, 16 Oct 2024 02:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729046389; cv=none; b=aIB+iwRsvLpR5AZgYafdaPMk0GsM6DKFTQ+7zRp+H58z9tKJBLJEXsyQfWI4ZBdR1969Bkl0I9J9x0NuFwxf4lr5SPOwRBhB2GxgyvF7p8yI3TNrkhF4Vgqd2onwD29mn9M6eOpp/1HbB7CUinLfFGCRd9TMUwt5Xv9FLulkaMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729046389; c=relaxed/simple;
	bh=g6EASXqUnuuaxkEInr73/Huvms2kMpPHVK/T9xmeJ4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DdBcuSUBBVaQwhc8RjldSlMf6jSbrTDRkjalZT8AbUZlEsWD41YhTFxxLdpzPsvV0Os9of/GP5mHgImuM3wz4x2ZfULcdSpSXk27edEmvWz4+FEDB6aWHH2XkSNYu5AHJedQx9DPoM++/od/Go59BzZm4r41VMnzG0GhTWL/IpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=c3kj8zHk; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="c3kj8zHk"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49G2Mdad024725;
	Wed, 16 Oct 2024 02:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=cEQjGSW748e+dYdmvdb3oEcAeJfFo+EFZcumXUkAnTM=; b=
	c3kj8zHkrnLElMAzh06cx+nIoOBBro+SgjzIyZ2ihQw2yZrfADo8cwnDQs3MLilO
	jumm0DkR0jUnPrjMQ2D05Gc2nS6Ez30gXeEgRDUoWbKEHymbTaaG51e6ZsHZ3dEm
	XmeEXATVr+0qz97gSRGVW386Q5VE1oGXWI/v0V4ZUiILGcbVy/zQi2JQ8FDxV+7b
	9JYogPWhILNhHrXL07J6NyEMdBhXkYitnYYEIJXJtvGnF+WnC5KTOrN5mC+TDViF
	A87IfXGKbIqiRrUZQdkkAkRdmTYsZ6PZ20WKrJHDP9ERXKqoJn66QlOACv8cqR0U
	WN/k5N1iDwVffLfIeUdQDw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7jqdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:39:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49G1UMfK036660;
	Wed, 16 Oct 2024 02:39:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 427fjem1v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 02:39:41 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49G2bkUi023540;
	Wed, 16 Oct 2024 02:39:40 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 427fjem1uj-4;
	Wed, 16 Oct 2024 02:39:40 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: michael.christie@oracle.com, himanshu.madhani@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wang Hai <wanghai38@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: core: Fix null-ptr-deref in target_alloc_device()
Date: Tue, 15 Oct 2024 22:39:02 -0400
Message-ID: <172904632513.1112721.1540847972381471347.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20241011113444.40749-1-wanghai38@huawei.com>
References: <20241011113444.40749-1-wanghai38@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_21,2024-10-15_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410160016
X-Proofpoint-ORIG-GUID: giVx5QzRzPdEIPZ_bDnZ9lxqEIUI1gTf
X-Proofpoint-GUID: giVx5QzRzPdEIPZ_bDnZ9lxqEIUI1gTf

On Fri, 11 Oct 2024 19:34:44 +0800, Wang Hai wrote:

> There is a null-ptr-deref issue reported by kasan:
> 
> BUG: KASAN: null-ptr-deref in target_alloc_device+0xbc4/0xbe0 [target_core_mod]
> ...
>  kasan_report+0xb9/0xf0
>  target_alloc_device+0xbc4/0xbe0 [target_core_mod]
>  core_dev_setup_virtual_lun0+0xef/0x1f0 [target_core_mod]
>  target_core_init_configfs+0x205/0x420 [target_core_mod]
>  do_one_initcall+0xdd/0x4e0
> ...
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> [...]

Applied to 6.12/scsi-fixes, thanks!

[1/1] scsi: target: core: Fix null-ptr-deref in target_alloc_device()
      https://git.kernel.org/mkp/scsi/c/fca6caeb4a61

-- 
Martin K. Petersen	Oracle Linux Engineering
