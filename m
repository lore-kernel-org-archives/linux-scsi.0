Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D1722301;
	Sat, 24 Jan 2026 03:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769226638; cv=none; b=Dzwvk3s73cXSZ6doUITdZ+G8SuaEYOCWuAb6p1ekL57fmW42JJJ1qw0/zkTkejzKcLObpszbRI7HK65IE0tJX24+SAlZ941ZS8FNuWTD8XdMMYOfUZ0j3e+L+XwOCY3GUjmLmwNynV4yQ4zOMLYZnJ6TwUwQwQVyM9dtaXOUGj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769226638; c=relaxed/simple;
	bh=42l6YtylT6TQm7ff/z+w/oByGd+aMnks762usiePNSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gM6WM/Ye5JXEftS5x5S+jvv6yPFA3g7JgWqrcfZmdjn/3ZYGw1wbuvJV+UCqdoBEBK4AW4wrW2UfFSU5nU0lY2LqO5sNQhhcqxtgtO7wH45cwkzzTjZlDmPo4t+R1TiEjPu2perj20QRePqpVx6gUPMiAtgse1RbiPruua1Ne0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=r9TKRLf4; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="r9TKRLf4"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O3Z18O1202406;
	Sat, 24 Jan 2026 03:50:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NrL5iSGPFvfTzx/j4lq4wuWu5i1EOarp0ld4tqRsSnU=; b=
	r9TKRLf40mLHrdKVjMdlDa+bfn6+mpmn65IJXClsUXBPv0v/672EEpC97ldnpFPf
	bTa2Bqispoi2X4lo2weQuaieQfQQjH6nmxgBTyXGNvEale87cOeMNrj1lYSPeny5
	ZdO0iTwdjUgebpoVZGcixws8M0R+5TGbCpvo51mSeuGE/8uuyZCMOYQcrJrdB/z/
	9nH70LhhVoLcX5zF1cP3wxbiqTRXjvSASOGpM5Bvh5OtSeXBahpOGysLKVrrxL6x
	GN53nQ9doLtomwym/tWuHgXHgrnh2w0jHLRGTtQWEdmYFdORM6MNW2BMGwov41Qz
	OjMlsFbUpaAk+I2RXYVBUQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvp4br093-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:50:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1YHWB020034;
	Sat, 24 Jan 2026 03:50:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbah67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:50:24 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60O3oNSn037773;
	Sat, 24 Jan 2026 03:50:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bvmhbah5x-2;
	Sat, 24 Jan 2026 03:50:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: ALIM AKHTAR <alim.akhtar@samsung.com>, avri.altman@wdc.com,
        bvanassche@acm.org, James.Bottomley@HansenPartnership.com,
        peter.wang@mediatek.com, tanghuan@vivo.com,
        zhongqiu.han@oss.qualcomm.com, quic_nguyenb@quicinc.com,
        liu.song13@zte.com.cn, chullee@google.com,
        Keoseong Park <keosung.park@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: core: Handle sentinel value for dHIDAvailableSize
Date: Fri, 23 Jan 2026 22:50:18 -0500
Message-ID: <176922262107.2870193.18152447158706871214.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
References: <20251226042825epcms2p6f02ba12fa97ff4a69c00f6fb9ff55603@epcms2p6>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-24_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=847 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240027
X-Proofpoint-ORIG-GUID: TfD05h5iKRQMweY0DnnCStvMMY6Bb6Ts
X-Authority-Analysis: v=2.4 cv=StidKfO0 c=1 sm=1 tr=0 ts=69744181 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pZ8c2ztXEa7yudCrEswA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-GUID: TfD05h5iKRQMweY0DnnCStvMMY6Bb6Ts
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNyBTYWx0ZWRfXwtktYBDinzuK
 5VgFTiynVAXy/9+zGuZvN0kAi+gGZ0M+gFsfMXRyH2VyHKAfJQDglremlTz7t+24CqLpzPdSp2B
 TycHdOdUBc+12O4pBegIZKMtSmXLMFT+g38O3YngpHT4tQj4nAFYWpeec5N7FpSgDOkaJCt7YLM
 mAOniHYfB/N6BRrg00+Q7WZrLvHl6Q6UmxFdzgv0k0pInlrRwQmQv8aSy4uQ6+8Oh5PhRygT2jd
 QpbRVE4PhHWTk+NvEOymynMaDVJHioz8PLvvhA+Y2GspclfyBbO+UfRrSGPfJQc6z6j61LgHSgh
 FRxailE05GkAr00do5mrBB2wuZ0v1KulRxpkJvWWvYF5dPQbGxaZwL8orkGHtzryGu7/U3HMXy9
 v+xtEVBPnIvmfk6UmjvJeDSSqG7DfFMnitvVNc/iIYyvIUN5z+ymigLsISp9GSh1wpbEqZQDS5F
 0zIWTUCAe3JJIrxJYB7icoPBxGOYaeNViekZ2vTU=

On Fri, 26 Dec 2025 13:28:25 +0900, Keoseong Park wrote:

> JEDEC UFS spec defines 0xFFFFFFFF for dHIDAvailableSize as indicating no
> valid fragmented size information. Returning the raw value can mislead
> userspace. Return -ENODATA instead when the value is unavailable.
> 
> 

Applied to 6.20/scsi-queue, thanks!

[1/1] scsi: ufs: core: Handle sentinel value for dHIDAvailableSize
      https://git.kernel.org/mkp/scsi/c/695df7ea6099

-- 
Martin K. Petersen
