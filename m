Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB1E1C6A0;
	Sat, 11 May 2024 18:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715453653; cv=none; b=Bj1XnwsMkoxqoh9GS2uaEI76Qaj4Wb9YMeZ1ZePwpaOkD2QhL9zqaFdvcox1moSVOER6wo3y1XnLI8jzBuGE+D39y/r/fVPDj7u6HvAwq//uqGsjjsX0nsX1CH8aktBAuw2+yuC6tYuK1L5UZITbE/SzL/8L5GAo5Vm+AEourk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715453653; c=relaxed/simple;
	bh=EPEdq9m9iwTSTHJqMzHZwBRvm5xNudtr0ykqNTzD22Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1Wm+d4Bh5db7OwK57RCamGb/JTX/Gda6kH/ipZ26MBTEWIK3N8hT01XcrtccsLlnwgnjdZ9UqaEsaRa+vQ5llrlvO25bqe68GxO93uoZ5FdIwP5Y/vNFQ2bmnGpOBVsLkKXO3p7CUQuogZrQ6vJHJJmTtaCk1tGgZsAI8ZwSeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oldJ+uFk; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oldJ+uFk"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44BIbxl3027683;
	Sat, 11 May 2024 18:54:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=oEAVqSarmVsZFJHxVfk8asRG0RaO1C3mAdmhMs+r4RA=;
 b=oldJ+uFkw2m85gUa9euc8gNBIypjac8mUyOXshSdDphV0dcbXdZmatfHVSBgthqzdgc1
 LD/6OqIvBjg0s/TvQ4K1W3uqDLS7QqkRPJvKtAArBMbpMPIiUgPGtmj7URLAcDJlpv4y
 Pb8YYGFgAwLD8pJJXry79SzIcPcrkU/lYhJyZ+LHh8Hjf5zz5reg7ffMrvDK64KAoWmh
 Zu8ooL058WQDVvgo1uoYmBuSQuFGFtWgdg808pGSPacTdcG5phl6MC0+rsbbIH2d/CYZ
 Sz9E2pWZDrBlMmd/IzDW0niJYNji7ils0l6Nfe/3XFcHEBA+6NSS7SYHiHxY8ZR1IuUv Qw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y2d18019p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:54:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44BG0GES022237;
	Sat, 11 May 2024 18:39:53 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y44fn6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:39:53 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44BIZYPR028255;
	Sat, 11 May 2024 18:39:53 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y1y44fn5r-3;
	Sat, 11 May 2024 18:39:53 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: michael.christie@oracle.com, linux@treblig.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] target: Remove unused list 'device_list'
Date: Sat, 11 May 2024 14:39:09 -0400
Message-ID: <171545260085.2119337.12710685580186288125.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240503234419.171823-1-linux@treblig.org>
References: <20240503234419.171823-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-11_06,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=818 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405110139
X-Proofpoint-GUID: vf0F97jXEsw2f57AjpuqRbNqFDmuY3Zo
X-Proofpoint-ORIG-GUID: vf0F97jXEsw2f57AjpuqRbNqFDmuY3Zo

On Sat, 04 May 2024 00:44:19 +0100, linux@treblig.org wrote:

> Commit be50f538e9a5 ("target: remove g_device_list")
> made 'g_device_list' local as 'device_list' but also
> removed the last use of it, the code that added the device
> to it.
> 
> Build tested only.
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] target: Remove unused list 'device_list'
      https://git.kernel.org/mkp/scsi/c/0f7b063faf8b

-- 
Martin K. Petersen	Oracle Linux Engineering
