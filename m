Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793299854;
	b=FNOezK0M1d3SHdgG8B9M1caIgyy2s/YuO8GYmlsOui0tVA3XsGB7Hcx0M9FyAwOGN0mk
	 Z8zyxP7Jp66HbKTGUrNDZHGdcmq0c0CR1Pakx4xKg9ayAdOKUcRgN4kmDufLRxL8Ozuna
	 +VycdvmwjmvMmZeVu2ZEAotq4KhzIlmkrGHELEyQAuQ+bZ4BKgJDGxdrNgTNvjCuyr97m
	 d7OTxCzSqGP1lgzdRHaR5VVoJyPlCnp4Qh4k6DguqDwM3TJoSIxwNMvzRrN0g1vXTPWfM
	 4Wu68cZubTl7QlWVTJ6iQA0SjHlpS7W+JSdno7KkoO2qLxcCbDSeFqzjooiR1fqx4Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793299854;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Content-Language:To:Cc:From:Subject:Content-Type:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=LX/IchEq0zst/gkv3fV1vQRcm0Go39Qa/xzSrfdyNGM=;
	b=NfLOV789LwPNJi38iXFihMCcdrA1hDPH8wB4EbGQQzJ0R/fsrG94FWI4a7ImclXZzT4y
	 /3zLSDQDcKcqoK1QtlXe5K6cdVbv7ipxSlwRvadWFPKiADFW55mid+gJOtSIdkYsn7VS/
	 o1tPkRNHCX557mC4YYFJutRg7YJvTL9CfKiiKZYuPRsEvj7ZpzCTwgKp8L9zY5J64H3yt
	 72DH50a28uo2yu+NV8RdVZyIZGPfuwrk9bRVAUml+ZdwrUo/hDnVRl3gZo37hCB8vBvzH
	 8M4MTzKXK/YWJZwYrzPNKPcr/xLx0oFozhLofPeyD87O195suVm7U2WBfHdblJ5plSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=edstEevJ;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E17606A31A;
	Thu, 29 Oct 2026 18:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90E17606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=edstEevJ
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TGEIZb3505303;
	Thu, 29 Oct 2026 18:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=LX/IchEq0zst/gkv3fV1vQRcm0Go
	39Qa/xzSrfdyNGM=; b=edstEevJS6d5bdTSudOTp1GFgLCKiQHHEzyuPxbt++hJ
	tHFN3O3kYtNyoafkA+EXSVWs6nRKXfC5zVF+1c89fXdrKUVi9bL/kn2mtNdUVibi
	PQLOZTEiLSaX2UFekF4J6kks+nhZNiQ9pAOrtfT7EnBXGOp9Qy1RTkrdnecximMf
	LXs4RcSw3F6ZcNxziS7MRBVpKRJbbYJVOCfcjbMY1bTrawS4+FOwLjYGeEdDzhyF
	FX42mOwsdBfBhtuqfSyukNHNo3/TZ9CWfmu2S5d6mut8NaGwhJKNvvZM/QiAVYtY
	/8qlBOw+lOly7ylqAvtt8YOQV/g0BHbERDPl2URe+A==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hgk3gbwr5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 29 Oct 2026 18:50:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69TGJx4R3449875;
	Thu, 29 Oct 2026 18:50:48 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4hm6pb9gqm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Oct 2026 18:50:48 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69TIollV20316842
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Oct 2026 18:50:47 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0BFFF58058;
	Thu, 29 Oct 2026 18:50:47 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 676D35805C;
	Thu, 29 Oct 2026 18:50:46 +0000 (GMT)
Received: from [9.61.39.38] (unknown [9.61.39.38])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 29 Oct 2026 18:50:46 +0000 (GMT)
Message-ID: <29073ebc-b616-475b-bc05-384da09fbb54@linux.ibm.com>
Date: Thu, 29 Oct 2026 13:50:45 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Ely <paul.ely@broadcom.com>
Cc: hare@suse.de, msmurthy@linux.ibm.com
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Subject: [PATCH v2] scsi: lpfc: Fix race conditions in ELS retry
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BOMmP1QG c=1 sm=1 tr=0 ts=6ae39588 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=Q-fNiiVtAAAA:8 a=Bz3PlmeQYvTki0S0ELIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: EwpCjOlHLhaJS7iapAt1IwfixQHgfo4F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA3MyBTYWx0ZWRfX4la0dvE84NqX
 79DAIoxOhEilZ7l3N4llTS/qbXZOi5ZFMkTKpbHLQ4MOS6Smxjs3JPo18+DUikJk0HA52bbbV/R
 +lcRyT25xb/+MbqX6nH6z+LEZcqUgLfq9OW1jAfxcplQY+SmbapaVpDx8mC5dMtjvOq9IE56dCp
 KK6f3GfN2wLpEJLPDEM3GaOIvf9iYGTVzG+uhZj2k8wXO4U7nf9/vx1TDoyocYo9sQ68vLmIc3D
 kQUFheC+DHhqP3qo0U+xIQu/RhAM7swmofqYXPt3Zcth0RmyfsZE/u511C5rwdeCB6T1t39ADs5
 7Rvo+BCt9SHO7M5MnDG9cuFNPZX0ldBDUafbvRo3BHL5Ca75pfsZ/1XUGIpm2LC6EjRrHk3beb0
 XnNq1WGgQI4zuzkI0uh0zAPr08hiMl/DzI4s1VOlHv5x0pPVRtyiDMrjdf9DOwm1MT+JkSHFxWn
 l3B9dvKTy97UT+myXPw==
X-Proofpoint-GUID: EwpCjOlHLhaJS7iapAt1IwfixQHgfo4F
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA3MyBTYWx0ZWRfXz9xGFcqcJ5YP
 9PdYSoj/h3N4D47fCX979aLONRCqkKt6xbo/D4wUMDVA7RXBdI06tTej8bghWK4hrnK2QAU8w6u
 Oi0XXMPyEkFmk01dk/gDGB660J/wh4c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_05,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 malwarescore=0 clxscore=1011 spamscore=0
 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610290073

This patch addresses a race condition in the lpfc driver's ELS retry
event handling that can lead to a use-after-free in the
lpfc_cancel_retry_delay_tmo(), where the NLP_DELAY_TMO flag is cleared
before acquiring the lock to check if the retry event is queued. This
creates a window where the timer can be rescheduled and fire, causing
both the cancel path and the worker thread to release the same 
reference, resulting in a double-put and use-after-free.

Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Signed-off-by: Paul Ely <paul.ely@broadcom.com>
Tested-by: Maram Srimannarayana Murthy <msmurthy@linux.ibm.com>
---
  drivers/scsi/lpfc/lpfc_els.c     | 32 +++++++++++++++++++++++++-------
  drivers/scsi/lpfc/lpfc_hbadisc.c |  5 +++++
  2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6f6394a0047c..ffd61ac46646 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4477,18 +4477,36 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, 
uint8_t retry)
  void
  lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct 
lpfc_nodelist *nlp)
  {
-	struct lpfc_work_evt *evtp;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_work_evt *evtp = &nlp->els_retry_evt;
+	struct lpfc_nodelist *arg_ndlp = NULL;
+	unsigned long flags;
+

  	if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
  		return;
  	timer_delete_sync(&nlp->nlp_delayfunc);
  	nlp->nlp_last_elscmd = 0;
-	if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
-		list_del_init(&nlp->els_retry_evt.evt_listp);
-		/* Decrement nlp reference count held for the delayed retry */
-		evtp = &nlp->els_retry_evt;
-		lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
-	}
+
+	/*
+	 * If retry event is queued, remove it under lock and consume
+	 * its payload to prevent double-put. The event holds a reference
+	 * to the nodelist that must be released exactly once.
+	 */
+	spin_lock_irqsave(&phba->hbalock, flags);
+	if (!list_empty(&evtp->evt_listp)) {
+		list_del_init(&evtp->evt_listp);
+		/* Take local copy and clear to prevent reuse */
+		arg_ndlp = (struct lpfc_nodelist *)evtp->evt_arg1;
+		evtp->evt_arg1 = NULL;
+		smp_wmb(); /* Ensure NULL visible before unlock */
+ 	}
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+
+	/* Drop the event-held reference outside the lock */
+	if (arg_ndlp)
+		lpfc_nlp_put(arg_ndlp);
+
  	if (test_and_clear_bit(NLP_NPR_2B_DISC, &nlp->nlp_flag)) {
  		if (vport->num_disc_nodes) {
  			if (vport->port_state < LPFC_VPORT_READY) {
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c 
b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4c673dffa671..3eb142cf4455 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -846,6 +846,11 @@ lpfc_work_list_done(struct lpfc_hba *phba)
  		switch (evtp->evt) {
  		case LPFC_EVT_ELS_RETRY:
  			ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
+			/*
+			 * Consume the payload to prevent reuse or double-put.
+			 * evt_arg1 was populated when event was queued.
+			 */
+			evtp->evt_arg1 = NULL;
  			if (!hba_pci_err) {
  				lpfc_els_retry_delay_handler(ndlp);
  				free_evt = 0; /* evt is part of ndlp */
-- 
2.55.0
