Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3832DEA6B;
	Thu, 20 Nov 2025 04:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612215; cv=none; b=R0Ez1zNjoGZop9n5jjNdZJRCVN9k62mJMBuZei+9vlHAUg6flrlXu7kh0TOA6kE/TDb/AlHRzilGa051NdsHs6FoUiWZjoqQu2Lp1RTNQWKXspwXutxyGVcHoQPN/fEtWw59vK9vYt+7GLn7kh8Pxa2BXBIqik7E74e+T9wFX6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612215; c=relaxed/simple;
	bh=bgSYNU2aCMwq3fR7x7MfYGW0c/eL9t4xja8xK3SRf14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H+Nr1CiZeIkh1sbykDuayDR5Wj4BVxoC3CTthk7B3jE4d/QCYNCT022jqt6vKwHDbx4J9/PlpFirE5DA2WMtsgHTKy00R6Fd4naodDlRsqzk+vhAQ7s6cua9cCcBnn5cyIbdEJyX7y4p7bV5xLal/7zsGrIxPoZxrOujC+zs//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AnVump8u; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AnVump8u"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NwDs013793;
	Thu, 20 Nov 2025 04:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Evob1+0Xjc9tofuifMtusEp1SLihO2tyVA1l9BhU4Gc=; b=
	AnVump8uBW9dfi0iN/nM3A7Bt8zVQD4mkgO8GC+grK/xHlNk/p8n3D6VJnwKoX1I
	gFdDZc3D4zOVt1qn8yBOZtjIhkhsBfvcEdbXP5wouSwe1To5LPukAj97vhI5SI2q
	f8JqzLICm5MXGFqvs4algRbqyg9R7qVlvv0/OHrtdDb9EAOW1Cl0F7Imm0fGSh4M
	pAJBiQUnUnv9/b0o/0e7to1Dvk477h2ldS4mEETFwpBWmzcFsUtD8yZhLh70skj1
	Q+nrAU+NdxlsJS6pcN4zfBUkhPWbCRm1m6lorjdx/f+1F+sLo7s4W+LFNpRI618Y
	9OtcCBNNoYQm74Zt7rNv1Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbur8wu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2cpt6007231;
	Thu, 20 Nov 2025 04:16:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:31 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPj012546;
	Thu, 20 Nov 2025 04:16:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-10;
	Thu, 20 Nov 2025 04:16:30 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH] scsi: message: fusion: add WQ_PERCPU to alloc_workqueue users
Date: Wed, 19 Nov 2025 23:15:59 -0500
Message-ID: <176357169048.3229299.14597102223382788221.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251107141458.225119-1-marco.crivellari@suse.com>
References: <20251107141458.225119-1-marco.crivellari@suse.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX+xU3U+ds8BmA
 QQ6KgpqyLa1tKKXQlO7YvalS+poIgJ80I5RXoFa8A61j5Q6Fqh56cy2EIMg1008v1wl03pkKcX1
 8a/VvYbP+SM2gyG5K4R3tz3YQiSpQTT/dDkpwuwb58U736HhN8zGsQNgUwg9L+/xJWfEy1xz6Oi
 2Zm+MpR89oam5ucBD0D1BKnNCZQ4tY6Hgmpx0G42krXvMz65qsErLGQQIjfNrAwgVkXNP9tIJlM
 mCJmKp17fjI9Ots6xBNGGZaX4TIVEQ+ovzheVCMybf97G4oiRYt/Xj14zigjMLcUknwB3ACd+Sh
 XLqrG9Jh2C4+5buz2cDp++NCS5NVy8hCo+0E0GTSMCqRpapZ3o0AsEuToAvZzZP9Bsa2SImANpc
 k1atkHakqtqlDtk3NbM6Tnx/skIQWQ==
X-Proofpoint-GUID: gmY4UG__bdRibtFs281PvdwxBI8k0tUa
X-Proofpoint-ORIG-GUID: gmY4UG__bdRibtFs281PvdwxBI8k0tUa
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691e9620 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10

On Fri, 07 Nov 2025 15:14:58 +0100, Marco Crivellari wrote:

> Currently if a user enqueues a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistency cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: message: fusion: add WQ_PERCPU to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/f0dc44177ac0

-- 
Martin K. Petersen
