Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688950;
	b=luOK8XkuI0/jr/bXakBv+azo2z626IEoh+cbOgajxvfKmMYawI0m9y1hRGFFfgtrkmRh
	 sJtdOII4kqq0nel0kiIE88+NUkoo2xX08y9eKIWNw7Mzsi0fDaHp4EEPz2ezRfQxTlWNx
	 Gd0iyGu2Aobes1FcsFRsiwAte2p3qjyhiPq58lLzvxIOUcQV0rF2IW7jfAC0FIvpXGnm0
	 EI09DCWUoS4UKHW0s/41+GdAzmO+N94FEjnm6PZnLG+F7rLDfuqzXFGqqs0nsSQJM6kaj
	 7nN11O3VzoGWJBLtJcBp2q3e51TYxFos9Fqku4ap2Bfx7ypWHpWmleMCz7ePP1huHaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688950;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=NU/GV3aLtPYXfGmgd/+gSYtTHK5EW/hO3KtY3yIfoMY=;
	b=H2agMcZoFq7Dnkhhb+GsQzTdWHb+jtsTBiY4QgetVDhjjRMOEoY1m/101aTnRobtcCH6
	 IvFXZb+nYDZlOwqU3YsQUPVqdMDoYltsYBgnSxw00rOtKRnNoNxotgq67YeeR++Ji3Mlf
	 OuhRoJIneIome6OmEE1p1oid59nS40sl/bOe/8s01UOtmoFCmpv9e6hQQuTMCvAvAwfKl
	 k7P4YMKhKglVSoZnMze7W3K43qGv8c+7ERz6VxBURpEK/bZ1Vxmd2GnBnj4SmsYgJrYGf
	 fkJMdi3K5lLoljsJnrztEn9t/seog4LnQ6LSMI4dOUkAWQKPABxwhQq8tYNWMQYlK5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ohzgRoLJ;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEEA606A31E;
	Thu, 22 Oct 2026 17:09:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDEEA606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ohzgRoLJ
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MEEN5o133227;
	Thu, 22 Oct 2026 17:09:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=NU/GV3aLtPYXfGmgd/+gSYtTHK5EW/hO3KtY3yIfo
	MY=; b=ohzgRoLJ61WxD5Az2Lh72sbhOQvQv7kiCLcBEPFglBOkuQfd2HYSC/A0Y
	zC1em5fRcUsNCl1gAM8/CbpkCqretrpZnqdC5Yi2TuhUtuMzfYc/XjpHQzWe/9JT
	nHO2m8PkhgruLSKf3XX1q2oVw88grjHxBCdXb+nxPyQx2pUaABuU4OixZZm55wzv
	2njwSxbC2opNWOvY9HkZ4JsBa49VfcYYVXFKnS4X/UaHIqYcp4forVQEHK60/jVk
	C0J1I6gz6hheqRsL9SoP/hUoysATULtvOje9VFkPMZnjAuQ/fEKyONx/nmwHqfEY
	XnOqZeotAXbEgZSYvEETIznEugT+g==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5agdh8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 17:09:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69MEJseU619356;
	Thu, 22 Oct 2026 17:09:08 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hfj1x158r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 17:09:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69MH94bN35848516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Oct 2026 17:09:04 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CB192004B;
	Thu, 22 Oct 2026 17:09:04 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E050F20043;
	Thu, 22 Oct 2026 17:09:03 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 Oct 2026 17:09:03 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v13 0/2] zfcp: Use DMA streaming API to map I/O
Date: Thu, 22 Oct 2026 19:08:26 +0200
Message-ID: <20261022170828.4189701-1-nikh1092@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA2NiBTYWx0ZWRfX5MBLYON6Ynn3
 jM++COkGqOvGBeKacwYShGmqDQMo07lFzbZfN1BZH4V0PuyOMfEzqlXnDwZ1fAvfkIuuZERS7/6
 nBlV8BWUdmMhkeKLXnmlI6CFmrAPG0Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA2NiBTYWx0ZWRfXzgTfGPNtL5Ut
 XwJLdhEHDgNzKO94/p8chios5jmdzNDMw1arNrlvZ1+ioq6tA8sHFf1/Z9R8GN5hgq3wZF3RjzZ
 PsAhxtPDT8WmTcTzZQR4s4IbeT7KLVlRaqNf7HeNXr7K084DMsLCuewfXRLn6EjyuCM+0LOQqdt
 9jEgwHJ5HLD6MrHP5IFjLyze0qSsL9TDP5t+/HEWT1kfbkhZLMxS6RoU+Q0puJ5LqFgSkdCRhYg
 sFRjt0gp5cfGlMMMEtmPb6juVoOXGnXNNtB7SB8fY9sxOcljvSHwYj6v0yOjcR1cQtMh+Ja4JUA
 p7k0WvaDcMJdtjkYEc8c6nH2SdXf1jBn3H7dGsZyfxRHTemasKBPx1E/geKoAsiFJa3J+6jDtYa
 hhWXLVNLr4xyKWwCCLjSovtXmBturCnwqoi8ktxgQDqEApFqhVK+c2i/bqRl/JG3YNvCtJlFTwy
 SbFWi1AKlnICjlK4fNA==
X-Proofpoint-GUID: u42_A2dpT2N6Rjacil91ze3EVOkQEfUk
X-Authority-Analysis: v=2.4 cv=JIKuIMKb c=1 sm=1 tr=0 ts=6ada4334 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=Wd4ccqAm3J3WqkYLFQkA:9
X-Proofpoint-ORIG-GUID: u42_A2dpT2N6Rjacil91ze3EVOkQEfUk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610220066

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

 drivers/s390/scsi/zfcp_aux.c  |  16 ++
 drivers/s390/scsi/zfcp_dbf.c  |  16 +-
 drivers/s390/scsi/zfcp_def.h  |   4 +
 drivers/s390/scsi/zfcp_ext.h  |  11 +-
 drivers/s390/scsi/zfcp_fc.c   |  48 +++--
 drivers/s390/scsi/zfcp_fsf.c  | 323 +++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_fsf.h  |   9 +-
 drivers/s390/scsi/zfcp_qdio.c |  40 +++--
 drivers/s390/scsi/zfcp_qdio.h |  27 +--
 drivers/s390/scsi/zfcp_scsi.c |  67 ++++++-
 10 files changed, 461 insertions(+), 100 deletions(-)

-- 
2.53.0

