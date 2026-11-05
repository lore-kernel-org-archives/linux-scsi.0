Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878421;
	b=DX7QvZGEz0MskjwHjqPy0NDJWf73UM29W6MrgRQfwWSBEWQ32A6bn8zNuzPYBUj7ALR3
	 6YMS7RZUjMPhMh4o2x2XC7i1O5S4Hli6+xS65oe3fzN1PXIgybbfqZMxF02IXW7kPKzrH
	 w12Zgfiky3maEGO0SwXXrUIPKeV9wdyUmgEUO6PWNkSkzHVThKDh68hb+vFljBHREttgN
	 EC/h2Fx4M8YDawaP1kCcYL4sJqv1v+eVrdSrfdqAg1NRXzZgmHtMF4mfLA0AAL1HW6Gqp
	 XLYVWNGFPv5s9MwppJeFreKDhXfdzarmARWwQGEG/s8sQPY9jZuzhhKCDMCN3SRtXcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878421;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=pKVJ/KyOYaycs0ZR8YVdSd/eRwZCMXN4pRXKGwCrB/I=;
	b=ASeFgxJrh+HrBIXD0IUQpb7osqRChuh6aW97UcjHZi1TTaVL2m8bnllMW9n0Z24ZSMmm
	 sVPf8WeIqhVuiaRPAX+hDloxDTNSJjGit5MUBcwmVs/uhBwFLwIBSXDZz5ufUU5zeoFeT
	 IuRzaM0jTHtVQZ0TIkPLaT9q8qtrtRzqBZIUGptnutB0eKlzh3ULkMSU/XaJVUYO8PLzr
	 DCZk8Ah6WZrWTZg5AL5XsjXR2lv1ksEiKb6YUr300xH8ii0hzgm0/H6G78xdsP7QSN4ex
	 A9U2cP78txld8x138OJuPTaumur1vjaDQPEhE24RU4CKPGB00sxryKebqY0E5eputHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32EA606A31B;
	Thu,  5 Nov 2026 11:33:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A32EA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jL0Yt1msnz5B0rZ;
	Thu, 05 Nov 2026 19:33:38 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6A5BXVNA036268;
	Thu, 5 Nov 2026 19:33:31 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 5 Nov 2026 19:33:33 +0800 (CST)
X-Zmail-TransId: 2afc6aec698da52-10268
X-Mailer: Zmail v1.0
Message-ID: <20261105193333968SpAtZ8KtfXSeTZlDpuSOO@zte.com.cn>
In-Reply-To: <20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn>
References: 20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn
Date: Thu, 5 Nov 2026 19:33:33 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDEvNV0gc2NzaTogdWZzOiBkcm9wIHRoZSB1bnJlYWNoYWJsZSBvZmZzZXQgY2hlY2s=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A5BXVNA036268
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 05 Nov 2026 19:33:38 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEC6992.001/4jL0Yt1msnz5B0rZ

From: Shao Mingyin <shao.mingyin@zte.com.cn>

ufshcd_read_desc_param() rejects param_offset >= buff_len before it
reaches the is_kmalloc block, so the repeated check there can never be
true.  Keep only the memcpy().

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
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
