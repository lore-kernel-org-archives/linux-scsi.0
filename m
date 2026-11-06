Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975777;
	b=w+f0GHLyCbisIQ1GqKegft1f8Y+gNQb/x7w8IAXSU+rBFCtW+WF3hEWhwyNRMnUrqD5C
	 /MmYlKlfglqcitlSTZoyLCdwSC0j3hz+K85dPerY7fFKgREGUUrRy6HJkUpbhJdaA/dXU
	 bDdJM3x3yN1CHC+d9TogPs6hKXAFOozS+p6YJTeeGSVTEmJW/zw6xWyirsbuoAS5z4Gom
	 2Er5nhsz6FXVGcU83k5XaSkqL/UlEtJ6gzNAahwV6MqG39jX4Ch4csgvrURM9Tmsg4zDo
	 zML+esXPjPfEKnkAEJ0r423NxTTCUBvre3CxcHIwxeU919r5k4Fnp4LeHUz4jhlNS3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975777;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=1Cg3gtPmmYVyD5KkJLzB/Rlbi9EMn5rEmZBvWkZTvHk=;
	b=YpLTFUME+rWYgsYSvNtra/pkxXKkp5nrTv0bBL20zrHT6wOSpA46CxtmLgES3MGKeej7
	 B5mGDTzvpZXYyZPr8xbdPPJh2UtwHWrc+Hg/dIA5cJEpvKEgf67r03HaMRPFSZOWNGycb
	 V62wHLzdFE1KYTqwaTfYXpTAIdr18Zo197sEerovdOsHuKDjDae/96HLRYYqv88/bs05B
	 ngylsmuQ1GRl1LcUDjYODtUxtM28taghhdlDZTa2iSymi67l9WjFnpSY6M5Rs0SLQu2K3
	 l5rVU6AlECGAEGAsM7glzOjlgsIfIFmF73Q3pk4/vZMBCSaknLy/7WidGvlJaUsuHyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC56606A32D;
	Fri,  6 Nov 2026 14:36:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FC56606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jLhZ64HwHz7QqdS;
	Fri, 06 Nov 2026 22:36:14 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6A6Ea6XO022991;
	Fri, 6 Nov 2026 22:36:06 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 22:36:10 +0800 (CST)
X-Zmail-TransId: 2afa6aede5dadd4-5dda4
X-Mailer: Zmail v1.0
Message-ID: <20261106223610005vV2T89e6BeHzs76bt6fl_@zte.com.cn>
In-Reply-To: <20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn>
References: 20261106223604417bkuf4vbx-Ya08zJ57wNur@zte.com.cn
Date: Fri, 6 Nov 2026 22:36:10 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIHYyIDEvNF0gc2NzaTogdWZzOiBkcm9wIHRoZSB1bnJlYWNoYWJsZSBvZmZzZXQgY2hlY2s=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A6Ea6XO022991
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Nov 2026 22:36:14 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEDE5DE.000/4jLhZ64HwHz7QqdS

From: Shao Mingyin <shao.mingyin@zte.com.cn>

ufshcd_read_desc_param() rejects param_offset >= buff_len before it
reaches the is_kmalloc block, so the repeated check there can never be
true.  Keep only the memcpy().

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
No changes in v2.
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fd52deb72d21..8f89ce52921d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3895,14 +3895,9 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 		goto out;
 	}
 
-	if (is_kmalloc) {
-		/* Make sure we don't copy more data than available */
-		if (param_offset >= buff_len)
-			ret = -EINVAL;
-		else
-			memcpy(param_read_buf, &desc_buf[param_offset],
-			       min_t(u32, param_size, buff_len - param_offset));
-	}
+	if (is_kmalloc)
+		memcpy(param_read_buf, &desc_buf[param_offset],
+		       min_t(u32, param_size, buff_len - param_offset));
 out:
 	if (is_kmalloc)
 		kfree(desc_buf);
