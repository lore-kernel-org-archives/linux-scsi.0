Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F128F30E838;
	Thu, 20 Nov 2025 04:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612217; cv=none; b=KRZc7LNbOOHMw3tcE1DnfXtV4vDP738vu3TFZZ5OR5ZycIQyHD9pz8wwkfnpdd0wUJ156l7LNitSpJsupkbLj3/xcZ46KiSwBSB5yBPka+vjZySaJeJbbPvV1tVKwRKYX64kVMXoEQ/p61ZtoZO7IEpAvlNmzopa21aE/7kGi0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612217; c=relaxed/simple;
	bh=7g2iETfRRDGdxSfB0hpZuANRXHtMTL517BBZKOGQoiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwOEZz25y7UgTC7xbfPbKw5RbFQJ+F6OMM/zzIU6fAGAOkC0nhSC91tqeQHR6XitE6WUAHscACWPjyvKFfZecZuPyKL6rEmLXT5b6DTSfLQpZiw75Y3CXyweOnyZJ3ds+W8ci21+pRAjZ7r9qNYb2L32qkkBpblzU8LBuB1fq+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o5Sit4KG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o5Sit4KG"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1Nbwj013047;
	Thu, 20 Nov 2025 04:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ow/oUvFsvidWBgkZCZXUSBdRA58ay0gGXk8mwdQOVv8=; b=
	o5Sit4KGL26jmf6rUBX/1Uo4BSypEyk4G8E6qIg6JykTbREpSXaJP1SHAFd5u6bk
	He9cwBOC9kraFA/GwPpg66y2xXbQFoOTC33w1pSb6VY8U1o7h4lIMilQzqTi4ugt
	uH7LLPV1BTm7hD2KOJZxWcusck9De8Yy8ROGkFzPMxwZydCSl9EEoGr7R/Bm61NL
	Dd0dGdsiwP9RRQjHimtcX97/Vs6ZdWAN6GGkbZAlrEn2P29gwQh41pMjOvRRCkMj
	1yNQAPiKjwlYjsEqTqILBZ8mDp4UJpmWU8+V6mdrr/1S40jbS5WBUiWE6KcFHpG3
	wroQRSb8fSxgjqLJUtojvQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbq0c7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK0sJfe007170;
	Thu, 20 Nov 2025 04:16:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4cx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:34 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPn012546;
	Thu, 20 Nov 2025 04:16:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-12;
	Thu, 20 Nov 2025 04:16:33 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>, Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: qedi: add WQ_PERCPU to alloc_workqueue users
Date: Wed, 19 Nov 2025 23:16:01 -0500
Message-ID: <176357169057.3229299.9881461598054802080.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251107151618.281250-1-marco.crivellari@suse.com>
References: <20251107151618.281250-1-marco.crivellari@suse.com>
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
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX/De6ui+n94tZ
 YSfZIOAKsj3632e8oAdci4l+pom5owF+dBM5dZFUA+74wsJHkJoX5El8+2MBSe8y+gf5Vmgm1ES
 6Y28sAo5bysjgu9Sn8XeS3qXAAYFna5JVVWZszM1LwlGhvE0aIegQLM36/04S4zkJ04ZjgJG5iQ
 pQsEZkTIq41HE3DA5IZU1zOsevNBSzAH2oaSbopE8i6Bm0X7o1EdfAjbRm1TT+eq2dwOrqykLUA
 bratusbji2j/0E4izRsrihHMyTXIriUtzbAdbHqA2PPr3qF1CG6Bv5Wz6zyLB+7MwtDcfPjq11O
 uwJbZrGwb011d4yo52qLNjFBdNzNiFnuwqFXGyKPng+X4gLNwoK17hdJN/+XiYeM1DWttMo7oll
 fbg0dG7imUXK0XOElQeWafyMPl8o9A==
X-Proofpoint-ORIG-GUID: I6TZtl7LdrJo3JbaD3Xd4x1btBZqtfyq
X-Proofpoint-GUID: I6TZtl7LdrJo3JbaD3Xd4x1btBZqtfyq
X-Authority-Analysis: v=2.4 cv=a+o9NESF c=1 sm=1 tr=0 ts=691e9623 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10

On Fri, 07 Nov 2025 16:16:18 +0100, Marco Crivellari wrote:

> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistency cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: qedi: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/f60b8957d8cc

-- 
Martin K. Petersen
