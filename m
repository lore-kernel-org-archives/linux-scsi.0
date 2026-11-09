Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195492;
	b=DNbn5/1JpnwNVSojmtcjWCRZe7iQUGcBTJEC66ugKX/IzB4PNny05umq3G1sMJ3S1EYn
	 uE36J0JppdiJ0tQZ6DBmkMrSEiY208KIQl5KaS+bXAXsK38YaL31cqJMMqkd4kBtBG//w
	 +eMgHkD9Xw44XV3ujL39qqX0miFg+Jy5HfirA8On+M6vkua0/05W1+5y/JdW8DZuv4aYb
	 fpbvjuCcqCDLUZOQMwF5+XK/ddwN/rmf67+tqzuGVCOeAc2dXiOZd2t/aK5M14ip6Awkm
	 QqqJx/IuOUvVjH4uNlVwkPNfKPzl3DMzH2tpEM/3eKMD0j25M6QZeYjLdtNUp+SxCcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195492;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Zmail-TransId:X-Mailer:Message-ID:In-Reply-To:References:Date:
	 Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:X-TLS:
	 X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:X-Fangmail-Anti-Spam-Filtered:
	 X-Fangmail-MID-QID;
	bh=SCgcCvjpVgxAQGFzaYNd2gEe0P2/mBn/A3wpYYQTHtk=;
	b=BtcyioVIlO8W9ElE1Y2sSUO6wyyOCKXHvUStTK0451K6noGWkLvB2opuLFeh1me3ECUO
	 k4ORvbkBw9tAIuO3GDQF5jGfuwMuhhatlwH5BWppvQGSs+Yy+fsovIg0Sj8POWg933jdQ
	 6c/Hn8J1wgnQ9rq8F+DkkyotbHH1QhegTTO8txezORrrZr2FP8FfBlHr+EYY2ZOPHTLgS
	 CNYJt44bHGaDTjrsS0vwUbMe+80f2vOwsWVUO26E1YtkTQdwTzaUijwrF+uhegoGCbnjQ
	 7cccqvcmhi2b0Rv3P+L5q39prQrbpRip2ypLVT6vZYzfGX4tYGbfmX9au2XDXWJI+LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	dkim=pass header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=YE8dnh5n;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDDB606A326;
	Mon,  9 Nov 2026 03:38:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FDDB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=YE8dnh5n
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jNFqQ1NBQz4yjSm;
	Mon, 09 Nov 2026 11:38:10 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794195490;
	bh=lZWEoNF2oFB9eK3jk5bK1iP9mc+Hj+HyJRK0HMRsDfY=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject;
	b=YE8dnh5nw3JRRcFpUOp0Go9HTkAJI27DULUclLDUyQcU03j/KEyvHW0SSmSPeTVBc
	 UnarJRTmSW3N6sxF1lQgOzj2hu/44CU20JFG9TiOXEFVwXwvDeybp2xu2Av6LofGdW
	 1Rddsptumn6sjTMw9u88sK5Y3BN2lEl8pRBnurmJ2p8mcRHUmwk1kGgnlXtV1paWY6
	 ciDrYRIrcibXDhK3AOwHSyZ2QkbyCW7Uk4vEf3mlpUcBZjlLZrXrf83M4raPZQ2LNf
	 oiCfe6Rzf7jiwbR5OPGjNo2Skv/RAmeYpIrAbLXm8aisTkamIWMfIXNOLunBAfhCXi
	 KbIvaPh7g7HMQ==
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6A93c0o0063755;
	Mon, 9 Nov 2026 11:38:00 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 9 Nov 2026 11:38:01 +0800 (CST)
X-Zmail-TransId: 2afc6af140193ff-415f8
X-Mailer: Zmail v1.0
Message-ID: <20261109113801611J1jCIkfmIY1QGjnJLAW25@zte.com.cn>
In-Reply-To: <20261109113753774uzCxndU_9x6G5W63TB1hA@zte.com.cn>
References: 20261109113753774uzCxndU_9x6G5W63TB1hA@zte.com.cn
Date: Mon, 9 Nov 2026 11:38:01 +0800 (CST)
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
To: <mkp@kernel.org>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDMvM10gdGFyZ2V0OiB0bXI6IGZpeCB0aGUgaW52ZXJ0ZWQgZHJhaW4gbG9nIG1lc3NhZ2U=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A93c0o0063755
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 09 Nov 2026 11:38:10 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF14022.001/4jNFqQ1NBQz4yjSm

From: Shao Mingyin <shao.mingyin@zte.com.cn>

The message is printed when __target_check_io_state() returned false,
i.e. when the command is already complete or kref_get_unless_zero()
failed, but it says "non-zero".  Make the message match the condition
and switch the unleveled printk() to pr_info().

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 0b719f3f9cdf..2ba84773466b 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -222,7 +222,7 @@ static void core_tmr_drain_tmr_list(
 		spin_unlock(&sess->sess_cmd_lock);
 
 		if (!rc) {
-			printk("LUN_RESET TMR: non-zero kref_get_unless_zero\n");
+			pr_info("LUN_RESET TMR: cmd complete or kref_get_unless_zero failed\n");
 			continue;
 		}
 
-- 
2.27.0
