Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794975246;
	b=LSp4F6GOpyjjW55JVIDovIoVt6fyh3yikc/rqDyvplYLb4f9Fke2JBY+I/YyUWwGZJDV
	 PnMOnXRuMXvUdW4MuibgKMMA7w4cwYpHdNAfUDrRdVIiFFvFJo3nUqFI6fxNovVBPiCYe
	 Z3saANyS+EzYlORQ7hMtXEW5xo+qx1P6uy2NTrKsYlC0FIUIAMCQU3G21RIb0+vvKI58r
	 j+8bJZhbsm4I+KC+spToCpYJro1KLo/M9Kx/aPiY2zdqAgqrG4P3hfokrqRqNFaQU23S5
	 SKiW8mHjHRj2hUHqdyfAugid0GSG8K55Qudf6irCWuIvzG1lo37xUJFChvouizyge5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794975246;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GPG8lOcLulms/jJaS3g/L2BNHyItP4cf5yOKPILINFI=;
	b=Z0e6I2rxxr4o/tzNrnXIwhrzoBqfWSeN1RqdQGLSVUNv91W+HoiQFf8t7gxcqkPdlvDh
	 fYLgc5F3c/4YWJFT42+wVj5IJfYWljSH/p5ME9RTJz3RSlHZLITUQG1kZnRL39APa4hvc
	 x/+BZkHa6CUZoSWCx+XjPPKvrCEq3fZUw1XYlTkmW1ffU94vAaolSjgwnTpjO7pE+0EA2
	 V9vdz1gkDBrv/y+BPBdQLSXNRvlu/KaMOvCr0bi5X3nJ0txu+RDwR3MU1LZojG4tWcpx7
	 WWvVnESdMfw/XRbbtXXDX29rr2qhnfH9avKeQHSfAPYmk1nl0iLBgzkwij3cBTWyshQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cvqhJdEY;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA36606A325
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 04:14:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ECA36606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cvqhJdEY
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ed2bfe3252so2134255ad.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2026 20:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794975245; x=1795580045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GPG8lOcLulms/jJaS3g/L2BNHyItP4cf5yOKPILINFI=;
        b=cvqhJdEYHrsoqlj7D/dBktgjPA41xa98nkLWQlnCpYhimNzYZmBJFMqmQKSEphE5Ge
         OajrsBz2EHcvI0aTqJYEeugWVzfsHPKjzP6ERS2dpiO6MI4L1kmkUe5iL0iPFCzkAtkm
         yEcHdHG9OSja21Jd4DCZmWBOdCjXoQ7QtZBpKIKa4yZcG7K81RSmiBU81V4nWDvWW/bK
         U29KZGDF2Tr0j/F6/kGiNs5MFpHSRd3ESFeqi+noKlJK+UzYt4T7DTo8Eg1jiVVhDIKw
         GkGnnpTMtEa95ey7mU9fq6kqBtVgD/IuA8MdGvbRJyGktekFLaWBRUxotFB/1xcYZzjt
         PTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794975245; x=1795580045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GPG8lOcLulms/jJaS3g/L2BNHyItP4cf5yOKPILINFI=;
        b=vv6X6MHH89elsOZqrhHWrWoF/lzpmgFRXpfx6C2BzO5ZjWZxnB2YMVMgVGUyaL74xG
         9YMwpqkemujBukPv9C39yTVADCSAHJvger+QD6gmte+Erhgzxog3wEb/OIXuDjjcITXB
         lW/saht9d1OeobUPFqgyS5QVZxDoCLPPzBW5+Zj1g9yu80/kbnYigJw1DrY3zCBrabL/
         XdNsoEWMfmQ5fv/wuU7DH2tq2QhFnF9tbZJ4kO6VwYozgWQp8tJGEq0N2C7ZyWakoGP5
         vKasGRiGdAdZO+ZBe0BNWZa47Pp3kqNYmchDw2EC0EG6k7aDkvFiigiiGVJFbCOBcP1p
         jmwQ==
X-Gm-Message-State: APuU4Z8+tz9BZCEL/jw03OzCWJO54RGzoNq9Fso1BQkH4bBCLgdpQe4V
	UDPFfCLNyV8jG4UNV8ADOoIOgbV+tlx19l7oxeWp2sICteN5HNioBh4c
X-Gm-Gg: AZFdTZethOFa4yht2CfUa2gTVyObJVk45i+1aAc7Kt1jOc4Mfj91c1SW/MaVrVxsW0q
	Vc6sb8KZ+xUtVyGYvjC5TMT62jWZ2yuIxj6pwwUL7nNNnpAq+UG8YHRZiJcjwtTCe4iIwLnvAws
	VhJvbUmhDhQRfvsu4yl8l2kku6NQQCnVsErNFsybw62AFHnp7c5SKusNqxjH9Op9S0Il0ylCniu
	g1zejJWoKRA+Y2fxWjTuXJ4E7SvvXSEugmp18Xw0dPCkCfYKxQ6QeNGh2AO9AeNaRbQSK01/sBl
	9guSwR7cH/kxhSh6kv65oqS054VqowCox++XSPYXs2ykpBnFXF3jmFumO7yy9YKjKKQDPJAL81M
	nrO0xt2nKtF+azB3zadalyww7SIWqaePSiW/XVgeBrruVdtunC7fYNJysw/d0D+eMp77lSxKpuP
	1+Ih2R6rKnMN48oOvUB2IRqtAhS3ed0uk3lNUafvWnJBOH21Tox04N4TKjbP09m8oNQYEITNjSl
	73v2FIsuGKCB/gTcOIgv1EZu2FqocOzfzpBEyNl8/NncgtwTPk87r+i0qIgSoc69ZMrIRnUFSxT
	D+MpjA5e9YSAv2Tz4YWqG4tsIoUhYiGn/SZqtpuMqeo=
X-Received: by 2002:a17:902:f70c:b0:2ef:e130:1505 with SMTP id d9443c01a7336-2eff72ea971mr12502285ad.10.1794975245258;
        Tue, 17 Nov 2026 20:14:05 -0800 (PST)
Received: from gmail.com ([2407:cdc0:d002:0:188:253:12:32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214f4dsm5728685ad.43.2026.11.17.20.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:14:05 -0800 (PST)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	James Bottomley <James.Bottomley@suse.de>,
	Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH v2 2/8] scsi: target: keep REPORT REFERRALS stores inside the buffer
Date: Wed, 18 Nov 2026 12:13:05 +0800
Message-Id: <20261118041311.19011-3-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118041311.19011-1-physicalmtea@gmail.com>
References: <20261118041311.19011-1-physicalmtea@gmail.com>
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

target_emulate_report_referrals() checks only that the start of an LBA
field is inside cmd->data_length before storing all eight bytes. A
short response buffer can therefore make the store run past its end.
For example, a nine-byte allocation reaches the LBA at buf[8].

The response builder must still visit the remaining LBA maps to compute
the reported length. Encode each LBA in a local array and copy only
the part that fits in the command buffer.

KASAN reports:

  BUG: KASAN: use-after-free in target_emulate_report_referrals+0x100/0x380 [target_core_mod]
  Write of size 8

  target_emulate_report_referrals
  __target_execute_cmd
  target_execute_cmd
  transport_generic_new_cmd

Fixes: 38edd7245771 ("target_core_alua: check for buffer overflow")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_alua.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 140154d93c430..c110914b7b78b 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -49,6 +49,19 @@ static LIST_HEAD(lu_gps_list);
 
 struct t10_alua_lu_gp *default_lu_gp;
 
+static void
+target_emulate_report_referrals_copy_lba(unsigned char *buf, u32 off,
+					 u32 data_length, u64 lba)
+{
+	unsigned char lba_buf[sizeof(lba)];
+
+	if (off >= data_length)
+		return;
+	put_unaligned_be64(lba, lba_buf);
+	memcpy(&buf[off], lba_buf,
+	       min_t(u32, sizeof(lba_buf), data_length - off));
+}
+
 /*
  * REPORT REFERRALS
  *
@@ -88,11 +101,13 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 		int pg_num;
 
 		off += 4;
-		if (cmd->data_length > off)
-			put_unaligned_be64(map->lba_map_first_lba, &buf[off]);
+		target_emulate_report_referrals_copy_lba(buf, off,
+							 cmd->data_length,
+							 map->lba_map_first_lba);
 		off += 8;
-		if (cmd->data_length > off)
-			put_unaligned_be64(map->lba_map_last_lba, &buf[off]);
+		target_emulate_report_referrals_copy_lba(buf, off,
+							 cmd->data_length,
+							 map->lba_map_last_lba);
 		off += 8;
 		rd_len += 20;
 		pg_num = 0;
