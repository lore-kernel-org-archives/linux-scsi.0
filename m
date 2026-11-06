Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975777;
	b=Ucw2WR8COdfXTGlfs5TXEOAieAdFvWOcQXuxxsIP5uxmA7YXZkWToM8fVrq4YBJcARD4
	 oCtt+0yAUxBo/61pAo+q0o0LsKF3re4kWCzhbrW/A8Jojx+J6PIcqQ4Ck0yPEdZuU4pdT
	 old/nA11YZXQAuTJNjH3t8AY6sM9XVsNPlCWrbtSMNbqi664j2GtjcjLEWOmoeOxErEtv
	 1QZcqRd/et8jJDNAqaLc79PIp9auTBJUWgisaItZ6DmZm2PfMzAQaoR+BzJWRLiDDCWTb
	 YURic7jbZbaqJEC7JocYUlWSq/Kxf0BhiAfx5O/cGhw6Uwjmmx19xzJAqJFdfPx1bXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975777;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=w7vA19J0F8JAf0Ktl0LCLKxkQeNGRF745wJpqi9t7XQ=;
	b=jMtndW0SdHa3uhEmhv+dm+FjrD4VzBIsk9BrZyzcrgufwp/dfFTNQGYvDQBnCt3bMWkg
	 g03PrTpTppWoDB+oefT4fK4IXPNo5cGk5ux86WbrrQUzI0hoidQdfMVYyh9pvRXWzNmrq
	 Gw/kYYoQL6i/dHb6hSDrcRcWR6Q13Ea69lJMpCsXiMtL1QMmmWQgS55ZAooEqGiqK9kD9
	 wSTfAA0EQUKKiXlER7kkPrk+Yfa41DWw1BaE8gncRVjg+Pd/BL7gyCtLsFVD5TZbzP+er
	 HwRhPT4wlnN8dvJOOuR/mnROKqnIspZRqHm8cfjBpuFKByt/NnGYNL3sqcXI+i5uJxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C761606A326;
	Fri,  6 Nov 2026 14:36:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C761606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jLhZ70SWBz4yjjF;
	Fri, 06 Nov 2026 22:36:15 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 6A6Ea9Q8023006;
	Fri, 6 Nov 2026 22:36:09 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 22:36:12 +0800 (CST)
X-Zmail-TransId: 2af96aede5dc8e2-4c8c3
X-Mailer: Zmail v1.0
Message-ID: <20261106223612595HndziFs0GantUQT-uxJSS@zte.com.cn>
In-Reply-To: <20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn>
References: 20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn
Date: Fri, 6 Nov 2026 22:36:12 +0800 (CST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <mkp@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
        <bvanassche@acm.org>, <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <jmeneghi@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHYyIDMvNF0gc2NzaTogc2Q6IGRyb3AgdGhlIGRlYWQgbnJfYmxvY2tzIHN0b3Jl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A6Ea9Q8023006
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Nov 2026 22:36:15 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEDE5DF.001/4jLhZ70SWBz4yjjF

From: Shao Mingyin <shao.mingyin@zte.com.cn>

sd_setup_atomic_cmnd() writes nr_blocks to cmnd[12] and then writes it
again a few lines later, after the boundary field.  The first store is
dead; remove it.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
No changes in v2.
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc45df819c42..6028f9e6cf7d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1408,7 +1408,6 @@ static blk_status_t sd_setup_atomic_cmnd(struct scsi_cmnd *cmd,
 	cmd->cmnd[0]  = WRITE_ATOMIC_16;
 	cmd->cmnd[1]  = flags;
 	put_unaligned_be64(lba, &cmd->cmnd[2]);
-	put_unaligned_be16(nr_blocks, &cmd->cmnd[12]);
 	if (boundary)
 		put_unaligned_be16(nr_blocks, &cmd->cmnd[10]);
 	else
