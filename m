Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C6641C71;
	Sat, 24 Jan 2026 03:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769226818; cv=none; b=dddQa7rKyOz7QnWPNXWbQxvxJzcQuhkJzUooC9mtZCaNb2jvHquRnC6tV41WMsFtf5o+UMr4eRBsBaBEShjozwnNg8Xes/JFTw0ApfXIb2OBUneanDZk76D8ohxFr/kLhTb+oW8GzmdJRD1Zpr0uIJJZrSDrgqDTrwS5oTRJVhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769226818; c=relaxed/simple;
	bh=Wcg6+CrRd8tdt6fC5tCHL2fYlARKcDRRqyU1tZYItAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XueuEthxp7oj/H8P06MR7XDEuV0UhRLK4n1VF/6vpfM7KKjpW0+WsWF+hCbv7IP4rfDnVoyIhLPJ7ZQctq+vFZkw/uLNfRtCHxPo4aCZGhhIVZ9j4kX9mfYrYNI9xpEuw4unPM6JYCWLXLrSP7dSXpfsBUbopomJDApXI6ydCnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QSNQF9d0; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QSNQF9d0"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60O3Usur098805;
	Sat, 24 Jan 2026 03:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=u2B2d0SVhIFFeaNGJp1VZPe1V5j+DlWEksp7hHGHRA0=; b=
	QSNQF9d0PE+fh0+h2qqRC/So+/9MO+rMW964NI0r+0Pk/vr2dfkhLOinc/IGKoG7
	TIUW38LKE0qwunrlaQIuw0SFF8SRymBmkUIKLI6uanD0a4rqMIFpineDxSsVlSDK
	emMU4kW7S99Zr6frFdB373BVi+1WB5NYLr/ZNei/FOanvQXEmvsZl24VzuHy0zE3
	anW595UHygEbyxKf3AaxTpfYqSc5XyR5BYR/fr1sYI8jbCIjWXNHURsdIcbWtsXT
	PWje4o/tTBhSmJbOdWvn/47P5F4u8SCjrLMTQ3wLHFrgLtrfIXzXx/LRSZmRIJpH
	lgiX127lMJQDjfdyf7QGNw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvn09g1gp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:53:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60O1Y3on019761;
	Sat, 24 Jan 2026 03:53:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhbak2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Jan 2026 03:53:31 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60O3rViX002545;
	Sat, 24 Jan 2026 03:53:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4bvmhbak2d-1;
	Sat, 24 Jan 2026 03:53:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com, Ajay Neeli <ajay.neeli@amd.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, git@amd.com,
        sai.krishna.potthuri@amd.com, michal.simek@amd.com,
        srinivas.goud@amd.com, radhey.shyam.pandey@amd.com
Subject: Re: [PATCH] scsi: ufs: amd-versal2: Fix PHY initialization in HCE enable notify
Date: Fri, 23 Jan 2026 22:53:24 -0500
Message-ID: <176922663899.2974474.7208654333061156840.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251224053950.54213-1-ajay.neeli@amd.com>
References: <20251224053950.54213-1-ajay.neeli@amd.com>
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
 mlxlogscore=736 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601240028
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI0MDAyNyBTYWx0ZWRfX2f0Jwfn+2nAX
 I19A1+rLlCLz6ezX0PiNAv0wRVkR+WdZEGQurqV8/5C9vwaGhO2+AbLyvUSzUdn3pfKzkHesqZu
 QXeQQ1zQpyRus7MrizUr7HipV/g3crPNWDIQeLdVoOHw3ctdRfw6Ej5KL9cOMNb3omvKPvWHpcq
 cjWOrKilPXmcJZJ9JIRV+vCWSPL8pbIpH2QVWnGlo1VuE+9/onVS0Lr+ahQZtbJPgnRh+f7FWvJ
 5taMnOI4XhbDObuQSl7ZSIIo6lBKy4xbgDZ2eS9P+ClBG1WI9HuqjgbKMWRBZVAF0UlEBwbIpU+
 gKMF+fWt1Y0oGykZ/Zrf7SOfrQv3fBMWXHVM793PblrFlravptSHz5RERiK05frgfCvRngNtaPt
 QBu5OX8AgPETM6UY4NgEMss78ZVRo/TSFramVFZxoeEOCSwjFmVS7hNrkmJt5gV2cq6baH/syyi
 NTLY3cvXWGWgtrkpBvQvRWbLQGIKz4Npyua3jyjg=
X-Proofpoint-ORIG-GUID: Zv8OJzb0vwdYdE6Nz3qZWSOP4EX1VcXB
X-Authority-Analysis: v=2.4 cv=Rp7I7SmK c=1 sm=1 tr=0 ts=6974423d b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=2EKg1jf6iU7tsW3Fa7sA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-GUID: Zv8OJzb0vwdYdE6Nz3qZWSOP4EX1VcXB

On Wed, 24 Dec 2025 11:09:50 +0530, Ajay Neeli wrote:

> Move the PHY initialization from PRE_CHANGE to POST_CHANGE in the
> ufs_versal2_hce_enable_notify() callback. This ensures that the PHY
> is initialized after the host controller enable sequence is complete,
> rather than before it starts.
> 
> The PHY initialization requires the UFS host controller to be in a
> stable enabled state to properly configure the MPHY registers. Moving
> this to POST_CHANGE aligns with the expected initialization order and
> prevents potential timing issues during controller startup.
> 
> [...]

Applied to 6.19/scsi-fixes, thanks!

[1/1] scsi: ufs: amd-versal2: Fix PHY initialization in HCE enable notify
      https://git.kernel.org/mkp/scsi/c/0444568edbf8

-- 
Martin K. Petersen
