Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794216549;
	b=WGNnkzPxVTswPagiQOAx2neyUlOkxjTQnAzWpht9jg2T+pX9B7rFqlRZiu3lCTSPduKp
	 FxLmNql0ipAg4Y3ogaIoMMPu2eMyvy+UbvsfEkwnU2slbllzIEoz8FimHt9FI5YDlTTg1
	 9tdFi6Fpu3crUh9LUY9BXkiuUbJtNMaqjQNYmDLu6wFQ01k4FRxIpQivAefOsfHtbGTyq
	 Nt7kyVKUlbcdIvRV6/270M+46UzbXlgx98aqmG1C3IWL+CPkB7IMqqRQwNQz6w9ZORwbS
	 p5EjKJguPd8rzY9I+xURpZ1ZsO3KnTlRaqJJO4eWEpu/f4Y5UThOE3jzNxijWoT+mhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794216549;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MlPpXHGQmMTRzRR6JQE6PvYGk6NnpKFFc4r+AoGuyFM=;
	b=Gdu2YBz0R9uVErShOnAkwdh538+GPNy7VVlT3SF2h1Qr9AADXKpHSzHgmJfDYIWRm6N1
	 FKVMaEj8CnJhZ3ATJjwz44RpVXlj8nlv/BUAFJn0Lwd5yqp5GoseShFX3e1d57TNPvPs4
	 NcR9rrCeLdjwjLUk4ZlsOdH09IUAQfx1LRmtSzx77Z+TTvgkJ3/Z9ZQHqx+QfqMDg8aX+
	 JcUyzZHZDU/yWLhMj/q8dlJLkI6NyBYD3bsY2dNHYDSek4vD76rUIMvi8e5DEaC8JMa7H
	 mk/AMjIHpNeDoyrSHbSt0fqxOB8d95bs4EAiuiMpXXHLOrQPd3hkkbK/RRgI10TOtmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VeDMrrGP;
	arc=none smtp.remote-ip=209.85.210.171
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C213A60A5BD7
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 09:29:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C213A60A5BD7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VeDMrrGP
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8b3577deeb0so250046b3a.3
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2026 01:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794216548; x=1794821348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MlPpXHGQmMTRzRR6JQE6PvYGk6NnpKFFc4r+AoGuyFM=;
        b=VeDMrrGPFDw3Ukg5QkZBevZ7ryDTXO/KoaQ82CprffedrPD95w+liomfeUNXGv39YJ
         9kN7Hhc6Hf8N3Oiod/8nmzJYaV/5+Yf11Af/sPoWf8KYgri5UEBsnJYIJu555UFN8ary
         CbExgPkfvUymOFthnbocOVvddYtUO+O0kuDsAEItYBsXDfEeVIIRrdHxzvWXd0oeRVQT
         NHKCpB1U3Tf5aKrc0vropD+0vVgBo8KsAzUpqXIhAWn9ozX+40dvi5xp9CJ4+b5UcOj6
         OHhFzixk58HURo9bgAbQXfhCr4MrE01A3FnoHCKZlV6Sj2KoDT3Yz560DbdMA7kedj7C
         PHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216548; x=1794821348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MlPpXHGQmMTRzRR6JQE6PvYGk6NnpKFFc4r+AoGuyFM=;
        b=upHjJ4cYAWyMEUg5CeGM6EWDRy7aQZYcXcMeXx6x0jIkASQLTzUS7LV1ugj3HkkhIN
         t0PV07seNXvTBD7vIFdjl4kpjM9yyEvQR2mr7AHcpfH1GqB3niqbZuAk90ZBmDCJ4xam
         okBoNEi824rXePutUFyTRKz8lwuMxAserQVSDVfw7MBCFP8Zc8vCDLmMVxs6bl1w4Aov
         d5cQJTU2sQwwuhWOJvx2HFjyrbIrEPAagJxQ8elxDBvecLYluqjaMIoAWBWsz7hx0x0v
         OxhS9ChMXvIdyq/TUnQw1fgqLqHvD8Rwsg+PZtfHx/rgrvFC9QcxqNiC9TUI7wVknKmC
         H8ww==
X-Gm-Message-State: APuU4Z8aRsVGqeG8VIV/BH1MV0/sXvg0Kl0xDd7s6GsjTpsgB9+Jao5h
	ViL6qyIrV1flLfXrQ1u9UpfOUZup/rZjBVQvMG416aOYlWfCCeGv8th9
X-Gm-Gg: AYBFou1uYb3X1VTyqmdlHn7k2OR0YgQL5MhYx9byAJTqDAfcrgC9vFV7F4VGIOKZq3a
	c4VsjCSXsEbTr4lxQoOYCvEIxz5Wvp0mgzWsxe8cGEc4xm7NV9UbUoq1ppK1EkMrr/Pc33zALJy
	HU2dpm5p2KsqvadKy83NG+8vgqc8Vai3725ViT9iBpTq6+hPsJusxDeqBQrRd1gci+2rAuc/yhJ
	eCXaLVTuUngsD0rGWzfQk4NNxJajRZmeIwu041yUTYgTJ5OCwjlAUGEeF2mJ0NiojnBUKrVvdVN
	8BSRtSv1h7AmCTJSPMNLnCFEHnIBU64CwKw0OukHNHOrMj5DtG1/ceaNXbJseYoOPxLEZWR2OFY
	dWhG/iPOApiR9GYPJNIaeTcCcnGLmFfsH5uCF7ayPCIvQ2glb7Vj1N8fdm4fPtzIr4Bl7TqTrAG
	stCRsEMBx847jPLFbLLS8nRCy9qI0RjAE3KikWt1fMAzLATxeOgU7cdbv9bX0zd7CPMScknffiM
	rz4IdDMzkd45i0SSNN4gZE1dAWDxAd5h0LRBHedIzfkhmQEjACSYbAEHpkenEKWoyTJKDglNEhb
	ve9LTXGZOB1Bp2cMPWnyNN/VsJ0k9E6cQasPdbxF3roDuQzOZrNtnfXUVYc/3QA=
X-Received: by 2002:a05:6a00:13a1:b0:890:bd5c:5710 with SMTP id d2e1a72fcca58-8b6717aef6dmr2691634b3a.41.1794216548030;
        Mon, 09 Nov 2026 01:29:08 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b648e55e85sm1103778b3a.17.2026.11.09.01.29.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 01:29:07 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 1/1] scsi: target: Skip zero-length protection SG allocation
Date: Mon,  9 Nov 2026 17:27:36 +0800
Message-ID: <20261109092744.822646-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109092744.822646-1-pkfxxxing@gmail.com>
References: <20261109092744.822646-1-pkfxxxing@gmail.com>
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

A READ(10) command with its TRANSFER LENGTH field set to zero, sent to a
LUN with protection information enabled, can select TARGET_PROT_DIN_STRIP
while leaving cmd->prot_length at zero. transport_generic_new_cmd() then
passes that zero length to target_alloc_sgl(). This reaches
sg_init_table() with no entries, so sg_init_marker() accesses an invalid
last entry and causes a target-side Oops, which can also lead to
use-after-free during subsequent iSCSI connection cleanup. A logged-in
iSCSI initiator can trigger this on a FILEIO LUN with protection
information enabled.

Require a nonzero protection length before allocating its SG list,
allowing commands with no protection payload to proceed without an
empty allocation.

These issues were discovered and fixed by Qihoo 360's Tulongfeng
multi-agent system.

Fixes: 5835812f13e5 ("target: ensure se_cmd->t_prot_sg is allocated when required")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c30..4cda1e610 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2841,7 +2841,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	int ret = 0;
 	bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
 
-	if (cmd->prot_op != TARGET_PROT_NORMAL &&
+	if (cmd->prot_length && cmd->prot_op != TARGET_PROT_NORMAL &&
 	    !(cmd->se_cmd_flags & SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC)) {
 		ret = target_alloc_sgl(&cmd->t_prot_sg, &cmd->t_prot_nents,
 				       cmd->prot_length, true, false);

base-commit: f66469d9905b39d2c260a15d7d6db450f4db67c1
