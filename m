Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793367675;
	b=oVi7Yo7WqIXCo7HDvcKaW4HaC6BfTMl5ELd5P67KsrFnReCgf9kxxjmGuSkjeoodT4ZK
	 9uwQb1sbDV9qQTjYcMZ5fIMjXlqE3Nq5sA8hIXUKUaZyKSUinyAeyL7hg9PqSEz5KMvza
	 //PTFAVBBSnTnl7lgWzvxzA4ygDNgQnQgNM/ax/3msCIgbfeYb0kl8imBR/2WKV8uxz6t
	 7Y5QoQs985SGJrPZ+MzsbLcJGMN7lJXgVjp+DQJTSdVQv8IlEpOeG46cLRT0vwKFyT/2J
	 t6ok02UHdxX1l7UaFaHSGTCrdWCtp4GTwt/1Lc2puXF4a7oZuvekhO4NeNSokoci+bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793367675;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:
	 Subject:To:X-DetectorID-Processed:Content-Type;
	bh=rMGCuhxXVMCY99RD1FQmPC/Y7haundwxZtxo65mIT9A=;
	b=33HrjQcE0ITQz7IJzppyoaWTYDiUJ7kh9JoYygQztu+OtkO728o4//giV689PrxmiYgO
	 y3s5Pl6QWUlOlrnLbK7TzEsGHhfZEIKf0vTnXfjifkDX6HcEc7M+UmJso2mKTjoad6cKe
	 ppYFHyfDw1VYFr4XAbsF1IhMv/AyO3in57W/nKa8MipS5Dv6jhdTiHx3smokyOUUBFONq
	 VlKf0Pri7cmSiUmnkl5+x5+BHb6vCeoI7etKtkOMLGgtpbXemaEiuXbO1C9g9qNjV7FuJ
	 zB6RcLtrVhaqYHqTbV6EH8PjuP0AFSGdfV92msbpTgihYmxRWZX3ApxfceAHxVCqtGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=DNFln2RM;
	arc=none smtp.remote-ip=209.85.160.226
Received: from mail-qt1-f226.google.com (mail-qt1-f226.google.com [209.85.160.226])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F15606A31C
	for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 13:41:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0F15606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=DNFln2RM
Received: by mail-qt1-f226.google.com with SMTP id d75a77b69052e-5351d76e1baso8022781cf.1
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 06:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793367674; x=1793972474;
        h=content-type:to:subject:message-id:date:from:mime-version
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rMGCuhxXVMCY99RD1FQmPC/Y7haundwxZtxo65mIT9A=;
        b=17l4qLTsm9uqVWiklvrK7EnMkQ0hddeNnsVBUkGxxJ4T0Y0kbUtTDrdzdzKXHnBK65
         EfXsMB/s2ZpxDnVWYPeBoDWX3yHaO43F/gDn1k49OOX17NIu4kf3KxvUob5rtBeyAV2U
         P2kkvBmhNpZBWiWUBWUeX6pdeW6jkmrV1oAqehS6ri9nptS8rlYcIX3Gic8lbbinM5Z5
         E0+6U88+pHAw7S8YcQ1JrRTAfQgQ5qCAqMmscNisLuFaO7bnPY0ao2fZ3xU18u2QzvRt
         0FryvM+/+BDDxEPr0WrKcuu4a+qXZPGqFVHjFus118ipLS/o0ae8/T9L19s/cXVJ+rcB
         w1LQ==
X-Forwarded-Encrypted: i=1; AKwUvBxSTUDc2ddAh64a85HYqmquBZlZLKhmyIoOgaWT/jYa5Pg5Ie2pgwMebiLDdy6vtueecCfmYbMM3E/r@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8gihSr6tKJWOryVv+/Bpz8AWxVSNlTTBfIr/lhyfZJhao+hvc
	Z1U+SRmIbfA8yZm/OE8btXHRUKZL0f8vtJMSPgCwCCpVwxffbI6fgjhc84vgacnoCGsmbFx2PD2
	Ttsi5A6q3UVCHh2hLyBMRi/fcAbf5yXauzXYj1KoDa7Vp5SYUb6zd+azAA0YmMsThgXyTiTCuge
	RwLEHim8pZtwvu7nXsF3/3+on6y5CxNAyQ39gRa1m3/Wqj6ILGendcMm5JmwCAXPuaVT0N43bXe
	K5ZzVz/leM=
X-Gm-Gg: AYBFou09oQsq4zgV8ncG35cA52P1P11vWOYuZAWuJGCXn42UQKgfeSjJDXvh62O6goV
	9DOYm3VhvG177IHuDf2bW3bEUiSmdb88Gqr2Bxwwu1sl//+qy+H4jepL06Vdh1p44f5ngS1oqGU
	wD9F4QYb3DDTPIe7+s8VVCc48/3LlMCjs809m3A88NNEoKzUQoiTjGlqxzSH/+muQPjDNWtjH6X
	r4HioVyXXFJl6mKlhiTq/QiqsBARTzAmIlBKct0nVLSkpyy/Fc4mwuY4fci115V0VMKYXoAYrIX
	W52nalr7L0o7vt+9Nzv57OkW7JQf5iKlq6f3gOxTutb/Vj8HPsHGi6epDlvMaZmry+/1vCOS37s
	HeJ5aGbNWt8qFek6eQG/tU3GwEF4+1MEz4Q6maR3sK5dkTzwVzzlVdo3llr1MA4h3BrqHshghNr
	Xgsp7Y/4myi+0q/lAy8KXmfvxMLnHE9w==
X-Received: by 2002:ac8:5f8f:0:b0:535:22e8:2fd3 with SMTP id d75a77b69052e-5411fd21a1fmr89047381cf.10.1793367673721;
        Fri, 30 Oct 2026 06:41:13 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-5431285f619sm106961cf.47.2026.10.30.06.41.13
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Oct 2026 06:41:13 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6756044f260so1268805d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2026 06:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793367673; x=1793972473; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=rMGCuhxXVMCY99RD1FQmPC/Y7haundwxZtxo65mIT9A=;
        b=DNFln2RM8Os2KBv6unVzrVM1bbCXR5lukZXf+W6H/E6KUiqyhAEyW8je2c3RGhIoDK
         jGanZI6FqFfgy8jxWumRASKM2rFdOgv0b2ZiJiGo5AW6F/mqt5OeVNyNaspoSwHRkGJI
         8ALQPeOIDNQbAnj/eqZifVBlPU6UP8F29nIuQ=
X-Forwarded-Encrypted: i=1; AKwUvBw9jOxFFNXgwdJopHPs5adCGQvoQr42tpXsByOhiQ6zaX/w/DdWQTgxMigpmDMK6VfsQ+JmCP+vbzdo@vger.kernel.org
X-Received: by 2002:a53:b703:0:b0:679:ac65:4894 with SMTP id 956f58d0204a3-67a8d39a752mr3239373d50.13.1793367672861;
        Fri, 30 Oct 2026 06:41:12 -0700 (PDT)
X-Received: by 2002:a53:b703:0:b0:679:ac65:4894 with SMTP id
 956f58d0204a3-67a8d39a752mr3239366d50.13.1793367672405; Fri, 30 Oct 2026
 06:41:12 -0700 (PDT)
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
Date: Fri, 30 Oct 2026 09:41:01 -0400
X-Gm-Features: AclHuK8kH1OuIkN_q5ZdT75tTegSRvmQGQPnwjHlNJ5kfbAVHTA6GSylbbGiccQ
Message-ID: <CAEQnVQ=J4JqS5s58zJ1DQjDMVWDkObfXMcKLS+E_oDQY=rjqCw@mail.gmail.com>
Subject: [PATCH v2] scsi: lpfc: Fix race conditions in ELS retry
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, msmurthy@linux.ibm.com
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000001f01d4065f0ef3b8"

--0000000000001f01d4065f0ef3b8
Content-Type: text/plain; charset="UTF-8"

From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
Paul Ely <paul.ely@broadcom.com>
Cc: hare@suse.de, msmurthy@linux.ibm.com
Subject: [PATCH v2] scsi: lpfc: Fix race conditions in ELS retry
Date: Thu, 29 Oct 2026 13:50:45 -0500 [thread overview]
Message-ID: <29073ebc-b616-475b-bc05-384da09fbb54@linux.ibm.com> (raw)

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
- struct lpfc_work_evt *evtp;
+ struct lpfc_hba *phba = vport->phba;
+ struct lpfc_work_evt *evtp = &nlp->els_retry_evt;
+ struct lpfc_nodelist *arg_ndlp = NULL;
+ unsigned long flags;
+

  if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
  return;
  timer_delete_sync(&nlp->nlp_delayfunc);
  nlp->nlp_last_elscmd = 0;
- if (!list_empty(&nlp->els_retry_evt.evt_listp)) {
- list_del_init(&nlp->els_retry_evt.evt_listp);
- /* Decrement nlp reference count held for the delayed retry */
- evtp = &nlp->els_retry_evt;
- lpfc_nlp_put((struct lpfc_nodelist *)evtp->evt_arg1);
- }
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
+ }
+ spin_unlock_irqrestore(&phba->hbalock, flags);
+
+ /* Drop the event-held reference outside the lock */
+ if (arg_ndlp)
+ lpfc_nlp_put(arg_ndlp);
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
+ /*
+ * Consume the payload to prevent reuse or double-put.
+ * evt_arg1 was populated when event was queued.
+ */
+ evtp->evt_arg1 = NULL;
  if (!hba_pci_err) {
  lpfc_els_retry_delay_handler(ndlp);
  free_evt = 0; /* evt is part of ndlp */
-- 

Reviewed-by: Paul Ely <paul.ely@broadcom.com>

Looks good Kyle - thanks!

Paul Ely

--0000000000001f01d4065f0ef3b8
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEICt++bV5enU0xjJu1uSfFinEYdi+
1Wt82yLN1GNW26pfMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MTAzMDEzNDExM1owXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBALurbscXU0fVKWk71BHbuwHYn/ubIrQl8nDzcTXx59fD3NYxkBVJmaV7tN2hffcE
FTkBCyAT6ZSG/8hAbycM3LhmtGSKA6x2IKNWR+T8gOD+3LczaeP1iAfEidmfROnQMUiDXcDp8b3m
R9AsZ9mUnSORFH5l0b7i6Ke8YW6Lez30flO8zOqi0AGWKkAHOH6gLYzfKqwLUucJZOLSSpVXmYCT
JSX9ZPqa1CAkN+prvOR3AQCcTyY0KyaAbU4BjQEI2BEayX4cWrFOuAMHg136eGkX0vWPZiP/P8v8
6oYsMPRTDprnpUlRPLBtynwB/o3LjSMM9Wx7TX9t403cf5efQdU=
--0000000000001f01d4065f0ef3b8--
