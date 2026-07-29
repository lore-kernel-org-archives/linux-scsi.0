Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53AD38AC7D;
	Wed, 29 Jul 2026 02:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293788; cv=none; b=K2yUgfqO0lUjVaHQESWeh7HIXaPTaoIHrDmCkCOmVezjrNXlQaXCewImn7BAO6dWnTafiu3uJHRpE8TadTnYgjaAdRxGT5F5tTwoK17mvVmpXDXT3yxKCGOVlvgHx6CxacehO85jZ8eKZjhDaHMfRltUBzDh/kah5BHwbA/clew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293788; c=relaxed/simple;
	bh=QNATp80OPPdw6bvPISEQECEbaWHxFg1Mmgfc1z0ljXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o6TA9yYxN0HUryUmlvkQRkko3IjQYM4Ns3y9VYDOQEPVC74AAVdEfUaWT8TIkAVM6Tfgsf/IM1QDerjdJGI2M2rE9JKysUvT9Ey44JTMwTCNwy/8Z9wKejOA3bTAQ5Gu7TxYkOYLr5zBzMr+TweS9ENwQyM7hHYbZ4M8nTuhiow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SZV+YIDJ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SZV+YIDJ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SNFJFu1581368;
	Wed, 29 Jul 2026 02:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/y0VxjQGtrjLN80i6UrVkBFywLscoIMUgNySRfQxJXE=; b=
	SZV+YIDJSDf+chZE9g5OcJNsauwmtP872rk//Df6ydEoVr3gmiiSFDO7+6PS00Fz
	dgS0LF8ZK6jhOlyiITYD2QEeRnTsnVG2J7iAWyXGHEGlLfb7Pno015prbinXtTml
	Jp1BiiN7Ib7nY6Ru6i6Clh/0WkKni3iSJ4mLIqaqH3pjMgFmDQAkzgwajAi8VwGG
	1gMM9hMdFDlyAEAzPD/Sc8nRuKAGaLyTo6qIflN6NwRycuE6MMXcG1w5un3vrjCW
	ADRW1kSWinAHtnsF8W+FiGBahhpDGQGCop1MGQIBVa2kNh5Uigq+gyhka8vhjCM+
	AVJRv2fGqnCOuhR2HJmhGA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr5xw7hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oYVQ034537;
	Wed, 29 Jul 2026 02:56:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkqu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:24 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMA2006812;
	Wed, 29 Jul 2026 02:56:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-5;
	Wed, 29 Jul 2026 02:56:24 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Mike Christie <michael.christie@oracle.com>,
        Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Clear cmd_cnt when initial counter enrollment fails
Date: Tue, 28 Jul 2026 22:56:12 -0400
Message-ID: <178529373871.132455.14926214635980143685.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com>
References: <20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com>
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
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-ORIG-GUID: epFqs7N_pFBtnhl2sWcjM_W_bnFovCFr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX7oEbXlugPERo
 SbndxnCdU85P8RkCPboe/X6Uqz3vsSY9Ss+xTBW40rTMOtYeBP7gNdo/X00V1mbpmBVPumit5F1
 NJUy240Gmq6SrdJL8kTzuPAd4uRKq62I/A5b6F9tlloZkwNYRR4s1/EZ/XsmJqqgH3zs+8BjkX7
 tD44kzmK9fAt8GjbQxE5iuk3n4scZZF944elHTY7irE9RJafdll48TX6qKXPWC24u9MltePxvO3
 gsGY661WomDXK5oGVfRdQQ0CwAYnhmer5R3SrwySXPVUnMWUtwFmSN5oPqoYUMYIM1r/XThSGYy
 CPCnnaKq/FDFbOLEZzTAsH+V9h3iNtqupBfJheGR5cpAnxRQwHWx3CB14E4JWJGm53mGKD/NZds
 dFLsKDCPVYcn3XmhbBBYpjWjAhoneNq7H7sLYk4TagO+YRn0LFXVk2n0MB7yQ8Hy7+Sjbc0Idmo
 v61oHfGBumzT1CzJUYL1o7te8g8gk58tkrYfY4T8=
X-Proofpoint-GUID: epFqs7N_pFBtnhl2sWcjM_W_bnFovCFr
X-Authority-Analysis: v=2.4 cv=A6Jc+aWG c=1 sm=1 tr=0 ts=6a696bd9 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8
 a=g9vm7uLBqE5REXbRsGYA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX/D+9d2FtG2mR
 b3qI5Ac0dgvQ0fVaWbBHuh4bHG95kijLNwLCnF6c2bvJKPVEGPc0kVJNPp5p41qwAEi6tRAptoz
 Z+JM/lS/hKpUFzx4ZfvDskuJI+PPVyUt1rMAyJ1I3yrKYFiZYYC0

On Wed, 22 Jul 2026 09:30:10 +0300, Leon Romanovsky wrote:

> When target_get_sess_cmd() fails during session shutdown because
> percpu_ref_tryget_live() returns false, the command keeps the
> se_cmd->cmd_cnt pointer that __target_init_cmd() assigned earlier without
> owning a reference. Final release through target_release_cmd_kref() then
> issues an unmatched percpu_ref_put().
> 
> Commit 8e288be8606a ("scsi: target: Pass in cmd counter to use during cmd
> setup") moved the cmd_cnt assignment ahead of the reference acquisition.
> Clear se_cmd->cmd_cnt whenever the initial target_get_sess_cmd() fails in
> target_init_cmd() and target_submit_tmr(), so release performs exactly one
> matching put per acquired reference.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: target: Clear cmd_cnt when initial counter enrollment fails
      https://git.kernel.org/mkp/scsi/c/a8ddfd2425bb

-- 
Martin K. Petersen
