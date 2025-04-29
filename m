Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF0425178F;
	Tue, 29 Apr 2025 02:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892581; cv=none; b=lNqSi8z4mXjU4Xx2sx1upBFIXUTNoet528pX1Jp7AqmbSlSj8G9GaNxB1tqEG0xX7uc6nRcWbzEBmj55bhdAjgOrOUwzTEGCwHqdv3qljBIpM1K7YukFOkLpP5z0lHJWn+4dR5mxTaR89axQhaka4VHI5z6vEQHEOSO1dBO60BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892581; c=relaxed/simple;
	bh=SoT6RTdWucu0o1lvNlv+rz07O1oMkR8b/dhOBq+2v+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9eBmy0nyoMq4klzoPla6+GjWzdOwe7dXZ0sXjZ6LLZzgM3tAhCA6H6BZaYB9tf15u7Ql3cbIauJx5oPjMVOm043LMIuk9sL1Ts2B77oJ9JIckOwdr0LixKyIUdB/QVYlUnBB5oQkx0GchN2qnDVN44ysWq+Mj1SPsQhJPFWKXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QfBNF5Eb; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QfBNF5Eb"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T28G5V013685;
	Tue, 29 Apr 2025 02:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mINiJ3m/wnAenGfI7r0OwlEnks+4vvAoEmdUb9yJGCY=; b=
	QfBNF5Ebjv9eB/i1zbxZ4cKGwcsUEpRecA69DJ8Z5zf6ZyPPc9OBp/kTyzwJ3/Ar
	K07yMdbTyvKKEgSpmqAeTJs/vuxMhqN+poZgu0TN+mIM1ymlj9fdWqG6gKDsCDYQ
	coKHMfuZ8xPpJAIdWtk22hZSnQI3ysdZvHdg8Dv6G+n5z2PHU/nfL5ecT8DTArY9
	kPKO59m5TR07krc5Jlb5BftGf1jBF0zdfp03vsORkNHbMPi9vpU+Y/cw55Aas6UY
	Yq4+xaPHto9WB9yucDALc1MeUCXMY+FPWjBdhZL/jl9vSAiK3uy78jUbWAPMFVHW
	A+49cBGeb1aJjktLsp+Zhg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46anq1r02c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:09:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T07EPb001298;
	Tue, 29 Apr 2025 02:09:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nx9724d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:09:26 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53T29OCW020520;
	Tue, 29 Apr 2025 02:09:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 468nx9723t-4;
	Tue, 29 Apr 2025 02:09:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Yihang Li <liyihang9@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, liuyonglong@huawei.com, prime.zeng@hisilicon.com
Subject: Re: [PATCH v3 0/4] hisi_sas: Misc patches and cleanups
Date: Mon, 28 Apr 2025 22:08:54 -0400
Message-ID: <174588857928.3470741.5541955410965623924.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250414080845.1220997-1-liyihang9@huawei.com>
References: <20250414080845.1220997-1-liyihang9@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=914 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504290015
X-Authority-Analysis: v=2.4 cv=OttPyz/t c=1 sm=1 tr=0 ts=681034d7 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=lzMmIcKYArRa7kSAjFoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13129
X-Proofpoint-GUID: TwRmuZPGl-Az3WTmxeCm5FrIx1R4-lGl
X-Proofpoint-ORIG-GUID: TwRmuZPGl-Az3WTmxeCm5FrIx1R4-lGl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxNCBTYWx0ZWRfXz5Afx1bJxcpQ 9+96RMhDKpwsRmG54ZmGMHF0dzH/N8EIB7yuOI0nUMGd4uik6QWuFz+YzwEVCO0Xgalj4zbkUdG 6W8jDWjzYD74cpDr4QSvv/n8DrQ4kMvqXKhgneTyYcyMuoPsoyTRwssyt2XvS8opErUJnJBLDTA
 vj8z/I4ajfIEa6WdsT+m1ZXD32MPgt62WjpZM6+jUoIrDKe03dqz3j9YKYQXr/el9iLOaO75086 9ZPzI3WGKm9xiXeu9f3CEqmfag+f6P6dR5ToxJ44TmE4YFIUAhq4E9atY61KFW9U4vNp+a6Y9dZ PzaHV8wZYGJjVXtCKWjSc8/8pXtIxOTb/ibVWsBvTZwAiNDIQ3EaIpYmqjaiFYudGIA7B2QWHgX pg/1UDpW

On Mon, 14 Apr 2025 16:08:41 +0800, Yihang Li wrote:

> This series contains some minor bugfix and general tidying:
> - Ignore the soft reset result by calling I_T_nexus after the SATA disk
>   is soft reset
> - General minor tidying
> 
> Thanks!
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/4] scsi: hisi_sas: Use macro instead of magic number
      https://git.kernel.org/mkp/scsi/c/4ca7fe99fc84
[2/4] scsi: hisi_sas: Code style cleanup
      https://git.kernel.org/mkp/scsi/c/92c8fe152415
[3/4] scsi: hisi_sas: Call I_T_nexus after soft reset for SATA disk
      https://git.kernel.org/mkp/scsi/c/e4d953ca557e
[4/4] scsi: hisi_sas: Wait until eh is recovered
      https://git.kernel.org/mkp/scsi/c/1ca57644e2e9

-- 
Martin K. Petersen	Oracle Linux Engineering
