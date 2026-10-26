Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792988224;
	b=vDgqjw8yrZYRT/nQrzZdCR6yCQ2kJa/HKci+Ur4IUqufeBXQ53nMBlvl5p6XTkz030LV
	 1sqzyiB1Qd3nMRhjj2XNBZs8gJ8X5U+eSuGhMxQDmipq0fy15LWdPzMJNUcG0NeI0kBXZ
	 s6tfcGS3rAzEMjJjlg5rFscyCaaodDQAI7uqEJg60adev22crNfZrcpvdZinz5QVeqPzt
	 P5MyNvx6muC8Iru/aKxpKralpVpSdC39w56MxLos7xQ+0qZoca30J0PG3yQ1yLUp/sjao
	 kxJF6LxAEVMdetLKlWzTB44dFjUUvrrtuBWnYWohss6gQpK6+XKkKYyhUdt6U5oGYSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792988224;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=hW+j5hVH2NoEz7o0BKAh/O6CXz6kmzHAOPnvYWNp+FI=;
	b=EbNfhb71Jegk3xRaCehjUJhz6x4R0535GkscMYBRwH+0oftK983G14uczT0yp1Lpj+J0
	 HCyQEwMfWpYdp487vXoTXO7YGBnQam8KjqX7l74Q/nelneK/cCES8Qp8KOoJZLJwOFyCm
	 pcZxB6b7eO2olk57rYHYhNeJ34+T9r403Iyo9Dv0scj8UQw20xi+73ygeDOGXlrmB0NL0
	 WdFmkh1z2O6SbhShGA6QgxJvAQmNWENEdNyuMze1DtctqVY5vnEosLGgkvCQxVevNjXG1
	 Dn4zA7b7KBetEkDAtuvrogVKkboDkzoNKvDYTPEKgQZ1v7Okqk8KcnvXyzMdLhlmYag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ontQWzV7;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAF3606A31A;
	Mon, 26 Oct 2026 04:17:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFAF3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=ontQWzV7
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q2i6sD833002;
	Mon, 26 Oct 2026 04:17:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=hW+j5hVH2NoEz7o0BKAh/O6CXz6kmzHAOPnvYWNp+
	FI=; b=ontQWzV77lWHvfCbPp141QBeC6FlPuA1soK0vISrw/j3vbp45c77zyao/
	qURQpy+rYmxi61Adj5nJHgZmfbKsGQfZJ24V/Nb3+4lvr2XsPe/uDOkGAI/iGYq2
	ZEaVSRB0YKy7JUETO7tKMc6J83WTn0dxPjSVbXFf1KJxhCS20yZ87II1PT9g+g3v
	GaHhIswexl4d7t/DtKBYPojVPDEsvoj84shTENTXgVlSTm0rFumGasjPCFe6CyIC
	QLDqmaEaR8ivRgCJuDJpO5wJdA4N5EO6tg8b2ncZfXueSTxAIAmJIVPb30SU5+8i
	uE+1qaTSfyrnvM2PNmNn17UA7xULQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgk3fqsyf-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 26 Oct 2026 04:17:02 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q2KQws1924216;
	Mon, 26 Oct 2026 04:17:02 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hh8ggv2dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Oct 2026 04:17:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69Q4GwY456230186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Oct 2026 04:16:58 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0489D2004D;
	Mon, 26 Oct 2026 04:16:58 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D854B20043;
	Mon, 26 Oct 2026 04:16:57 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 Oct 2026 04:16:57 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v13 0/2] zfcp: Use DMA streaming API to map I/O
Date: Mon, 26 Oct 2026 05:16:52 +0100
Message-ID: <20261026041654.2301619-1-nikh1092@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=BOMmP1QG c=1 sm=1 tr=0 ts=6aded43e cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Wd4ccqAm3J3WqkYLFQkA:9
X-Proofpoint-ORIG-GUID: 4VQ7dfiLZTNR98kiIa3a8kK_A1u8q83e
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAxNiBTYWx0ZWRfXy9xzsYTGaNV9
 inoWM5bzGoGABjRt0pf/Yb3X6W3d/nQb9fA5KM4GU9vHoVzVQJfuxWxCNSAHcBhLvrkR/P8rPtR
 dTC4LcZ4bF1VIvy1pqET45ryyfmxHmwjqMOfdto90UVBiIo8QUkV62JeXeO3b+EO5ct3OoQqecu
 Fxrdh3BIkVjEiP8FtBujjiL06xkXRyMl7YOU2R9M6heEmpDDFsmz4YbSiOe8XDrqz0pGYOlmMwa
 ozxAfs3vnjnfsuFyokiYdXw8VfVYpWasKguO+IEmJJHv4Lw8AQ3ztvFQo/+ycOJYhZasy8lXiyh
 UislMCSIdBlGWGjE/SvQEr8+0zz+8rpAobGjhQiVIBKyPi79IuBo7FsAEdI/JiQOus/8Xhly3Jl
 7l7cEMLJ6em8+yTAYgMgv/JsFDAGBZsIsZQIUy9/s162W0/NG0voUHhwUVae2t5cYzAo3Q2gxBT
 m2KMgzjZRJAJugh1j/A==
X-Proofpoint-GUID: 4VQ7dfiLZTNR98kiIa3a8kK_A1u8q83e
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAxNiBTYWx0ZWRfXyrXtqK8x+J5H
 jkIOorZ/nbmKHdUflw8jEzvqmo9gQCwRgFcqOvChPXGTQ6cpCbvIgOStpf0CDhJbfwtWXVdwlzM
 aly/nfFypttCIpvLJHuBZp6MxHLav5Q=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1015 spamscore=0
 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260016

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
 drivers/s390/scsi/zfcp_scsi.c | 126 ++++++++++++-
 10 files changed, 518 insertions(+), 105 deletions(-)

-- 
2.53.0

