Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AAE3054DF;
	Thu, 20 Nov 2025 04:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612213; cv=none; b=LmNHheqhAR3cAyT4zeLEYAVS+pVvjqVUPhqSaREVChgFxfRKbEWZwlXAPyj61q+hhbrDFrs00j+GhzL3KekRjY7KheMJ2CijeoOQMxXIlb86eSG0sLUm9Ad7oC004Jl7chtLR6kwIIzJdx+5NySH0vP6tlV3Sl3WnxLKQ5CLTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612213; c=relaxed/simple;
	bh=hoY04vuzntzWqYXNiRq3TYQVLQL4mXds1UWNF5uaqyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QSDgD7SnFswJzFvc6GX752bbyKTuvdn7Ptdrc6cOKsWg4XiuOv4N/KmJRBZD0QfhffxbP3qLoxlJB0GxYgqwmYa3JTxmDYHAWwLA8Aw+53gDW1OevoZxvhQNrxf//1bsXGU+nwNRCbqcVhxCVUgPstfX+hHYMfnFft8JS0tGSVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KF6d1iGo; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KF6d1iGo"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NOvS029790;
	Thu, 20 Nov 2025 04:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nucd/UvULR7AQa5eal63eJ57OKRhYlWvv9/fN0MLPkY=; b=
	KF6d1iGoXmOgprC9XWnH/iTOfMuXJFtEReYRlymuFwZgEoKz1i23Hg2VDvjSf2Be
	Z4DmVv0XLwAyXIKp47CZRMoceJieq3cbw9mSlEcpKJQmPOwTQ/MqcnBl60wbAQa6
	x68RkK87nzvrvFkcP0RMu1LtSu9OcUZ81mmST9obYD0U5bLNAnH7U3GCFw01g9sx
	rtmDGqfsXAavNudoPHoSEcd9avGShpFSUzjgrpHfijfF/cgnAJveaFSM6+txao8u
	BilHhSFZ9/ZMxHh5+DlfA/cr+hK8tk+QdpQCv3smPcAjm8epDal2a/r1nfygVPR5
	wzjw9vgsIZgH3O983XFohg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968bhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2KoeX007938;
	Thu, 20 Nov 2025 04:16:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:30 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPh012546;
	Thu, 20 Nov 2025 04:16:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-9;
	Thu, 20 Nov 2025 04:16:29 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc: WQ_PERCPU added to alloc_workqueue users
Date: Wed, 19 Nov 2025 23:15:58 -0500
Message-ID: <176357169044.3229299.16284873382507442071.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251104110808.123424-1-marco.crivellari@suse.com>
References: <20251104110808.123424-1-marco.crivellari@suse.com>
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
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e961e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: fRsVot2gvmxLcEoHH-erH5knOy944Zlu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXw8PBQTJW+z5h
 KfWBAiu9186uvxj5na+EpIzVimFiBdVkJaSOyihCo2i49au92226+lW8O3hm4ROxjKLu0Quaqph
 0m2vkMP8ffswuNX0bO+zXW8kRpS1qrbFtG1lxiof4/06HTB82YgNJ+HN3Pm+2jg8/aSm4ukPgQL
 C/Pf2Xrby0rAPGQBJ1SsWrGOyB6G5TdMmM/1Hq6jia8QjxSRMydsajU74Kij6r8t4a7Fe0h0LmC
 86uRD7OpP4gwoFE0jPKRsSHF8MkU7Yw1J93RSE+gVxMsbsdMqFIeSqvN4TLGXMiSMKHoiPX4Ki6
 028y4MS3gwaXPFTgS8cQCABd+Aj3AD3QDTSqOPHIDrWcN/ASJXay33hhh2JHndGaW+CurjU5UT5
 G5WXRi6fEK0YPQla7+yo6LEHmSnnSA==
X-Proofpoint-ORIG-GUID: fRsVot2gvmxLcEoHH-erH5knOy944Zlu

On Tue, 04 Nov 2025 12:08:08 +0100, Marco Crivellari wrote:

> Currently if a user enqueue a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> This lack of consistentcy cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] scsi: lpfc: WQ_PERCPU added to alloc_workqueue users
      https://git.kernel.org/mkp/scsi/c/84150ef06f89

-- 
Martin K. Petersen
