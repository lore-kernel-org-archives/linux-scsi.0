Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.163.158.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794419271;
	b=mt7iBoYRdbKWAV8aEQ1uQme75HlliALnbJ/Sixf9dZVLnQidfikBJhGyxyecHFwGTYlT
	 m9aGm+Op8MSExU2hs0uZ7WQnBRy2wXTawW6s1KBrn8ZhP1rBsd405Wpt/xg4vVVsArofA
	 cLU7S9xjP4FtYr1AEjqx+g9h+PSAoxDNVUWKpt82jis8cFgmZDAfo0I1L2M1XQsQBciBY
	 8T/u6iXbFtuWQB3le1Rqnzl1O52QdhTXtsF25kGZ6q7Ka1hN9EO10WUpHdakzxxiemOAI
	 3zyHQp7U0c3BmOFr0VmbWQlI0pa/O9BF2RuHAyU2J9eKXxppjl6ujqUSPl/TeQOudKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794419271;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:From:Subject:To:Content-Language:Cc:Content-Type:
	 Content-Transfer-Encoding:X-TM-AS-GCONF:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=bRXpA5Hyu4UhWX5g9RklULNga9AqhfZ0PdkETI674+Y=;
	b=UJC3Uuwu+8nZ0jnVdxtH/AqQnPf2JgkAfwVGigjMMXUhubugVGxzubNvHsK+8r31BAu+
	 rjK2l8kMWUn5LRBtIMnskO2+/ikfi5AoZJlAIP4u6BUg1zWnVBSZa5Bbm3sz3iRxgnUNL
	 dcmmZy2He6BBP5wEK6N1LXHVGP1aFpvcNe4IJIsjnL77mzEsHJ8ZQe5V8ajQflBaFuKnM
	 PhNHbG1R93mSB5HV9hbn/FnRHnK53QxoJfrSoFvgOF4+dp8TXTdiPlPo1/Shu8BZWxJjI
	 tOU5Srnudj4ztxJyFvKVeZve3pjL1Pq2zVpEMz8oIS9TAYKlaPTPwA3hSC7vVoI70bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.ibm.com;
	spf=pass smtp.mailfrom=linux.ibm.com;
	dkim=pass header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=dlqFzcfx;
	arc=none smtp.remote-ip=148.163.158.5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A226F606A326;
	Wed, 11 Nov 2026 17:47:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A226F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=dlqFzcfx
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABFESgD1392206;
	Wed, 11 Nov 2026 17:47:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=bRXpA5Hyu4UhWX5g9RklULNga9Aq
	hfZ0PdkETI674+Y=; b=dlqFzcfxLPJnwqpk5fQHORS8KOJ0ILt475jNgvaoRQCc
	gDEEh6z9KJSyVyHYischs7cq5e0iMJ8zoAN+oiC9hOvnFtFnUgxR1zDHj3hO/YnP
	zHesu9agGiv1Pu6pKQXTPvgriRWfMnwq8L5iw6QpoqgJ7QKgIKroLmXRXimltCzd
	7T7aKi+XDh+GxA0OssCeiSQrDpDI+i1XURnf1SP9AVuCnRtSt34nWE3MsS0XIQsF
	BCeYsHuVDQkjvcKRlWcGK50B2sCn722lN1TGa+bWjQTbwK3MsfY52txJIfwx5pwY
	6d8urofS5kL4iQ7dJJlDpA2M7CAR5GpxsylWPcRhxA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4hssdkueyx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 17:47:43 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABF54pQ2382072;
	Wed, 11 Nov 2026 17:47:42 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4hvd51u58f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Nov 2026 17:47:42 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6ABHlgej32244312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Nov 2026 17:47:42 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 34F965805A;
	Wed, 11 Nov 2026 17:47:42 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B0BF158051;
	Wed, 11 Nov 2026 17:47:41 +0000 (GMT)
Received: from [9.61.45.73] (unknown [9.61.45.73])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Nov 2026 17:47:41 +0000 (GMT)
Message-ID: <dcea48dd-f76c-4bb0-9275-c12ef9bd78a2@linux.ibm.com>
Date: Wed, 11 Nov 2026 11:47:41 -0600
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
From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
Subject: [PATCH v4] scsi: lpfc: Fix race conditions in ELS retry handling
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Paul Ely <paul.ely@broadcom.com>
Content-Language: en-US
Cc: msmurthy@linux.ibm.com, mkp@kernel.org, Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=POqaavqC c=1 sm=1 tr=0 ts=6af4aa3f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=8EvOkyO9o1yzKg11qnMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MCBTYWx0ZWRfXyzuiA3KGXnk2
 GEv+2WsKATv7n8fQ9DSCdGWrW3S1YqBBZWto+Qm6yN0cwNH5on+nyP6FgkKlhBNBkoFQ1MmS7It
 rv5VaCLj6yHL0tYz8BQmeAi/xXLO0oLoC640dR4RHaMGrmdwbzXy7ccQzlItTkxHFG5FkMBeEHv
 9xis81cD6x5goJX/xY28/fXYWQQmKhglBX1piqv5jHUm51wpAh1+/qfsiDXD44VhV7XWZ1n2qFg
 QGYNmJqmF825UL7ryyZ275Ei5EyK+FhWEgvY2W2CWNppqEV5d8E4PehXyPnGoQtvI3rFYMXZymi
 zVtRSP9JzaiP9c71wR/AJIvfDbMb9/1wW4Cxyg1WX8S6720INjqco33QIfj7Cyoe7HidNR4wOVr
 1KNisq/O5SwiU1Hho+5cYhC3dvi1hKnWNlbpS1sk8EcOkSP00tEQHadZ5LPxcQlBcXkXurclAYk
 vayu40cUZwzJMSOayfw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MCBTYWx0ZWRfXxCzA3qXmfPd6
 EcYzjG0Os9x+vV7thhkvKkJq77Uo202uv8HEWP98dbXenm/KSdcE0OwlBnGYBqFi++BICwCJV9M
 3Bp085c3yNb7MRDOZUlgaIqC15U5h3A=
X-Proofpoint-ORIG-GUID: DC63c8bWx2QC1HU6EBK7MgmKi971GZ5j
X-Proofpoint-GUID: DC63c8bWx2QC1HU6EBK7MgmKi971GZ5j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-11_04,2026-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110070

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
Changes since v3:
- More whitespace cleanup. (Paul Ely)

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
