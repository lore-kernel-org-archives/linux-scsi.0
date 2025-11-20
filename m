Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A095F2FDC3E;
	Thu, 20 Nov 2025 04:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612209; cv=none; b=HR7wzOAgmEC7YJuUeVbVuzS1Ru+th61OcDvT/KBRTQYkvOjQg+Lka8oNGwhXaSmy0nirPInhE+vR1FQhj80BjGqDFipVfZZTCPyqoFHCWpKQLVk02sCq8vd9b8ZD/ctHiYQQ8nKNOGwSxoUAsy2ROAVBLNjdpoVYjISMhPArRSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612209; c=relaxed/simple;
	bh=GLt+tlhEtciE1Coqksal0TZi4L2cDYfRv0xglKPqp9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+UQPzvvoKTw9tZn4tjGmVCqytS0T6v0O3lnbkbgP9JxkutuFyC1AGa5LKQLjq7dLNdvi821Pvk1yXGjGeF+GRB8Cj68c1X1fBiBrp/DQwlSyzEfmfrqtfLtiZRQVsH7RFFjG9NvRMwUspEfiK/285q64FOcRTwnPDLRidUxqek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ikM3KwQB; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ikM3KwQB"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NbFw013300;
	Thu, 20 Nov 2025 04:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=kYnjb4atwgNl8zZ00KN1Mi00uifFyyPHZQ2mQ2yQ73Y=; b=
	ikM3KwQBmCysn5WhhEwGRVswzmCGVD+GPDplENIga0SH2yoA1UZ0UAtVGzPnAmP1
	prk4xlw4vooVACbB6p61kXgekL+3WUFsZGIoxvDPTCQvAAAqpxWekX8l0ficem64
	5ak2KIBXZpyE1/Nd/2A7V09kd/VzJneCt9gR5vD5rmA1dj+e5yWKlub5oRU8+yQ9
	R8rYuXq6nVFq/QK/TyzDvH/mXfAEhd2gNlnUqoOiDlL0WVClTk/FGS2SgLZiJVbH
	HvL0hoH8C3k+IYKbSxvOtd9iGWrSY4KM8d5qiDzcWW2alCDnyNLSOCmkIhn1+zjX
	SSTVL6GUBnh2+l49ZCtkQQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbur8wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2drQI007212;
	Thu, 20 Nov 2025 04:16:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:27 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPd012546;
	Thu, 20 Nov 2025 04:16:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-7;
	Thu, 20 Nov 2025 04:16:26 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: be2iscsi: add WQ_PERCPU to alloc_workqueue users
Date: Wed, 19 Nov 2025 23:15:56 -0500
Message-ID: <176357169050.3229299.3597494771842467173.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251107144949.256894-1-marco.crivellari@suse.com>
References: <20251107144949.256894-1-marco.crivellari@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=962 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX9Z0zESYwjq0B
 YifEpzwhVyb0cUdNDZJPxHYopsSxiAeYaWcQBo8aa5XpdFKsy3HbbqmMMHuaeIFOk91M4BAZ2y+
 A4Z9aBIDKgj9trf1jekOB0/6d0JZrGSj6SCwKKnLH90JGLQjs/+mGb/XcoP/CZAvpbPkdeXuvWg
 3SARfEbmaMTKALSkpchzvqPZOJK3+LbT6a8feyR/5DeGptEf71IFwfRBNHlZ9VnvdWHDM1fjxfX
 Ia9sm4iN9wr7fzCOa5XVslp3TE+LP1A8jgdCHDRCwuUoTKcrsc2tOPwg9kOTAW2hP0op9pnvDKD
 MD2CbpxId08gkgHMnfWkEtD/ObZ7VTTat3DyVspFbtM2aa3pQbHLkm3vKSInbm0ZcKvQrKcmKWh
 QcmHGbifeZN7FTYnMY6Ope6pRPOf3w==
X-Proofpoint-GUID: NdTq0HrmljHa7JjO61YFafvsqco0DDE5
X-Proofpoint-ORIG-GUID: NdTq0HrmljHa7JjO61YFafvsqco0DDE5
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691e961c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10

On Fri, 07 Nov 2025 15:49:49 +0100, Marco Crivellari wrote:

> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistency cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: be2iscsi: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/6184ec8b633e

-- 
Martin K. Petersen
