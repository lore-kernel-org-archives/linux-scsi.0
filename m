Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795714144;
	b=hrmFsGNasKouFXk3mVPkdVMJ6AgoQ9s1vI7AxlyVt/Mqcpf3EvJg7fgUOD1OUVJpwN1Y
	 uuuDu1K9sxDr0scbZGno7L7M/NgLdhqMxCjahGU30RYJsl5KnfVxGT/oa1qwfaSMlIH/c
	 xKyn1Q/htrWfjkDE81adLm+bC2x1tAoa8weBXWFJwk6yoTAmosBl3ZaT8nPwcUeT05iyH
	 EYDMayJt+XgmRlHyVhw7iyadNLuTEzz3X57nqrwb5Zn82AFk/y8Tn6P+I9ly7NeZHdpVs
	 p1pY/cXvMuY93PFPDjIHw5/JdgEBE7AKkCZlEoiVPZq7mLa89aKn+Z8YIAWi/IXItQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795714144;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=TX7Nii9x5yTysf9/AmcLYyyr6SmHK8dLBkxO2v0O1E0=;
	b=bXMeadw3N1Sb7XpwRGqaZbkmbIKwCgmpcrSA8Tzbu+hLeWLBt2cwrt+eiS64WWIPUuTV
	 HuwYinMydrvvOPK7aJS/RGU6y3nSu9haTKUn1DCztbQxSqIFOIn2Dl5kjkqsys4jQmCs0
	 1fP6FBtPa1CqQabs1IJO6LrHigohoZ3O/ZL5foilnZ+EDVaOgaI0MnT2UOM0eJXUKkF5I
	 qzsqBkd+vYDA66xXKLMKk8XmzomzcwnIWjThAUlNOJ1D0OcWLeqYcgiyU25oFyx+pGgnj
	 Ih1ZDjWs5UyHbIY2npv3don1xcRDJghnzDFq/cxsYqm3i+08FcukX6Np39Eoj62dcNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=FJgpSUsU;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21906606A31C;
	Thu, 26 Nov 2026 17:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21906606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=FJgpSUsU
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQG4nh3587142;
	Thu, 26 Nov 2026 17:29:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=TX7Nii9x5yTysf9/AmcLYyyr6SmHK8dLBkxO2v0O1
	E0=; b=FJgpSUsUUVUXEXLZmmyKIOyo/7kCH+tCrOYcFkpBLBhuPJy4Rj20eZN2F
	DAW7RulfvdmoHC4edB3Mo7Ma7JLFuVJ4RE3nw3TNB4fJRZKefys2YSoyB1dJjxuz
	Zm+1y1UaC61zRws/GnRiNouCNV5QQbRIcWjBxEC9MKzy9dnqc/IXYtoGWs02A70a
	wz+y1whTaVowfELN/RPzMLrfrmk+rkEAEMWBdcig9xGPxhfU8qmWgyRq1xLv9OB+
	7hBxU5RiG9vxX0iOxXWMAkblJK7pm3N8BcXOQscsHWsd+CaYFDTEpJVpUFIaF/sL
	EAgRsJazjEh4oGmtLalWJRC8A2xqg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34gvhv2j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 17:29:02 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQG4VHT1833805;
	Thu, 26 Nov 2026 17:29:02 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5uxx5qu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Nov 2026 17:29:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AQHSwYV38535500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Nov 2026 17:28:58 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4875720043;
	Thu, 26 Nov 2026 17:28:58 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F75420040;
	Thu, 26 Nov 2026 17:28:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.124.213.230])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 26 Nov 2026 17:28:56 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v15 0/2] zfcp: Use DMA streaming API to map I/O
Date: Thu, 26 Nov 2026 22:58:49 +0530
Message-Id: <20261126172851.8688-1-nikh1092@linux.ibm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=CYCdd7rl c=1 sm=1 tr=0 ts=6b086c5e cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Wd4ccqAm3J3WqkYLFQkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDA2NyBTYWx0ZWRfX6GPNY9BILA4O
 pI7hEAUlGOC203rlqeIKb62xrC/K9GpFiYhk0lO9PFF2LntiO6dybUT8wBP13Tu8QS7a7eB6/ui
 6PjNswoxFb+gpk/kl5gPsi/bea5u8Fg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDA2NyBTYWx0ZWRfX9q8dVfw1wkfl
 w4r2dwuyBNQDhyUFyfFV1HtgwgSAELlBmNinKzAuzGl3gEazBTFaUgqInFpgqOuyqnK6jtqfcpM
 BPrCbGc1I7DIyT728MutQNGlqEwXQRwn4vQ4BiyQnYEzmrTk1gPZyx565kMrjvwm3UNDOxj84i1
 cBAWNxGQt9AeyZnnbWheQfYtcy0+ZQUtqrk+5pVFI/mMXw4eldAhf42EO8MUtkE4PiirT1Wzqwl
 IAvPQsdSORyzgMGrxfOCAMQB8YTcV+u2/6fkiTc15PacJIRYAJvmZIUx3Eh+XJ4jY5+yTPgjlAa
 6Rays4iS/izSQtCO/SRcVODkhFVIuLeP4lt/8YfSiWr5eYyb2FffDDxA+2kYG5o1wu+Oy32tf8U
 p6BsNKoEnudnOQ22oTS5tOAMjio/Iy/9nDstrW5iYUz6uxwgjgKSJ8LcLzqfquE2YlUlB9yuEfK
 m9ryBLRMlxdEDcBi8BA==
X-Proofpoint-ORIG-GUID: gMTLZQsoy8nP3jYElMW8RWrJ6hYh6obJ
X-Proofpoint-GUID: gMTLZQsoy8nP3jYElMW8RWrJ6hYh6obJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_04,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611260067

In the existing zFCP driver, virtual addresses are translated directly
into bus (physical addresses) for DMA operations on all I/O buffers
passing from zFCP driver to the device.

Need for using DMA-API in zFCP driver:

In a Secure Execution environment, the host must ensure that device DMA
accesses are restricted to non-guest-private, page-sized memory blocks.
This prevents I/O failures that can occur when a device attempts to
access guest-private memory. Therefore, guest memory pages must be
prepared by the hypervisor before they become accessible to an I/O
device.

To support this requirement, the host Linux kernel must be reliably
informed whenever a memory region becomes eligible for device DMA access
and when that access must be revoked. This information must be
maintained correctly at least at page size granularity. To satisfy these
requirements, all I/O buffers used by the zFCP driver should be mapped
through the DMA API.

DMA API Integration in zFCP:

The zFCP driver is updated to use the DMA streaming API's to map all the
I/O buffers which will be passed to the device.
All zFCP I/O buffers (QTCB, SRB, CT/ELS and SCSI I/O) are represented as
scatter-gather lists and mapped through DMA API using dma_map_sgtable().
Once the DMA transfer is complete, the corresponding mappings are
released using dma_unmap_sgtable().

By routing all device-visible memory through the DMA mapping layer, the
driver ensures that:
1. DMA access is properly authorized before use.
2. DMA is revoked after use.
3. Secure Execution memory restrictions are honored.

M Nikhil (2):
  zfcp: Replace sg-list with sg_table in zfcp_fsf_ct_els structure
  zfcp: Use DMA streaming API to map I/O

 drivers/s390/scsi/zfcp_aux.c  |  15 ++
 drivers/s390/scsi/zfcp_dbf.c  |  16 +-
 drivers/s390/scsi/zfcp_def.h  |  17 ++
 drivers/s390/scsi/zfcp_ext.h  |  14 +-
 drivers/s390/scsi/zfcp_fc.c   |  46 +++--
 drivers/s390/scsi/zfcp_fsf.c  | 338 +++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_fsf.h  |   9 +-
 drivers/s390/scsi/zfcp_qdio.c |  45 +++--
 drivers/s390/scsi/zfcp_qdio.h |  27 +--
 drivers/s390/scsi/zfcp_scsi.c | 146 +++++++++++++--
 10 files changed, 561 insertions(+), 112 deletions(-)

-- 
2.39.5 (Apple Git-154)

