Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795207816;
	b=jW9gsiHpPLXns6L2q+Td8eC7PZ2E5JQ0oA66OEtujQvz4v5RtNvXFhTTOy66lIX5d8Ez
	 JXXMrpfHlOZaIFoygXk8Cv7UNNvoxdNuu9tb9p8d1TOWrqQdfV7SHPB6XdT/22PocePMa
	 ahBtp8rNaBTjRPthO4xQimoOKOirJBxqiIb4/Tjf+vbFSVFFnZVM5rf4aoLQQMv2TTAKx
	 dh4DvmXFSF4b/JaRaIzMIK84iatThe88UiMvu9HIe5eikOYJNZ686CjNMfmetZ7nMSpDF
	 HURTCUcMzrM8kk1HIFzptTb02kmtUkSPalQ6AhDDNuc7cMgfoXXsP2jne880878YzyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795207816;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:
	 Subject:To:X-DetectorID-Processed:Content-Type;
	bh=rWqNDrO7z0PyY5ybU5cYcdoNoGnK7+1JPqZ17eUTuHc=;
	b=IbOYDN5MsQ1ofYLCkT64GSncogkBV8iBb0RHCgqKRkChmDjiLSsBi1Y3T+Pmlyubvpg3
	 d14Mpzja/LK3cEnU/FaOPJKHCwnYLq2MoQ11YZ9oPsDi4LM5oUKr2/jledOH/2rJ1X5lm
	 K3MHWSgsJF1YZHu3m2Rehk8GxBSNcmDSg1WWTQ2eSyrL+wnjuL3WIvVHcMekxvtiwHMhU
	 7lXVFzPI3xiBj/5f0YusPFjNab3Jzo4et7fiI0AI8st/AbF167g2Bqul3u0dO1XEeuXE7
	 B2elvsLE2rarLRL+Y025eoRtk+/9jbbHXIy7AEpzpm2+VQlNM30q4QPgMCXhP4Wqr1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MtGf7vJc;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4385B606A688
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 20:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4385B606A688
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=MtGf7vJc
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so733507a12.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 12:50:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795207807; x=1795812607;
        h=content-type:to:subject:message-id:date:from:mime-version
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rWqNDrO7z0PyY5ybU5cYcdoNoGnK7+1JPqZ17eUTuHc=;
        b=BVm50qARyzEjud/rRGnlk45/0ajRiR0/To/rD21230qv6Va/DMZ8zL+ol9GUiEQdLK
         4y6V158easu0u92d4n9c5TQLs9a8SPnfRRa3PczqsbeBhyapMTexuiT73GVwl1t6wUXk
         XCLU0m0oUpvf31CzppSr6YXHogz0GcbBgzDT03jPHKxtriWPlgYsV1TvjfHmSa1FoWP7
         Ao2EMHdGZaJr0gMpG72aVL8UwvBHMGJS+7rvUAkC6c0TaEzHZjBk0I1RSnNipVjtIzqD
         JAKisxOUBBoQQkvBQTpSTBsgM/Fsyu8Qrh7GN09u99CWu3t6H1X9h2dsagvsVdEegvcw
         Up7Q==
X-Forwarded-Encrypted: i=1; AL+hErEE85IjnJYSd5/kIN6SN/pR65vwp0UZs+4E7EVS60PkID4sjTZJvtYisfFUXt03+FCdeD+4x6OWiNOw@vger.kernel.org
X-Gm-Message-State: APuU4Z9LBTqtO3eI0uH2SdevlDCkSJukeV314ZefI6fJ4i97EArnBzzO
	/qtN6A4K21EYdhEHUW1v0mzumSjigt2Z8XotL1CJWbxp4QFZ0R6FZpSvyXx7qQuDAEAIVvh9aSD
	0y/yz7V3HiOGq4tBF7E42qJlEJOXydRMMVeWj+AXaccFxHAfo94r9hhbp9ONk1kmb0DUumT09oQ
	Ju81AaBsElTre5D/6ztkti6rgin+dQpmpEmNf9AaE35KBy1vjljt8k5JD7ZWvMVoy8KbeOtFEov
	R+Z4rnnm4I=
X-Gm-Gg: AZFdTZdjKw3YVDGnFBmTAS+3vcSLNn4nq/QvPLCazzRA5L3tNe32Zeao0m028tHneGq
	OWEIuEGO6t5rnc7aSuSwpQA+Ikj1WsG12OWtEgbPQAyOkAO0EdiM/ZOFdml+Ai2W8vJDrVaXKjz
	liXmDxq5SKjSHw+0TyD7d3DXeMb9NG356sU54tscktjsDhR6nthYqNqwP8ltKKIOwn4nGtqqrJd
	RcYkY7G9qrlRN0Ye8XZdISQgOzvd0fA6a8bkpNNwkLoIF4Yez00wfzVKvTyr147MYxU8v5Se60O
	YjY0D12xnW5efc+ORx27NaQNmdTDgwVJQw1cg1o2tHdk4cmLmCjIQ2qrABUL00+pFu91+jk9EVv
	lRDdXRi4CsG3BBXUmf8/ofnd9aKTYMyG8rlpPEZ0kQk7DxShCJCNHq2Qfri3XT+Uwc1vtH7sOj3
	LE2X3fq4hPLn11xOrADBfoJ7SnnsONAw==
X-Received: by 2002:a17:90b:5543:b0:3ac:6fcf:81a2 with SMTP id 98e67ed59e1d1-3b41cb33a0dmr3505744a91.57.1795207807392;
        Fri, 20 Nov 2026 12:50:07 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b40625d66bsm3762994a91.4.2026.11.20.12.50.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Nov 2026 12:50:07 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-8b0cfe694c3so21436917b3.2
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 12:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795207806; x=1795812606; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=rWqNDrO7z0PyY5ybU5cYcdoNoGnK7+1JPqZ17eUTuHc=;
        b=MtGf7vJc9lreRwZDVwq1TgRpAV8Qh5EYBV9VEzcPAuOcoIfTDB5Fmt3clnRJd4gYGi
         M6Vj3116BYIIsmMoAAQg6tAqnYRKopacqMsEiXpeqKZJlFYhLVt0mbei5n8YAjZPV/+U
         lYLqBVDksG+qEGz786H59ZXAhj4y5hEFZvrNE=
X-Forwarded-Encrypted: i=1; AL+hErFIPdykUjxM7rrdl0e3ERcc1+YMLeHD1EEtyRFXKnU0ze09IuUMKzOf56JLi7UnC4t0aP8vv72iBd6e@vger.kernel.org
X-Received: by 2002:a05:690c:e908:b0:8b3:3956:6f7e with SMTP id 00721157ae682-8b52043cdd0mr18592917b3.12.1795207806374;
        Fri, 20 Nov 2026 12:50:06 -0800 (PST)
X-Received: by 2002:a05:690c:e908:b0:8b3:3956:6f7e with SMTP id
 00721157ae682-8b52043cdd0mr18592807b3.12.1795207805966; Fri, 20 Nov 2026
 12:50:05 -0800 (PST)
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
Date: Fri, 20 Nov 2026 15:49:54 -0500
X-Gm-Features: Aa3M54r6QwEBfV1B6KlwQtAuN8l6g1Wkip5X_go3_xJ3QB0fmhCGgqbx6HtIxnU
Message-ID: <CAEQnVQmvXfXov0XmTNZ7V7iPhSUxgtPHJwC1o5HZkkwo0dozvg@mail.gmail.com>
Subject: Re: [PATCH] scsi: lpfc: Fix format string and OOB copy in lpfc_read_object()
To: irogers@google.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nigel Kirkland <nigel.kirkland@broadcom.com>, mkp@kernel.org, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000009d3d6d0660bb63fc"

--0000000000009d3d6d0660bb63fc
Content-Type: text/plain; charset="UTF-8"

From: Ian Rogers <irogers@google.com>
To: Justin Tee <justin.tee@broadcom.com>,
Paul Ely <paul.ely@broadcom.com>,
"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
llvm@lists.linux.dev, Elkin Cruz <elkin@google.com>,
Ian Rogers <irogers@google.com>
Subject: [PATCH] scsi: lpfc: Fix format string and OOB copy in
lpfc_read_object()
Date: Thu, 19 Nov 2026 09:05:00 -0800 [thread overview]
Message-ID: <20261119170500.1514537-1-irogers@google.com> (raw)

In lpfc_read_object(), rd_object_name is a 26-element u32 array (104
bytes, LPFC_OBJ_NAME_SZ) populated from rdobject via scnprintf() without a
"%s" format string, and then copied to the SLI-4 mailbox request with:

for (j = 0; j < strlen(rdobject); j++)
read_object->u.request.rd_object_name[j] =
cpu_to_le32(rd_object_name[j]);

Because the loop bound uses strlen(rdobject) (byte count, unbounded) to
index 32-bit dword arrays of length 26, any object path of 27 bytes or
longer reads past the end of rd_object_name on the stack and overwrites
rd_object_cnt, rd_object_hbuf[], and adjacent mailbox memory. Passing
rdobject directly as the format string also evaluates any '%' characters
as printf specifiers.

Format rdobject with "%s", capture the bounded byte length returned by
scnprintf(), and iterate over DIV_ROUND_UP(len, sizeof(u32)) dwords.

Found via an x86_64 LLVM=1 (Clang 21.1.8) allyesconfig audit with
-Wformat-security enabled; fix and changelog drafted with an AI coding
assistant. Verified with an ASan/UBSan C reproducer for short, '%'-bearing,
and >104-byte object names, and build-tested with LLVM=1 W=1 and
-Wformat-security; not tested on Emulex Fibre Channel hardware.

Fixes: 72df8a452883 ("scsi: lpfc: Add support for cm enablement buffer")
Fixes: 59936430e6a6 ("scsi: lpfc: Fix CPU to/from endian warnings
introduced by ELS processing")
Signed-off-by: Ian Rogers <irogers@google.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 9173263c87f9..26c9f5721340 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22259,11 +22259,12 @@ lpfc_read_object(struct lpfc_hba *phba, char
*rdobject, uint32_t *datap,
 {
  struct lpfc_mbx_read_object *read_object;
  LPFC_MBOXQ_t *mbox;
- int rc, length, eof, j, byte_cnt = 0;
+ int rc, length, eof, byte_cnt = 0;
  uint32_t shdr_status, shdr_add_status;
  union lpfc_sli4_cfg_shdr *shdr;
  struct lpfc_dmabuf *pcmd;
  u32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW] = {0};
+ size_t len, j;

  mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
  if (!mbox)
@@ -22283,8 +22284,9 @@ lpfc_read_object(struct lpfc_hba *phba, char
*rdobject, uint32_t *datap,

  memset((void *)read_object->u.request.rd_object_name, 0,
        LPFC_OBJ_NAME_SZ);
- scnprintf((char *)rd_object_name, sizeof(rd_object_name), rdobject);
- for (j = 0; j < strlen(rdobject); j++)
+ len = scnprintf((char *)rd_object_name, sizeof(rd_object_name), "%s",
+ rdobject);
+ for (j = 0; j < DIV_ROUND_UP(len, sizeof(u32)); j++)
  read_object->u.request.rd_object_name[j] =
  cpu_to_le32(rd_object_name[j]);


Tested in the lab and ran it through a different AI scan.  Both clean.

Thanks!

Reviewed-by: Paul Ely <pely@broadcom.com>

--0000000000009d3d6d0660bb63fc
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
L+YwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIIAZ0sLOMNADxA2+8wr2MblYhH/P
4416EuEoG1JMTuueMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2
MTEyMDIwNTAwNlowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAFMML3AvJrX12WIgrYCF+M6IxXlWKdyN1O5Mk85QqA59o/d4NEsF9Nclh/O75l82
+dFa6Oc4mseFFEXIL0Xoq3CGN0AUy3GhVI49EQcbtravOoin9sn7Do058u8tNopLHDyB+ZD8KS8C
sLWzVakckN1c6e2mYSN/eKEfWe2xqOywJJbEnKBhjiLG0YnzaeAm+xGD0PgafjRNNilZRnJXYADj
Qz1mGZV19cOepmyrN6LqaVtN1eGWjbH9vc2W57qyqFtrfQRIoCiIFNX4OpiIsA91blkq+pIGqq9p
eH7z10enJb+uhcQUQZBwPbUV+4ZXW9AfUJ/SAZKwnTcmoXg9a08=
--0000000000009d3d6d0660bb63fc--
