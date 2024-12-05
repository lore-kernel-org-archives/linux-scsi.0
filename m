Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7152F4E2;
	Thu,  5 Dec 2024 02:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733365114; cv=none; b=HotFAxmKjJOJon8PZOFgNTD3GgNx1YW5f22mBvntl05FGL5u8lc+fP834G4qMDqM4I9gUCalQxEsluVlSw+gnIu5s250tYbJX97NLBxuVlNJe3VSyQCa/alm/JN65GktLVpm3npLMwme66h49GupHG6y/r/Yeqamj2iXOgr6+OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733365114; c=relaxed/simple;
	bh=nBX3ow0p0Fwc7PV0o1UcbmziHwrQ0Cgt+2+zW2D3g48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hHRzovHhy9zybiE80Uygi7qUfdrO4MmjT+9fwKVg0/rA9ohxJ+JIZm9nzXWZLB4Y4zYl306FlObORBNaF5kOgGsoadbzlAUkUQaOmjQ79k+3c11BfPBQ/35czYLNE32ffmHQDOJT7aZJXwAVHuRKy95phqgKIBJh54juX7lJsZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SrqcCpu+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SrqcCpu+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B51BpT5026351;
	Thu, 5 Dec 2024 02:17:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=GFDJEh2h+7hEQ8DkKn8zRrqmm5esLpVKlkKmELOfHPY=; b=
	SrqcCpu+VvENf8ii4rvMCDdqEjO1N3h24quEG4A67Mt9ytpSYn/dFmJWh/07axUy
	XwfR9XBzHosH78TSfqi9U2+14ZoKGZ70qN6SNQFh2YpmV8b0xK8SstjEOozJJc50
	xHfVNjOHCKkWEJoRLElAKduySATwaadMfo62LF0OR46EgEzStVXrvb1q8jQUs4TP
	WjUm+F7FcrOugCd0bMwjTLWlwxph+LEp3IdgMavYY0QEdXxXRMFzybLVteVR8zPm
	45VgxutmBvrD5uqnbgFpJvqmKZFxdIiBGsJUN2IUAEGQSk5CRny/MaRunD02YwAp
	Ro7oMG/PS3kmM2QE62F9Vg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437trbsxwf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B50Bk4X001376;
	Thu, 5 Dec 2024 02:17:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s5a8u6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Dec 2024 02:17:42 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4B52HbvO018742;
	Thu, 5 Dec 2024 02:17:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 437s5a8u3n-3;
	Thu, 05 Dec 2024 02:17:41 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, avri.altman@wdc.com, alim.akhtar@samsung.com,
        jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, yi-fan.peng@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
        eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
        bvanassche@acm.org, draviv@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] ufs: core: add missing post notify for power mode change
Date: Wed,  4 Dec 2024 21:17:02 -0500
Message-ID: <173336487644.2765947.4960635225695603166.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241122024943.30589-1-peter.wang@mediatek.com>
References: <20241122024943.30589-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-04_21,2024-12-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412050017
X-Proofpoint-GUID: m1SM2rf2XV08WfvKY5okJaOm3yBzardu
X-Proofpoint-ORIG-GUID: m1SM2rf2XV08WfvKY5okJaOm3yBzardu

On Fri, 22 Nov 2024 10:49:43 +0800, peter.wang@mediatek.com wrote:

> When the power mode change is successful but the power mode
> hasn't actually changed, the post notification was missed.
> Similar to the approach with hibernate/clock scale/hce enable,
> having pre/post notifications in the same function will
> make it easier to maintain.
> 
> Additionally, supplement the description of power parameters
> for the pwr_change_notify callback.
> 
> [...]

Applied to 6.13/scsi-fixes, thanks!

[1/1] ufs: core: add missing post notify for power mode change
      https://git.kernel.org/mkp/scsi/c/7f45ed5f0cd5

-- 
Martin K. Petersen	Oracle Linux Engineering
