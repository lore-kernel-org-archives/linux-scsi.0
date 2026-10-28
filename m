Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793164495;
	b=xziMVmMi4o6qsMKXnMT4nKAGFprA+Oy4DDp3esygFlkToyUmsOdgSgXhBQ+g1Ae4x37u
	 OpG4OCphai82M60+S88uyhDdamQ+QwIii3WuYhzzYL43efUf0B7ZHT+iKbL4JHMQKRZ+7
	 JWJgOQDaQ5CjMpovcg9kOL0rY5x8c1niKtF6895D200r5w8aTKabgIEXgxmloH6Zg8zap
	 WY8ctoGl4cxkL7apw/iaKQnUlQSl0xowxElCUHhfiGsCTnYmcQ4FSAAHxCXqpPPQHCPCL
	 9y6tNaoY3OZhTwB/Sq/SLdLMHgQYpmyXxpK1oiKYXwBxPuPUHE+oSXp5ofB/lcuOviA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793164495;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=+JMr9Md+HInyjUxDjlR1LOoxHmbVAfGsVkKYmeUYaO0=;
	b=iG8XE3MKPSoAB3NmOwBoeQF9m1gUxy5BJgVTjjeJSpb6E7jJz5e8d/FHRKhKzbZe8uBd
	 8pB9KAgZnxQclXWn9M7Xr4jOqlaWqaNCMKrGeFnCQE0b+yYh8rQPnBu1Vb2EmuW6wQ3nO
	 aLWHtkYPKxW4YXg9NZoJqdnn4tynhw4U5GrB4crF6FVCWZcwlAE29HMT6Z8xTxegQXn0Z
	 FoM8Ky0IEwe2guUHpY6j1f7St0j7w71xykbhck+HcnLSAWuZ+XSKWgOyjhHZo26OSdVGJ
	 N1xNJL9/om5zsbsWtpdSp55Ti4RSsvBBdQ4IhTsGFAWYFAeBbitmYEwIP3oub2vusQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Fk64Fqud;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3379606A31A;
	Wed, 28 Oct 2026 05:14:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3379606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=Fk64Fqud
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69S4j3F53325417;
	Wed, 28 Oct 2026 05:14:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=+JMr9Md+HInyjUxDjlR1LOoxHmbVAfGsVkKYmeUYa
	O0=; b=Fk64FqudXo+fA5YYTn+3YfJB4jzGj40dqzhE0B2si0DYttWt/WMb10+ik
	vso+cIBvoqCQafjK63VNu7/YktPRLEOCSIighiNcAx1IOeMJcJGvr1nNwRgihFdl
	pHfrcc0st1Knn1dSDT0ajwVGYQ1Ki815J/xDRZabAbn/lDXNNZEdSyNeYGZVaR8c
	OiEFAm53iqFlpXOcCUVKBSDfmAQtM5qyKQbpoeQCY6gM3Mymk0V6PXqqlss1Gv2E
	XxKVfJnVWvbK8E95D1R0k2SP5ce74qZqnDgmDpJK2SCIiEF/e2qHjfNOwcAQpCYe
	Shq4PUCSwIBLBHFiVBN1fiL1cmZ1g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgk3g2vhu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 05:14:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69S4Z4oL1081797;
	Wed, 28 Oct 2026 05:14:53 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hh8gh5y9h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 Oct 2026 05:14:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69S5Emfw31719924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Oct 2026 05:14:48 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BED7620049;
	Wed, 28 Oct 2026 05:14:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A277D20040;
	Wed, 28 Oct 2026 05:14:48 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 Oct 2026 05:14:48 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v14 0/2] zfcp: Use DMA streaming API to map I/O
Date: Wed, 28 Oct 2026 06:14:44 +0100
Message-ID: <20261028051446.3163392-1-nikh1092@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=BOMmP1QG c=1 sm=1 tr=0 ts=6ae184cd cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Wd4ccqAm3J3WqkYLFQkA:9
X-Proofpoint-ORIG-GUID: nv3-bv8mqECZ7A89XzX419uFCGnwwcNo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI4MDAyMCBTYWx0ZWRfX10GKqylDZb8n
 zvGLGS+vsiGNK7D2O7DxBY6oelAcbwIxIl1WCjsILKWQrC0yfIBTQ2nJIpDbFKWS4bg0yH9yHwe
 LLLYtDLc/UPgQKTsoUqgIOcayZSmNID2FZtYXUXW4Up5apgZF064KgOb/XUHV4O6I2ksBFEGV1Q
 zE3Wry1Z3WPoPy/ZDYB8JUztFDzCziI9JCTvqOrDkOGm2apvz8HxsKgkORzzXw9wvmqWDN6jeqn
 HrL7U2xmTNNSrb67lTPr8Hi9yEQll+trjv0cLVA3wC79I/tTIfAvcJpc9vjDh/K08zeJBUFPZ3v
 uJPM3S3CO8U/P1z86Dhia5pOeKPYGDCQFu9WGYTyglSRJ3YXK+rg4T/rqwkQ0J75Ee1JAY2tFkn
 zRkqKvr86rZoyZk+HTfnc68KNnzJDkCzC42V0JEkIXXq/LydeUprmzaNOAheVBo33SL9Egr/MP4
 4gDgFQ4a3WUKA3VsU/A==
X-Proofpoint-GUID: nv3-bv8mqECZ7A89XzX419uFCGnwwcNo
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI4MDAyMCBTYWx0ZWRfX4RX5uRiOgTG7
 4t0j42hrXWqumfWJNCiE5w4gg047zS2YCcVINl3qiLU6RwBpqb2JesZV/dKw+e791zrEgphTlbP
 bp4QqKffepHNxd0L/oLY6Jm4SUk+BFg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-28_02,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015 spamscore=0
 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610280020

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
 drivers/s390/scsi/zfcp_def.h  |   4 +
 drivers/s390/scsi/zfcp_ext.h  |  12 +-
 drivers/s390/scsi/zfcp_fc.c   |  48 +++--
 drivers/s390/scsi/zfcp_fsf.c  | 325 +++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_fsf.h  |   9 +-
 drivers/s390/scsi/zfcp_qdio.c |  40 +++--
 drivers/s390/scsi/zfcp_qdio.h |  27 +--
 drivers/s390/scsi/zfcp_scsi.c | 205 ++++++++++++++++++++-
 10 files changed, 595 insertions(+), 106 deletions(-)

-- 
2.53.0

