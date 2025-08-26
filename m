Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618CA27056E;
	Tue, 26 Aug 2025 02:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756175668; cv=none; b=Jr1W+NgI5uAO+GUj1a/IUa1iLWnpt7KtzJHpQP9xLZNGwmZjFzxjfTtypCaLizE3xLU8che81U6jn2hzUAg2yAfLwGhlVsZ3wtH/ZiZn2qTeiMLq4HYNMOgezzVHNvprTzsuwh3AsTW60Q/0RQ0/4ix8m5pLN/CSiX3QxtxB0CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756175668; c=relaxed/simple;
	bh=1eXuud9EurRpcghR+aNueIU+kv6RL80lchlF+SZqfuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GkR3fcx1DK5SQ0tuItt6aCIcQfP/XJ0vFbzOED5JGJDh8RzkidKhPE1VLJy98bX/Tqv5Ee8aztSfngonaUhaAFiZQB0YKjXKrayAk6MyM9F/BemTDbAcnigrygZ882+kKX5JBqD6iDfJ4urfOhfi0VG0FXXDJmLF0hgTLI633dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R7nOcg5L; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R7nOcg5L"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q1JHw0011249;
	Tue, 26 Aug 2025 02:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L55ghXavB7aUxNG5PA1sPhB/vRGawzBq7VnALhEDHzc=; b=
	R7nOcg5L1tVTtgFMkaLATquCttoxStHozvXe+GYZs6wKv+iDcX2Yesi53qZzbiZM
	jDyvMk5ycAU4m2KDlGWB7uZouNI+DOHCxBkbT5i91Jfi3wtNLgzrOTzQDHk7w8No
	Ii7FNKElx6ZHRvqVFgOZ1nY5Ff3dq3wZ3abEiju/LqGQ2Y0HdillCDF6g2ExqRJ6
	QjAdpk5E16k8Ro2BhKOXN3NY+2/ONmhSmonGYHUYlB9vdexnrSbCht4tUPCRm1CP
	DoyoQd5YPO8EvFtRyyTaHcURuVmhx6RvEohf2MiFdsMcyPOFf1+UJ7ZTouk/s35V
	EshNYUOtwbxVY5Sz0qPC1Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twa8uk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q0YrXX012168;
	Tue, 26 Aug 2025 02:34:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q438xc25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 02:34:03 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57Q2Y2s0010861;
	Tue, 26 Aug 2025 02:34:02 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48q438xc0n-1;
	Tue, 26 Aug 2025 02:34:02 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-nvme@lists.infradead.org, kbusch@kernel.org, hch@lst.de,
        sagi@grimberg.me, axboe@kernel.dk, Bryan Gurney <bgurney@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        james.smart@broadcom.com, njavali@marvell.com,
        linux-scsi@vger.kernel.org, hare@suse.de,
        linux-hardening@vger.kernel.org, kees@kernel.org,
        gustavoars@kernel.org, jmeneghi@redhat.com, emilne@redhat.com
Subject: Re: (subset) [PATCH v9 0/8] nvme-fc: FPIN link integrity handling
Date: Mon, 25 Aug 2025 22:33:53 -0400
Message-ID: <175613417235.1984137.13827666752970522478.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813200744.17975-1-bgurney@redhat.com>
References: <20250813200744.17975-1-bgurney@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_01,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=949 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508260021
X-Proofpoint-ORIG-GUID: ryuEKCCrvsMKSxHKhpmLuXYOt4OckGpO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX5cvgzmOQStbf
 ikmyFU3/QlCSCFA/K9hI4BUtIgCIl0uplZ5fhMjKvXH22QxY9QTmBCjGWE7fpC8zvUFnijs00kP
 Y+zMT8n4F3KNyqBLSFm9J1OKIhrpyDrmZ97ieNak1LWw4L+FGjWd1kHsYQDjKeoumIOqUqZgqwQ
 HpCjOoza7KrFp9/ubqGPaO0QBkPlPDpYS1wI35tlELaDscdrnWKX9ET/8sVicebkORMQjVEm9XV
 VYqDxLAP3QD3yhKHeFh5OHjOfyuBUrMDkzoa4rYZsocv1+Censc9F/L1DQhBgdawRBzHgOEqGV0
 T/7o74TX2K/XqokshlqA6DK0dy7ZQJRq4DTn9m4qwnMpvxdJhsv5C1wwecW35vm4pGl4ZWCVlal
 OgNILNp/NUyx2jHAMCreTcVZGUG6AQ==
X-Proofpoint-GUID: ryuEKCCrvsMKSxHKhpmLuXYOt4OckGpO
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68ad1d1c b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=4R7AhlzvliZDtLbOosoA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070

On Wed, 13 Aug 2025 16:07:35 -0400, Bryan Gurney wrote:

> FPIN LI (link integrity) messages are received when the attached
> fabric detects hardware errors. In response to these messages I/O
> should be directed away from the affected ports, and only used
> if the 'optimized' paths are unavailable.
> Upon port reset the paths should be put back in service as the
> affected hardware might have been replaced.
> This patch adds a new controller flag 'NVME_CTRL_MARGINAL'
> which will be checked during multipath path selection, causing the
> path to be skipped when checking for 'optimized' paths. If no
> optimized paths are available the 'marginal' paths are considered
> for path selection alongside the 'non-optimized' paths.
> It also introduces a new nvme-fc callback 'nvme_fc_fpin_rcv()' to
> evaluate the FPIN LI TLV payload and set the 'marginal' state on
> all affected rports.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[9/9] scsi: qla2xxx: Fix memcpy field-spanning write issue
      https://git.kernel.org/mkp/scsi/c/6f4b10226b6b

-- 
Martin K. Petersen
