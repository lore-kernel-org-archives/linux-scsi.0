Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975782;
	b=3i5/H5Fyw6P8mA9RYW8wq4id2H8UO2cVjxnXYHPJB8HX5+758K3JCVXEAXfAKcXfY77q
	 lxAS1BfXyDJ7EftlpvKaIFwttrmTgSBAwWivr5QJUNOOAzeY71DOEsiaeXs5XzLFysVcJ
	 yf+yRU8xNccd/mk5/WB9+mP/dCbgOySz1YNc3dmYyeKgeRmbPliTcdmNU9+7g3TOvbz3i
	 Q7kJ504Z3eDDZQdGgchpsAeM6HDUYLPBgnGyX0UIIPDNWjeQNR24D1JsotQVNZD3XIsit
	 I3ds/KBO+2eEcGTg1ArEfxxnyUhMFZv3MGV7PqNsMJ8op61JLtzpx+05fdVPzo99/2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975782;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=o98NC+Lh4cgyrhfxm3LZHx5jeRFeOtrLw3ijmZcnEcg=;
	b=YUwp+NzwiRHnR4G3eLC0bb3otAe97wNDXKGJY3PciWhvZyq9RPffZUoK7Ks6jpLZiqNE
	 jft/ogu/PZYFzK4RvIO6hzyKRnNCGXitjVgLB79yKLy2RJua06TQqTepSCPkxOWDLXtdH
	 3xafZr56EA85Iqs6MVBX2e4imC6fuzpnVjKjZuvcPoyb+unIuiZ5BXeuw8ORggyTDoOBq
	 /0R1XDsQzpl4P3t+lNlJ7M+E83BZiBYAiz9PCsEqpnvqpxBkSZpX8Yzo3Xl0UNijaZbj0
	 9W6BoH65QHaSKZApf+4VKr1Jn0JgSvq0cacv2bdmhnYeTPSeTZ6yxgVZltB5r8UNYJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D24606A32E;
	Fri,  6 Nov 2026 14:36:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45D24606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jLhZD0N3Tz4yjjP;
	Fri, 06 Nov 2026 22:36:20 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6A6EaAr6023008;
	Fri, 6 Nov 2026 22:36:10 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 22:36:13 +0800 (CST)
X-Zmail-TransId: 2af96aede5dd95e-4c93f
X-Mailer: Zmail v1.0
Message-ID: <20261106223613960sirnIKlV9mIx6hCytsRNY@zte.com.cn>
In-Reply-To: <20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn>
References: 20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn
Date: Fri, 6 Nov 2026 22:36:13 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIHYyIDQvNF0gc2NzaTogc2Q6IGRyb3AgdGhlIGRlYWQgLUVPVkVSRkxPVyBicmFuY2hlcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A6EaAr6023008
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Nov 2026 22:36:20 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEDE5E4.000/4jLhZD0N3Tz4yjjP

From: Shao Mingyin <shao.mingyin@zte.com.cn>

read_capacity_10() and read_capacity_16() no longer return -EOVERFLOW:
commit 72deb455b5ec ("block: remove CONFIG_LBDAF") removed the last
-EOVERFLOW return statements from both functions.  Drop the two branches
that check for it.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
Changes in v2:
 - Mention the commit that removed the -EOVERFLOW return statements.
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
