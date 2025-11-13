Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F9A26E6FF;
	Thu, 13 Nov 2025 02:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002043; cv=none; b=nYym4AZ+PgTBEbKGKqrvX4rpGjMXNrj7Mn3selfLc3cJdvRPQgWEr4RKVzBu1DXrn3KMKQ7LmLuecq7AP39oKRNsbTpsle93ULrGdAnEFhdrYeA7WKvWZH+pD4XGB/3HQt3snMXss8KO3Mq5ZbrKD8w64sREW0VRQ7b7033McHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002043; c=relaxed/simple;
	bh=2I0GtS5dRI4YrFW+AzlY4UrGCrHodvQXEA1Q7t0Q1tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZWjFYNbQiLIWZ9jpRYUrCYNkAqc4tL2zBRiCLIIoTzAK+JH7jlApVtqtRBUNgBRFDlRx0+ataNAHoStzjUHyG+Xast/ykJ7XR4gC0S24dKNnKdDjQhR6GRHwzME2bKqql+ezE4x69GYa9ouIwUwRAkJCugfXD67gqD5U47IYNHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sYOD8MqQ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sYOD8MqQ"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gURd030882;
	Thu, 13 Nov 2025 02:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1mxTuRYZG4jRBVmE6A7YdaPvEtiuIjJworHCqzKfVuA=; b=
	sYOD8MqQZXqztXtrNVosl6e6cL1LidRU6co8M32vJPJhkhqKAR2OlUfRisWs8tUg
	JVJyYKofZ7Is7XsSF33qMcwbcypUVPpGeQpr8mUsGmxZLzt3fAVFhl6ljf3m+r7u
	D/K4pDV1jsdX5Tc1V4WZ/y62QzJ2CkSJ6UmdcUSzH0MwMf+TplDY1Ukfq6m90lns
	HSvfcdYarX8Pr/qccGLGgkNrv5Na69kQz/2BT3Hiuym2F6lb9nF8i1Oa7TsznnAT
	Bvy6jSTrzks3DoK9wjaTG4TnJBKgwfiyRptCSZecC23XJwfCM9K4/TGizewtacbb
	ZvirpoOJgnuu9yRcEKZ1fA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acyra8qd1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0mg0a032415;
	Thu, 13 Nov 2025 02:47:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van9qbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:13 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lB8J038323;
	Thu, 13 Nov 2025 02:47:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9van9qab-4;
	Thu, 13 Nov 2025 02:47:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: fcoe: add WQ_PERCPU to alloc_workqueue users
Date: Wed, 12 Nov 2025 21:46:53 -0500
Message-ID: <176298170725.2933492.12293045729480817141.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251105150336.244079-1-marco.crivellari@suse.com>
References: <20251105150336.244079-1-marco.crivellari@suse.com>
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
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=932 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE1MSBTYWx0ZWRfX+G5HWvAWjqIJ
 4u07mfTxKVZfBFbtnXoLzeBQc+T1nntj6sf96Hfa838h7kCIhPIPyPx2s9O6NDlB+t8TkDiZdeQ
 05ZjouyJJ75YPh+krXLjnbGQoHpgwukOjdsYYDT5mKxRObtA5vIGFUFjCX59Wt0VI2c2ie0Ok6l
 YnZ4XFD7c5g5oba9zPSROnUTpxr3Hwp0R251IWaVeyLy9hqEvvlKx4ZRnE7fv55i+AFC1G30ZBM
 +jAzkXZ9A81lrEaXAat8RYgGybYGVJitbuMbYNPyLNYJ9KSTmnQICtTLDiExCGoy4oAiLj6dYpO
 FMbskGdfxwWTZQ5wmgjMCrfIv6CzHqPtN2x9RydcMNKg7MEz8XeSIG9s1ngT8MlFu2jsFsEfWc0
 r5LpF7aWFxgW1cEfxfJpQn9IxrIoA1csoHN2Jr8CTEze8c/EFQk=
X-Proofpoint-GUID: LbzTQPN0OpIM2yzmWKF1Wr4Gm0g0eKCA
X-Authority-Analysis: v=2.4 cv=ILgPywvG c=1 sm=1 tr=0 ts=691546b1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12100
X-Proofpoint-ORIG-GUID: LbzTQPN0OpIM2yzmWKF1Wr4Gm0g0eKCA

On Wed, 05 Nov 2025 16:03:36 +0100, Marco Crivellari wrote:

> Currently if a user enqueue a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistentcy cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: fcoe: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/57565f97b0ea

-- 
Martin K. Petersen
