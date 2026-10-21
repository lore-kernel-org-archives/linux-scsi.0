Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571706;
	b=YF2eDqYCVIv3aZAgX4JUKwnjiqSVfRqK2cVy5XIjVC4DZGZM0KR559MkDWd3BEhn3kQR
	 1cPjpMz9PQHNFI8l1lzT/+YLxxJCFuzgZtyJICqY4lTdDeGn+ccIwpW2wzQ4XnkHKZZVK
	 azldzoNGDgHwSxE14FLPhuGtNMKgONHpjTfjXuHPzzCkb1yRrTDF3jlIEattWBZK+pDsJ
	 UcWmgfFYCX6NZTZmmKXdbEufE26EChtAQaNxRspp6UAipRzDPxeTl61cmr+3fafxCSBrN
	 ocRCI3j5jT1bDocnazkMXGoYxFzSMn1BUmR7DqBmufxNl51f5EYAvx9/5V7ZJ4cT2CA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571706;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=AJ5ANGdJVaZH+wUzAzhVB5ljNnp6sprJ0+FTwXBhctY=;
	b=t67FXjWiNKi/hj/808JbMdmmbbR//4VFiEkoGNCrur2ACaQwBkwLkykkOXO+KC8iYtge
	 +vk77foNKKNEGfPsb6+KRbjiGQHAbgLjK2EgiSNyPZHiZvftgaQDfNOMMirjFlv5q+15k
	 pYr61ynvcP12ZmudiYTnW9SeN/2gvSguKx1uabdXKz8wHBrx63VNpywI2XCfuciKjMXnd
	 Ewsfg2I1VzHhCt/ilpKG1ECGuF/7EZax7FBlyBVPuIIGegslucLIrXt+tNSrwS8wxdOCt
	 irUlRrW9dsOH39UJ/nEj+xCLHzXv57BZd2G+W7Fv/FxZhw+httnvjPuERo0ZeSgONQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=DEccahNE;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91397606A31C;
	Wed, 21 Oct 2026 08:35:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91397606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=DEccahNE
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5iw6C2857618;
	Wed, 21 Oct 2026 08:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AJ5ANGdJVaZH+wUzA
	zhVB5ljNnp6sprJ0+FTwXBhctY=; b=DEccahNEkSSJ05oGczyvF9Xvzu8telzFl
	/cJldtzEzCDqojrYc3ugn0TKJLtjd0JRLtO/VLl7Fe7GCAbqzqbxOkzvlMyGZfhB
	7S7fhurnAkC+QvNtV1E/FEOmBf7jbAXdWJbk+ZvdlZVKbtXsukDNfN/G74RtTVkC
	VSkBl6wnU0P7xZJvinaXq5eMXRDVaWhpmpuE5nDieXM4UiKFIHuyM2f5Om2kNq4c
	x7gAgrFJnvX2/WxDcUW/p09QhCB8EIqlckQAfRgpDvSVaxwOd9QGM6NLhDyrbb3X
	aDEAW+SKirIM7SQI43eXr32KxwTuNSIrDwGg3tywBrD3D1T/8sWJQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hdw5bfuqg-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 08:35:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5o27p2599171;
	Wed, 21 Oct 2026 08:35:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4he7bs49j8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Oct 2026 08:35:03 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69L8YvA546006648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Oct 2026 08:34:57 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 326012004D;
	Wed, 21 Oct 2026 08:34:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0D71C20043;
	Wed, 21 Oct 2026 08:34:57 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 21 Oct 2026 08:34:56 +0000 (GMT)
From: M Nikhil <nikh1092@linux.ibm.com>
To: sashiko-reviews@lists.linux.dev, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc: niharp@linux.ibm.com, pasic@linux.ibm.com, bblock@linux.ibm.com
Subject: [PATCH v13 1/2] zfcp: Replace sg-list with sg_table in zfcp_fsf_ct_els structure
Date: Wed, 21 Oct 2026 10:33:50 +0200
Message-ID: <20261021083351.1626409-2-nikh1092@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021083351.1626409-1-nikh1092@linux.ibm.com>
References: <20261021083351.1626409-1-nikh1092@linux.ibm.com>
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
X-Proofpoint-GUID: 0HvF_gWaNYHNsPQBwPcijG0TF5XWafdO
X-Proofpoint-ORIG-GUID: 0HvF_gWaNYHNsPQBwPcijG0TF5XWafdO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzMiBTYWx0ZWRfXzWP4KUu2FuO7
 bXZmCykaH1ry20Ngw72o9FkJDlHfZCHGB0pHOkZWiMtcKGJZJiFiXSEv4z9zbcXWlmvhr68SOjK
 2H62CeEjTboxz9tRSCg58SeL4NMiqxc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzMiBTYWx0ZWRfX257wOFVGVKVl
 D6tms14efNfHoDD3An50sLnNnexGbpMrHB+AV2u1OmtBtwaKufcKIDR19Qi/aIZlmENHA1OL/k2
 3L6CHJI2SRqr68grH+STdf/vaBs3u1+elCXgX+rdKtyf6uKkUQ+vCSeDtnBmMzu3Qse58jkGw4z
 KRcd75MaWMRfbuxQirF2d6hAO7ZFD/75XcER/zQB095nrqPEhafz6QHnhKeNLwzo9NyVykbUg/j
 TU5C89iHkw2GEA6f/K+52dShlj7ChnrooGlD3p4g6MYhFvK1kqX7/qp0eNC5XbA8m+QKYt9obXW
 v48ItFsg8fF5nNYyxCX1nMv+krxZnNLp+sjs98mAJOnxp47E8KFMyRXBOL6tG4gMD7ToGVdYpa9
 /nOeU1YrpAkTsrvduXoZdIRp6uAjGBjcgVIwhTZvXpbgihhWdYWout1z/QQKQIKAAHcegIVvrts
 ULe22pnvEoUOMcbe6SQ==
X-Authority-Analysis: v=2.4 cv=Gb2CDgXL c=1 sm=1 tr=0 ts=6ad87938 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=SPISVwao-ayoBmANS60A:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 malwarescore=0 spamscore=0 phishscore=0
 clxscore=1011 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210032

The zfcp_fsf_ct_els data structure is updated to replace the sg_req and
sg_resp members, which are of type struct scatterlist, with request and
response sg_table instances.

These sg_table structure reference the corresponding scatterlists
(sg_req and sg_resp) maintained in struct zfcp_fc_req.

These changes allows to track the original and mapped scatterlist nents
once zfcp is converted to use DMA-API for mapping the sg lists.

Signed-off-by: M Nikhil <nikh1092@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Nihar Panda <niharp@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 16 ++++++++--------
 drivers/s390/scsi/zfcp_fc.c  | 36 ++++++++++++++++++++++++------------
 drivers/s390/scsi/zfcp_fsf.c |  6 ++++--
 drivers/s390/scsi/zfcp_fsf.h |  9 +++++----
 4 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 81fb8af408e9..f7e737e076bf 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -617,9 +617,9 @@ void zfcp_dbf_san_req(char *tag, struct zfcp_fsf_req *fsf, u32 d_id)
 	if (unlikely(!debug_level_enabled(dbf->san, ZFCP_DBF_SAN_LEVEL)))
 		return;
 
-	length = (u16)zfcp_qdio_real_bytes(ct_els->req);
-	zfcp_dbf_san(tag, dbf, "san_req", ct_els->req, ZFCP_DBF_SAN_REQ,
-		     length, fsf->req_id, d_id, length);
+	length = (u16)zfcp_qdio_real_bytes(ct_els->sgt_req.sgl);
+	zfcp_dbf_san(tag, dbf, "san_req", ct_els->sgt_req.sgl,
+		     ZFCP_DBF_SAN_REQ, length, fsf->req_id, d_id, length);
 }
 
 static u16 zfcp_dbf_san_res_cap_len_if_gpn_ft(char *tag,
@@ -627,9 +627,9 @@ static u16 zfcp_dbf_san_res_cap_len_if_gpn_ft(char *tag,
 					      u16 len)
 {
 	struct zfcp_fsf_ct_els *ct_els = fsf->data;
-	struct fc_ct_hdr *reqh = sg_virt(ct_els->req);
+	struct fc_ct_hdr *reqh = sg_virt(ct_els->sgt_req.sgl);
 	struct fc_ns_gid_ft *reqn = (struct fc_ns_gid_ft *)(reqh + 1);
-	struct scatterlist *resp_entry = ct_els->resp;
+	struct scatterlist *resp_entry = ct_els->sgt_resp.sgl;
 	struct fc_ct_hdr *resph;
 	struct fc_gpn_ft_resp *acc;
 	int max_entries, x, last = 0;
@@ -698,9 +698,9 @@ void zfcp_dbf_san_res(char *tag, struct zfcp_fsf_req *fsf)
 	if (unlikely(!debug_level_enabled(dbf->san, ZFCP_DBF_SAN_LEVEL)))
 		return;
 
-	length = (u16)zfcp_qdio_real_bytes(ct_els->resp);
-	zfcp_dbf_san(tag, dbf, "san_res", ct_els->resp, ZFCP_DBF_SAN_RES,
-		     length, fsf->req_id, ct_els->d_id,
+	length = (u16)zfcp_qdio_real_bytes(ct_els->sgt_resp.sgl);
+	zfcp_dbf_san(tag, dbf, "san_res", ct_els->sgt_resp.sgl,
+		     ZFCP_DBF_SAN_RES, length, fsf->req_id, ct_els->d_id,
 		     zfcp_dbf_san_res_cap_len_if_gpn_ft(tag, fsf, length));
 }
 
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index 05d081297879..1fb6f2c3b607 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -393,10 +393,12 @@ static int zfcp_fc_ns_gid_pn_request(struct zfcp_port *port,
 	fc_req->ct_els.port = port;
 	fc_req->ct_els.handler = zfcp_fc_complete;
 	fc_req->ct_els.handler_data = &completion;
-	fc_req->ct_els.req = &fc_req->sg_req;
-	fc_req->ct_els.resp = &fc_req->sg_rsp;
+	fc_req->ct_els.sgt_req.sgl = &fc_req->sg_req;
+	fc_req->ct_els.sgt_resp.sgl = &fc_req->sg_rsp;
 	sg_init_one(&fc_req->sg_req, gid_pn_req, sizeof(*gid_pn_req));
 	sg_init_one(&fc_req->sg_rsp, gid_pn_rsp, sizeof(*gid_pn_rsp));
+	fc_req->ct_els.sgt_req.orig_nents = sg_nents(&fc_req->sg_req);
+	fc_req->ct_els.sgt_resp.orig_nents = sg_nents(&fc_req->sg_rsp);
 
 	zfcp_fc_ct_ns_init(&gid_pn_req->ct_hdr,
 			   FC_NS_GID_PN, ZFCP_FC_CT_SIZE_PAGE);
@@ -558,12 +560,14 @@ static int zfcp_fc_adisc(struct zfcp_port *port)
 		return -ENOMEM;
 
 	fc_req->ct_els.port = port;
-	fc_req->ct_els.req = &fc_req->sg_req;
-	fc_req->ct_els.resp = &fc_req->sg_rsp;
+	fc_req->ct_els.sgt_req.sgl = &fc_req->sg_req;
+	fc_req->ct_els.sgt_resp.sgl = &fc_req->sg_rsp;
 	sg_init_one(&fc_req->sg_req, &fc_req->u.adisc.req,
 		    sizeof(struct fc_els_adisc));
 	sg_init_one(&fc_req->sg_rsp, &fc_req->u.adisc.rsp,
 		    sizeof(struct fc_els_adisc));
+	fc_req->ct_els.sgt_req.orig_nents = sg_nents(&fc_req->sg_req);
+	fc_req->ct_els.sgt_resp.orig_nents = sg_nents(&fc_req->sg_rsp);
 
 	fc_req->ct_els.handler = zfcp_fc_adisc_handler;
 	fc_req->ct_els.handler_data = fc_req;
@@ -706,8 +710,10 @@ static int zfcp_fc_send_gpn_ft(struct zfcp_fc_req *fc_req,
 
 	ct_els->handler = zfcp_fc_complete;
 	ct_els->handler_data = &completion;
-	ct_els->req = &fc_req->sg_req;
-	ct_els->resp = &fc_req->sg_rsp;
+	ct_els->sgt_req.sgl = &fc_req->sg_req;
+	ct_els->sgt_resp.sgl = &fc_req->sg_rsp;
+	ct_els->sgt_req.orig_nents = sg_nents(&fc_req->sg_req);
+	ct_els->sgt_resp.orig_nents = sg_nents(&fc_req->sg_rsp);
 
 	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct_els, NULL,
 			       ZFCP_FC_CTELS_TMO);
@@ -865,8 +871,10 @@ static int zfcp_fc_gspn(struct zfcp_adapter *adapter,
 
 	ct_els->handler = zfcp_fc_complete;
 	ct_els->handler_data = &completion;
-	ct_els->req = &fc_req->sg_req;
-	ct_els->resp = &fc_req->sg_rsp;
+	ct_els->sgt_req.sgl = &fc_req->sg_req;
+	ct_els->sgt_resp.sgl = &fc_req->sg_rsp;
+	ct_els->sgt_req.orig_nents = sg_nents(&fc_req->sg_req);
+	ct_els->sgt_resp.orig_nents = sg_nents(&fc_req->sg_rsp);
 
 	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct_els, NULL,
 			       ZFCP_FC_CTELS_TMO);
@@ -924,8 +932,10 @@ static void zfcp_fc_rspn(struct zfcp_adapter *adapter,
 
 	ct_els->handler = zfcp_fc_complete;
 	ct_els->handler_data = &completion;
-	ct_els->req = &fc_req->sg_req;
-	ct_els->resp = &fc_req->sg_rsp;
+	ct_els->sgt_req.sgl = &fc_req->sg_req;
+	ct_els->sgt_resp.sgl = &fc_req->sg_rsp;
+	ct_els->sgt_req.orig_nents = sg_nents(&fc_req->sg_req);
+	ct_els->sgt_resp.orig_nents = sg_nents(&fc_req->sg_rsp);
 
 	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct_els, NULL,
 			       ZFCP_FC_CTELS_TMO);
@@ -1090,8 +1100,10 @@ int zfcp_fc_exec_bsg_job(struct bsg_job *job)
 	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
 		return -EINVAL;
 
-	ct_els->req = job->request_payload.sg_list;
-	ct_els->resp = job->reply_payload.sg_list;
+	ct_els->sgt_req.sgl = job->request_payload.sg_list;
+	ct_els->sgt_resp.sgl = job->reply_payload.sg_list;
+	ct_els->sgt_req.orig_nents = sg_nents(ct_els->sgt_req.sgl);
+	ct_els->sgt_resp.orig_nents = sg_nents(ct_els->sgt_resp.sgl);
 	ct_els->handler_data = job;
 
 	switch (bsg_request->msgcode) {
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index d407f16e77ef..a3b99839da9e 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1242,7 +1242,8 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	ret = zfcp_fsf_setup_ct_els(req, ct->req, ct->resp, timeout);
+	ret = zfcp_fsf_setup_ct_els(req, ct->sgt_req.sgl, ct->sgt_resp.sgl,
+				    timeout);
 	if (ret)
 		goto failed_send;
 
@@ -1342,7 +1343,8 @@ int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
 	if (!zfcp_adapter_multi_buffer_active(adapter))
 		zfcp_qdio_sbal_limit(qdio, &req->qdio_req, 2);
 
-	ret = zfcp_fsf_setup_ct_els(req, els->req, els->resp, timeout);
+	ret = zfcp_fsf_setup_ct_els(req, els->sgt_req.sgl, els->sgt_resp.sgl,
+				    timeout);
 
 	if (ret)
 		goto failed_send;
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 4b92e85ec71d..22e7fd933a78 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -487,8 +487,9 @@ struct zfcp_blk_drv_data {
 
 /**
  * struct zfcp_fsf_ct_els - zfcp data for ct or els request
- * @req: scatter-gather list for request, points to &zfcp_fc_req.sg_req or BSG
- * @resp: scatter-gather list for response, points to &zfcp_fc_req.sg_rsp or BSG
+ * @sgt_req: sg_table for request, its sgl points to &zfcp_fc_req.sg_req or BSG
+ * @sgt_resp: sg_table for response, its sgl points to &zfcp_fc_req.sg_resp
+ *            or BSG
  * @handler: handler function (called for response to the request)
  * @handler_data: data passed to handler function
  * @port: Optional pointer to port for zfcp internal ELS (only test link ADISC)
@@ -496,8 +497,8 @@ struct zfcp_blk_drv_data {
  * @d_id: Destination ID of either open WKA port for CT or of D_ID for ELS
  */
 struct zfcp_fsf_ct_els {
-	struct scatterlist *req;
-	struct scatterlist *resp;
+	struct sg_table sgt_req;
+	struct sg_table sgt_resp;
 	void (*handler)(void *);
 	void *handler_data;
 	struct zfcp_port *port;
-- 
2.53.0

