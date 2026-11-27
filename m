Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795806491;
	b=WDJBRLMuo/yPYm2It0GfuCd9bF6lYwTqYnqzZZaiJCXfQM9bGmzLu/cHxNh8efaYJJVK
	 4FYlZEd7HN64YPkjJAb59hOhYr25UJEt3eOAGZQ5hUmwsJrc2HUjUMCLQUy8JWlvJqcsZ
	 Ikq6OtxJXtjbEjjb16YAF1O0hGJtsM6Lf77RctL7PogolJNokDiK0o8mcUjFObE5mXB4d
	 nlcF9OyJ39+SoizW7Vsv1w11UaBNGHo07iTBuhrMj8ysE4w/DDQ81AJ7Qp7ilC/R6ZIYe
	 hiUfmIdBH//rNoCX9wSDm/Xr8KVLtbn9Fa1xzI6P+ZN4YQ1FpAOCGeRU/9QmEycWvuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795806491;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=TX7Nii9x5yTysf9/AmcLYyyr6SmHK8dLBkxO2v0O1E0=;
	b=OvHokzVN8o9ULHp9yTZqTvUyaHvzwIMzSBS+6MmbVrrkB5ce01uZExWc2/2L+N83E9eV
	 VdHmRuojzH3gihiPyzGXE4+mCB32tAgUflFnHm7Vo4mqaZW7xV39tU7tUCxWc3icOw4zj
	 Fh7EM1UNbjIRoTrqzknPBNCbLOSiSXmNNVTqK44IUoTTbjvbBlRnmAWSIie6iv8feuCnO
	 2xyr0FlGZxCD/rmKHUGPIe03uWr/5+HhKTBAXVG3u9qZTDRkIE57LQyearZEScZA9SWvO
	 wNmTVdOYk8Xlw/D1959+nmZRrdcO3/r+Cim0nqmL9icTjLatC5dZE9VUTvCESAsoqag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=OEdgPjOK;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3FB606A31E;
	Fri, 27 Nov 2026 19:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B3FB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=OEdgPjOK
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARG4crI1892019;
	Fri, 27 Nov 2026 19:08:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=TX7Nii9x5yTysf9/AmcLYyyr6SmHK8dLBkxO2v0O1
	E0=; b=OEdgPjOKVf/Wbme7BPD4ixAeYF5fjtGl4UQ51e2V8ZZSGFcEs0L1bhT7Y
	C4200sqrh1tZb2hU1vkNpsLdqQgqSumEH4ogYFuf54tftp67irAxMTc2IikleWhj
	5+iwuBdQe/uIWwXqydca1eU22HwTUAGEMAJUgdnQoOQxjt+YBHoBVKrZ+4cERNug
	kQke6jcOptSp22shFT/MRbkT1XrdF7+JVpH+gcNaR2cuz0Szm6ExUOgMoZo0sxd+
	QoIShj0BGpQZSNGwqjTW/VkEP0h5HmYGGRFUQQbrL0OUCa3juYl7KC/AK5bNnRer
	JZevdYTAdjMzIFidRkvfdCS9FWZug==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34g3qa0m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 19:08:08 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARFnIj51295747;
	Fri, 27 Nov 2026 19:08:07 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6rhcmfr6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 19:08:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARJ83hh28902026
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 19:08:03 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48F6D2004B;
	Fri, 27 Nov 2026 19:08:03 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D9962004E;
	Fri, 27 Nov 2026 19:08:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.16.103])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 19:08:01 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v15 0/2] zfcp: Use DMA streaming API to map I/O
Date: Sat, 28 Nov 2026 00:37:52 +0530
Message-Id: <20261127190754.6442-1-nikh1092@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=SoQFe/O0 c=1 sm=1 tr=0 ts=6b09d518 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Wd4ccqAm3J3WqkYLFQkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA3NiBTYWx0ZWRfX9bCexmgiGvu2
 HRWDBOeyMa/ojnOUEjnFBH3pw4NNloNGg0DpqXNcFp3KFuS/+DG29X+qmtM16TKf5tEw9gTQlFc
 EWqMY9aOyzxqWfD770hyRTB7U+/BM4M=
X-Proofpoint-ORIG-GUID: UsJiBDUSw35I8AnhOyH77GeQGgkDxhqG
X-Proofpoint-GUID: UsJiBDUSw35I8AnhOyH77GeQGgkDxhqG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA3NiBTYWx0ZWRfX/7Hpo5P8HicU
 LN8Mtnfu80bpv5QmXYxf5L9Emk0p1J9t3wLsmjELjDq3E7LHOnS6aYS+xb7vv3N5rbnIMR+tyS+
 0WRQQZF0ae6vaxgCt3rlbmRul8A4TYZ+zG1giAVP8rueEVO9dVvaGG7R9JK5X35jBxNtVp+yt5k
 AgehalE9aLScAev54qGfKa1XkjJj8eeij0xQHAEziAaq28k3cI7aOFRgSpOe0uzE5jhoinpr1I9
 zcyhyOux/dVMe90po+sjmlkDOwulv8ILs7sq1UXXfwPfYO3OECtjl25fdyaT9qnK4ZhLJG0z8ju
 w/xoHEjvlNgoQ2mEj0XY+ZUfax9rO/UNRlX6hoQgP6NTfL9gSuebDCy/kyBXWLjbkhh/7dkN4NI
 5fi5m8tguVJGDeqwrgsZVXyI8EDGXcQGmfaO6mUU8lLN0FmDq+axoX8AbfsSVMuqILqL5PoDK4c
 P/bv+qSSw7mLpKqlkqA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_03,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 malwarescore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270076

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

