Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688954;
	b=R0VB8aNSPSkE7Ls2djUXxdcEE3/mponz2MFIRXRSkz5dA3Ekt2mBVbY4JC0xvQNXz6jY
	 r1RrM3/Qok6qKcFQmg4haR+GuElt7lbX8YNOYw4nxfhq1A1ibzRzsfISM6t8EG/YMG51C
	 TEREAdbj3WGecviCywFhavqwceNm5v/QEAE3o96V23IpOAazmDTLNbBKFF0bT73+QA+UI
	 pZ7izrQzJkyNzVKRrl6RwdFpoofqyh3xV0zTQ+dyvTJVkI+YFxuqR9iH2Wf4rr2zV7Tp3
	 DA6lK7xQmwWRAZm4c35Wqwqb8DKNd5DKr4bQECGQFxo/V4pWPkdnT83pSo2csBlgZ1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688954;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=1LqUlBQTgzDktwGZi/Lxfae3+0hyaCKQD7x7niunVmA=;
	b=XAQYC//zofX4PoIwyGZ6PHj4VCZw2iNGMuXih040idiD9Kpie4zw4l+hcxxk6AG0BY6C
	 Sg7zQoBiT2MObO7eS3KJozpe16hCl9o/YpnkQv3Dzu+CzI/Cb59NwPLcYn26bbrfg281D
	 /JKHbhh4VV786nwBrLGLG4zVMfHE8V6dd9CRR6ah8WLna+P1eoVnPycCVQqvahBl/bBdn
	 Dh4LOo9UYbiXvc96OpwC7GRom3+x2K8PMHEYLigl20p3MMYv2DmveEGy44z1lbngu3Gmk
	 VJ/YLLyMUIpPagu8ZIfzbBtkO7eNNxWouwyf+CxpxNvudZ3mgMwdPDdYWza2Kz1MMqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NWpCFvpL;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5906D606A324;
	Thu, 22 Oct 2026 17:09:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5906D606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=NWpCFvpL
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69MEEhqC3183748;
	Thu, 22 Oct 2026 17:09:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1LqUlBQTgzDktwGZi
	/Lxfae3+0hyaCKQD7x7niunVmA=; b=NWpCFvpLyb7PDah8dY6Nj/EVg2kNINqol
	3zi5gF9kQfAWeiZGNwjzOWCOFLoLYKrfi2aznnjDygkV7PGlTiFAf4p/SkeMVX14
	WpkrwGtT9rLwgomdhFIWkjAsmkhX+h5N15BJAZRbRXiuA9eQNt81WE3Qy4ZxmBsy
	3CU5OwPzKh1qxcaLoe9ci4UpY5pJqW4vZuZkv0OS2Eqr4dGxkehNw462aeBe1dg3
	E1FhDpMQ/bKR50Gy7VbZ53YZGnV0uh2Ow+vgW+CvqUnn69YdvknM487Vv6+tFngb
	EFVXqUIrBrFnWHUY76sVPAq5kLviHGH9VR9kkgrXon/QNUxkgHMbw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw58fxhs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 17:09:11 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69MEJxn9662226;
	Thu, 22 Oct 2026 17:09:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hfgck1gsk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 Oct 2026 17:09:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69MH96No50659694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Oct 2026 17:09:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A3CDA20043;
	Thu, 22 Oct 2026 17:09:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 731BB2004D;
	Thu, 22 Oct 2026 17:09:06 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 Oct 2026 17:09:06 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v13 2/2] zfcp: Use DMA streaming API to map I/O
Date: Thu, 22 Oct 2026 19:08:28 +0200
Message-ID: <20261022170828.4189701-3-nikh1092@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261022170828.4189701-1-nikh1092@linux.ibm.com>
References: <20261022170828.4189701-1-nikh1092@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIyMDA2NiBTYWx0ZWRfX7dR2rPxOfnnR
 sFmIaLQm4senDgwQREWRGaIabivugd5I7D7gRJnjxhBk3JfaDpu4Y+2KQ+2rPuDW1ed6xt+y9Rz
 HFPoRG7fllRxOBJl45VfolQi4wnd4ME=
X-Proofpoint-GUID: nYhsKfw11_Niti5Qh0dkJqfVXVW0Vpjo
X-Proofpoint-ORIG-GUID: nYhsKfw11_Niti5Qh0dkJqfVXVW0Vpjo
X-Authority-Analysis: v=2.4 cv=UOBIjyfy c=1 sm=1 tr=0 ts=6ada4337 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=5MLZUeRbS7Pg7qHgI9gA:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIyMDA2NiBTYWx0ZWRfX99cuPu9prQ/T
 7TakBST5g18APGcx5KPfDVK2jR5v9PelwnEIt1qSFKoXOs33TF0SyHBBVGn4WOD6QAI4VPMO+Yf
 7rnt2ErNoyKDfR06ptuqtZAdDkK+4aBlZVY5ByMw6z6oPJaKNTSPpKs0zekVsWmKb+NrJ5Wg/D4
 IfLO5a4RAF8Wa8R5HlS9LHEUTdDMxiH18ePE5AtXiVyqL6J27q2MR7jAiZQqCTlGRd4uZVkBwnz
 86GkJghFjqogBi4dxfOva1VbrYqX4uXEpFQUN5WIJGa/WL3BXYonFTPZNI6sG9O2Ycy0TPWAR/F
 LaLP557Oumf+NYiLVA42giMkf1NlV2jslr0ItuT5ZDrCjjMJJWIZEheTVJk19asFnRi7PztPyle
 CbPiymq9lIMFSiXRM+In/qQqt7ukMKKOcmjKxWm9tkYNit/0FtROnVj3GXD5AqRzLGLyjHtEvJ4
 74+m0+yuRcb1qJ2ekeA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-22_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610220066

In the existing zFCP driver, virtual addresses are translated directly
into bus (physical) addresses for DMA operations on all I/O buffers
passed from the zFCP driver to the device.

Need for DMA API:

In secure execution environment, the host must ensure that device DMA
addresses are restricted to non-guest-private, page-sized memory blocks.
This prevents I/O failures that can occur when a device attempts to
access guest-private memory. Therefore, guest memory pages must be
prepared by the hypervisor before they become accessible to an I/O
device.

To support this requirement, the host linux kernel must be reliably
informed whenever a memory region becomes eligible for device DMA access
and when that access must be revoked. This information must be
maintained correctly at least at page level granularity.

To satisfy these requirements, all I/O buffers used by the zFCP driver
should be mapped through the DMA API.

DMA streaming API usage in zFCP:

Changes in this patch-series converts all I/O buffer mappings in the
zFCP driver to use the DMA streaming API. Specifically,
`dma_map_sgtable()` and `dma_unmap_sgtable()` are used to map and unmap
the scatter-gather lists.

All zFCP I/O buffers (QTCB, SRB, CT/ELS and SCSI I/O) are represented
using scatter-gather lists. The `sg_table` structure, which encapsulates
the scatterlist together with the original and mapped entry counts, is
used to manage DMA mappings efficiently.

Use struct sg_table to manage scatter-gather lists for QTCB, SRB,
CT/ELS, and SCSI I/O buffers. Initialize single-entry scatterlists for
buffers that are not already represented by scatter-gather tables. For
SCSI I/O, reuse the tables provided by the SCSI midlayer and temporarily
adjust orig_nents when fewer entries are populated than allocated.

Map buffers after updating their contents. For SCSI I/O, synchronize
req->qtcb for device access in zfcp_fsf_fcp_cmnd() before submitting the
request to QDIO. DMA unmapping handles synchronization for CPU access on
the receive path.

Signed-off-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |  16 ++
 drivers/s390/scsi/zfcp_def.h  |   4 +
 drivers/s390/scsi/zfcp_ext.h  |  11 +-
 drivers/s390/scsi/zfcp_fc.c   |  12 ++
 drivers/s390/scsi/zfcp_fsf.c  | 323 +++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_qdio.c |  40 +++--
 drivers/s390/scsi/zfcp_qdio.h |  27 +--
 drivers/s390/scsi/zfcp_scsi.c |  67 ++++++-
 8 files changed, 423 insertions(+), 77 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index fea573e00f9d..20c905c68e1e 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -329,6 +329,19 @@ static void zfcp_destroy_adapter_work_queue(struct zfcp_adapter *adapter)
 
 }
 
+static int zfcp_set_dma_mask_for_adapter(struct zfcp_adapter *adapter)
+{
+	int ret;
+
+	ret = dma_set_mask_and_coherent(&adapter->ccw_device->dev,
+					DMA_BIT_MASK(64));
+	if (ret)
+		dev_err(&adapter->ccw_device->dev,
+			"Setting the DMA mask failed for the FCP device.\n");
+
+	return ret;
+}
+
 /**
  * zfcp_adapter_enqueue - enqueue a new adapter to the list
  * @ccw_device: pointer to the struct cc_device
@@ -404,6 +417,9 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
 
+	if (zfcp_set_dma_mask_for_adapter(adapter))
+		goto failed;
+
 	if (zfcp_erp_thread_setup(adapter))
 		goto failed;
 
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 6c761299a22f..5063921e8d93 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -322,6 +322,8 @@ static inline u64 zfcp_scsi_dev_lun(struct scsi_device *sdev)
  * @pool: reference to memory pool if used for this request
  * @issued: time when request was send (STCK)
  * @handler: handler which should be called to process response
+ * @metadata_sgt: sg_table for metadata of a QTCB or SRB request
+ * @metadata_sg: scatterlist for metadata of a QTCB or SRB request
  */
 struct zfcp_fsf_req {
 	struct list_head	list;
@@ -337,6 +339,8 @@ struct zfcp_fsf_req {
 	mempool_t		*pool;
 	unsigned long long	issued;
 	void			(*handler)(struct zfcp_fsf_req *);
+	struct sg_table		metadata_sgt;
+	struct scatterlist	metadata_sg;
 };
 
 static inline
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 0eb9bc9d03e4..62d0a5686deb 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -150,6 +150,11 @@ enum zfcp_fsf_print_fmt {
 extern ssize_t zfcp_fsf_scnprint_fc_security(char *buf, size_t size,
 					     u32 fc_security,
 					     enum zfcp_fsf_print_fmt fmt);
+int zfcp_fsf_req_map_sg(struct zfcp_fsf_req *req, struct sg_table *sgt,
+			enum dma_data_direction dma_dir);
+void zfcp_fsf_req_unmap_sg(struct device *dev,
+			   struct sg_table *sgt,
+			   enum dma_data_direction dma_dir);
 
 /* zfcp_qdio.c */
 extern int zfcp_qdio_setup(struct zfcp_adapter *);
@@ -157,13 +162,15 @@ extern void zfcp_qdio_destroy(struct zfcp_qdio *);
 extern int zfcp_qdio_sbal_get(struct zfcp_qdio *qdio)
 	__must_hold(qdio->req_q_lock);
 extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_qdio_req *);
-extern int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *, struct zfcp_qdio_req *,
-				   struct scatterlist *);
+int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct sg_table *sgt,
+			    struct zfcp_fsf_req *req,
+			    enum dma_data_direction dma_dir);
 extern void zfcp_qdio_shost_update(struct zfcp_adapter *const adapter,
 				   const struct zfcp_qdio *const qdio);
 extern int zfcp_qdio_open(struct zfcp_qdio *);
 extern void zfcp_qdio_close(struct zfcp_qdio *);
 extern void zfcp_qdio_siosl(struct zfcp_adapter *);
+void zfcp_qdio_zero_sbals(struct qdio_buffer *sbal[], int first, int cnt);
 
 /* zfcp_scsi.c */
 extern bool zfcp_experimental_dix;
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 1fb6f2c3b607..bc8dfdebe88f 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -1104,6 +1104,18 @@ int zfcp_fc_exec_bsg_job(struct bsg_job *job)
 	ct_els->sgt_resp.sgl = job->reply_payload.sg_list;
 	ct_els->sgt_req.orig_nents = sg_nents(ct_els->sgt_req.sgl);
 	ct_els->sgt_resp.orig_nents = sg_nents(ct_els->sgt_resp.sgl);
+	/*
+	 * dd_data lives past the memset(job, 0, sizeof(*job)) boundary in
+	 * bsg_transport_sg_io_fn() and is never zeroed by blk-mq on request
+	 * reuse.  A prior BSG command will have left sgt->nents set to the
+	 * mapped entry count from dma_map_sgtable().  zfcp_fsf_req_map_sg()
+	 * treats any non-zero nents as a SCSI-midlayer "populated < allocated"
+	 * hint and clamps orig_nents to it, causing truncated DMA mappings for
+	 * larger follow-on payloads.  Reset nents so these sg_tables are
+	 * handled like zFCP-internal ones (nents == 0 before mapping).
+	 */
+	ct_els->sgt_req.nents = 0;
+	ct_els->sgt_resp.nents = 0;
 	ct_els->handler_data = job;
 
 	switch (bsg_request->msgcode) {
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index a3b99839da9e..25f15d67c37a 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -14,6 +14,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <scsi/fc/fc_els.h>
+#include <linux/dma-mapping.h>
 #include "zfcp_ext.h"
 #include "zfcp_fc.h"
 #include "zfcp_dbf.h"
@@ -84,6 +85,88 @@ static void zfcp_fsf_class_not_supp(struct zfcp_fsf_req *req)
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
+/**
+ * zfcp_fsf_req_map_sg - map the scattergather list for DMA transfer
+ * @req: pointer to zfcp_fsf_req
+ * @sgt: pointer to scattergather list table
+ * @dma_dir: DMA data direction
+ * Returns: 0 on success, -EIO otherwise
+ */
+int zfcp_fsf_req_map_sg(struct zfcp_fsf_req *req, struct sg_table *sgt,
+			enum dma_data_direction dma_dir)
+{
+	unsigned int saved_orig_nents;
+	int ret;
+
+	if (!valid_dma_direction(dma_dir))
+		return sgt->orig_nents ? -EIO : 0;
+
+	if (!sgt->orig_nents)
+		return 0;
+
+	/*
+	 * The SCSI midlayer sets orig_nents to the allocated SG capacity and
+	 * nents to the actually populated entry count (nents <= orig_nents).
+	 * dma_map_sgtable() and dma_unmap_sgtable() both use orig_nents, so
+	 * clamp it to the populated count to avoid mapping trailing zero-length
+	 * entries. Only clamp when nents has been explicitly set (nents > 0);
+	 * zFCP-internal sg_tables leave nents = 0 before mapping, relying
+	 * solely on orig_nents.
+	 */
+	saved_orig_nents = sgt->orig_nents;
+	if (sgt->nents > 0 && sgt->nents < sgt->orig_nents)
+		sgt->orig_nents = sgt->nents;
+
+	ret = dma_map_sgtable(&req->adapter->ccw_device->dev, sgt, dma_dir, 0);
+
+	sgt->orig_nents = saved_orig_nents;
+
+	return ret;
+}
+
+/**
+ * zfcp_fsf_req_unmap_sg - unmap the scattergather list after DMA transfer
+ * @dev: pointer to the device used for DMA
+ * @sgt: pointer to scattergather list table
+ * @dma_dir: DMA direction of the sg
+ */
+void zfcp_fsf_req_unmap_sg(struct device *dev, struct sg_table *sgt,
+			   enum dma_data_direction dma_dir)
+{
+	unsigned int saved_orig_nents;
+
+	/*
+	 * We still need the check for mapped sg count here to not perform
+	 * unmap for SCSI commands which have zero payload.
+	 */
+	if (!sgt->nents)
+		return;
+
+	saved_orig_nents = sgt->orig_nents;
+	if (sgt->nents < sgt->orig_nents)
+		sgt->orig_nents = sgt->nents;
+
+	dma_unmap_sgtable(dev, sgt, dma_dir, 0);
+
+	sgt->orig_nents = saved_orig_nents;
+}
+
+/**
+ * zfcp_fsf_req_unmap_metadata - unmap the metadata associated with FSF req
+ * @req: pointer to zfcp_fsf_req
+ */
+static inline
+void zfcp_fsf_req_unmap_metadata(struct zfcp_fsf_req *const req)
+{
+	struct device *dev = &req->adapter->ccw_device->dev;
+
+	if (unlikely(zfcp_fsf_req_is_status_read_buffer(req)))
+		zfcp_fsf_req_unmap_sg(dev, &req->metadata_sgt, DMA_FROM_DEVICE);
+	else
+		zfcp_fsf_req_unmap_sg(dev, &req->metadata_sgt,
+				      DMA_BIDIRECTIONAL);
+}
+
 /**
  * zfcp_fsf_req_free - free memory used by fsf request
  * @req: pointer to struct zfcp_fsf_req
@@ -259,6 +342,8 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
 	struct zfcp_adapter *adapter = req->adapter;
 	struct fsf_status_read_buffer *sr_buf = req->data;
 
+	zfcp_fsf_req_unmap_metadata(req);
+
 	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		zfcp_dbf_hba_fsf_uss("fssrh_1", req);
 		mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
@@ -457,6 +542,7 @@ static void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
 		return;
 	}
 
+	zfcp_fsf_req_unmap_metadata(req);
 	timer_delete_sync(&req->timer);
 	zfcp_fsf_protstatus_eval(req);
 	zfcp_fsf_fsfstatus_eval(req);
@@ -870,10 +956,27 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
 		req->qtcb->prefix.qtcb_version = FSF_QTCB_CURRENT_VERSION;
 		req->qtcb->header.req_handle = req->req_id;
 		req->qtcb->header.fsf_command = fsf_cmd;
-	}
 
-	zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id, sbtype,
-			   req->qtcb, sizeof(struct fsf_qtcb));
+		sg_init_one(&req->metadata_sg, req->qtcb,
+			    sizeof(struct fsf_qtcb));
+		req->metadata_sgt.sgl = &req->metadata_sg;
+		req->metadata_sgt.orig_nents = 1;
+
+		if (zfcp_fsf_req_map_sg(req, &req->metadata_sgt,
+					DMA_BIDIRECTIONAL)) {
+			zfcp_fsf_req_free(req);
+			return ERR_PTR(-EIO);
+		}
+
+		zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id,
+				   sbtype, true,
+				   sg_dma_len(req->metadata_sgt.sgl),
+				   sg_dma_address(req->metadata_sgt.sgl));
+	} else {
+		/* SRB */
+		zfcp_qdio_req_init(adapter->qdio, &req->qdio_req, req->req_id,
+				   sbtype, false, 0, 0);
+	}
 
 	return req;
 }
@@ -885,6 +988,15 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
 	struct zfcp_qdio *qdio = adapter->qdio;
 	u64 req_id = req->req_id;
 
+	/*
+	 * Flush all CPU-side QTCB writes to the SWIOTLB bounce buffer now
+	 * that the QTCB is fully populated.  SRBs carry no outbound QTCB.
+	 */
+	if (!is_srb)
+		dma_sync_sgtable_for_device(&adapter->ccw_device->dev,
+					    &req->metadata_sgt,
+					    DMA_BIDIRECTIONAL);
+
 	zfcp_reqlist_add(adapter->req_list, req);
 
 	req->qdio_req.qdio_outb_usage = atomic_read(&qdio->req_q_free);
@@ -954,7 +1066,17 @@ int zfcp_fsf_status_read(struct zfcp_qdio *qdio)
 	memset(sr_buf, 0, sizeof(*sr_buf));
 	req->data = sr_buf;
 
-	zfcp_qdio_fill_next(qdio, &req->qdio_req, sr_buf, sizeof(*sr_buf));
+	sg_init_one(&req->metadata_sg, sr_buf, sizeof(*sr_buf));
+	req->metadata_sgt.sgl = &req->metadata_sg;
+	req->metadata_sgt.orig_nents = 1;
+
+	retval = zfcp_fsf_req_map_sg(req, &req->metadata_sgt, DMA_FROM_DEVICE);
+	if (unlikely(retval))
+		goto failed_dma_map;
+
+	zfcp_qdio_fill_next(qdio, &req->qdio_req,
+			    sg_dma_address(req->metadata_sgt.sgl),
+			    sg_dma_len(req->metadata_sgt.sgl));
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	retval = zfcp_fsf_req_send(req);
@@ -965,6 +1087,8 @@ int zfcp_fsf_status_read(struct zfcp_qdio *qdio)
 	goto out;
 
 failed_req_send:
+	zfcp_fsf_req_unmap_metadata(req);
+failed_dma_map:
 	req->data = NULL;
 	mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
 failed_buf:
@@ -1076,6 +1200,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *scmnd)
 	}
 
 out_error_free:
+	zfcp_fsf_req_unmap_metadata(req);
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
@@ -1091,6 +1216,11 @@ static void zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *req)
 
 	ct->status = -EINVAL;
 
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &ct->sgt_req, DMA_TO_DEVICE);
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &ct->sgt_resp, DMA_FROM_DEVICE);
+
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
 
@@ -1130,19 +1260,42 @@ static void zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *req)
 		ct->handler(ct->handler_data);
 }
 
-static void zfcp_fsf_setup_ct_els_unchained(struct zfcp_qdio *qdio,
-					    struct zfcp_qdio_req *q_req,
-					    struct scatterlist *sg_req,
-					    struct scatterlist *sg_resp)
+static int zfcp_fsf_setup_ct_els_unchained(struct zfcp_fsf_req *req,
+					   struct zfcp_qdio *qdio,
+					   struct sg_table *sg_req_table,
+					   struct sg_table *sg_resp_table)
 {
-	zfcp_qdio_fill_next(qdio, q_req, sg_virt(sg_req), sg_req->length);
-	zfcp_qdio_fill_next(qdio, q_req, sg_virt(sg_resp), sg_resp->length);
-	zfcp_qdio_set_sbale_last(qdio, q_req);
+	int retval = 0;
+
+	retval = zfcp_fsf_req_map_sg(req, sg_req_table, DMA_TO_DEVICE);
+	if (unlikely(retval))
+		goto err;
+
+	retval = zfcp_fsf_req_map_sg(req, sg_resp_table,
+				     DMA_FROM_DEVICE);
+	if (unlikely(retval))
+		goto err_unmap;
+
+	zfcp_qdio_fill_next(qdio, &req->qdio_req,
+			    sg_dma_address(sg_req_table->sgl),
+			    sg_dma_len(sg_req_table->sgl));
+	zfcp_qdio_fill_next(qdio, &req->qdio_req,
+			    sg_dma_address(sg_resp_table->sgl),
+			    sg_dma_len(sg_resp_table->sgl));
+	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
+
+	return 0;
+
+err_unmap:
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      sg_req_table, DMA_TO_DEVICE);
+err:
+	return retval;
 }
 
 static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
-				       struct scatterlist *sg_req,
-				       struct scatterlist *sg_resp)
+				       struct sg_table *sgt_req,
+				       struct sg_table *sgt_resp)
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
@@ -1150,57 +1303,73 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
 	u32 feat = adapter->adapter_features;
 
 	if (zfcp_adapter_multi_buffer_active(adapter)) {
-		if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_req))
+		if (zfcp_qdio_sbals_from_sg(qdio, sgt_req, req, DMA_TO_DEVICE))
 			return -EIO;
+
 		qtcb->bottom.support.req_buf_length =
-			zfcp_qdio_real_bytes(sg_req);
-		if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_resp))
-			return -EIO;
+			zfcp_qdio_real_bytes(sgt_req->sgl);
+
+		if (zfcp_qdio_sbals_from_sg(qdio, sgt_resp, req, DMA_FROM_DEVICE))
+			goto err_unmap;
+
 		qtcb->bottom.support.resp_buf_length =
-			zfcp_qdio_real_bytes(sg_resp);
+			zfcp_qdio_real_bytes(sgt_resp->sgl);
 
-		zfcp_qdio_set_data_div(qdio, &req->qdio_req, sg_nents(sg_req));
+		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
+				       sgt_req->nents);
 		zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 		zfcp_qdio_set_scount(qdio, &req->qdio_req);
 		return 0;
 	}
 
 	/* use single, unchained SBAL if it can hold the request */
-	if (zfcp_qdio_sg_one_sbale(sg_req) && zfcp_qdio_sg_one_sbale(sg_resp)) {
-		zfcp_fsf_setup_ct_els_unchained(qdio, &req->qdio_req,
-						sg_req, sg_resp);
+	if (zfcp_qdio_sg_one_sbale(sgt_req->sgl) &&
+	    zfcp_qdio_sg_one_sbale(sgt_resp->sgl)) {
+		if (zfcp_fsf_setup_ct_els_unchained(req, qdio, sgt_req,
+						    sgt_resp))
+			return -EIO;
+
 		return 0;
 	}
 
 	if (!(feat & FSF_FEATURE_ELS_CT_CHAINED_SBALS))
 		return -EOPNOTSUPP;
 
-	if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_req))
+	if (zfcp_qdio_sbals_from_sg(qdio, sgt_req, req, DMA_TO_DEVICE))
 		return -EIO;
 
-	qtcb->bottom.support.req_buf_length = zfcp_qdio_real_bytes(sg_req);
+	qtcb->bottom.support.req_buf_length =
+		zfcp_qdio_real_bytes(sgt_req->sgl);
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 	zfcp_qdio_skip_to_last_sbale(qdio, &req->qdio_req);
 
-	if (zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req, sg_resp))
-		return -EIO;
+	if (zfcp_qdio_sbals_from_sg(qdio, sgt_resp, req, DMA_FROM_DEVICE))
+		goto err_unmap;
 
-	qtcb->bottom.support.resp_buf_length = zfcp_qdio_real_bytes(sg_resp);
+	qtcb->bottom.support.resp_buf_length =
+		zfcp_qdio_real_bytes(sgt_resp->sgl);
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	return 0;
+
+err_unmap:
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      sgt_req, DMA_TO_DEVICE);
+	zfcp_qdio_zero_sbals(qdio->req_q, req->qdio_req.sbal_first,
+			     req->qdio_req.sbal_number);
+	return -EIO;
 }
 
 static int zfcp_fsf_setup_ct_els(struct zfcp_fsf_req *req,
-				 struct scatterlist *sg_req,
-				 struct scatterlist *sg_resp,
+				 struct sg_table *sgt_req,
+				 struct sg_table *sgt_resp,
 				 unsigned int timeout)
 {
 	int ret;
 
-	ret = zfcp_fsf_setup_ct_els_sbals(req, sg_req, sg_resp);
+	ret = zfcp_fsf_setup_ct_els_sbals(req, sgt_req, sgt_resp);
 	if (ret)
 		return ret;
 
@@ -1242,8 +1411,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els(req, ct->sgt_req.sgl, ct->sgt_resp.sgl,
-				    timeout);
+	ret = zfcp_fsf_setup_ct_els(req, &ct->sgt_req, &ct->sgt_resp, timeout);
 	if (ret)
 		goto failed_send;
 
@@ -1256,12 +1424,21 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
 
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
-		goto failed_send;
+		goto err_unmap;
+
 	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 
 	goto out;
 
+err_unmap:
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &ct->sgt_req, DMA_TO_DEVICE);
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &ct->sgt_resp, DMA_FROM_DEVICE);
 failed_send:
+	zfcp_qdio_zero_sbals(qdio->req_q, req->qdio_req.sbal_first,
+			     req->qdio_req.sbal_number);
+	zfcp_fsf_req_unmap_metadata(req);
 	zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
@@ -1275,6 +1452,11 @@ static void zfcp_fsf_send_els_handler(struct zfcp_fsf_req *req)
 
 	send_els->status = -EINVAL;
 
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &send_els->sgt_req, DMA_TO_DEVICE);
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &send_els->sgt_resp, DMA_FROM_DEVICE);
+
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
 
@@ -1343,9 +1525,8 @@ int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
 	if (!zfcp_adapter_multi_buffer_active(adapter))
 		zfcp_qdio_sbal_limit(qdio, &req->qdio_req, 2);
 
-	ret = zfcp_fsf_setup_ct_els(req, els->sgt_req.sgl, els->sgt_resp.sgl,
+	ret = zfcp_fsf_setup_ct_els(req, &els->sgt_req, &els->sgt_resp,
 				    timeout);
-
 	if (ret)
 		goto failed_send;
 
@@ -1358,12 +1539,21 @@ int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
 
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
-		goto failed_send;
+		goto err_unmap;
+
 	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 
 	goto out;
 
+err_unmap:
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &els->sgt_req, DMA_TO_DEVICE);
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &els->sgt_resp, DMA_FROM_DEVICE);
 failed_send:
+	zfcp_qdio_zero_sbals(qdio->req_q, req->qdio_req.sbal_first,
+			     req->qdio_req.sbal_number);
+	zfcp_fsf_req_unmap_metadata(req);
 	zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
@@ -1404,6 +1594,7 @@ int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -1469,6 +1660,8 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *qdio,
 			retval = -EIO;
 		else if (req->status & ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE)
 			retval = -EAGAIN;
+	} else {
+		zfcp_fsf_req_unmap_metadata(req);
 	}
 
 	zfcp_fsf_req_free(req);
@@ -1516,6 +1709,7 @@ int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -1578,6 +1772,8 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 			retval = -EIO;
 		else if (req->status & ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE)
 			retval = -EAGAIN;
+	} else {
+		zfcp_fsf_req_unmap_metadata(req);
 	}
 
 	zfcp_fsf_req_free(req);
@@ -1810,6 +2006,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 		put_device(&port->dev);
@@ -1876,6 +2073,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -1950,8 +2148,10 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-	if (retval)
+	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
+	}
 	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
@@ -2009,8 +2209,10 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
-	if (retval)
+	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
+	}
 	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
@@ -2103,6 +2305,7 @@ int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -2227,6 +2430,7 @@ int zfcp_fsf_open_lun(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -2316,6 +2520,7 @@ int zfcp_fsf_close_lun(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -2474,6 +2679,15 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 		return;
 	}
 
+	if ((scsi_get_prot_op(scpnt) != SCSI_PROT_NORMAL) &&
+	    scsi_prot_sg_count(scpnt))
+		zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+				      &scpnt->prot_sdb->table,
+				      scpnt->sc_data_direction);
+
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &scpnt->sdb.table, scpnt->sc_data_direction);
+
 	zfcp_fsf_fcp_handler_common(req, scpnt->device);
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
@@ -2617,20 +2831,22 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
 	if ((scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) &&
 	    scsi_prot_sg_count(scsi_cmnd)) {
-		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
-				       scsi_prot_sg_count(scsi_cmnd));
-		retval = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
-						 scsi_prot_sglist(scsi_cmnd));
+		retval = zfcp_qdio_sbals_from_sg(qdio,
+						 &scsi_cmnd->prot_sdb->table,
+						 req,
+						 scsi_cmnd->sc_data_direction);
 		if (retval)
 			goto failed_scsi_cmnd;
+		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
+				       scsi_cmnd->prot_sdb->table.nents);
 		io->prot_data_length = zfcp_qdio_real_bytes(
 						scsi_prot_sglist(scsi_cmnd));
 	}
 
-	retval = zfcp_qdio_sbals_from_sg(qdio, &req->qdio_req,
-					 scsi_sglist(scsi_cmnd));
+	retval = zfcp_qdio_sbals_from_sg(qdio, &scsi_cmnd->sdb.table, req,
+					 scsi_cmnd->sc_data_direction);
 	if (unlikely(retval))
-		goto failed_scsi_cmnd;
+		goto failed_normal_scsi_map;
 
 	zfcp_qdio_set_sbale_last(adapter->qdio, &req->qdio_req);
 	if (zfcp_adapter_multi_buffer_active(adapter))
@@ -2638,12 +2854,26 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
 	retval = zfcp_fsf_req_send(req);
 	if (unlikely(retval))
-		goto failed_scsi_cmnd;
+		goto failed_req_send;
+
 	/* NOTE: DO NOT TOUCH req PAST THIS POINT! */
 
 	goto out;
 
+failed_req_send:
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &scsi_cmnd->sdb.table,
+			      scsi_cmnd->sc_data_direction);
+failed_normal_scsi_map:
+	if ((scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) &&
+	    scsi_prot_sg_count(scsi_cmnd))
+		zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+				      &scsi_cmnd->prot_sdb->table,
+				      scsi_cmnd->sc_data_direction);
 failed_scsi_cmnd:
+	zfcp_qdio_zero_sbals(qdio->req_q, req->qdio_req.sbal_first,
+			     req->qdio_req.sbal_number);
+	zfcp_fsf_req_unmap_metadata(req);
 	zfcp_fsf_req_free(req);
 	scsi_cmnd->host_scribble = NULL;
 out:
@@ -2719,6 +2949,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *sdev,
 		goto out;
 	}
 
+	zfcp_fsf_req_unmap_metadata(req);
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index bac8385e069f..83855d2dd94a 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -39,7 +39,7 @@ static void zfcp_qdio_handler_error(struct zfcp_qdio *qdio, char *dbftag,
 				ZFCP_STATUS_COMMON_ERP_FAILED, dbftag);
 }
 
-static void zfcp_qdio_zero_sbals(struct qdio_buffer *sbal[], int first, int cnt)
+void zfcp_qdio_zero_sbals(struct qdio_buffer *sbal[], int first, int cnt)
 {
 	int i, sbal_idx;
 
@@ -233,31 +233,41 @@ zfcp_qdio_sbale_next(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
 }
 
 /**
- * zfcp_qdio_sbals_from_sg - fill SBALs from scatter-gather list
+ * zfcp_qdio_sbals_from_sg - DMA map scatter-gather list and fill SBALs from it
  * @qdio: pointer to struct zfcp_qdio
- * @q_req: pointer to struct zfcp_qdio_req
- * @sg: scatter-gather list
- * Returns: zero or -EINVAL on error
+ * @sgt: pointer to scattergather list table
+ * @req: pointer to zfcp_fsf_req
+ * @dma_dir: DMA direction of I/O
+ * Returns: zero on success, -EINVAL or -EIO otherwise
  */
-int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-			    struct scatterlist *sg)
+int zfcp_qdio_sbals_from_sg(struct zfcp_qdio *qdio, struct sg_table *sgt,
+			    struct zfcp_fsf_req *req,
+			    enum dma_data_direction dma_dir)
 {
 	struct qdio_buffer_element *sbale;
+	int i;
+	struct scatterlist *sg_element;
+
+	if (zfcp_fsf_req_map_sg(req, sgt, dma_dir))
+		return -EIO;
 
 	/* set storage-block type for this request */
-	sbale = zfcp_qdio_sbale_req(qdio, q_req);
-	sbale->sflags |= q_req->sbtype;
+	sbale = zfcp_qdio_sbale_req(qdio, &req->qdio_req);
+	sbale->sflags |= req->qdio_req.sbtype;
 
-	for (; sg; sg = sg_next(sg)) {
-		sbale = zfcp_qdio_sbale_next(qdio, q_req);
+	for_each_sgtable_dma_sg(sgt, sg_element, i) {
+		sbale = zfcp_qdio_sbale_next(qdio, &req->qdio_req);
 		if (!sbale) {
 			atomic_inc(&qdio->req_q_full);
-			zfcp_qdio_zero_sbals(qdio->req_q, q_req->sbal_first,
-					     q_req->sbal_number);
+			zfcp_qdio_zero_sbals(qdio->req_q,
+					     req->qdio_req.sbal_first,
+					     req->qdio_req.sbal_number);
+			zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+					      sgt, dma_dir);
 			return -EINVAL;
 		}
-		sbale->addr = u64_to_dma64(sg_phys(sg));
-		sbale->length = sg->length;
+		sbale->addr = u64_to_dma64(sg_dma_address(sg_element));
+		sbale->length = sg_dma_len(sg_element);
 	}
 	return 0;
 }
diff --git a/drivers/s390/scsi/zfcp_qdio.h b/drivers/s390/scsi/zfcp_qdio.h
index 8f7d2ae94441..9f89f2975f6f 100644
--- a/drivers/s390/scsi/zfcp_qdio.h
+++ b/drivers/s390/scsi/zfcp_qdio.h
@@ -11,6 +11,7 @@
 #define ZFCP_QDIO_H
 
 #include <linux/interrupt.h>
+#include <linux/types.h>
 #include <asm/qdio.h>
 
 #define ZFCP_QDIO_SBALE_LEN	PAGE_SIZE
@@ -106,16 +107,19 @@ zfcp_qdio_sbale_curr(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req)
  * @q_req: the qdio request to start
  * @req_id: The request id
  * @sbtype: type flags to set for all sbals
- * @data: First data block
- * @len: Length of first data block
+ * @has_qtcb: FSF request has a QTCB
+ * @qtcb_len: Length of first data block QTCB, if any
+ * @qtcb_dma_handle: DMA handle of the QTCB, if any
  *
  * This is the start of putting the request into the queue, the last
  * step is passing the request to zfcp_qdio_send. The request queue
  * lock must be held during the whole process from init to send.
  */
 static inline
-void zfcp_qdio_req_init(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-			u64 req_id, u8 sbtype, void *data, u32 len)
+void zfcp_qdio_req_init(struct zfcp_qdio *qdio,
+			struct zfcp_qdio_req *q_req, u64 req_id,
+			u8 sbtype, bool has_qtcb, u32 qtcb_len,
+			dma_addr_t qtcb_dma_handle)
 {
 	struct qdio_buffer_element *sbale;
 	int count = min(atomic_read(&qdio->req_q_free),
@@ -133,33 +137,34 @@ void zfcp_qdio_req_init(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
 	sbale->eflags = 0;
 	sbale->sflags = SBAL_SFLAGS0_COMMAND | sbtype;
 
-	if (unlikely(!data))
+	if (unlikely(!has_qtcb))
 		return;
 	sbale++;
-	sbale->addr = virt_to_dma64(data);
-	sbale->length = len;
+	sbale->addr = u64_to_dma64(qtcb_dma_handle);
+	sbale->length = qtcb_len;
 }
 
 /**
  * zfcp_qdio_fill_next - Fill next sbale, only for single sbal requests
  * @qdio: pointer to struct zfcp_qdio
  * @q_req: pointer to struct zfcp_queue_req
- * @data: pointer to data
+ * @dma_handle: dma address
  * @len: length of data
  *
  * This is only required for single sbal requests, calling it when
  * wrapping around to the next sbal is a bug.
  */
 static inline
-void zfcp_qdio_fill_next(struct zfcp_qdio *qdio, struct zfcp_qdio_req *q_req,
-			 void *data, u32 len)
+void zfcp_qdio_fill_next(struct zfcp_qdio *qdio,
+			 struct zfcp_qdio_req *q_req,
+			 dma_addr_t dma_handle, u32 len)
 {
 	struct qdio_buffer_element *sbale;
 
 	BUG_ON(q_req->sbale_curr == qdio->max_sbale_per_sbal - 1);
 	q_req->sbale_curr++;
 	sbale = zfcp_qdio_sbale_curr(qdio, q_req);
-	sbale->addr = virt_to_dma64(data);
+	sbale->addr = u64_to_dma64(dma_handle);
 	sbale->length = len;
 }
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3590113c2b74..1ca3fc216932 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -184,6 +184,15 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 		zfcp_dbf_scsi_abort("abrt_or", scpnt, NULL);
 		return FAILED; /* completion could be in progress */
 	}
+
+	/*
+	 * Suppress the normal completion handler's unmap by clearing
+	 * req->data now, under the abort_lock write-side.  The actual
+	 * DMA unmap is deferred until the hardware has stopped using
+	 * the buffers (after wait_for_completion or after ERP has
+	 * quiesced the adapter), so that we never call dma_unmap_sgtable
+	 * while the FCP channel may still be writing into the pages.
+	 */
 	old_req->data = NULL;
 
 	/* don't access old fsf_req after releasing the abort_lock */
@@ -198,18 +207,34 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 		zfcp_erp_wait(adapter);
 		ret = fc_block_scsi_eh(scpnt);
 		if (ret) {
+			/*
+			 * fc_block_scsi_eh returned FAST_IO_FAIL: the
+			 * fast_io_fail_tmo fired.  ERP has already called
+			 * zfcp_fsf_req_dismiss_all() (which requires QDIO
+			 * to be down first), so the hardware is no longer
+			 * using the buffers.  Pass FAST_IO_FAIL back to
+			 * scsi_eh, but unmap first.
+			 */
 			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
-			return ret;
+			retval = ret;
+			goto out_unmap;
 		}
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
+			/*
+			 * Adapter is gone; ERP shut down QDIO and dismissed
+			 * all requests before clearing RUNNING.  Safe to
+			 * unmap now.
+			 */
 			zfcp_dbf_scsi_abort("abrt_ru", scpnt, NULL);
-			return SUCCESS;
+			retval = SUCCESS;
+			goto out_unmap;
 		}
 	}
 	if (!abrt_req) {
 		zfcp_dbf_scsi_abort("abrt_ar", scpnt, NULL);
-		return FAILED;
+		retval = FAILED;
+		goto out_unmap;
 	}
 
 	wait_for_completion(&abrt_req->completion);
@@ -224,6 +249,28 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 	}
 	zfcp_dbf_scsi_abort(dbf_tag, scpnt, abrt_req);
 	zfcp_fsf_req_free(abrt_req);
+
+out_unmap:
+	/*
+	 * The hardware has stopped using the SCSI command's DMA buffers:
+	 * either the adapter confirmed the abort, ERP quiesced the adapter
+	 * (zfcp_fsf_req_dismiss_all requires QDIO down), or fc_block_scsi_eh
+	 * signalled link-level quiesce.  Unmap here, directly from scpnt,
+	 * because old_req must not be touched after the abort_lock was
+	 * released.  The normal completion handler (zfcp_fsf_fcp_cmnd_handler)
+	 * skips its own unmap when it sees req->data == NULL, so there is no
+	 * double-unmap.
+	 */
+	if ((scsi_get_prot_op(scpnt) != SCSI_PROT_NORMAL) &&
+	    scsi_prot_sg_count(scpnt))
+		zfcp_fsf_req_unmap_sg(&adapter->ccw_device->dev,
+				      &scpnt->prot_sdb->table,
+				      scpnt->sc_data_direction);
+
+	zfcp_fsf_req_unmap_sg(&adapter->ccw_device->dev,
+			      &scpnt->sdb.table,
+			      scpnt->sc_data_direction);
+
 	return retval;
 }
 
@@ -237,6 +284,7 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_req *old_req, void *data)
 {
 	struct zfcp_scsi_req_filter *filter =
 		(struct zfcp_scsi_req_filter *)data;
+	struct scsi_cmnd *scpnt;
 
 	/* already aborted - prevent side-effects - or not a SCSI command */
 	if (old_req->data == NULL ||
@@ -244,6 +292,8 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_req *old_req, void *data)
 	    old_req->qtcb->header.fsf_command != FSF_QTCB_FCP_CMND)
 		return;
 
+	scpnt = old_req->data;
+
 	/* (tmf_scope == FCP_TMF_TGT_RESET || tmf_scope == FCP_TMF_LUN_RESET) */
 	if (old_req->qtcb->header.port_handle != filter->port_handle)
 		return;
@@ -253,6 +303,17 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_req *old_req, void *data)
 		return;
 
 	zfcp_dbf_scsi_nullcmnd((struct scsi_cmnd *)old_req->data, old_req);
+
+	if ((scsi_get_prot_op(scpnt) != SCSI_PROT_NORMAL) &&
+	    scsi_prot_sg_count(scpnt))
+		zfcp_fsf_req_unmap_sg(&old_req->adapter->ccw_device->dev,
+				      &scpnt->prot_sdb->table,
+				      scpnt->sc_data_direction);
+
+	zfcp_fsf_req_unmap_sg(&old_req->adapter->ccw_device->dev,
+			      &scpnt->sdb.table,
+			      scpnt->sc_data_direction);
+
 	old_req->data = NULL;
 }
 
-- 
2.53.0

