Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878436;
	b=oZZXxf9QQQy7eKyGiN5xkv050bpbsGWUvjkeZsqRsD4Q1YEEMeGV1f2BbTMHwUgH+VgD
	 ReBeqUIvkywYHpJtvY1AY1uIWfC8OvRy7y+7MW34gMTy6kvP37sd0xuHoe3h0q8f1NH/T
	 Xf1sN2S52kTxm8Gg76QTNdlhMQtEBDd81MvIX0HLac6zOG4/ehZ0I7v8cSQb28TC7xOES
	 n8hf5CXe0hRNJ7qxflalvbCT/P+j1OTnSoSN6dDQE4DbZztsJAl9Wbm5maWfUAxdPEbWw
	 RWDPrLdC+0nkoUdsn9gn4flUEurYGnPlqjLxlrGPmIdKuCNaLGuJxdEdwIr9+hPrNUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878436;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=YmhYB6FSw7SAlZ7uPoF9ohpVMxGQe+nw6zEETgF4dbA=;
	b=RN1VoJvLu8wqTe5zL/XjGy0oBV5jOVHjUZNHjWnN4FS3hJCYPW8LjIOJGsZosyYqEdYE
	 itU40v6OXXWM3L6wjOuU79E8U/HB20xyRrRyoNDcOD1b4xe5Xu3ZTgQzrYq72zJ4zjVtq
	 zS1QbO6xm6GLye/zIN2ptRezSFtVFR9dD6eDdCIQENSbyGJYuJYIrxiw9r3jvXu7NWLcA
	 A3+dnK68IQqaB/yLv9Arim/cS8cZRI5CdFFCrjMNLvilnKJV2KM2qUELVhWkylHJOg77d
	 DL0fSAqvG4N/3YIFllMMlLOW8B/5J/oQ0IbIrCXTv7u59R8MwvcRziaOP8zwBuECaTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5653606D822;
	Thu,  5 Nov 2026 11:33:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5653606D822
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jL0ZB4hYwz5B0rb;
	Thu, 05 Nov 2026 19:33:54 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6A5BXn1c068577;
	Thu, 5 Nov 2026 19:33:49 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:51 +0800 (CST)
X-Zmail-TransId: 2afb6aec699f1f6-15a06
X-Mailer: Zmail v1.0
Message-ID: <20261105193351820CRZfBnzFE8zZm2DrNx0T_@zte.com.cn>
In-Reply-To: <20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn>
References: 20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn
Date: Thu, 5 Nov 2026 19:33:51 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDEvMl0gdGFyZ2V0OiBpYmxvY2s6IGRyb3AgdGhlIGRlYWQga21hcCgpIE5VTEwgY2hlY2s=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A5BXn1c068577
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 05 Nov 2026 19:33:54 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC69A2.000/4jL0ZB4hYwz5B0rb

From: Shao Mingyin <shao.mingyin@zte.com.cn>

kmap() never returns NULL, so the check after it is dead code.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index ea65d39fef88..604fca959f2e 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -461,8 +461,6 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 	int ret;
 
 	buf = kmap(sg_page(sg)) + sg->offset;
-	if (!buf)
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	/*
 	 * Fall back to block_execute_write_same() slow-path if
 	 * incoming WRITE_SAME payload does not contain zeros.
