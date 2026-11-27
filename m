Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795806511;
	b=uVL3p3su/BcKK8ySK1pJg0bwftre5vnkQX1/psebu+XvuT5jriRBgTULwa+1TlI4PcOO
	 KluhaV0EBxvGnuRe0Z2CdgFeytBtkG5k4YBKTAIbsYoqTvheS0Hy7jMtB9PCWOlhHeltq
	 CIw2343HDZ8ebV0v+Pvm7TX14IneoZpO7rh1fXZRHNz+PWOaFdvpUnSKCWq1oV4JdTgaa
	 qPyYLqtTyEHfLUZFw79/K27RqFAoPA7PBRfeVrxVthD5a1P00r64lTOgn91iaze9GdZ34
	 LGLmyD/0b4nz0E6dc/Ap7DU6jEtxMJh0NCS767TZFDgituAV09S8y+DiQCvvuva3Uiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795806511;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Spam-Info:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=1rJlobT5bQSnoMMoxs5rfg97z51FP0OOd4piy2Yq/fc=;
	b=l0kpghNjttpyhlycSKS6NsNICXJh/aVq7soaS65u82K8NhazINhp11mNhnYd0ddat35g
	 5ZnZmt4RiKxtutohVVG1PK4lDn21w0Bz+VyRgewedsLk3SwuLtjD4wteUXlV3xcIA6Twj
	 jH1KJHHlQpOAfl/44DU0M3LZHt9Wr2w91lm76LK31SDoevJpxCSAs1tb96gvhI/Ge6mHd
	 CTTFmZHLtFMLZCESDJEte/bS0wQxxw5huCGl5VCyFzejc3VTbm2ydanO9bMwcPvZLVD9L
	 u6JWrcb6wgjEU8/ewPaLTSEg+U5WwRt2LiFK2L62zUW5FgknzMDDIJ2BOIw8XXKZE2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=dgxuJmvV;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E664606A31E;
	Fri, 27 Nov 2026 19:08:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E664606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=dgxuJmvV
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARG4gdv2251714;
	Fri, 27 Nov 2026 19:08:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1rJlobT5bQSnoMMox
	s5rfg97z51FP0OOd4piy2Yq/fc=; b=dgxuJmvVdllcv6rT0psye/pUw2mLXO6W0
	6nLKkaHZYXma/gfAGcJaztT6xdYTMieHKsSBFc8x9aOxr0UjB7SgDgVPw+EY67Nr
	JrUznoxCY403nihLSyLOJjg1y9Nw88hn5kRe7r5vOxNxuVpoBKLX8f42Vv+xOY2M
	pzm5TLAwBdgWpiHk3iEx9AKC+HJmu8kBXGiR0NRYfXUCR5KmW09Rlm7PGxLibsuh
	oC+ZXQvVbmG4IQDpY3DoYsimgbshiTvY6et4FwKX91/6J9Wgmrl81ktOk6WGH7vG
	fG1+61LjcJkRS4DRwi+0Ur3c6HBbhsyigherZerLrER0mCS5nWgyg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34p4x8xw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 19:08:28 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ARFnIjB1295747;
	Fri, 27 Nov 2026 19:08:28 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j6rhcmfs9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Nov 2026 19:08:27 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ARJ8L7u50528724
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Nov 2026 19:08:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 365D720063;
	Fri, 27 Nov 2026 19:08:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 63B0E2004B;
	Fri, 27 Nov 2026 19:08:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.16.103])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Nov 2026 19:08:19 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v15 2/2] zfcp: Use DMA streaming API to map I/O
Date: Sat, 28 Nov 2026 00:37:54 +0530
Message-Id: <20261127190754.6442-3-nikh1092@linux.ibm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261127190754.6442-1-nikh1092@linux.ibm.com>
References: <20261127190754.6442-1-nikh1092@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDA3NiBTYWx0ZWRfXym12lFZQ10zC
 DNQbX+xqKwetFV1RCOYljHA9nCDzOnYkxmjVcHYakTHNXGS5gUzbuxc4Pf7Vr0JspxCoOFfvFkr
 SKzCWKsgCNu9HETsYBPb08U6PedRRE0=
X-Proofpoint-GUID: heoM5Y4LpFxgRU3JMETQgCte214iWJNW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDA3NiBTYWx0ZWRfXzNjgezLi9IxH
 td3UOKxDuU4XIBsYxm28s7kjeXrm8qGlLMJThldEfXK5D93509iJq/une42cr5uF9cuIqSy7Ur6
 NdrkmnQBZtGkxTQzPrY3A/QuNijPZTEtNJ8nTeTYqUYemfA3O51RFgnLHEyHwy3OZGseU9lmvGV
 zxPdk9KOp/6f0g6pdoCCjbMRuYY7PaFqHQEH/tdwAdM7C5m2+SA7vU+4yiVniW52ck2tYvRjjGL
 XJVoY91KaS8av0xPGMLfTmQuQZWTsI+pcnyJnpL7BVA0WoHq1QWX0bda+XyIpYfMktsewJKDDzW
 w/OoKH7hS9rHiPPiEmBtycG3tfFF/KwFza60v8S3Ym/Nm7P7qTwSSsG7l3erhFKLJb9011TqwWK
 0YtEo2L38itVA6z6L+s24m0RjmNlHhs8i9bKzcn0QBgewEu53WL8BTjy1IJDoHxBHD2gI1mCmGg
 IWE9BMpSiriypCwknrA==
X-Proofpoint-ORIG-GUID: heoM5Y4LpFxgRU3JMETQgCte214iWJNW
X-Authority-Analysis: v=2.4 cv=QabzLcbv c=1 sm=1 tr=0 ts=6b09d52d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=pu8HPzglTkPNHs_9H-4A:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_03,2026-11-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611270076

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
v14 -> v15
- Introduce SCSI EH ownership and DMA unmapped status flags, protected by
  abort_lock, to prevent late completions and ERP dismissals from
  accessing recycled SCSI commands or performing duplicate DMA mappings.
- Use sg_nents(sgt->sgl) instead of sgt->nents to correctly determine
  populated scatterlist entries before DMA mapping and unmapping.

v13 -> v14

- Fix NULL pointer dereference in DMA mapping if the scatterlist has
  coalesced segments.
- Also handle dma unmap when scatterlist has coalesced segments.
- DMA sync with device for req->qtcb added inside zfcp_fsf_req_send()
  before sending request. This is added to sync the dma address of
req->qtcb after parameters in qtcb are modified.
- Add zfcp_qdio_zero_sbals() whenever cleanup during the failure of
  subsequent maps to cleanup the stale QDIO entries.
- Use the DMA mapped count for setting data division rather than
  pre-mapped CPU segment count.
- Fix double unmaps, UAF and other DMA mapping leak during the SCSI
  abort scenarios when the hardware is still using DMA mapped buffers.
- Use dma_set_mask instead of dma_set_mask_and_coherent to avoid
  override of DMA mask set in CIO layer for 64 bit.
---
 drivers/s390/scsi/zfcp_aux.c  |  15 ++
 drivers/s390/scsi/zfcp_def.h  |  17 ++
 drivers/s390/scsi/zfcp_ext.h  |  14 +-
 drivers/s390/scsi/zfcp_fc.c   |  10 +
 drivers/s390/scsi/zfcp_fsf.c  | 338 +++++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_qdio.c |  45 +++--
 drivers/s390/scsi/zfcp_qdio.h |  27 +--
 drivers/s390/scsi/zfcp_scsi.c | 146 +++++++++++++--
 8 files changed, 523 insertions(+), 89 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index fea573e00f9d..eb1f34133df4 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -329,6 +329,18 @@ static void zfcp_destroy_adapter_work_queue(struct zfcp_adapter *adapter)
 
 }
 
+static int zfcp_set_dma_mask_for_adapter(struct zfcp_adapter *adapter)
+{
+	int ret;
+
+	ret = dma_set_mask(&adapter->ccw_device->dev, DMA_BIT_MASK(64));
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
@@ -404,6 +416,9 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
 
+	if (zfcp_set_dma_mask_for_adapter(adapter))
+		goto failed;
+
 	if (zfcp_erp_thread_setup(adapter))
 		goto failed;
 
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 6c761299a22f..f74784c113c3 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -84,6 +84,19 @@
 #define ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED	0x00000040
 #define ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED       0x00000080
 #define ZFCP_STATUS_FSFREQ_TMFUNCFAILED         0x00000200
+/*
+ * The SCSI command in req->data is owned by scsi_eh (set by the abort
+ * handler, never cleared): completion and dismissal may only unmap it, if
+ * not yet ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED, and must not touch it otherwise.
+ */
+#define ZFCP_STATUS_FSFREQ_SCSI_EH_OWNED	0x00000400
+/*
+ * The DMA mappings of the SCSI command in req->data are already unmapped
+ * (by the abort handler or zfcp_scsi_forget_cmnd()) and scsi_eh may have
+ * finished the command: never unmap again and never touch the command.
+ * Both SCSI flags are only changed under adapter->abort_lock (write).
+ */
+#define ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED	0x00000800
 #define ZFCP_STATUS_FSFREQ_DISMISSED            0x00001000
 #define ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE	0x00020000
 
@@ -322,6 +335,8 @@ static inline u64 zfcp_scsi_dev_lun(struct scsi_device *sdev)
  * @pool: reference to memory pool if used for this request
  * @issued: time when request was send (STCK)
  * @handler: handler which should be called to process response
+ * @metadata_sgt: sg_table for metadata of a QTCB or SRB request
+ * @metadata_sg: scatterlist for metadata of a QTCB or SRB request
  */
 struct zfcp_fsf_req {
 	struct list_head	list;
@@ -337,6 +352,8 @@ struct zfcp_fsf_req {
 	mempool_t		*pool;
 	unsigned long long	issued;
 	void			(*handler)(struct zfcp_fsf_req *);
+	struct sg_table		metadata_sgt;
+	struct scatterlist	metadata_sg;
 };
 
 static inline
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 0eb9bc9d03e4..226539e5c706 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -141,6 +141,7 @@ extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
 extern void zfcp_fsf_fc_host_link_down(struct zfcp_adapter *adapter);
 extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *sdev,
 						   u8 tm_flags);
+void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_reqid_check(struct zfcp_qdio *, int);
 enum zfcp_fsf_print_fmt {
@@ -150,6 +151,11 @@ enum zfcp_fsf_print_fmt {
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
@@ -157,13 +163,15 @@ extern void zfcp_qdio_destroy(struct zfcp_qdio *);
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
@@ -177,6 +185,8 @@ extern void zfcp_scsi_schedule_rport_block(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
 extern void zfcp_scsi_set_prot(struct zfcp_adapter *);
 extern void zfcp_scsi_dif_sense_error(struct scsi_cmnd *, int);
+void zfcp_scsi_unmap_cmnd(struct zfcp_adapter *adapter,
+			  struct scsi_cmnd *scpnt);
 extern void zfcp_scsi_shost_update_config_data(
 	struct zfcp_adapter *const adapter,
 	const struct fsf_qtcb_bottom_config *const bottom,
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 1fb6f2c3b607..2512abd85f98 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -1104,6 +1104,16 @@ int zfcp_fc_exec_bsg_job(struct bsg_job *job)
 	ct_els->sgt_resp.sgl = job->reply_payload.sg_list;
 	ct_els->sgt_req.orig_nents = sg_nents(ct_els->sgt_req.sgl);
 	ct_els->sgt_resp.orig_nents = sg_nents(ct_els->sgt_resp.sgl);
+	/*
+	 * dd_data lives past the memset(job, 0, sizeof(*job)) boundary in
+	 * bsg_transport_sg_io_fn() and is never zeroed by blk-mq on request
+	 * reuse.  A prior BSG command will have left sgt->nents set to the
+	 * mapped entry count from dma_map_sgtable().  Reset nents so that
+	 * no stale value from that command is seen before this one is mapped
+	 * (zfcp_fsf_req_unmap_sg() skips tables with nents == 0).
+	 */
+	ct_els->sgt_req.nents = 0;
+	ct_els->sgt_resp.nents = 0;
 	ct_els->handler_data = job;
 
 	switch (bsg_request->msgcode) {
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index a3b99839da9e..b3bc848beb9a 100644
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
@@ -84,6 +85,93 @@ static void zfcp_fsf_class_not_supp(struct zfcp_fsf_req *req)
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
+/**
+ * zfcp_fsf_req_map_sg - map the scattergather list for DMA transfer
+ * @req: pointer to zfcp_fsf_req
+ * @sgt: pointer to scattergather list table
+ * @dma_dir: DMA data direction
+ * Returns: 0 on success, -EIO for an invalid DMA direction, or the error
+ *	    returned by dma_map_sgtable() otherwise
+ */
+int zfcp_fsf_req_map_sg(struct zfcp_fsf_req *req, struct sg_table *sgt,
+			enum dma_data_direction dma_dir)
+{
+	unsigned int saved_orig_nents;
+	int populated;
+	int ret;
+
+	if (!valid_dma_direction(dma_dir))
+		return sgt->orig_nents ? -EIO : 0;
+
+	if (!sgt->orig_nents)
+		return 0;
+
+	/*
+	 * The SCSI midlayer sets orig_nents to the allocated SG capacity,
+	 * which can be larger than the number of populated entries (the
+	 * list is terminated by the end marker).  dma_map_sgtable() and
+	 * dma_unmap_sgtable() both iterate up to orig_nents, so clamp it to
+	 * the populated count found by walking the list; otherwise they
+	 * would run past the end marker.  Do not use sgt->nents for this:
+	 * after mapping it holds the DMA-mapped count, which may differ.
+	 */
+	saved_orig_nents = sgt->orig_nents;
+	populated = sg_nents(sgt->sgl);
+	if (populated > 0 && populated < sgt->orig_nents)
+		sgt->orig_nents = populated;
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
+	int populated;
+
+	/*
+	 * We still need the check for mapped sg count here to not perform
+	 * unmap for SCSI commands which have zero payload.
+	 */
+	if (!sgt->nents)
+		return;
+
+	saved_orig_nents = sgt->orig_nents;
+	populated = sg_nents(sgt->sgl);
+	if (populated > 0 && populated < sgt->orig_nents)
+		sgt->orig_nents = populated;
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
@@ -259,6 +347,8 @@ static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
 	struct zfcp_adapter *adapter = req->adapter;
 	struct fsf_status_read_buffer *sr_buf = req->data;
 
+	zfcp_fsf_req_unmap_metadata(req);
+
 	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		zfcp_dbf_hba_fsf_uss("fssrh_1", req);
 		mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
@@ -457,6 +547,7 @@ static void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
 		return;
 	}
 
+	zfcp_fsf_req_unmap_metadata(req);
 	timer_delete_sync(&req->timer);
 	zfcp_fsf_protstatus_eval(req);
 	zfcp_fsf_fsfstatus_eval(req);
@@ -870,10 +961,27 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
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
@@ -885,6 +993,15 @@ static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
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
@@ -954,7 +1071,17 @@ int zfcp_fsf_status_read(struct zfcp_qdio *qdio)
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
@@ -965,10 +1092,14 @@ int zfcp_fsf_status_read(struct zfcp_qdio *qdio)
 	goto out;
 
 failed_req_send:
+	zfcp_fsf_req_unmap_metadata(req);
+failed_dma_map:
 	req->data = NULL;
 	mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
 failed_buf:
 	zfcp_dbf_hba_fsf_uss("fssr__1", req);
+	zfcp_qdio_zero_sbals(qdio->req_q, req->qdio_req.sbal_first,
+			     req->qdio_req.sbal_number);
 	zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
@@ -1076,6 +1207,9 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *scmnd)
 	}
 
 out_error_free:
+	zfcp_qdio_zero_sbals(qdio->req_q, req->qdio_req.sbal_first,
+			     req->qdio_req.sbal_number);
+	zfcp_fsf_req_unmap_metadata(req);
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
@@ -1091,6 +1225,11 @@ static void zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *req)
 
 	ct->status = -EINVAL;
 
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &ct->sgt_req, DMA_TO_DEVICE);
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &ct->sgt_resp, DMA_FROM_DEVICE);
+
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
 
@@ -1130,19 +1269,42 @@ static void zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *req)
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
@@ -1150,57 +1312,73 @@ static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
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
 
@@ -1242,8 +1420,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els(req, ct->sgt_req.sgl, ct->sgt_resp.sgl,
-				    timeout);
+	ret = zfcp_fsf_setup_ct_els(req, &ct->sgt_req, &ct->sgt_resp, timeout);
 	if (ret)
 		goto failed_send;
 
@@ -1256,12 +1433,21 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
 
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
@@ -1275,6 +1461,11 @@ static void zfcp_fsf_send_els_handler(struct zfcp_fsf_req *req)
 
 	send_els->status = -EINVAL;
 
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &send_els->sgt_req, DMA_TO_DEVICE);
+	zfcp_fsf_req_unmap_sg(&req->adapter->ccw_device->dev,
+			      &send_els->sgt_resp, DMA_FROM_DEVICE);
+
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
 
@@ -1343,9 +1534,8 @@ int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
 	if (!zfcp_adapter_multi_buffer_active(adapter))
 		zfcp_qdio_sbal_limit(qdio, &req->qdio_req, 2);
 
-	ret = zfcp_fsf_setup_ct_els(req, els->sgt_req.sgl, els->sgt_resp.sgl,
+	ret = zfcp_fsf_setup_ct_els(req, &els->sgt_req, &els->sgt_resp,
 				    timeout);
-
 	if (ret)
 		goto failed_send;
 
@@ -1358,12 +1548,21 @@ int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
 
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
@@ -1404,6 +1603,7 @@ int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -1469,6 +1669,8 @@ int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *qdio,
 			retval = -EIO;
 		else if (req->status & ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE)
 			retval = -EAGAIN;
+	} else {
+		zfcp_fsf_req_unmap_metadata(req);
 	}
 
 	zfcp_fsf_req_free(req);
@@ -1516,6 +1718,7 @@ int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -1578,6 +1781,8 @@ int zfcp_fsf_exchange_port_data_sync(struct zfcp_qdio *qdio,
 			retval = -EIO;
 		else if (req->status & ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE)
 			retval = -EAGAIN;
+	} else {
+		zfcp_fsf_req_unmap_metadata(req);
 	}
 
 	zfcp_fsf_req_free(req);
@@ -1810,6 +2015,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 		put_device(&port->dev);
@@ -1876,6 +2082,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -1950,8 +2157,10 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 
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
@@ -2009,8 +2218,10 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 
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
@@ -2103,6 +2314,7 @@ int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -2227,6 +2439,7 @@ int zfcp_fsf_open_lun(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -2316,6 +2529,7 @@ int zfcp_fsf_close_lun(struct zfcp_erp_action *erp_action)
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
+		zfcp_fsf_req_unmap_metadata(req);
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
 	}
@@ -2469,11 +2683,22 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 	read_lock_irqsave(&req->adapter->abort_lock, flags);
 
 	scpnt = req->data;
-	if (unlikely(!scpnt)) {
+	if (unlikely(req->status & (ZFCP_STATUS_FSFREQ_SCSI_EH_OWNED |
+				    ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED))) {
+		/*
+		 * scsi_eh owns the command, so never touch it beyond the
+		 * unmap.  The request is off the request list, so the
+		 * hardware is done with the buffers and nobody else can
+		 * unmap them anymore, unless they are already unmapped.
+		 */
+		if (!(req->status & ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED))
+			zfcp_scsi_unmap_cmnd(req->adapter, scpnt);
 		read_unlock_irqrestore(&req->adapter->abort_lock, flags);
 		return;
 	}
 
+	zfcp_scsi_unmap_cmnd(req->adapter, scpnt);
+
 	zfcp_fsf_fcp_handler_common(req, scpnt->device);
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
@@ -2617,20 +2842,22 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
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
@@ -2638,12 +2865,26 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
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
@@ -2651,7 +2892,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 	return retval;
 }
 
-static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
+void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
 {
 	struct scsi_device *sdev = req->data;
 	struct fcp_resp_with_ext *fcp_rsp;
@@ -2719,6 +2960,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *sdev,
 		goto out;
 	}
 
+	zfcp_fsf_req_unmap_metadata(req);
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index bac8385e069f..9ac63a8154f1 100644
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
@@ -398,8 +408,9 @@ void zfcp_qdio_close(struct zfcp_qdio *qdio)
 		return;
 
 	/*
-	 * Clear QDIOUP flag, thus qdio_add_bufs_to_output_queue() is not called
-	 * during qdio_shutdown().
+	 * Clear QDIOUP flag under req_q_lock first, thus preventing any new
+	 * requests from calling qdio_add_bufs_to_output_queue() during
+	 * qdio_shutdown().
 	 */
 	spin_lock_irq(&qdio->req_q_lock);
 	atomic_andnot(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
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
index 3590113c2b74..64e909d3ebd9 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -163,6 +163,59 @@ static int zfcp_scsi_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+/**
+ * zfcp_scsi_unmap_cmnd() - Unmap the DMA mappings of a SCSI command.
+ * @adapter: Adapter whose device the command was mapped for.
+ * @scpnt: SCSI command whose data and protection SG tables are unmapped.
+ *
+ * Caller must guarantee that the hardware no longer uses the buffers and
+ * that nobody else unmaps the same command, otherwise the SG tables would
+ * be unmapped twice.
+ */
+void zfcp_scsi_unmap_cmnd(struct zfcp_adapter *adapter,
+			  struct scsi_cmnd *scpnt)
+{
+	if ((scsi_get_prot_op(scpnt) != SCSI_PROT_NORMAL) &&
+	    scsi_prot_sg_count(scpnt))
+		zfcp_fsf_req_unmap_sg(&adapter->ccw_device->dev,
+				      &scpnt->prot_sdb->table,
+				      scpnt->sc_data_direction);
+
+	zfcp_fsf_req_unmap_sg(&adapter->ccw_device->dev,
+			      &scpnt->sdb.table,
+			      scpnt->sc_data_direction);
+}
+
+/**
+ * zfcp_scsi_abort_unmap() - Unmap a command from the abort handler.
+ * @adapter: Adapter the aborted command was sent on.
+ * @scpnt: The command whose hardware use is known to be over.
+ * @old_reqid: Request ID of the original FCP command, taken at handler entry.
+ *
+ * Under abort_lock, unmap @scpnt and mark old_req
+ * ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED, so that its completion, its dismissal
+ * by ERP and zfcp_scsi_forget_cmnds() skip @scpnt.  If old_req is no longer
+ * on the request list, it was completed by the hardware or dismissed by ERP.
+ * Because ZFCP_STATUS_FSFREQ_SCSI_EH_OWNED was set at handler entry, that
+ * path has unmapped @scpnt (or is about to) without touching anything else,
+ * so there is nothing left to do here.
+ */
+static void zfcp_scsi_abort_unmap(struct zfcp_adapter *adapter,
+				  struct scsi_cmnd *scpnt, u64 old_reqid)
+{
+	struct zfcp_fsf_req *old_req;
+	unsigned long flags;
+
+	write_lock_irqsave(&adapter->abort_lock, flags);
+	old_req = zfcp_reqlist_find(adapter->req_list, old_reqid);
+	if (old_req &&
+	    !(old_req->status & ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED)) {
+		zfcp_scsi_unmap_cmnd(adapter, scpnt);
+		old_req->status |= ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED;
+	}
+	write_unlock_irqrestore(&adapter->abort_lock, flags);
+}
+
 static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 {
 	struct Scsi_Host *scsi_host = scpnt->device->host;
@@ -179,12 +232,28 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 	write_lock_irqsave(&adapter->abort_lock, flags);
 
 	old_req = zfcp_reqlist_find(adapter->req_list, old_reqid);
-	if (!old_req) {
+	if (!old_req ||
+	    (old_req->status & (ZFCP_STATUS_FSFREQ_SCSI_EH_OWNED |
+				ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED))) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
 		zfcp_dbf_scsi_abort("abrt_or", scpnt, NULL);
 		return FAILED; /* completion could be in progress */
 	}
-	old_req->data = NULL;
+
+	/*
+	 * Hand scpnt over to scsi_eh: the SCSI_EH_OWNED flag makes the
+	 * completion handler stop at the DMA unmap and never touch scpnt
+	 * otherwise.  The unmap is deferred until the hardware has stopped
+	 * using the buffers, so that dma_unmap_sgtable() is never called
+	 * while the FCP channel may still be writing into the pages.
+	 *
+	 * The flag stays set on all return paths, as scsi_eh may finish or
+	 * requeue scpnt at any time later, including after device, target or
+	 * host reset.  Whoever sees the hardware done with the buffers first
+	 * unmaps exactly once: this handler (zfcp_scsi_abort_unmap()),
+	 * zfcp_scsi_forget_cmnds() or the completion/dismissal of old_req.
+	 */
+	old_req->status |= ZFCP_STATUS_FSFREQ_SCSI_EH_OWNED;
 
 	/* don't access old fsf_req after releasing the abort_lock */
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
@@ -198,16 +267,34 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 		zfcp_erp_wait(adapter);
 		ret = fc_block_scsi_eh(scpnt);
 		if (ret) {
+			/*
+			 * fast_io_fail_tmo fired.  This may come from a
+			 * per-port reopen that closes the port without
+			 * shutting QDIO down or dismissing requests, so the
+			 * hardware may still use the buffers.  Only unmap if
+			 * QDIO is down; otherwise escalate and leave the
+			 * unmap to a later completion, dismissal or reset.
+			 */
 			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
-			return ret;
+			if (atomic_read(&adapter->status) &
+			    ZFCP_STATUS_ADAPTER_QDIOUP)
+				return FAILED;
+			retval = ret; /* FAST_IO_FAIL, QDIO is down */
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
+			goto out_unmap;
 		}
 	}
 	if (!abrt_req) {
+		/* the hardware may still run the I/O: do not unmap yet */
 		zfcp_dbf_scsi_abort("abrt_ar", scpnt, NULL);
 		return FAILED;
 	}
@@ -219,11 +306,25 @@ static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 	else if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED)
 		dbf_tag = "abrt_nn";
 	else {
-		dbf_tag = "abrt_fa";
-		retval = FAILED;
+		/*
+		 * The abort request failed or was dismissed by ERP; it is
+		 * unknown whether the hardware stopped the original I/O.
+		 */
+		zfcp_dbf_scsi_abort("abrt_fa", scpnt, abrt_req);
+		zfcp_fsf_req_free(abrt_req);
+		return FAILED;
 	}
 	zfcp_dbf_scsi_abort(dbf_tag, scpnt, abrt_req);
 	zfcp_fsf_req_free(abrt_req);
+
+out_unmap:
+	/*
+	 * The hardware is known to no longer use scpnt's buffers: abrt_ok and
+	 * abrt_nn (the adapter confirmed the abort), abrt_ru (QDIO shut down,
+	 * requests dismissed) and abrt_bl with QDIO down.
+	 */
+	zfcp_scsi_abort_unmap(adapter, scpnt, old_reqid);
+
 	return retval;
 }
 
@@ -237,11 +338,17 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_req *old_req, void *data)
 {
 	struct zfcp_scsi_req_filter *filter =
 		(struct zfcp_scsi_req_filter *)data;
+	struct scsi_cmnd *scpnt;
 
-	/* already aborted - prevent side-effects - or not a SCSI command */
-	if (old_req->data == NULL ||
+	/*
+	 * Already unmapped - prevent side-effects - or not a SCSI I/O command.
+	 * Commands owned by scsi_eh (SCSI_EH_OWNED) are still unmapped here,
+	 * as the hardware is done with them after a successful reset.
+	 */
+	if (old_req->status & ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED ||
 	    zfcp_fsf_req_is_status_read_buffer(old_req) ||
-	    old_req->qtcb->header.fsf_command != FSF_QTCB_FCP_CMND)
+	    old_req->qtcb->header.fsf_command != FSF_QTCB_FCP_CMND ||
+	    old_req->handler == zfcp_fsf_fcp_task_mgmt_handler)
 		return;
 
 	/* (tmf_scope == FCP_TMF_TGT_RESET || tmf_scope == FCP_TMF_LUN_RESET) */
@@ -252,8 +359,10 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_req *old_req, void *data)
 	    old_req->qtcb->header.lun_handle != filter->lun_handle)
 		return;
 
-	zfcp_dbf_scsi_nullcmnd((struct scsi_cmnd *)old_req->data, old_req);
-	old_req->data = NULL;
+	scpnt = old_req->data;
+	zfcp_dbf_scsi_nullcmnd(scpnt, old_req);
+	zfcp_scsi_unmap_cmnd(old_req->adapter, scpnt);
+	old_req->status |= ZFCP_STATUS_FSFREQ_SCSI_UNMAPPED;
 }
 
 static void zfcp_scsi_forget_cmnds(struct zfcp_scsi_dev *zsdev, u8 tm_flags)
@@ -305,6 +414,21 @@ static int zfcp_scsi_task_mgmt_function(struct scsi_device *sdev, u8 tm_flags)
 		ret = fc_block_rport(rport);
 		if (ret) {
 			zfcp_dbf_scsi_devreset("fiof", sdev, tm_flags, NULL);
+			/*
+			 * QDIO still up: the FCP channel may still be using
+			 * the buffers of outstanding commands.  Do not let
+			 * scsi_eh finish them; escalate to host reset instead.
+			 */
+			if (atomic_read(&adapter->status) &
+			    ZFCP_STATUS_ADAPTER_QDIOUP)
+				return FAILED;
+			/*
+			 * QDIO down: the hardware is done with the buffers.
+			 * Detach and unmap the commands so that a later
+			 * completion or dismissal of their requests cannot
+			 * touch a finished scpnt.
+			 */
+			zfcp_scsi_forget_cmnds(zfcp_sdev, tm_flags);
 			return ret;
 		}
 
-- 
2.39.5 (Apple Git-154)

