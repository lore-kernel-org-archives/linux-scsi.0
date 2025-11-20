Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C97D2F1FCA;
	Thu, 20 Nov 2025 04:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612208; cv=none; b=IoxtI26LN7dJNIBCsv6YoEPupz+R+BnKmUCnCURF+MU43uKYSaWY7CMIjJXwJRDcsce5hfmfKXWLebdhnWBbvEhjr0PEdD59BEV1M66kMJW7ppRp55al/7Z8UkhmKz0Sj2MC9KNtI0mibAwJzd4A3HQHMJyQxMUcMvDvfi5vmD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612208; c=relaxed/simple;
	bh=dNxRrWGwSd7o4FFHjvTcIl2GWgnpdBMQaHTRaQvpIm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UhBPg2ZNNpqACczHjCk86Qi3/xo8hg2r9uVxQJ2ne1obEzkcRaIwV14Tu4AxMrg84ZkXAcm0sfin2VcnD1h6YzaDaBE21ejAPAnitmmIqO1Fd+NKI3ajYYrBsiNFYFW6pcC8QAR+mMQuQM8IyZLNuRkOW/yRfdY4wjb57p5O60E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JmlYGOuf; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JmlYGOuf"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NTo6006811;
	Thu, 20 Nov 2025 04:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=EfY00sq3wBLEslCoYcfPxdS2r5JfYW//pvy8RIl+6rQ=; b=
	JmlYGOufaoxiaYkEst4C/7tSN29fDQ29wM/OlZljTPmFFHh/cPaCtMFQj+kU6+1P
	Ud5nw54tXReF741+MktJ+GtZXMWQz+wPr+AEB96aAIEpvVDZI8Cl7eDcHhujMhqc
	S59+Yf6B6WNGcJXP1vc6LAz0x7Cxi31Cz/bRSs3EmA9wPhkXf20pqq3I6XT3mMaZ
	aVbvAQOhhvffc+fSxdjyEPj/HgnJ27vWBtM2qeo7HzcVuM+CG6hOynsd/onlho34
	Sm5fq0lwirEzItzll6wBct7hzhRXijW4LN5WuMudpp4BTBu8jxBR83tYdV1bCUZY
	8HEFyyGLgj1AYePZtyD0kQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1ga3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK28lZh007971;
	Thu, 20 Nov 2025 04:16:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh49w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPX012546;
	Thu, 20 Nov 2025 04:16:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-4;
	Thu, 20 Nov 2025 04:16:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/2] add WQ_PERCPU to alloc_workqueue
Date: Wed, 19 Nov 2025 23:15:53 -0500
Message-ID: <176357169053.3229299.12133106434264079182.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251107150155.267651-1-marco.crivellari@suse.com>
References: <20251107150155.267651-1-marco.crivellari@suse.com>
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
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=848 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Proofpoint-GUID: jmMDco2C-BtwDlwuOvrp4bTs0LHZZAyu
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691e9618 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_LVgOtpX0SWOOce4EqEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXzkwYph6tF8vz
 Qcz9GW7g6nP+xnNop+UDFkjQ5FNUHVIIGy2zi2btOYxFux3NaBx5vwLozbMigtBIEaXChPtTx4H
 VfkblwAVVYRhkZIx6r8RJB1+I7qeP762lJTEVptjb9p2U+v5xXag6pKxEEGLZZPVVTKvxBMdNl4
 W/DH9ckXyNb3f9A+oYvSTViN8AYAJpcouRrScFAHF5RvGoD3cgruNaExKxQ5w1npoX/ehWC9wpO
 n5QSRP0d2+BaLo1LEnQeE9F2zg3IuJ+03B0tA3tCxJ+CDMHqgrsxOHBTKAWPPNECH9ZJEwXHbwP
 eoDaisXQZjImhZEDzPUPiCIvswaxIN0X4uJ3jofK6ycPZfQRs0BuW96JDA6QVbR1TteJ2eVb4Vd
 6LdVyZl7PbogZ84OBn/zuIlLvtdm8g==
X-Proofpoint-ORIG-GUID: jmMDco2C-BtwDlwuOvrp4bTs0LHZZAyu

On Fri, 07 Nov 2025 16:01:53 +0100, Marco Crivellari wrote:

> === Current situation: problems ===
> 
> Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
> set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.
> 
> This leads to different scenarios if a work item is scheduled on an
> isolated CPU where "delay" value is 0 or greater then 0:
>         schedule_delayed_work(, 0);
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/2] scsi: bnx2fc: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/a43a2e48d534
[2/2] scsi: qedf: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/e036dadf78f8

-- 
Martin K. Petersen
