Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477E028466C;
	Wed, 11 Mar 2026 02:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773195000; cv=none; b=GwLGQcnZ04DILXXH+LChHNRcMVjW60/l0DiPRbeKGP9D3ir65C60GTfyvzixtHFvZF1LEWRp8o/8kVb1/WW1OpHry7AkBpvRztdNO4+88vDgVqOp+ntUkkt8cbXG0MB7pPWBcgD7fFYs6Z4gNNxoD06C6DuguBrhAaBbd8qOJ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773195000; c=relaxed/simple;
	bh=KPmY88Ea/fW5GG4HNnP9eil0tKGecgw+g27CvvlQYyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pXAaDvqm1nAh61GNHsa/2lOIDd/8yF7YwchSQxOYT/Eq29sbUeG2yTJrUr2Y+lM65Iki0F8fAwiK9wR2RfGUJSNHM3ThDEd0VKM4Jrvc586wvXo0fAtz77RuCnTbduPTyb9uKh9FVfda2eVldUOo9wLH2eCaDYOOyy2XFrB8L0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RYuaKOOA; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RYuaKOOA"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIYgxl2347887;
	Wed, 11 Mar 2026 02:09:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2cz6alsdKKXtL/NaufthgCf3gRLP1VXTEABSy9kbUng=; b=
	RYuaKOOARQsuOy2XGyvlu9HjQqTfMUodAZwVX30cD4v7tOvC7WXokPM4fL1iGzF6
	Ld2e/zh67raXaSpL2boxi79xlmPN57jTkpFc/1etrggvXPo53ZTFo967LnatSkiD
	Pmr4OcEgrCVkgeYe+9u5SAx3a8MJA/4fbcdsHWSCVo1c6/ciOqjMyPUu7SalkMgH
	UPVKDWvaUOeGjzyIvLVjBlCkAXhqtvp+SBqYEGR+H1QuuaG6pjQEGQ++w0hSm+Xi
	xrbki7d9OuwBzIuo7/fxpsV9TzjZPTT6KRWNC2z4EhywBQdw6Z/btPBOwfofThF8
	vdiEVO8RESlvhutKpg5VgA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csmmac31m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:09:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62B23hrT013484;
	Wed, 11 Mar 2026 02:09:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4craffewu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:09:39 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B29c9i018454;
	Wed, 11 Mar 2026 02:09:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4craffewtr-3;
	Wed, 11 Mar 2026 02:09:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yangxingui@h-partners.com, linuxarm@huawei.com, prime.zeng@huawei.com,
        liyihang9@h-partners.com, liuyonglong@huawei.com
Subject: Re: [PATCH] scsi: hisi_sas: Fix NULL pointer exception when do user_scan()
Date: Tue, 10 Mar 2026 22:09:34 -0400
Message-ID: <177319446962.2524613.14229090120578022614.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305064039.4096775-1-liyihang9@huawei.com>
References: <20260305064039.4096775-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Proofpoint-GUID: NC3EUTN4hc9U3_TaXQp5lRjBVVsNqTjk
X-Proofpoint-ORIG-GUID: NC3EUTN4hc9U3_TaXQp5lRjBVVsNqTjk
X-Authority-Analysis: v=2.4 cv=U5efzOru c=1 sm=1 tr=0 ts=69b0cee5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=5gXe__im_SQNU3M1EAIA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13819
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfX++iKlqUTEqhd
 k8E6MNtArorCOzE0MFpe0rslxFgeuojMuX/LeVCzGU7K7AZZrqcgEyB/RI8mFEKSuCOrx3REhqx
 Y8r72U+jq4BQSo2Co85zAxrbojrzccE/n7Bs+XYLNJ/l1+KC4FHtHmY7zpKMvi9j32ZrVqFEbr5
 QbeULp0yMpSTp4NtUHo8GIPnyxPf/dikDp5SE4NVTdb3MP++4Zs2yh5elE9fs2yUT0HcILb3uwU
 7OxBYMqpiD6EkdjnqJ0jcqmYeUUWcwaiUctUFVUkmj5zXj1CUHvU75FsmdI63ByzhnBw3sGmkbE
 HS8Y/6yTsffj8qwFBlk8qK8fiDyvMNaYvb8eB3K2F+AXmKCmrYb9dEB3xFfydzDzy0vzYOkLeu5
 g3WI1JUldsgfLk/1gxHR2MTIFGzLzRt4zNmyRTp1pgzB2OUO0GP/6wG/IlJZf4onViD6Rk7jjCu
 mSIXTaGJ3lMxO0GOvGR00dHEQL/uc5w/Ach9aKm0=

On Thu, 05 Mar 2026 14:40:39 +0800, Yihang Li wrote:

> user_scan() invokes updated sas_user_scan() for channel 0, and if
> successful, iteratively scans remaining channels (1 to shost->max_channel)
> via scsi_scan_host_selected() in commit 37c4e72b0651 ("scsi: Fix
> sas_user_scan() to handle wildcard and multi-channel scans"). However,
> hisi_sas supports only one channel, and the current value of max_channel
> is 1. sas_user_scan() for channel 1 will trigger the following NULL
> pointer exception:
> 
> [...]

Applied to 7.0/scsi-fixes, thanks!

[1/1] scsi: hisi_sas: Fix NULL pointer exception when do user_scan()
      https://git.kernel.org/mkp/scsi/c/8ddc0c269165

-- 
Martin K. Petersen
