Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571701;
	b=rX1+gKADlCeYkqLcBHKEZd7HiEz/8C3+KsS1rsc6IjFhwBUaWnz47COOlnuoRUWMWvvj
	 xQ3lqM1qtWLjoHweFlE4UPwJPGH8hk6ThSiY5pd4DJgEah4LVYveNUt/8Q8h/AOzsJqL+
	 XftXW6oNSBtjXRKeGeaGFWYLCm3oXaYHcnQiYThmP5xc95AQFDMIJfXAMwK4JAmKCXmMD
	 GsZdjFbCAZDNtwl1tAfaNdpO8jpIGXBlL4/j+aE+0Rz0JPddoTb2pcWhpDu+bpp3UI+Dg
	 cF8oCGHbEJsG52VwbHixW4HMJC9+kn5GdQP1b4wbxi+JfnjieWFyPczgRbgsg4PYI1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571701;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=LHOufChsw+TtWAa5ca7muSaAZI0vYZ6iD/J08E01zV4=;
	b=kb5sFB8iQCh903tzuqbWefFm6CMbdcKCWt+bG32/qR3VdVARtoe70v31I6UDmBeJqV8T
	 DYBEDY6tcBzXmev4DviniQ7zIM6ataDECh5qs0eNZRXbYfgL8gdDhyxg3iSD+lj1pSdu2
	 vRcwDGChIOqpnb8Oly7prI/gSX/l9IITxpEHv100TsMb6e32w0hSrvhrs9/JrtTHUadbL
	 +T9h81QOxYkJWSPYlJaV3vqG+IUe/tTm7BAdQSXPNGtEpV3AyR38Edfm6Qj72PzVKTLkr
	 Ifoee3qKSAzYJXKfn3CFhN45eLCEMKnwnCC0rrA/HWUSGgYtWgkdYWGFyuRJX2dPbzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=BsT+PcMt;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD48606A31A;
	Wed, 21 Oct 2026 08:35:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECD48606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=BsT+PcMt
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5iGdU2855461;
	Wed, 21 Oct 2026 08:35:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=LHOufChsw+TtWAa5ca7muSaAZI0vYZ6iD/J08E01z
	V4=; b=BsT+PcMtQFo8y0esRs54FmAfFlYllouTO/yZRLrAE7sW9T6jG0ELhLIdG
	mdeTB2z15ic93FyHn9S/3DLTtwwCth8ZXUljQoa90EAMPxBftKA965jT4g5BKeMh
	CRRZEKhG7XciybGPJG+FzdzimBvwTnS41pfuxMI/H3ApyqhjECCJxFcOfF4Vl1mP
	+D3TKZx1Z2s31DNRDozzV2JQqieNualbib1R6ozcWLK8Rgm3/2yPzbeEePCqoZ5i
	KjafZwkDPGtZSxPJ5ilIIoEgrtO0bYVuWHz7pTPN/Pz0018UgYjLqT+iVTIpS34z
	B8nzFwS011s1+4eZqBgTiceJdIxYg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5bfupg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 08:35:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5o3UL2684505;
	Wed, 21 Oct 2026 08:34:59 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4he8vhuxv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 08:34:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69L8YtG242729732
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 08:34:55 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 960E92004D;
	Wed, 21 Oct 2026 08:34:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 797E12004B;
	Wed, 21 Oct 2026 08:34:55 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 Oct 2026 08:34:55 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v13 0/2] zfcp: Use DMA streaming API to map I/O
Date: Wed, 21 Oct 2026 10:33:49 +0200
Message-ID: <20261021083351.1626409-1-nikh1092@linux.ibm.com>
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
X-Proofpoint-GUID: 4MHKFDFsAuw1FTZZ07FiBoYQBMDwZ6Tb
X-Proofpoint-ORIG-GUID: 4MHKFDFsAuw1FTZZ07FiBoYQBMDwZ6Tb
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzMiBTYWx0ZWRfXxQZNhzaczzDu
 Wl5Xxa53w4v000pHqqaAcc3rE8lczOfKfB/cSqLXTs4n8+TXye91nIeKD458rXEOFhx5HSAmQN9
 A4gwQ/uAoMWhfjxSveO5QmgxI7IX1Jc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzMiBTYWx0ZWRfXyi0N/jLSt8EG
 MqUNAe5O+BM4YCpe/Wf67/LXQvoNV2KCAytCkJZQ30AurPjTSZIyC70sCgQ3MBtfMp50pvU+Kbf
 d/kr6VD/ec233I4Dkol78sZUraafsbo87qNXvWRIH1LG1zjBhDiYolH77H9WQKzHsWf3BQjCaig
 XNbOwY1TflLEC/JbHC+m7JrhfuLlwPrDbYptFQ6iZ5vJKMXZjkDGa//fA/G/Q283eyzhXY+QIFa
 ZjzvCFWa2YgsLEDSoib6IFhe2qB6q4VWHV+JwJF9EYYvkC5wV84p1qSze2NGJeZdZqV1hqIjq9D
 OQ7nzc0ROQGTSZ+UuGjcD6f6pv1Xxg8CZWY/ctOcDSxxniDJKArE3tZxFUOOMI/I2YKFIr8kUz+
 nilNsAQ/JR+g4n6CjHFV2rWBg9ptQv4XDRocsxBBNumUsSu22yzb96XOkyeC/ZumfNAYEMWfh0w
 Y0/NedCWYYO0KF3qZ5A==
X-Authority-Analysis: v=2.4 cv=Gb2CDgXL c=1 sm=1 tr=0 ts=6ad87934 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Wd4ccqAm3J3WqkYLFQkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1011 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210032

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
 drivers/s390/scsi/zfcp_fc.c   |  36 ++--
 drivers/s390/scsi/zfcp_fsf.c  | 299 +++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_fsf.h  |   9 +-
 drivers/s390/scsi/zfcp_qdio.c |  39 +++--
 drivers/s390/scsi/zfcp_qdio.h |  27 +--
 drivers/s390/scsi/zfcp_scsi.c |  26 +++
 10 files changed, 386 insertions(+), 97 deletions(-)

-- 
2.53.0

