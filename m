Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878426;
	b=XsEW/VJSdwQcgxK7hnjqy4uODL4a4UUsDETsePtYTOEl7ut1DBBo97cgobLXz/cmEvpV
	 xlKXAVAsVu8QxTKFg1WuQlx3K0AGWOkfRe4ON6pDsTf0uY/SkNNhQKI7YS/l7o2vZLB/w
	 Daq/WINDWSVIKSMbBXqGqX/bQAScA+yYZZKuodUwtNrazSVGGfj9Dcfz7U9DFdefEOPB+
	 uNk5l6p/w9aH2mcLiSx+78Er/9slj2FZFX6SFfBEPKw28B4y+9radBMJj4zZqwmN/NZyf
	 +K+56xPrPDRusCoJgslZzylgtrRhluWA3LzkQ1qAeUMx5frwFC4bF/dLvVMwy2VMScg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878426;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=BYAL4RFZkCF15GvaomPYOCXVCuV39KBU9jCSgDeUH/c=;
	b=GcPA4xcsHpLlB+GlYwT5ZedsvKzisArIU5Bn+XORhtqkUXz8vJLL3tCQCVNk01dcqFzC
	 16Uvq2TJf3PHYbygtDmmvfcy7WMoLpqEY8iAj78Q6CI4mAAL4Xqjgx/B4/9p6jq3q2A5K
	 moL68yxl6O1dWuuGMaMsR374rRgtGPHUbQ0rt3cMWjzJGl2C3fa2XH0OFfwlmH0bcwMBS
	 oNmUVVstCu/Io0W04/2Zbf+TH00OWFV6e3Mf+8y+bQLeXuasDo7bmMLCtjVW3C9XRPoj9
	 DcfrLXIadZL/3C7GbYD6SDcdQyOT26KYehzmfZwYqbsExoH1QD8VBRO30TMuNFDTWUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F24B606A329;
	Thu,  5 Nov 2026 11:33:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F24B606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jL0Z00tVDz5B0rg;
	Thu, 05 Nov 2026 19:33:44 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6A5BXZcN068141;
	Thu, 5 Nov 2026 19:33:35 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:38 +0800 (CST)
X-Zmail-TransId: 2afc6aec6992c3c-10452
X-Mailer: Zmail v1.0
Message-ID: <20261105193338195knvPnRIVc5cwFpUvGK9yw@zte.com.cn>
In-Reply-To: <20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn>
References: 20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn
Date: Thu, 5 Nov 2026 19:33:38 +0800 (CST)
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
        <loberman@redhat.com>, <jmeneghi@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDQvNV0gc2NzaTogc2Q6IGRyb3AgdGhlIGRlYWQgLUVPVkVSRkxPVyBicmFuY2hlcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A5BXZcN068141
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 05 Nov 2026 19:33:44 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC6998.000/4jL0Z00tVDz5B0rg

From: Shao Mingyin <shao.mingyin@zte.com.cn>

read_capacity_10() and read_capacity_16() no longer return -EOVERFLOW,
so the two branches that check for it are dead.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index dc45df819c42..8474ad579e90 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2916,8 +2916,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 
 	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, lim, buffer);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size == -ENODEV)
 			return;
 		if (sector_size < 0)
@@ -2926,8 +2924,6 @@ sd_read_capacity(struct scsi_disk *sdkp, struct queue_limits *lim,
 			return;
 	} else {
 		sector_size = read_capacity_10(sdkp, sdp, buffer);
-		if (sector_size == -EOVERFLOW)
-			goto got_data;
 		if (sector_size < 0)
 			return;
 		if ((sizeof(sdkp->capacity) > 4) &&
