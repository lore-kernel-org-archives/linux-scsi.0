Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793009589;
	b=r2puhrPDVyazgb5TCMZsWNSXn98nJFhEh6YRJjFBodZWfFyl9JZUtdVBkg8KffkRQYN3
	 K1PdZqmYuOJuE4dH0gj1udpewaG02M0X7VQ9u1if3yTvrZAJZVQJIGpfajP5BS2V24AAX
	 ZDc1vZikcuhsVAhh0sVPMkBjheJteqPaIb3AVOY6W/jcXVLS68P1A5XxZCSlBe9Is/KZU
	 Fy1wV4R5SbQfE/X0cxHA+Wa4iIUutc08txug6Oe+aozlpBQA+izELkFIeiSe9AYVuqvEp
	 Fgmmp3RktzvmEU8+BTJMBqGQZaTQNh7VwWoKtrtKk5WOFx9KUL6QQ6u45MkkAF0AY8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793009589;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=tE7TMUoot9+ZHXItE2xcDUNk1Jwtobyrt6OsciPfROg=;
	b=NDo8Y9wrumTHkm/8uK77wtvCyO3U5xG0yIsGDu+0ts9hMjxdMDi4tmSf0C30AjjuUCii
	 iTTnrsHm1lGy7gsN4yidSD8MK5UIfm40H6n2hwqgCGdTj+qbaDz9tzlyc1ML8XkS0YOfL
	 xkr3gQl4t09srJ7Bi544VklyWBS40WmoAwf606jetp/deWojMimpDqfEX/px26rHVlq+M
	 tvmEPhFFrJt2Yho01B558F2+HdLWmGOHXNVkkKmxRgQ4xi+C7PMYJpRyb0KWMI4srP9h8
	 QmgJSRqKKtl5Mvep6T/gD488xn8PWwkD+ZhTBEoaZfsCEiL6PJPb0z1tKk66dYKvFSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b="b0Z/EXoQ";
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0D7606A327;
	Mon, 26 Oct 2026 10:13:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D0D7606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=b0Z/EXoQ
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q2j3fU352580;
	Mon, 26 Oct 2026 10:13:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=tE7TMUoot9+ZHXItE2xcDUNk1Jwtobyrt6OsciPfR
	Og=; b=b0Z/EXoQSgGKQk5vgY0VW8AXSjSd6yd2UUuJeHiDbv4VZuM4v/R1arVgc
	l/pV1VS7A91NuUOcqjyYj/qn8/Cj2+b4BDSOFW7bzgMJuLEoWkMSrdGKWs1nKH/k
	3uWLEfwQljCSs9X12B5OVuSsNJqcRZ2JOTiR4qpfYfPjBfrjouF5kpaLP0fQgylq
	QHRw6e0BJfoxgHypdi8Q0iFdpXazt1EgU7Exjg+h0CwIO1tswXvlDn6dyBPZ/uLT
	Y4kVil8F8Y7sBQOfQCcagnZkzMRezbMaFPxckof4QjwZ/L4P91BuD0vtYzRdXSQI
	erixYbm9gSRW2okQTfHcSw8tgcO9w==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgmbss7jr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 26 Oct 2026 10:13:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69Q7H5Fv693092;
	Mon, 26 Oct 2026 10:13:07 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hh97gn3g5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 Oct 2026 10:13:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69QAD3YD26804558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Oct 2026 10:13:03 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BB5F220076;
	Mon, 26 Oct 2026 10:13:03 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AC9E20075;
	Mon, 26 Oct 2026 10:13:03 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 26 Oct 2026 10:13:03 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v13 0/2] zfcp: Use DMA streaming API to map I/O
Date: Mon, 26 Oct 2026 11:12:59 +0100
Message-ID: <20261026101301.3543163-1-nikh1092@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI2MDAzOCBTYWx0ZWRfXziPpaB+DAjxo
 79igLaYtAf4TaKdLAW5WScgvsP05Zot6Fe/KvPlMcfqud3PP+iiy5WbYW6wPVnuJVvXqgbpFosN
 evFTevT++fw+lHqufXkxS0JLEGWIboNJs6hv+AU+Xx3FLF+Pq1RZXFFsNmbq82ujNhIjbWqOot/
 EdqBfF+0mVpdayp1HAT7OVENf3FF5tLkig1w7v8mfID5EJrbpRHfNLimFw8p4oWeUh/0O9MJ1Wp
 EPVFbNsi4KoANMw3fbLUvXJPcYMH5oZkPIaa0k3mBzGhSr1hzfEJSaUqDyR4uIxyFWkP6e1rABx
 QiCUS5C0lCWuPnn8oyWhvvG5XbPxU54JW9/xXjroANJvdvTALoBtMkY548gz3ek06r1oA4X0d3X
 KYzSS+8p1h9JWeN9KuzCIJVdo3h0fUXM4J3Yh1Why3xdbc/mxWnDtni5TeHB3wnEPc6/fe8cAYN
 AjHtcifN6zDSrMfu+bA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI2MDAzOCBTYWx0ZWRfX4tIMv8x6XR6c
 cJN2nhEXv69hxfZP7UFYyvxPKCj8OlFTFJLZIHrPWv9IRrDBBu7xbrsUL1m4EYxHER6gRRCDkEU
 OB0tB9I5iIZolcSCQQsj3hS3mBK1aRY=
X-Proofpoint-ORIG-GUID: PNjCznEVARRt8Iwx7BlyPcwXm-77bO4K
X-Proofpoint-GUID: PNjCznEVARRt8Iwx7BlyPcwXm-77bO4K
X-Authority-Analysis: v=2.4 cv=CeKdd7rl c=1 sm=1 tr=0 ts=6adf27b4 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Wd4ccqAm3J3WqkYLFQkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-26_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610260038

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
 drivers/s390/scsi/zfcp_scsi.c | 126 ++++++++++++-
 10 files changed, 517 insertions(+), 105 deletions(-)

-- 
2.53.0

