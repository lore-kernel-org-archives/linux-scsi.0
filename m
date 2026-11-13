Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559231;
	b=du+HPIbivKimVnk/Md0dAThF+RDoYSNVCylgRLdveYrt+Sz0ecxt/5tWrqNBLzb2TAew
	 dL+W1ZTWL+OImb4/a2nLr24UiFeTlPJuy7AXSH7ooTjkvZypsuAZnmmVpomj15BcFhogl
	 CNmHEejgKo2mb/9UNhpPzNDX1FG7noEP09peDkvCmYTdm718929hQ4zwiMZO1HG0W/V0V
	 DJxiSau1RqCLdoRVWSzlcT7mPLx6czHWZu82rs36AonJxreANMH+2Ak5pFueX/uTveFss
	 92iZWWCT4Oi07e0naGXOhu2rQtFSe1UNC3XhfeEn6TGzUJwhB4jN3o1eBN9Qgi1V9Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559231;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
	b=lCi0XyDkOWUD20X/n5stSyEC8L3dFtOxa28eZbSKlmfcD57Ul/++PVVf9UalBUJpRTRj
	 JP4OM94im9NHgYB4HhANNzQNUna9mr1CTyWXbZastylD29QSsVUUWZs6k3eKsy/EZrOhU
	 XjOWxb0lxWQBhxp/fD1xGr9bhXdE9sKphEWQwkplXbom1Haf4tInzITTbOKjSzCo95W/J
	 fTJw6aScgD88yJVZKW8tN1etESsa/ltZjoBW4HrcsehiGBbusDO2jURuJizEKYBA3OVFk
	 ieV2aC4jUkYYbnQtkjKYJC0HMN9FPQrm6H8gRCYM2QryVD3Qu9S5MW25k8BA3aP+2TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HFQ3NMFD;
	arc=none smtp.remote-ip=209.85.216.52
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E277606A8A3
	for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 08:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E277606A8A3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HFQ3NMFD
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b179528d56so277898a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Nov 2026 00:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559231; x=1795164031; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
        b=HFQ3NMFD/HeHqYJQZncUggUrOcMsaYsc6YJAUjDIsCZEZ99XBDbk8eKvWDF+Gnnrcd
         svJJ+NI70TLXlxc0n1QkUdGBFgOEAeAAGvKfgKVnZl+v92VHhDFwUFx4TBLOXVvLojUP
         LEeHLydP4SIxStMQasLl51rfhBqfGqbnVX/t31+VgC2V3srZjG78WS+xEx032q57Teu6
         Hwf4POH4kZXxDBFsy75EYAKphlXWF//aw+m68zUh5aRduOGg9nW4UfkfnUh2xIVQ42Nq
         UwxFv/yTP1Yf95db/kKvzRb8Yjd52tHxSyekeJBtDKAzgsZJobPigb34M/u+Vl2afuEP
         iaQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559231; x=1795164031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6HjmYTtzj67gEj1W3Fr4INGR7fSq4j0RNLKw8boe0iU=;
        b=yKro72WlYcZrqbx1OMZxl/v+3/H95JswBtttpweoyVTHUkLmYJl/p+IXK7P7wSB0Do
         /zGtf+AzTqHK2H2/BcsEf21WSGhd0TezlHaRjF1+/Gd9T/4EoKc7c8VZ9PHQy1s/CrIa
         b+Kz2XCh2gJOzItJTyOuRi/9FJX4o1I/hOY3YBHp1jc6CH72jSX7lJFDehZSkWhanFB4
         HbBO921TeBdBK0PT7S+IUFct5Y+8v3O2DRetl1jQLvuWPr3Q5vNtMCVlMVxPzUdTX4qq
         i5chuo9S1dDOGSS2iBq92CRz13U0nZMie7pj6WoZIitZe0uxIW4LnHi4FtcF+ouTMU8Y
         /mnQ==
X-Forwarded-Encrypted: i=1; AL+hErEcDwo4CflYgWBc4lJWiRZ93zDeuEmuG/C4JnHbppt9qeFUljHWmsZQvbWZRUMwOZjLwtApWLsrQQG+@vger.kernel.org
X-Gm-Message-State: APuU4Z+P7CDqx3LyUjRPNh5zjF15bZOOuyYMkSlDioaEc2aD7NNvFnka
	Yxkrg5Jz9XWOKHabPDMEBoBX623nOgxMDeZNNSa45CwGM0yowHKvirlU
X-Gm-Gg: AYBFou2ERBX5CRIG04MOe0E666pmMd0oKKv+FyYvlJt/pcmkNye26+oY8SBbLAdxfex
	AnyeQa/AqG0k46JMxfQ7G4tIp2G/XcU3KVsTUt1YFGLzV1ZPss8YpLOjQreyBnXvsPxvQhwLp5Z
	cbZfAjjv6epCTRhR1eIDRY49mOF60do017ODV+vMPnGBWrIsOBIhKKY9He+VYwpzgX3pYqFDAOI
	ZAEYQAjgx9dzNMRFzlQ3xFkg6JzxjMbXceCSqX/sSXk9ikQMrltsTbieRwNF9yVboSvr2t6Tf3W
	TvepzvTWnHDhaAinYTM2NiS7sStL2qddnjp6vPlrsPNCrbbYF/E5GXAFWsjCXhy6PPSTYpnR8vZ
	RG8IsQZop5WkXHTg/juzaByz9O1UXae/P2XO5Wlcw305forAEFS4ahsIcqLQCS/vC1pbxEbUPPj
	1lbHZTdHDVT/F8J5J+PsWzaOw57krQGPnnW8KtN6JzechixhJIyfod8COeqIj4r41x1MM7XAj1F
	/1W0KjQbXSNXUsKbqEg1CF7mnTlPI9LkJbbuQYDiYDmzJfLBkeWgopmCmgku9OA7MXr8w3qllX6
	qZi6mufhCW4MEYB1el13rRS883gtX8GiQ6D2sxw7zw==
X-Received: by 2002:a17:90b:4410:b0:3ad:818f:3da2 with SMTP id 98e67ed59e1d1-3b1b0b9a342mr1279723a91.63.1794559230508;
        Fri, 13 Nov 2026 00:40:30 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:29 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 2/3] scsi: target: Clear all control read scatterlist entries
Date: Fri, 13 Nov 2026 16:38:41 +0800
Message-ID: <20261113083848.1517595-3-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
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

__target_submit() only clears the first scatterlist entry of a control
read buffer supplied by a fabric driver. Control CDB handlers can leave
response bytes untouched, so later entries can retain stale kernel data
that is returned to the initiator.

Clear every supplied scatterlist entry before command execution. Use
sg_zero_buffer() so entries spanning multiple pages are handled as well.
Keep clearing the full entries, including any part beyond data_length,
as the existing code does for the first entry.

Fixes: 944981c7e106 ("target: Add control CDB READ payload zero work-around")
Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
 drivers/target/target_core_transport.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c30a..267f5e2cc8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1633,23 +1633,16 @@ static int __target_submit(struct se_cmd *cmd)
 	core_alua_check_nonop_delay(cmd);
 
 	if (cmd->t_data_nents != 0) {
-		/*
-		 * This is primarily a hack for udev and tcm loop which sends
-		 * INQUIRYs with a single page and expects the data to be
-		 * cleared.
-		 */
+		/* Control CDB handlers may leave response bytes untouched. */
 		if (!(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
 		    cmd->data_direction == DMA_FROM_DEVICE) {
-			struct scatterlist *sgl = cmd->t_data_sg;
-			unsigned char *buf = NULL;
+			struct scatterlist *sg;
+			unsigned int i;
 
-			BUG_ON(!sgl);
+			BUG_ON(!cmd->t_data_sg);
 
-			buf = kmap_local_page(sg_page(sgl));
-			if (buf) {
-				memset(buf + sgl->offset, 0, sgl->length);
-				kunmap_local(buf);
-			}
+			for_each_sg(cmd->t_data_sg, sg, cmd->t_data_nents, i)
+				sg_zero_buffer(sg, 1, sg->length, 0);
 		}
 	}
 
-- 
2.43.0

