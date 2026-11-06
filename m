Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975781;
	b=dPw/ukSUFAhKfaFKzSf2gtWMvCf3HjnL+lvhQn1fCcRQTUm5uDn0FBcbhtiP8y9FINAM
	 ivxwdpOvFx+e5DnDmuZ9ss4EMTH3LaCCCDZmgmjVB+8Q6i+J1NzqUafsVKKrhtbAv+Rsh
	 eiHOgPgN4FuUPyBnXMyau85QYXY8jfGrXqPpErirql6eyhl4v+ZZsWFH7H8ZAiT11qbm+
	 BSB982rM67DFuYnvIHumlUmxwlfyyS2DlxYkumMcsBEHhnuSZuAKt2gzhQZ9upIsgRlae
	 8DWn3s/KOnqw6vEkAG8FYgEvFrcFsR1lGtw3HCL3ZRyaoEXs3fUqrAl+SvciHDmP2hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975781;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=oC+OoUMYsdNAoPxaxjxqF5eGXxzELU+9u2jd+pen848=;
	b=SYYsiplieU7QKAQdd/EU7f4nvs9Llv/rzfVxMgFpHMpSG0oYSKGUGyB3GaFq/K5o7Jgj
	 Z6yAa6aMWBMpum/aTUpqa557vnEdhvGN5NkYoRjOuvzwnnq6WrPvNlihUdsWNCA/Q9wMN
	 2qixz88O7mgGtsrZBAgTnjKWrn7JwRmp1nVdY7rWtCWpRPt5dswcOcXOrKbqi8fC5akNq
	 StJaIym9l0yCDRrMTplXK/tEzkbXb+0LixMWhqgeFdyxGV6WZx50/OX7Kli96AMIUmzu9
	 YGwyPHj1IzH4uphEyTx3K6dNimXrtqqyAEkyvh/gSrPLTOMNIWqIxVWs0sKSLbLCTFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A7A606A329;
	Fri,  6 Nov 2026 14:36:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5A7A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jLhZ41CZdz5B14n;
	Fri, 06 Nov 2026 22:36:12 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6A6Ea9oo041189;
	Fri, 6 Nov 2026 22:36:09 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 22:36:11 +0800 (CST)
X-Zmail-TransId: 2afa6aede5dbe52-5de22
X-Mailer: Zmail v1.0
Message-ID: <20261106223611303E-DryXu7HO9yuD9X2pATL@zte.com.cn>
In-Reply-To: <20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn>
References: 20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn
Date: Fri, 6 Nov 2026 22:36:11 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIHYyIDIvNF0gc2NzaTogY29yZTogZHJvcCB0aGUgZGVhZCBWUEQgc2l6ZSBjaGVjaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A6Ea9oo041189
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 06 Nov 2026 22:36:12 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEDE5DC.000/4jLhZ41CZdz5B14n

From: Shao Mingyin <shao.mingyin@zte.com.cn>

scsi_vpd_inquiry() returns result + 4 where result is the page length
and is non-zero (otherwise it returns -EIO), so the returned value is at
least 5 bytes and the "result < SCSI_VPD_HEADER_SIZE" branch can never be
taken.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
No changes in v2.
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 05232ab6366f..fe4d748cab1a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -378,13 +378,6 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 	if (result < 0)
 		return 0;
 
-	if (result < SCSI_VPD_HEADER_SIZE) {
-		dev_warn_once(&sdev->sdev_gendev,
-			      "%s: short VPD page 0x%02x length: %d bytes\n",
-			      __func__, page, result);
-		return 0;
-	}
-
 	return result;
 }
