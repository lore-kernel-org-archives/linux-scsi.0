Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794423899;
	b=Vznv1kS3AmOBn4AT2MRWNejRNwQ9NM9/oRXDcUPdbhdvAq+/+wPRMnFLazr8WydAGILF
	 K/qGpnrlcequgv8lx3POWZDIVowfGb8As3COUqXifm8XSi8lZqJDeLlT1anUB4JPomG3m
	 ZZvLTP2vplJ1wAwOVFwO3kfjLwLW3Rx/yBJb1kjzgCFRMXml1euMY2u2ioEz2UweLnMYc
	 DWiGhWtjpmMyQoVyxs8Tjw1UhH5o9JpPJCWNtU4K+Uy15ZZSOzYPIqFsJA30RIXm9nRrj
	 4HRT81MtkibAoBOhy/iqF3LCr9DbBiBEQPI76hK3tBQuvyEbF6SWvlF1BHu1KabjZ6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794423899;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:
	 Subject:To:Cc:X-DetectorID-Processed:Content-Type;
	bh=8D8JxprCeqZDSOSCGhIReHkVL2kzRJ4gd4B5aEAwBTA=;
	b=UROER8vrIG3QcDsfehRdIjsqUAwjhFDJDEtN0uJtYwaqvnahR8+ytPEWpzieWXQ7o7pG
	 AUwYBLXhHvsZnr9tFWRw5iUa9ZnBFZyCejQd+VzU+Itjyp62xCD8bC08uMpPO6TBKE/ak
	 PEXKZhdWCafs5j+6lPc7cJ4rQSD0Rxu1Zi+LdQFcdLeIL8pCxcZNMJyIHvqm3DHleL4Gf
	 j30x17jo6Upf04dVtIOBO1/yr1ntwuxJ26C/qndZRnhf62jnzOKWQiJNell7eMKdj4092
	 9Hl8H6avQuvUsk0y7DZ0NnQMmwd9Zoj7+QVdv2Z4hssMrm7TfWX9TTrQffO5MEe6/kA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Ja791mRL;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF38E606A897
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 19:04:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF38E606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Ja791mRL
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so92761a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 11:04:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794423898; x=1795028698;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8D8JxprCeqZDSOSCGhIReHkVL2kzRJ4gd4B5aEAwBTA=;
        b=icP13kYYeF3KUtRLsOsOCQ09cz0tdGb3NvSa+S6jVSG5Fkr+XT8nOGfvl7Tk+5AkIS
         XtaXh/npy94BOaUCLwOh7YBRCX9kPCijzAUcyOMpQWoa7wLNtPAxTsaa65Pol3Ik2Y8+
         2iVR8YUBRHesk+RjV8Q8W2IiyZs6cLEPDPEzYPq5gn9GtOcr2uMie59N//jHUHL9m4VJ
         +JrvyDnIeZ/8cFPHCO8C53lbY0eUlJrrFOkVMI6PXjekp8EGH7r55pvQLER8lRcZpSzA
         F9TFVRKbnhy5G9T7d5omqs2Q8Au/NNdMec0ODO6O8QQj+gcDKVbG5tzqikhtgjTmiUXx
         B0/Q==
X-Forwarded-Encrypted: i=1; AL+hErHda0Z1zxjlhhnj/uMveahoniVYnvJ7T5fFS2jKgHpTD1ywQK2+qU3lheQwDv5EalCjvHAJMOvNLl7S@vger.kernel.org
X-Gm-Message-State: APuU4Z+Us4uOXpezGrjANQKM/IugXIkB4r4ECEQ5mmt4CoDIfERidbc6
	rF8lEupRT74IOA0yLOlVdGCO8Fxe83ulB+5O7AsOo5eoLaB/bhOH2UfNfiuFupB9F75gxMpRrvc
	7fAKRmY1zPMRU0TvcXMtLKLWtOtjs1h+BG8cY7108gOGnFcDYLR7oivVwU5WX/Q8lBppg03XvI/
	RWbBZhAx2kPKIxpBEjr2jJ2ShZiUHPWF1zC4kApg2Pm+iGaxau3YmsI2cQB5wNzUyEwpJ85XBme
	p82/tOxzfE=
X-Gm-Gg: AYBFou0Z5pRuLFLJDA0kmsDtseiWmqH+kSjNNGSongc4vF3XQ/SM0Mnaa4uxoq8m6Xj
	BlkDjM0f7p90nH4Um9sjALt0V2w8mv6LJ8VIAhf467elJGmt12hZrLhG9y8S+LsoJQUsyS9Bffs
	Gyv78xL2Nl6uSWd9VbYSeQgL/skdzQsBdAaewSkUTvwT/nn9vnN+AJ7sH4P2a148dFLaK4UTnHU
	twASDJxHbRJi6b843O4Hxr4h2Z5F4Ou3bIfTFLtPOxzQdo7nMtICw/vq89uhr3/S+zm3EMlpVtY
	gV9f23TXvfuPdzPWmP33vc+Odv71HLjQtjKjJLO5COXabIWUnAi9BcCzwVeHNKdrWyV9q2vQ/Vy
	PE0+j+jkvrsuXfxb3wAXc1YyEIypSV5q0VZBVQsKtYdHIhWOQyn/GF0AdX24wOK5/URk8J68iPy
	t4ZRwOT5CGcG4pnNFyWAvUqVhrPvRdHQ==
X-Received: by 2002:a17:90a:8c8e:b0:3ab:d26b:c2df with SMTP id 98e67ed59e1d1-3b197cadcdamr165371a91.27.1794423898086;
        Wed, 11 Nov 2026 11:04:58 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b197c1a3e7sm222082a91.2.2026.11.11.11.04.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Nov 2026 11:04:58 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-67906c453b8so229500d50.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 11:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794423897; x=1795028697; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8D8JxprCeqZDSOSCGhIReHkVL2kzRJ4gd4B5aEAwBTA=;
        b=Ja791mRL1F9n37wgKYfLXNBIOS0U+TxeTbvJta8U3JdmIe2IqrT0zxVbvqQHgun1GS
         89MKeLiIG/rUNCDPc3rrBfkoRFPX6QSDRkEQ0eY2G4vgZWGI1bef8sRVuPMZh6WvYmrN
         zCXQUYuo4C8I/NGxa5HyrckKT2TK+hmr177co=
X-Forwarded-Encrypted: i=1; AL+hErH6f45KT7+fzBdYQ/uCHk3fsk1UwmUtguyp58sNDQoVXgiRlDBepw1C7PI/jJ6PQ1Pj1NbIiz8BF33f@vger.kernel.org
X-Received: by 2002:a05:690e:1381:b0:677:d05a:4800 with SMTP id 956f58d0204a3-67c78cc3ed7mr210951d50.25.1794423897019;
        Wed, 11 Nov 2026 11:04:57 -0800 (PST)
X-Received: by 2002:a05:690e:1381:b0:677:d05a:4800 with SMTP id
 956f58d0204a3-67c78cc3ed7mr210932d50.25.1794423896573; Wed, 11 Nov 2026
 11:04:56 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Paul Ely <paul.ely@broadcom.com>
Date: Wed, 11 Nov 2026 14:04:44 -0500
X-Gm-Features: AclHuK_wLjUNY8t4gTVp9WORphVKxWRH6HPk9989tr1CeHDoOEDmDz7ghQ_MU4o
Message-ID: <CAEQnVQmsGhWwnpQW2KFRBbzu1x6nAz28SsQAGbgPJeButRWcug@mail.gmail.com>
Subject: Re: [PATCH v4] scsi: lpfc: Fix race conditions in ELS retry handling
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mkp@kernel.org
Cc: msmurthy@linux.ibm.com, Hannes Reinecke <hare@suse.de>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000fa2d8c066004def3"

--000000000000fa2d8c066004def3
Content-Type: text/plain; charset="UTF-8"

From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
Paul Ely <paul.ely@broadcom.com>
Cc: msmurthy@linux.ibm.com, mkp@kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH v4] scsi: lpfc: Fix race conditions in ELS retry handling
Date: Wed, 11 Nov 2026 11:47:41 -0600 [thread overview]
Message-ID: <dcea48dd-f76c-4bb0-9275-c12ef9bd78a2@linux.ibm.com> (raw)

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
@@ -4477,18 +4477,35 @@ lpfc_issue_els_edc(struct lpfc_vport *vport,
uint8_t retry)
 void
 lpfc_cancel_retry_delay_tmo(struct lpfc_vport *vport, struct
lpfc_nodelist *nlp)
 {
- struct lpfc_work_evt *evtp;
+ struct lpfc_hba *phba = vport->phba;
+ struct lpfc_work_evt *evtp = &nlp->els_retry_evt;
+ struct lpfc_nodelist *arg_ndlp = NULL;
+ unsigned long flags;

  if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
  return;
  timer_delete_sync(&nlp->nlp_delayfunc);
  nlp->nlp_last_elscmd = 0;
- if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
- list_del_init(&nlp->els_retry_evt.evt_listp);
- /* Decrement nlp reference count held for the delayed retry */
- evtp = &nlp->els_retry_evt;
- lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
+
+ /*
+ * If retry event is queued, remove it under lock and consume
+ * its payload to prevent double-put. The event holds a reference
+ * to the nodelist that must be released exactly once.
+ */
+ spin_lock_irqsave(&phba->hbalock, flags);
+ if (!list_empty(&evtp->evt_listp)) {
+ list_del_init(&evtp->evt_listp);
+ /* Take local copy and clear to prevent reuse */
+ arg_ndlp = (struct lpfc_nodelist *)evtp->evt_arg1;
+ evtp->evt_arg1 = NULL;
+ smp_wmb(); /* Ensure NULL visible before unlock */
  }
+ spin_unlock_irqrestore(&phba->hbalock, flags);
+
+ /* Drop the event-held reference outside the lock */
+ if (arg_ndlp)
+ lpfc_nlp_put(arg_ndlp);
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
+ /*
+ * The ELS retry event can be requeued by lpfc_els_retry_delay()
+ * as soon as hbalock is dropped. Consume the payload within the
+ * hbalock to prevent reuse or double-put.
+ */
+ if (evtp->evt == LPFC_EVT_ELS_RETRY) {
+ ndlp = (struct lpfc_nodelist *)(evtp->evt_arg1);
+ evtp->evt_arg1 = NULL;
+ }
  spin_unlock_irq(&phba->hbalock);
  hba_pci_err = test_bit(HBA_PCI_ERR, &phba->bit_flags);
  free_evt = 1;
  switch (evtp->evt) {
  case LPFC_EVT_ELS_RETRY:
- ndlp = (struct lpfc_nodelist *) (evtp->evt_arg1);
+ /* ndlp was already captured under hbalock */
  if (!hba_pci_err) {
  lpfc_els_retry_delay_handler(ndlp);
  free_evt = 0; /* evt is part of ndlp */

Thanks Kyle - looks good

Reviewed-by: Paul Ely <pely@broadcom.com>

--000000000000fa2d8c066004def3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
iId6lRoDnFAsEvnaOMvg29iSc9gZaFsMAV8NLrmVgatBLqETEHgQ4n1BrE2+pRoymE80Zf+Qe5W6
GF5zYMjxe2smznZoexz/BISo+5QDZaKZKtmoZ3ApyLjKz1G5Q2hUhmZWHvMu/eGSXP59UaUUmelW
ZlVs3E0h345YpaGuBNlquYm35nQ3ehYjm2jqaIh7F7K0+eF5TPjcMLpqnpak12xIx6BCxmFi8Oqu
Gb9+KrrAD+KPgqzjyZZxdVcCAwEAAaOCAdkwggHVMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8E
AjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxz
aWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDov
L29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EM
AQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3
dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwIAYDVR0RBBkwF4EVcGF1bC5l
bHlAYnJvYWRjb20uY29tMBMGA1UdJQQMMAoGCCsGAQUFBwMEMB8GA1UdIwQYMBaAFAApNp5ceroP
ry1QLdugI4UYsKCSMB0GA1UdDgQWBBTc34vK15RY7h33segpWeDeAloTGDANBgkqhkiG9w0BAQsF
AAOCAgEAb0hABkNonbsXXPrDOwB9B9lRtVhdRszakaT0zWubTTtHAV/XTebY1b4caUC2iX9AJvr0
XTJrFAiLtJ6eeP6yQOjD+rBprWauwPUzydJWEftECpX/lbPgZLBSHx22euCSnIm8HNj8o0bMi+Ii
plCW6kU56G1krQY0jrqDJCFgH4Wmp1TrKi36iVTIXyYLDtPOcSXe9hLmeUlQuL4nAoB8EsI45w4a
5Wi/xS7vGQLXzXAQ2SY6Yuseqhh+QcXvzeb0uVB54edC4HFrVX9DtFzHXoyB9s0C29MZm2zpFPNS
DgwnsmTsvpPuLELuuaJvIKnSHHR9FKrmQZbmz/i6KyBt0enmjNk7I7vAKQa8IqZxSrjvR6tYExiq
BP9ZuiXJnuqoPujFE7kphkUjmK76yv8904eZNflTvcEDpthD1boifOzT78iQ3fbuytR8LKx7tzGV
Ga9+dcLBcR/eP85Vmc9NW1frtO3dRd26+DHs1lXX96Em5AAlvBgDw8b1GfyEvfimBkxTIWxR3mBB
jAMkNKrfvV7NxS9AfcFu4fvxuBJc+t2FN1zBc8VyVyn9ZBeJ2DYS9uQ2x00QPXMHqVlAT5fBanmS
n1fgcSTdHEy1fzVZIAtM1XMIWy03bJKNBwUebgxHKHSUCZ7VSMHE4jyERMCqkvTxU6h4JJ7YzRrU
jhXYo8oxggJXMIICUwIBATBiMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAyMDIzAgx9OiWw8dVRSIkn
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIIWT9huXa0u2S4Ryr8l85ZCmP+wh
7+HMb97vQ31jTC2+MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MTExMTE5MDQ1N1owXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBALOkze+CtrMf6SN2XezRYozl9ds+bczJFV2sLArr6USVynovH4a+3I2sBd8xwJke
Iz97HfrsPskllDv7pz2sPBTlHpmU01i8hBQyDLXgzShVAUbSiLewqbUEuMG6wVTm4GWf4P5LzDcm
gMZHDCM7MQKkKYSZOdnoZnxp7IixfL4Jdz7Uj4jbWQNo8YdpkEjiTpWsoSP5TjUuZRG9xdJutJYM
xcC0mxQ2o7ANrPIfnVhzyJLK57fGicKH6m5LwQNQGdZLuPrCk/p5LoqKU2BJsZ24ilQMM78O7LHG
65rYKWz6uduhs88+lUkRLKYjYa09gMYPq9f9T9Wx37I/HUQkVT4=
--000000000000fa2d8c066004def3--
