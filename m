Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793496380;
	b=br3lqPM0eCBCqnxzJ8YMy/pi2io2qVgIfDQMySAcLsI/1+wpK0uN7RpCZj959qq65NUS
	 z5LyYMeYsrMU/w69df0soeWyl4Xs40Ubo/XKECIRPDRXL8T2E489rU/aYjP2aBxdLT9Bq
	 U8pcWZwFpW+OgS4hX/II4Tugs/8zAf9BwM+9QQ1qc3dM7tXmmM1ZhYicrbb08IpG9GldZ
	 ayv+lB74XLDhHg6yBuV3KhfBdOEE+iY9Y0TrMPDj9aY7bOzZm3+SoOlWkvLOkVh6MnVZs
	 sp80T+8UBoT8kNMtfRUpQpN1lbCpmotSJ2LRSATYkK7ixQp8pkwWp0YFMs23c7sQFIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793496380;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Sender:From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=YIO/wuqnNRfPuoyQxCQ5Pvo+F5MRblOAdwgMq3xL4Lc=;
	b=V879Y27hiDnRg1zYgCLLMgL8tDs77CmSfHc130Eg2vNH4r5OKoXqByk7XPDy6CT/MKR4
	 ZqvHj7L3W8SbF75MzlheqYO/WELrm6XqXPtL9ggWXeHm1l/cV+IKQ4sc81M3nMMQ2UOi6
	 l/c3hd1Mypt+H6PMg5kwL+1iTWInPtosvk8xJQb7ZsDe8sAcMeCxpUEmgRMMmJ0mQABA3
	 Epx5mW8V5psT6/iA6yxSXhyXMcENaVNp7KPWuM7fN5DgveiSPRPQxb9wWYsryCmkZCBf2
	 /8gB2d79fon1BptPWSDFvPHIass7VxT6J+sSBsOxdFcl0APRa+XJXXM8nfmppCHmSow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NZdzdKzz;
	arc=none smtp.remote-ip=209.85.217.51
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF1E606A31E
	for <linux-scsi@vger.kernel.org>; Sun,  1 Nov 2026 01:26:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBF1E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NZdzdKzz
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7cc91ddf447so670497137.2
        for <linux-scsi@vger.kernel.org>; Sat, 31 Oct 2026 18:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793496379; x=1794101179; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YIO/wuqnNRfPuoyQxCQ5Pvo+F5MRblOAdwgMq3xL4Lc=;
        b=NZdzdKzzFe070I/A4X0Fc37wFboISxd+dXeprLXL93hPsdzyrxnOaSYC/oKSwdpRBm
         lpn3m96r40JJqJzs89RLwlSccm9pWzFYp/Emofr0XL3WgAQ7UlSHV8dfA3KNYpWvX+lK
         wgkjgGR/8jfPobWkC/VnLPZHmkOS7JyCD9b6AoIPE87MXiquya17jytSlyBh0lS9Ii1z
         6eLpAa4nDORZ9DmL5U0qabmWsvJ8r2n242dLo565TSVzWBbaeWkXZ5M9gghEhvX8eIpS
         UsRLUsJh2hAj96GuQY74YSZnzPsQcWumuMikix9nioU3RlzSJdu7NLcjsL+Pz7CBOjdj
         7fEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793496379; x=1794101179;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YIO/wuqnNRfPuoyQxCQ5Pvo+F5MRblOAdwgMq3xL4Lc=;
        b=Q4FasrDSAFO195SgKOWXoB8JWJ8VcxakMUPxJMy0nwvtfNrHcFG3Hay9YBzv1qdYKA
         2neq1vG1jE8+GeK46fDXyNjg5PZlZ/qH3DkYzzqAjDauZrgAqz4T+NBlUur0mZDIUoLG
         +VVmfpOnh16SLFK3G/3x+07Kq4v/Nj9TS8GLgvO3tOMVDwaxsPX39qY5pGRwbhspRlZB
         3cPLvjkMToJIKGxH6QqHEEWaL6A0yKJguO0qGUD8o39ffXaAetUmQlyq+S9b1VfUkkXb
         5PrSIpd9T+35cQrmoLDEUuRynmdz9oZKispALhz4HekzTVifQ01DEEgGTFkCCKB1eN9u
         ZeMw==
X-Forwarded-Encrypted: i=1; AKwUvBysCtXa/jU1eTaqUk6fwmZwMxEjR5Y9nhph/Ll7bT5FAWo/FPw8os9OrJpPfUrCo9n6N5Ye8X3dDGDe@vger.kernel.org
X-Gm-Message-State: AFq9FYJL+zziSR4YyvTBiJOF8JgegbtkxNVrN+ogDZBuXG9aSX7Fl+PR
	rAmnhysu5Lalm8G64pvh7/9CVu6V55tJM/ivGGmZvywUncoGnvuA7B/8
X-Gm-Gg: AYBFou38owak4LLzcY7SjVIBkQJDvPOa4cId6FFJrgIJViIQ1SCdzFrNUtu62/6Ws5x
	oqJctdKfvZ2KUQOR7rpwRT1LU4XxLbOwWuSLrHgOX4al1eE7rM9yFwsfWrZiOgbuxcl7gdIyYk7
	OcEDpPN8q5vK2D0uDH9jgJZWQyNGygE2A8R/wUkRrjCL/AtNbfE+MY7qzoCGUkMV/htq6rOsq0m
	xD9JqKzYsYASCozNgjqhqLiVs6Rgfq09m2gnPABp56JoGPqhPFFP6rKF1GADKXaKCZ7hlV05+D8
	W2fO+2Xx47ftU4rHTsySL75QI++4Wn58v+998vtUlKUF3AkZOxrxvzjUMqEoXrKOXNk/LbAxgi9
	M0RRNyA8PkrgFnwiwSxUNE89kXIVLPzEhaGTbd3xlCuWF3RJUVpfSOdoUUvfc+x/wSU6Nx9JbH1
	z6GiN/3ZEMvclX6rChT+phsPwqfhTK996mD/rLFoUEVeYKcWzbhHCyf/OEWIFN1GLKIItp7dfHx
	8kL4n3FLxr80lpivkWOvYv6SnR6gybFWIQ0lLYEvwiGZAiJ507lqu1gnggzHHqBNDP6gbEmew7v
	C+Pv1tlvqQEn2g/r/i9bqouRgBnB99gj14hVGt6mW4aKDrD/u984yG80rh+vCz4e7wZMytTXjQ=
	=
X-Received: by 2002:a05:6102:3309:b0:785:c39b:6a1 with SMTP id ada2fe7eead31-7d072636f57mr2626543137.6.1793496378542;
        Sat, 31 Oct 2026 18:26:18 -0700 (PDT)
Received: from nb-x1-03 ([181.120.144.175])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d07754c1c6sm7089367137.3.2026.10.31.18.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 18:26:18 -0700 (PDT)
Sender: Ciro Iriarte <ciro.iriarte@gmail.com>
From: Ciro Iriarte <ciro.iriarte+software@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] scsi: target: core: Parse APTPL res_type and res_scope as hex
Date: Sat, 31 Oct 2026 22:21:39 -0300
Message-ID: <ea903e6c-09b5-4a11-80e8-6e1387f39ef5@gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

core_scsi3_update_aptpl_buf() saves the reservation holder's type and
scope to the APTPL metadata file as zero-padded hex ("res_type=%02x",
"res_scope=%02x"), but target_pr_res_aptpl_metadata_store() reads them
back with "%d" tokens and match_int(), which parse with base 0. A
leading zero selects octal, so match_token() parses only the "0" of
"res_type=08", the trailing "8" makes the token not match, and the field
is ignored as unknown. An Exclusive Access - All Registrants holder
(type 0x8) is left with type 0 and the write fails with -EINVAL and

  Illegal PR type: 0x00 for reservation holder

Userspace that restores APTPL state by writing the saved records back
to pr/res_aptpl_metadata (rtslib-fb does this when it recreates a
storage object) therefore loses every type 8 reservation across a
target restart, and with rtslib the storage object creation fails. The
other valid types (1, 3, 5, 6, 7) and scope 0 only work because their
octal and decimal values coincide.

Keep the on-disk format and parse both fields as hex. The valid type
and scope values have the same hex and decimal representation, so
records written in decimal by hand keep working.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Cc: stable@vger.kernel.org
Signed-off-by: Ciro Iriarte <ciro.iriarte+software@gmail.com>
---
 drivers/target/target_core_configfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 2b19a9560..a45bb3d56 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2126,8 +2126,8 @@ static match_table_t tokens = {
 	{Opt_initiator_sid, "initiator_sid=%s"},
 	{Opt_sa_res_key, "sa_res_key=%s"},
 	{Opt_res_holder, "res_holder=%d"},
-	{Opt_res_type, "res_type=%d"},
-	{Opt_res_scope, "res_scope=%d"},
+	{Opt_res_type, "res_type=%x"},
+	{Opt_res_scope, "res_scope=%x"},
 	{Opt_res_all_tg_pt, "res_all_tg_pt=%d"},
 	{Opt_mapped_lun, "mapped_lun=%u"},
 	{Opt_target_fabric, "target_fabric=%s"},
@@ -2229,13 +2229,13 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			res_holder = arg;
 			break;
 		case Opt_res_type:
-			ret = match_int(args, &arg);
+			ret = match_hex(args, &arg);
 			if (ret)
 				goto out;
 			type = (u8)arg;
 			break;
 		case Opt_res_scope:
-			ret = match_int(args, &arg);
+			ret = match_hex(args, &arg);
 			if (ret)
 				goto out;
 			break;
-- 
2.55.0

