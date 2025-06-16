Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420263A1BA;
	Mon, 16 Jun 2025 21:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750111039; cv=none; b=GXoc0ery5OV9bwVM2t/39x4fTScSR/gQ4MUFu7jwVKQSXcyC8YIRYi3fPE8B6vDNJh4bN32JOe5Rv/7WtLiQbYjBObyEX2FlRgJbYZFUMhoxz/b9yrjXOV0Qfj/WLMWrjGPpN65OIE4WPXAtEFR5uFYZXXUMyDj6NXlaIb1k8nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750111039; c=relaxed/simple;
	bh=u+KNOfybQo03KBjKi+aihU9EtTdSm30ZIXYRfwzg4dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=exvIVzihOtdTMT0bzLstj7/B0bJ/ZwX+Wiv8qChSIYCTxBcZRcnVNHsGnON4nRx2MYwsGvIdXevbM05yuUjxyvwgEY5xBFmGZNUMyGo+Kgn8MskNkuyZhS2Uwuu4o7P9AInmTQWZAcZ/jemaHLvY8KtliiRA3Di9CRKnDoytxgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=k8w95uJJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="k8w95uJJ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55GHuSJj015723;
	Mon, 16 Jun 2025 21:57:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dRph7sDC4CJclrWguDimpexPWI1vZubxMixzgpSZK/o=; b=
	k8w95uJJ8AdaMOgUNWexuzprtq3vUbJeb90V3nn332rscsGDfTDl+zsKQprGxQ+u
	52LHB6nxuBp0LsIMH2UjwbwFVyW+C4ekUCgjvS2++DFnTriUJIsH1BqjY7zHeQxe
	ZtNWwwPxElfBOYhcpR6h8jGtIPepXbr6De2JSZb90HNHR4SgG0ljzdPwwXNgsZTe
	iwT/hmcub5okf85ckdkv1MdapyGG/MZS2mlCQNUXxIrWvV02ozc3gK8MLKT3zSj9
	w99hApp47+iJ5shlxXtZP3pG38+rC640XDodjyPbiMG+xeuAMnwcbDud3OEWLF3i
	VSZVf/0qnMTb5y9DkqoCKQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478yv541jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:57:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55GLMSHT036276;
	Mon, 16 Jun 2025 21:57:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yheyp04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 21:57:13 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55GLvC9f007737;
	Mon, 16 Jun 2025 21:57:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 478yheyny6-3;
	Mon, 16 Jun 2025 21:57:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Chandrakanth patil <chandrakanth.patil@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Chen Yu <yu.c.chen@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] scsi: megaraid_sas: Fix invalid Node index
Date: Mon, 16 Jun 2025 17:56:41 -0400
Message-ID: <175011089422.1498478.12936104062771646424.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250604042556.3731059-1-yu.c.chen@intel.com>
References: <20250604042556.3731059-1-yu.c.chen@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_10,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=814 bulkscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506160155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDE1NSBTYWx0ZWRfX+vIVnJR1ZGtH XY2cmw3A4x3wodtyLQEZL+ot/TlIFtAvTXqLfDhImsipTR8ltLkr7ehge2JEWNYAvreRdnNm1e3 LudkA/mGFKm/TvyBMeStiBGDPKHxu9/npzIJ14gTQovWJmeQH+ok7CJ3KQzFDUllr7GYkHWjLL4
 /b01yEvpXhHPogNl+ybFx62mm02os81AwhoUQg93t9eOnSDho+RITv+pjYuhGiKZXXj4WFeSwvA bAs1c3rhjFIs86yDYIMZYr1/7HiyH3DoKp/egl1Vyb2/U9C7HTsIaGcctRxF96ZtpOdvTpLybMo ofsT9x9FCEFtiZjmGCgWouXikyJM+hVBcn/PALIm/Z1pgNJyRO+xoSjh8PHqDHaOlprcxDIbVSf
 dD8BUOE2EKSAckdtxCtwSQc2g3dVMNNlnLf3gi/kIMirr8sK3QXwJo3JBnd1o7vTI2U75jXk
X-Proofpoint-GUID: buC_f1YVP9gyfSbSUte2-OWqXvjqh5pA
X-Proofpoint-ORIG-GUID: buC_f1YVP9gyfSbSUte2-OWqXvjqh5pA
X-Authority-Analysis: v=2.4 cv=W9c4VQWk c=1 sm=1 tr=0 ts=6850933a b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=g3mBmZGx-6S3bqwv00EA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:14714

On Wed, 04 Jun 2025 12:25:56 +0800, Chen Yu wrote:

> On a system with DRAM interleave enabled, out-of-bound access
> is detected:
> 
> megaraid_sas 0000:3f:00.0: requested/available msix 128/128 poll_queue 0
> ------------[ cut here ]------------
> UBSAN: array-index-out-of-bounds in ./arch/x86/include/asm/topology.h:72:28
> index -1 is out of range for type 'cpumask *[1024]'
> dump_stack_lvl+0x5d/0x80
> ubsan_epilogue+0x5/0x2b
> __ubsan_handle_out_of_bounds.cold+0x46/0x4b
> megasas_alloc_irq_vectors+0x149/0x190 [megaraid_sas]
> megasas_probe_one.cold+0xa4d/0x189c [megaraid_sas]
> local_pci_probe+0x42/0x90
> pci_device_probe+0xdc/0x290
> really_probe+0xdb/0x340
> __driver_probe_device+0x78/0x110
> driver_probe_device+0x1f/0xa0
> __driver_attach+0xba/0x1c0
> bus_for_each_dev+0x8b/0xe0
> bus_add_driver+0x142/0x220
> driver_register+0x72/0xd0
> megasas_init+0xdf/0xff0 [megaraid_sas]
> do_one_initcall+0x57/0x310
> do_init_module+0x90/0x250
> init_module_from_file+0x85/0xc0
> idempotent_init_module+0x114/0x310
> __x64_sys_finit_module+0x65/0xc0
> do_syscall_64+0x82/0x170
> entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> [...]

Applied to 6.16/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: Fix invalid Node index
      https://git.kernel.org/mkp/scsi/c/9b71a94b0bc7

-- 
Martin K. Petersen	Oracle Linux Engineering
