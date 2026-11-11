Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794366404;
	b=ctmkdf53zV1UKG4p/SQgGDMCcRgC76VFYI92E5SsGGWG8rwgEkTUyC4L3ybms18WF3jR
	 IiAJaOa0t1fq5yvmRdd3OjNl6vlhv6i4duBEs19WoEbG49JhAqv510W65XUYAna/WoViH
	 46n5WvpvD3ES3Or61LtVIgPrHhfNrjvO01GD+0ZWVBPBH8PDMKjsbXIdY8BfowTTyelFU
	 0qOI7pXtNjK7+xTtrVQ83AtDK2s63pE1cV+ezuM+jC1zVvIymnYSYzGxIaddvtco2jMPV
	 pJ976pI8tVU7flgBcSyhsJ0YHA1TSZAkUA7qDJWI/9g/7XYAc5HlcHBOPtv3jvNgXjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794366404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mLhyYGCVTORdd4WihP4IIQfVXI++QSCchObfVqbadWA=;
	b=eCzWIXfaxPDhQwXD+BraduF088lW5MuTeNVyt9a7S/qb8j9nEe3SQ+KhvBDrflxjYLzz
	 nlaaPJcrCREse7K9dhUZsPl497KaewcnCF4yuBtOhzGAtXQHq16Fhf5imhqHAFMqf7qvP
	 kWBfLCF9PGeG58W9bVbEx4SITiVS7605gArlhR70CahATR/Ug/Or4bhGGsAt3MoizAmDQ
	 8pJNUGjo77rpsjXXIyIiHAKahQFgIF4zpg4KN6OoONVL4JlpgX9MMKhRliMU448ZjcIjS
	 LwXa+k6z1Hok8zCV238yVoFVcjknJu61rnp+INeRssFjbaov7rGxNSornXf148w+VBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W7W0MsWh;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815F2606A321
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 03:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 815F2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W7W0MsWh
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b16896b8ceso861209a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Nov 2026 19:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794366404; x=1794971204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mLhyYGCVTORdd4WihP4IIQfVXI++QSCchObfVqbadWA=;
        b=W7W0MsWhl2pdpNVYjWLOyyPFheedfMFbCq2aybaSoFL5RextMQgVc6pOy/1WqmlFDC
         K0TPARUDnzD3ilY7LHrBTMS+oRCi0LKl1GOYON41ft9nx3sGcLgCr2hfXJLs15eAaBJq
         SWv5ExgvJDJZQJwicIW/PRABJsVsET3o6my4ONLHK3o2KbKrHUkmwIOeYIxp78YSNXqN
         XPjkS5kjqi7LOivq2fbzhJNsBq3wT0SIumqqiIqk3qVDaOCMiji/Zm8lnydN2S+CK4bR
         bF5jRkco1p8NJgeeqW8Ahy6T5OlbhmIJ7n9rMUqvdKqHKozwmPyY7Zgs9QJigdXuRhoP
         4yZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794366404; x=1794971204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mLhyYGCVTORdd4WihP4IIQfVXI++QSCchObfVqbadWA=;
        b=2JUJLbzD8QWwto2aCL7j57Rm/P4zVSIjg/ECeJz5rNjS+dldpBk2VjKYxXblQMUHd2
         ao65kNjDCeJ3egvRp5gASYD6ObeCyJXPOW62wMacebakTz8AyFPPXTluPyEZRpXspS4n
         SsfxlX1/FD2GNnRxvWFKwI103JU1isRmQLEM1RE38SM/TiGk84bVZ++EejY3QYXfqmCM
         0jqezkECkcrQdEmyoWpbIIaUmMMLYykF+kRaY6c8rc+zQSvcLPkUu8fc3vMFc4x84UHW
         JdflUe2n2gD10HLk5KCFMjx+3g3NfuJBFtU0epy+lM/ZCb2K75BxTjbrweL7joPEsBSg
         1XLA==
X-Gm-Message-State: APuU4Z9K4JJOK3AuMyTL1vj+SBXHZqk/U1671kdYVyGAx8Yf4SZDe8h3
	ttLN3+j0hnD586ENuARg/4mR+CGvREVW/0s4eOGNcuwINmJGqr3k1Y/1
X-Gm-Gg: AYBFou37ktkZPXgXHPIoCHNMwBf3GQ2Fo8s+dWF79PW5IvWnZtFvviXnOqdEQVHeD0G
	4qE+2T2Zls9/fvWhDTYAYYWe22amE7MjVH5s9Po+X4jIRRYhOiJvHqvjNZFoGwoNsXuNC32VsCN
	eFAKxD3oYv834iLHAWJ2qCrQiT+o/2klDKYDXMlKe/FLUBCVIi54YnEAAeBUo1psbShrQaiTSjT
	lfgXY/KgAf1MZ6J7Aoq+yZuWGcB7RTFFuPTyr0EVfR78ZMJNyj1T8X4cizUF+JplpatvemJw6fn
	QP13fHostnSq3q16+WoZGWTniz4fiIenzpiY/6JImUW58hx2ME6qULP3e0R9RKAVuyIPvUh4cBH
	EVx5tFDnY1futXwwR8SgD3yd38AHIKlIYBlCfm2ml5Zy5J23LaHex8Iw6KTEFittYnAvK1+vO6V
	+DelmLfZ7qd1SytZB499AhmpfB2mQBxHUgAqqydrNfPUz5FCtp5F3I5se+uUoOvQgqYIXggvPa9
	0FohW5ShTqVsxdRLCpTqMbB+ekc4OLPy6bvqABRmIV4oDuFxbllExxsxQF9em+gR9K2Bh5SN5FR
	eXLQRMY+n8HC0BnzwllwqHeqYCjNVpJTIBmitgQfnw==
X-Received: by 2002:a17:90b:2584:b0:3ac:ffb8:1809 with SMTP id 98e67ed59e1d1-3b182f3eec3mr934352a91.39.1794366403744;
        Tue, 10 Nov 2026 19:06:43 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b181f9873csm667757a91.1.2026.11.10.19.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 19:06:43 -0800 (PST)
From: yong liu <pkfxxxing@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v2] scsi: target: Disable protection processing for zero-block commands
Date: Wed, 11 Nov 2026 11:05:43 +0800
Message-ID: <20261111030544.1216434-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109092744.822646-2-pkfxxxing@gmail.com>
References: <20261109092744.822646-1-pkfxxxing@gmail.com> <20261109092744.822646-2-pkfxxxing@gmail.com>
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

A READ(10) with its TRANSFER LENGTH field set to zero on a PI-enabled
LUN can select TARGET_PROT_DIN_STRIP while leaving cmd->prot_length at
zero. transport_generic_new_cmd() then allocates an empty protection
scatterlist, causing a target-side Oops, which can also lead to
use-after-free during subsequent iSCSI connection cleanup. A logged-in
iSCSI initiator can trigger this on a FILEIO LUN with protection
information enabled.

After validating PROTECT, reset the protection operation, type and
checks for zero-block commands in sbc_check_prot(). This avoids the
empty allocation and prevents backends and fabrics from selecting PI
processing without a protection payload. Preserve the existing
data-length adjustment for commands carrying PI over the wire.

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Fixes: 5835812f13e5 ("target: ensure se_cmd->t_prot_sg is allocated when required")
Cc: stable@vger.kernel.org
Signed-off-by: yong liu <pkfxxxing@gmail.com>
---
Changes in v2 (addressing sashiko-bot's protection-state review):
- Replace the allocation-only guard with a zero-block protection state fix
  in sbc_check_prot(), so backends and fabrics do not select PI processing
  without a protection payload.
- Preserve PROTECT validation and the existing data-length adjustment.

Developed against f66469d9905b39d2c260a15d7d6db450f4db67c1 (7.4-rc1).

 drivers/target/target_core_sbc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 21f5cb86d7..560e62cef7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -721,6 +721,12 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char protect,
 	if (sbc_set_prot_op_checks(protect, fabric_prot, pi_prot_type, is_write, cmd))
 		return TCM_INVALID_CDB_FIELD;
 
+	if (!sectors) {
+		cmd->prot_op = TARGET_PROT_NORMAL;
+		cmd->prot_checks = 0;
+		pi_prot_type = TARGET_DIF_TYPE0_PROT;
+	}
+
 	cmd->prot_type = pi_prot_type;
 	cmd->prot_length = dev->prot_length * sectors;
 
-- 
2.43.0

