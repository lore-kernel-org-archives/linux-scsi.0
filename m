Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794408591;
	b=p/Lrn0VSp5lqP1AHzc+E1nBiTMOQ4Dlp1ynfP4cWJ2Hf2joQ+vg5FooVvEYCNPMWZhPY
	 tos8ycJgqocv7IF9OAKwe0TDA3DAMvZdfPXO1/W1dB+568h1NO51UXWQCjUAZN8NQZsjt
	 0jIh1txAKAmVvmLIKtnh2wO85mJRjC0V4wwwsKRaNCbNct+QGLi0+8NONwLVj85ELfKt7
	 OnRZqAsj7I5iNnFQzfowFF5LEXB9dvY+W+211Ag3lbLlVlWLu9R/DEYzGsQwW6mQt8vob
	 aFmDnoU9VPuneveHkCRG5sFG3NvzlZ+xGsVX4r++7B0dLtNrQgsLtRntHlB/gAwM/qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794408591;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:
	 Subject:To:Cc:X-DetectorID-Processed:Content-Type;
	bh=X+s2UhjwRA5qzWTzBqOq0NT2phVmMd5L0ljrIwsb5Nc=;
	b=BE7mEsSCiRsZP8cRLlnBZkmvA1yvKL+E05omDtJPRwL4najXD/7FnsbmcxG6Reh1VRGn
	 IDTh97L9La7CF0WsMhexCyJPh4z85MsgcaStJKEKF5ksH8icQrfYwnMXk2tp1X/8qfar5
	 ZxZP2+ua0b1sBXvwXxdHBNe2uHBM2JXkrg6Qfc6IfaLRYqQeCoacNCaa73e+KJ82SLDNo
	 8yYZIbepWE47Fp+OzPO6ROXyFqUHeYh4vUm8nO4TGMpRzWAJQ2yg3u1sTfKv7vs4y2cw7
	 DRHi1TJV24ob4Vu3gTSBaYAizXDaRYx4bzfiRztY35u1ixJcKUDmmceWyxPfp2ftmhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="Z/8CpSo5";
	arc=none smtp.remote-ip=209.85.214.225
Received: from mail-pl1-f225.google.com (mail-pl1-f225.google.com [209.85.214.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B510606A324
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 14:49:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B510606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Z/8CpSo5
Received: by mail-pl1-f225.google.com with SMTP id d9443c01a7336-2e977109392so18689445ad.0
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 06:49:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794408589; x=1795013389;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X+s2UhjwRA5qzWTzBqOq0NT2phVmMd5L0ljrIwsb5Nc=;
        b=BWV3QfgbUvYk5sM6kkki31wMmXM07eonco8NB8/AMRZJJXCuE4oa1rmz3DAYtLQRPl
         0H7ULynD3Wy2ch10LW+EurBkMwNvnHP6R58y55giFSkLBzI7LQT9sNjo5PXQsYaFeyxI
         n+PGHhfYx+313XUm1uYr+8L4T5EMBtAOLCKB+8sVrgD1o+mFE1+udoKGYnOXlrSBKxmE
         J4aM23jUp1HFEAOI9lvJOjeeeiQnQj3Mmy/b/27JDkbziQDE4hh0yIOs8wl4BvXwUEgH
         BQKFPAy7Lakx8xYH0NUEUEyFskBM3H4s/1N0N/uVEt7AorVUw6nKT4DMVy4DTpdu/1Bz
         he9Q==
X-Forwarded-Encrypted: i=1; AL+hErGeQKY6byMAHspsa9HRh3qujWd3oEjOOG1aUZ5NeD99Ek7EjoiR+ySATEhvRyzdPxmbSw38c8C3YHZC@vger.kernel.org
X-Gm-Message-State: APuU4Z8hoWPCuP56RLMONICyeI9+WkNbfaa9RDkcnFEickTf6uLwuVkJ
	Hg2EdwR434Qm4xWMyD4jHZfyf/nMhCcDqd3JMEabBDkTDMPa4vSU7T2N2KDBKwv9UusVWI8r1ZI
	r7NXlCMbr0PMRHXRDAD+YPfMGqAjzJnhy+9XH5KhW+HgHoD8kPzTJHyCBYwdVQsHK8XJpijlYws
	xMV4tOXh9Hqgf3ST+ORqStXWUAHyFWb4dSgOdaVClfoB026tHn/E9Dbit+BfecpArTFO2i1HxRO
	iBJbGqZN3Y=
X-Gm-Gg: AYBFou0LaxbftcMQFfCcpDVAnWLGNWME3j/yZyEW3qZEEE6OSHR4mdYP0Y2dyFZqkW7
	CvuA16nxKOVLg7m5K7hOniCrad1rnQ73qbBLubftmwIq6eorU4oJGSLNugZagUghoh/ZV3bEs6G
	qskkC64a85Gy8teVHt8Jwv4ugTeUnSz2gN3DqpgIy7g7LwtEX65vSbcMZrg3MIrgwmtoyqnYDtc
	akaE9oj5WjoZpdvoKBULBlDePbqaDhySWXPMxvbhVA+Mb2KvP4gMyF61tho+P/CeHsjusn4tfSF
	uG614TLQN/5FbEjt+7LpVbkHup8itJrXCSB1O9TRY9xVx8CMrhBjHEWBtO//rhlNDoPbQXjazbn
	Rt+4eqhRQtAMOWfrc9xHlS4qEsbBYTE07ie9GZum9aNRSarj1aU6010xLnWaoVXG64ky5HKDeT5
	O9sbNdmp769BenAyCa0rQlBPSeLIV+bw==
X-Received: by 2002:a17:90b:2552:b0:3b0:9deb:d994 with SMTP id 98e67ed59e1d1-3b182f85315mr2482951a91.64.1794408589439;
        Wed, 11 Nov 2026 06:49:49 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b17e0dcaf8sm2139801a91.3.2026.11.11.06.49.48
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Nov 2026 06:49:49 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-67c0efb7b97so4600758d50.3
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 06:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794408588; x=1795013388; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=X+s2UhjwRA5qzWTzBqOq0NT2phVmMd5L0ljrIwsb5Nc=;
        b=Z/8CpSo5Yl+QsDg5WM6dVPNm36EkQlc9rhwhK4ygowIS9zf4EY058csn85u8DLOCEy
         qodvXWgyXEHuaK47ulSxlj1DekGszvj22bzP5pv94rsM5ab5AAWjyYrnAuvKVuyV8M1m
         ef+q5dJ9EHN4T65OYub2EME9y/M+jMFKfARc8=
X-Forwarded-Encrypted: i=1; AL+hErFaTjk4q15YeVgxTFMH5c6bnldeHyzURMF/qS34gsCY6ubbAxxmd7KMwFXhbbWzL0znD68X8o1TT+xm@vger.kernel.org
X-Received: by 2002:a05:690e:4803:b0:679:9971:e859 with SMTP id 956f58d0204a3-67c67f771b4mr1109170d50.50.1794408588189;
        Wed, 11 Nov 2026 06:49:48 -0800 (PST)
X-Received: by 2002:a05:690e:4803:b0:679:9971:e859 with SMTP id
 956f58d0204a3-67c67f771b4mr1109161d50.50.1794408587777; Wed, 11 Nov 2026
 06:49:47 -0800 (PST)
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
Date: Wed, 11 Nov 2026 09:49:35 -0500
X-Gm-Features: AclHuK8aT4loQ4gE6XyUczqV8eRFxYLJ9yRejRstRCDc9t3n5AOPuCZuj2X5ySM
Message-ID: <CAEQnVQ=uT+zMiF_mPD6j2g6qrpUL1Eufw=QNabJFEOz_wwLVRg@mail.gmail.com>
Subject: [PATCH v3] scsi: lpfc: Fix race conditions in ELS retry handling
To: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: msmurthy@linux.ibm.com, mkp@kernel.org, Hannes Reinecke <hare@suse.de>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="00000000000080dc150660014e66"

--00000000000080dc150660014e66
Content-Type: text/plain; charset="UTF-8"

From: Kyle Mahlkuch <kmahlkuc@linux.ibm.com>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mkp@kernel.org
Cc: Paul Ely <paul.ely@broadcom.com>, msmurthy@linux.ibm.com, hare@suse.de
Subject: [PATCH v3] scsi: lpfc: Fix race conditions in ELS retry handling
Date: Tue, 10 Nov 2026 14:16:38 -0600 [thread overview]
Message-ID: <e893d431-79ef-4fae-bca4-38903fc8f49d@linux.ibm.com> (raw)

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

Hello Kyle, the patch would not apply.  There is an extra space here
in lpfc_els.c:

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
  <=====  here
  if (!test_and_clear_bit(NLP_DELAY_TMO, &nlp->nlp_flag))
  return;

lpfc_hbadisc.c also has a white-space issue as well.
--ignore-whitespace allows the hunk.  I looked quickly but didn't see
it.

The patch still looks good -

Paul


Paul

--00000000000080dc150660014e66
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIPXy7urNe8lHUCEgcdzJ+Lnb0HK3
9Sr78e7INL6+igfEMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MTExMTE0NDk0OFowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAL/12k3REvakv3ClMBXwCrXk2zG/CQRETbcnS/iv9/jEkvI7S9tD2dD4oUBQiVAT
fKM9bepZti+U7wJEYTLca4dEqlz2UWhFIaQDss0WUvVKdwZF2f/MCxt/FMLlTzkhTy7eI6NQyoEw
Xi34LarEEHcNmJS3PCAb6vl7Aa1jK3cba6pRElhRvSyS3DjRZY7OhqOAKT6UFU5Lg+2/SZuGwGf6
AS6gmaVLiJjEtThJ+Xr19L4WYxBxptM3jQU3H5i7FZ9Tek4ZQQ5YG1aO3AN0ny/Ya0wjU8MWeUDZ
V/2gZQlWjyIr9fr4i7NK+j8pZsp5Cf3SVq1t0IW5C6a8GVHlEj8=
--00000000000080dc150660014e66--
