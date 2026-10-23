Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792755655;
	b=fxLhHs6znzT5dhjLbOnZroNKD+S12R1eZg3LPQm6ffkk5wPsdwHnFROyigYfknQWdena
	 qAhkVTt+35Xa4KDXMjtAsuv08CkqfkTMnfunF2TMLB3OJsyij3p/8PB29f23bJ97t8upe
	 X/W1gL5BlkOdEILC29x41IIXmwuWdyk+aE3GgAEnq+ge8HAUgo5ovGgHAloX4xl58mNm0
	 9MnhNeFa57K46t2GN/C3ZPWHJDUz7cYjw26vxr6TXqR5KOthw6LoJs/uhGQBhmxsJ+4JK
	 9Kn1Shwz23CJeDMr1J1W9E6ySxvIQtKxCVcNBEnTceLIhLLNFrN+LUemDhp4SnWrTFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792755655;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=hSiiBjdYGOC90gp66VdhgLidz2uIKbHRKjjfhmzqziU=;
	b=bnpspACnAFAhSBKzoaG8XDZZx4xusXNQQDs6Oua0RJ7xYjNWLe7V3m9kQOhCyG8mi8rP
	 aV4WAkGPv8Hj0xRu7ATyhoaJiIC3M/xH3AjNBlcCMPgm/3r173wGLPguYTnTmEVMzvSDH
	 HFZAmHgM52UlDlJmezfs+92J1SXXGCDQDlt6Kj1nvrbMDgysCQHNjHv8Jp7bvfWQxQzlI
	 lwZXFWKJS+tZdHn5ZcST9LNzD9Xe5hIy0X5ena1gy5awV5Y+Pd2OHsNsUw/liURaMlpfn
	 pxd6yx0KyoMyD0HG7Rri+Nns1V4uwLbh+MJXhi0mGV9oBH9y0FGfr3HpKUU6rlFlI4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=o0CvD0ud;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8887606A31B;
	Fri, 23 Oct 2026 11:40:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8887606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=o0CvD0ud
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAEB0C2613895;
	Fri, 23 Oct 2026 11:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=hSiiBjdYGOC90gp66VdhgLidz2uIKbHRKjjfhmzqz
	iU=; b=o0CvD0udikbMdIc/U2JL0iD5J0jYcXkfPbIOs7RfHoErC96l1SQcVhncz
	nEjb4hFQfVNJZUJH8J9Z2Dn4cwmIhQT5DBEwzj8ob1+wwso76QnoJBbMLi91CvVY
	xruUBAKbotJqemayr4sWxXCgiH53tDjtI0/L9Bm7hEYTHncaCjhTV23csV3LQKg7
	YR/TXQs7gU+YE0lGq7kfeVZHR/g1lTi0oq9jyJU6ys/OsnHVvzd3j1o7BaZEEzf3
	qYPClSbpMgNm/G/WP2miHmkPOYdalt9NiZOh47VGQ+4PO5MS+ARsGDEcaGyVFDCz
	fvll0D+QEFRMRFyTEE99i7sImUlpg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5amtxv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 11:40:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69NAK2oW1967067;
	Fri, 23 Oct 2026 11:40:52 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hfj1x4wn7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 23 Oct 2026 11:40:52 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69NBenaa36438310
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Oct 2026 11:40:49 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1554C20043;
	Fri, 23 Oct 2026 11:40:49 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8CF220040;
	Fri, 23 Oct 2026 11:40:48 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 23 Oct 2026 11:40:48 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v13 0/2] zfcp: Use DMA streaming API to map I/O
Date: Fri, 23 Oct 2026 13:40:44 +0200
Message-ID: <20261023114046.4137557-1-nikh1092@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIzMDA0MyBTYWx0ZWRfXzZ0P1Scj5DXc
 5MmKZvxiayloo13R9RDLv3gwORguRE3ILkYvdb9/GR/C2BzkQuFgAybYqSFIMQBRRI2ZvyY29Ij
 wafoOMvr63pzwzH2JDF0Yfqh7uajqKQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIzMDA0MyBTYWx0ZWRfX5EkiB9IUgAM7
 48X8lpid0QxGafdUY7vEEl4iINAxarjP+tgXMxXtpRDxLZJY0ep+4BzjaQNGeQetbYAoQ//kUiF
 rSOJCAf7qWLjOhJtqorDAmAe+xHG8vjGP/FXXpmVN0pYMuUxpColzCJyzFWsQG1th8EzCqrseVQ
 fZSlnOnXbGu83fivLl0vk267WbgdCnlYtJXaQp3SZT9A8c+nNLuV5A2akwoCpaK8xgIAKR1txPz
 UojPpo98dNe9anLq68D8Kmk+jMUbb4CGVZn+MqcK3MV+xiDyAQn9gExEPlDjiSVUT7LzDclG7Di
 fEW3LQ5zdsx9l9ieF2RIgeOfxcVMyxq5YyK7obvkKCcV7h6VJd/2/49uTqbJYGVclaK5wP//ljJ
 Id5LBr6CVdVCGCthI4MJxI//1QC/uZRq/+BD3OnC+VvDdImvOnHdGqnQdHSQOXfEbIJ+SXl8mcj
 9pwQHXMLz0jA1KH2Y3w==
X-Proofpoint-GUID: ZZ3wFrRNQ-bBkx3pSrs8Oz2MIwt0De6T
X-Authority-Analysis: v=2.4 cv=JIKuIMKb c=1 sm=1 tr=0 ts=6adb47c5 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=Wd4ccqAm3J3WqkYLFQkA:9
X-Proofpoint-ORIG-GUID: ZZ3wFrRNQ-bBkx3pSrs8Oz2MIwt0De6T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-23_03,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610230043

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
 drivers/s390/scsi/zfcp_ext.h  |  12 +-
 drivers/s390/scsi/zfcp_fc.c   |  48 +++--
 drivers/s390/scsi/zfcp_fsf.c  | 325 +++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_fsf.h  |   9 +-
 drivers/s390/scsi/zfcp_qdio.c |  40 +++--
 drivers/s390/scsi/zfcp_qdio.h |  27 +--
 drivers/s390/scsi/zfcp_scsi.c |  83 ++++++++-
 10 files changed, 477 insertions(+), 103 deletions(-)

-- 
2.53.0

