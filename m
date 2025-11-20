Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DF430AD04;
	Thu, 20 Nov 2025 04:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612216; cv=none; b=R5Jx4jTt9v4d0zwb858ljJQrQSAbdDqItXUMktRx1OnJk0uYLAVBKzYWlUzJCIe8/tuN6Wb53/A28TYHXlOOMoRiBs63fDmX48MevJ7KI3FAR2Wlis/dENa8hcv7b7IDDCFfbfe9K1Yv6Ksup6By+jsxy9KIOIBENTzialVXdZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612216; c=relaxed/simple;
	bh=B2WM4/nTzlSaSPqQMZXWxCORe/W5qIV0EUlH9xWJJEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElzfsKV7zpYoyyERFa0lY4VMEC7YQf7OvtsLR5Wj3pY4Zg5rds866AjCLvof11kf0ADyh89fOeBWeLnESdwBO3hGgV6XR539TyQme6aQq47w+wmVMZxvmqHdDId0BF1lEXEKeo/th9k5PvX7o/Cve+nZrwQC8uZVIYuj2D5ySOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BAWsJUH5; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BAWsJUH5"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1OgpS031011;
	Thu, 20 Nov 2025 04:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=1hK2YgKHTrvuCLZIfV7VQYEh5NGYOdrmguFQip+ZnDM=; b=
	BAWsJUH5VwOSTzcU87mCMZROLSncXmUCG/6XfHiUaPoBzfMXdotE2rZUxRho5rJ2
	kLFxaAU/9B0qDHHx48U96eb/tIIamne+2K+JZC9jkihAm41NkRlQuTMEI5bZw1WK
	Zb8B+sCy7cO15yWczEOqaG7Lsvt8JLIwodqZtKPPzNiwk8Qg7C61IQ+V0ZfGl4rO
	MN7c3qG6h8HzM+wiLeoV8/lulFu4nXFwTkF17UOC0BSml3oMrTz3K6X2GZFrLCZ9
	B8r4vVDEHVpRgjAB4T5wCYJxGeWjMBV1skK2KA5H7yFDY5P3IbowG62ouQpgwfoI
	nuyQtke88YhorzXVnuDfug==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968bhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2fkwW007189;
	Thu, 20 Nov 2025 04:16:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4d7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:35 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPp012546;
	Thu, 20 Nov 2025 04:16:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-13;
	Thu, 20 Nov 2025 04:16:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] scsi: target: add WQ_PERCPU to alloc_workqueue users
Date: Wed, 19 Nov 2025 23:16:02 -0500
Message-ID: <176357169059.3229299.5787079886006984139.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251107154008.304127-1-marco.crivellari@suse.com>
References: <20251107154008.304127-1-marco.crivellari@suse.com>
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
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e9624 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: nnseIGoZyAabOqfZRThHhAKSGGYmnE2M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX6WN9lZgSFhLX
 /tUls+rl+z5NqGNYV25poSmcBhb87lX4EgQFDp+90HIlUFlINe/scpEr0a0RhRovgw90tV54MFa
 4zhKdMQrAcjKJHtb9dyn117b9pR0gtODMNs+qhvAoL+UVIxxeFlzxe7jqCSpJQf1PIBuk3ali7x
 tix8u2ksY1bz+tZBi0VKHEaMDyOmvpxtGlOFh5vEZ+FXio9g24eUvhDu4Q2kLzXI/uhquBhSEIC
 o3TVL7K7fLT8d6Q/KcGlJrkkJpEc9/MYjX0Uq1if8oFbjMdWch0AnW37/Q+zErHXNkRuZvji244
 J677yY7F0dtvmNIWfHTWrG2r2TYRmvIAjJudUTFoBmOxE/ryCU1jAOYikAPaylyeRCj9hK0J3nz
 5LOQGr2Pe+Okv+XKXix8JyPv9/z8sw==
X-Proofpoint-ORIG-GUID: nnseIGoZyAabOqfZRThHhAKSGGYmnE2M

On Fri, 07 Nov 2025 16:40:08 +0100, Marco Crivellari wrote:

> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistency cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: target: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/2e2e559390db

-- 
Martin K. Petersen
