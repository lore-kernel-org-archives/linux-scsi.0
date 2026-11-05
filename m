Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878446;
	b=V2rgZtDW6/qMU+8QFyUpWVE8sA0xqq+7T5c2qQzylkYtv9OfSTTFMMIVSYXRsgbqC38x
	 lnSXAcxLMgiVZqVNFFzNEDr9zjQVcPh83bJdUh+yppl6dwJQkCQVnZetIzM4L9/GOYaTt
	 BxgoZ2TH5LnyL6gO5crBGSzpToa+OcxO6YHLavG2WzTY846bDraW/WfrCJbYQfE+IKg/q
	 BM+uVTxq7qPuFyJF4m33Hle7ePTZ09ALMEPYA9mIKw2vst4EV4Zl/sApYLW+vfGVCRYdI
	 usSsACUOwIiZIcJ45p/POoEI5MZKdv9oMYf0W/w05CubLupuD20a26nhGlF4hvp9ZYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878446;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=4H6QLB09008EpySCBk9eMRP08vrQbXO2LZChefl2NAo=;
	b=FQrAms19xwX32YBSI9YBonX7ZMSBGLZcqX7BED6UwASjzu7DbKS3hk0wYe6TaxRBgNqQ
	 7EPrGZPuAInlqCdi8W66on8DDfh49tTLtMMMRE5r/qglFQtRWDbXeHZfmZdVVuFnq5e15
	 PlivUdQXlGFRJ2IV05l0OCNzCAt3gnX81Gomluq5ycjTKINNAyPU0iVLsGPGkRqH1CE/t
	 WLsN49fPtjHs9k69RjfAjdVfJtscX0vGftF5uJSzu0oqYrFGCS/qPgpIj8F6GmFozC/TR
	 mQyHWXrzg83YvZtMy58LlL0yUA9WdK0pmdihfeLymWTkgb9WZmZmEQhtmy3bmM+J/BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B70606A33C;
	Thu,  5 Nov 2026 11:34:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31B70606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jL0ZH1lxnz5B13Y;
	Thu, 05 Nov 2026 19:33:59 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6A5BXoTG036530;
	Thu, 5 Nov 2026 19:33:50 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:53 +0800 (CST)
X-Zmail-TransId: 2afc6aec69a12d1-10ae6
X-Mailer: Zmail v1.0
Message-ID: <20261105193353023NXQ1VSNCIijJ53XmDJc1y@zte.com.cn>
In-Reply-To: <20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn>
References: 20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn
Date: Thu, 5 Nov 2026 19:33:53 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDIvMl0gdGFyZ2V0OiBjb3JlOiBkcm9wIHRoZSBkZWFkIGttYXBfbG9jYWxfcGFnZSgpIE5VTEwgY2hlY2s=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A5BXoTG036530
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 05 Nov 2026 19:33:59 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC69A7.000/4jL0ZH1lxnz5B13Y

From: Shao Mingyin <shao.mingyin@zte.com.cn>

kmap_local_page() never returns NULL; drop the wrapper and always
zero the segment.

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 927861c30afc..9819515ce967 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1646,10 +1646,8 @@ static int __target_submit(struct se_cmd *cmd)
 			BUG_ON(!sgl);
 
 			buf = kmap_local_page(sg_page(sgl));
-			if (buf) {
-				memset(buf + sgl->offset, 0, sgl->length);
-				kunmap_local(buf);
-			}
+			memset(buf + sgl->offset, 0, sgl->length);
+			kunmap_local(buf);
 		}
 	}
