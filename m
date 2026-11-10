Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.156.1
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794341808;
	b=bZbEKHT9YA5F3jBcYxIBEe0AOJdx7mz76K2rDdnyd/0YyczaRSrUDGZvtLHeXLFCKEId
	 KIQXJzwwleBrLOFRypv9ZxSt1bl8akvfKJBoD2OrCdpVbjz97DiVkpZHh65IneFdsv8pJ
	 SFLLMBt7I/ZonTxfO1QHJG3jbaC7/pKjrYQ5NFcGQHOS3RoAQcFPT4VaPkjGsl4Pvstq5
	 0rP2xChEXq2P2URpSQ1xte6GgaXA6et/LTJCgmzUwH0hxue4PKFyJcO130aSq7AvAcOt6
	 ARYXf7lZ/N/jOg6Ye1Yo3wg6M5QX/njgUMr7wjOW66L+ckrud/bFARVlsjysnFg+WnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794341808;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Content-Language:To:Cc:From:Subject:Content-Type:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=xMoe48qPntPCouip6vp6PY9I604DIpbtJ391w7p+qs0=;
	b=kpSSYGQrhfSb0fhiBRht4DHwOu8GUsXFcZX7HBQP8fSWiYvabykDxBnyBpdRtrkakQx2
	 38TTPsGYvdqsfzG3cV0fYvHJtj1h6wQe/MQjS2EBUGJCFR1prSg3fLpI4HnMwjSIdUa5E
	 qMlJoY/3MRhhriANbqeZNPv4WnbP9MLY4i/Y/LU9jG7M0hZ9iPHMAMCfrTleL6xrju980
	 jEDuxGkgcC/Uud2uyFdQA+RGXZVQZGZ9nlkWzKsyt/e55/cItcRq9fGGEbPLXLVFsgYjX
	 IiZwyMX1igS2jkeGztN4T+88KDGLeGAErtDzL1oa+Cqk71NtDD5ckgHlWgMCxSdMByg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=S30neKvo;
	arc=none smtp.remote-ip=148.163.156.1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237AF606A321;
	Tue, 10 Nov 2026 20:16:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 237AF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=S30neKvo
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAJEDOF1521824;
	Tue, 10 Nov 2026 20:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=xMoe48qPntPCouip6vp6PY9I604D
	IpbtJ391w7p+qs0=; b=S30neKvowgWiasAjDMS0pwJnBZY9lIbdOsnPfShLDq/S
	SIpsNuvbgnJ0itxFzAd0CObg8iDWXijxayjzEBbfRtNF3XEu3n2bGlZYJlU4xZox
	eR0Omikd/CsqnB7/5Lwnpb6Rz8QYhhPblRKwVLT+w+VRG4E6MoKz8EOjE2vuOS3d
	YquHo28zy0Tb8cWbsJU3HPzqPsp/HpWNyKhVNmTJHb8SQrnPB+UwTuwA19/7X4qB
	B/ki932DtOHaoxOFaJe2Wrz5/h5EeHG79QLgLXtXkqsilSq+rY59h1jbS5RtWtT/
	LN6Zuk+jNvgU6ldQ5dXU/hel0rK1uN2Qm02Qy+25/w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hsunt70ce-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 20:16:40 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AAJ6vml2228217;
	Tue, 10 Nov 2026 20:16:39 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4htepw095m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Nov 2026 20:16:39 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AAKGdqD65798520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Nov 2026 20:16:39 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1015258055;
	Tue, 10 Nov 2026 20:16:39 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BBE358043;
	Tue, 10 Nov 2026 20:16:38 +0000 (GMT)
Received: from [9.61.112.67] (unknown [9.61.112.67])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Nov 2026 20:16:38 +0000 (GMT)
Message-ID: <e893d431-79ef-4fae-bca4-38903fc8f49d@linux.ibm.com>
Date: Tue, 10 Nov 2026 14:16:38 -0600
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
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mkp@kernel.org
Cc: Paul Ely <paul.ely@broadcom.com>, msmurthy@linux.ibm.com, hare@suse.de
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Subject: [PATCH v3] scsi: lpfc: Fix race conditions in ELS retry handling
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEwMDA4MCBTYWx0ZWRfX6XD663Bb65CO
 SPjr1B0t0SE1LpTWBvU7zv47WmTrJagNTwS554I1zSmquXFUvKXAuEfU+dlwqw/qEnHL3XSUbua
 dB4CSwa4v5XNuO9f4L5InGkXUzUThCXMlB3S7XVxASa987DS6HkbmXVd3XoQG+3N4rw8S0Cyw1R
 owZwSUAh2y/wMCWxl/oM9rTQoeJbx9+h4GjYReOsSiYc5qWZMjAN224KPfBthW8pl8IQ8okVM+9
 +Mzp3KTEldlin780xQrfPRPmGQ37g4ecgtxxijudE0c4+amUdkv3kHw+6aTCm4X5RkmOtX2ursJ
 hWZTRFt1w1zmp1c+GQB+ZDNDy39YuMKEOGWay4DTynSyGQqOpMeT5Rxuwug5vP2BWpWLf8KKYtr
 N5EtXp4UdO9N9w3Yw26rap2oPzHqGQwcnGwLD4W7pfQAApQ/BioqUf79VkHEmbUhMilfAg6wCLe
 sjkKi60CD7mhzl+kz9Q==
X-Proofpoint-ORIG-GUID: ivBoNhzCCOzghoJbd9fD2yjfDd5LNatR
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEwMDA4MCBTYWx0ZWRfX+bAoCPZX/o/a
 tgI6B7z9J8gDQSMCLpW6yvrS4vLx11HR0950ba90975xorcth6OEBVfkBkB+s8vni+Bnhr/tcgB
 T1JIi9FuE/YAV4+8Iiv869Oh8lNfeos=
X-Authority-Analysis: v=2.4 cv=euZKXYpX c=1 sm=1 tr=0 ts=6af37ba8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=HiiFMaum0WKSXYThIFcA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ivBoNhzCCOzghoJbd9fD2yjfDd5LNatR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-10_06,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1011 suspectscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611100080

This patch addresses a race condition in the lpfc driver's ELS retry
event handling that can lead to a use-after-free in the
lpfc_cancel_retry_delay_tmo(), where the NLP_DELAY_TMO flag is cleared
before acquiring the lock to check if the retry event is queued. This
creates a window where the timer can be rescheduled and fire, causing
both the cancel path and the worker thread to release the same reference,
resulting in a double-put and use-after-free.

Moved capture ndlp and clear evt_arg1 under hbalock while dequeuing
LPFC_EVT_ELS_RETRY in lpfc_work_list_done().

Signed-off-by: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
---
Changes since v2:
- Capture ndlp and clear evt_arg1 under hbalock while dequeuing
   LPFC_EVT_ELS_RETRY in lpfc_work_list_done(). A requeue by
   lpfc_els_retry_delay() could cause a NULL dereference in the worker.
   (AI review)
- Whitespace and line-wrapping cleanup.

Link: https://lore.kernel.org/lkml/29073ebc-b616-475b-bc05-384da09fbb54@linux.ibm.com/T/#u

Changes since v1:
- Leave test_and_clear_bit op and timer_delete_sync at the beginning of
   lpfc_cancel_retry_delay_tmo() outside of lock. (Paul Ely)

Link: https://lore.kernel.org/lkml/1c8a764c-fce1-4ce1-b797-47ac328cf3f2@linux.ibm.com/T/#u
---
  drivers/scsi/lpfc/lpfc_els.c     | 29 +++++++++++++++++++++++------
  drivers/scsi/lpfc/lpfc_hbadisc.c | 11 ++++++++++-
  2 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 6f6394a0047c..98d1824aefe1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4477,18 +4477,35 @@ lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
  void
  lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct lpfc_nodelist *nlp)
  {
-	struct lpfc_work_evt *evtp;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_work_evt *evtp = &nlp->els_retry_evt;
+	struct lpfc_nodelist *arg_ndlp = NULL;
+	unsigned long flags;
  
  	if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
  		return;
  	timer_delete_sync(&nlp->nlp_delayfunc);
  	nlp->nlp_last_elscmd = 0;
-	if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
-		list_del_init(&nlp->els_retry_evt.evt_listp);
-		/* Decrement nlp reference count held for the delayed retry */
-		evtp = &nlp->els_retry_evt;
-		lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
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
  	}
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+
+	/* Drop the event-held reference outside the lock */
+	if (arg_ndlp)
+		lpfc_nlp_put(arg_ndlp);
+
  	if (test_and_clear_bit(NLP_NPR_2B_DISC, &nlp->nlp_flag)) {
  		if (vport->num_disc_nodes) {
  			if (vport->port_state < LPFC_VPORT_READY) {
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4c673dffa671..75457f19d4ea 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -840,12 +840,21 @@ lpfc_work_list_done(struct lpfc_hba *phba)
  	while (!list_empty(&phba->work_list)) {
  		list_remove_head((&phba->work_list), evtp, typeof(*evtp),
  				 evt_listp);
+		/*
+		 * The ELS retry event can be requeued by lpfc_els_retry_delay()
+		 * as soon as hbalock is dropped. Consume the payload within the
+		 * hbalock to prevent reuse or double-put.
+		 */
+		if (evtp->evt == LPFC_EVT_ELS_RETRY) {
+			ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
+			evtp->evt_arg1 = NULL;
+		}
  		spin_unlock_irq(&phba->hbalock);
  		hba_pci_err = test_bit(HBA_PCI_ERR, &phba->bit_flags);
  		free_evt = 1;
  		switch (evtp->evt) {
  		case LPFC_EVT_ELS_RETRY:
-			ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
+			/* ndlp was already captured under hbalock */
  			if (!hba_pci_err) {
  				lpfc_els_retry_delay_handler(ndlp);
  				free_evt = 0; /* evt is part of ndlp */
-- 
2.55.0
