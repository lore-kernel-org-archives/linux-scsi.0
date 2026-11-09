Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195492;
	b=m/VWeEgcETl5ptmtoL6FBwhFwfk5eHu3V5VTc/L2pMF+zOzx1kX9CKwatieA7EWSGYD4
	 t3jhJqgswqr0NoZewBpp+LFZE2UsFzF5PXkbqiXYGHzav17OdTVeJy+rjhVzGby4o6/kB
	 hcJfwQwEZbqjZOgdmFwwdkrU9dbU/JxswWQtcdSmTYJW4IQ9GDGmM209SBZbrsK5wD/8o
	 Pyo6XWEQkAzzJIstdL64U3JXSnP1Ayx4lAP9WD+XubxjgB/nPuJ6nYI9kYFbBvZZ56SAR
	 3YETQgcCVlqYaydNS8xdY6Qzj72mUG6gawTqnYMAWwPw4Hq275o3UQ5mhFJ6Rliaghw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195492;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Zmail-TransId:X-Mailer:Message-ID:In-Reply-To:References:Date:
	 Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:X-TLS:
	 X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:X-Fangmail-Anti-Spam-Filtered:
	 X-Fangmail-MID-QID;
	bh=dDNuQNZ4Q068kBc1irsl4Q24UzIeGT8nB+Lz9WNYUZI=;
	b=yEi/D5H/BiMhOWQCdTlVDJafX1Ln57d/JEhVZgilDEJakwJuwfe1A4NlSWV/0kqd+A1V
	 E24HZ71emXGgO+1Y9aSKp5GCPGvGjnY/o0nu5G5sCj6Ca2+bXXXRCHG8DA6tPNrLTooWu
	 xs34hZszARrCAxZGXl4xXp9wbrHyjbPfs2mFVIB8qdg6Gb/Txw5vvHfjh9cbgt4oSeWba
	 Vq/84Sju89M5lP4gIpoOV2Za8/JtD2AwTRk5OY64W5DFlkiiTrjj5wbCXTgdNlnODUq9y
	 HR9QzMEfIDrXfunfZOJr40LLGs1mDM8AZgEsVyHYW6WQtEvERbHO36mEpT34Ws91Z4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	dkim=pass header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=2LvEJA9C;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E18606A325;
	Mon,  9 Nov 2026 03:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24E18606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=2LvEJA9C
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jNFqP4YWjz8Xs70;
	Mon, 09 Nov 2026 11:38:09 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794195489;
	bh=DJGnq2eXzgUcR8zJRuPb0SOZFdcdyGHn7xiZ7s4VT/M=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject;
	b=2LvEJA9CWoC1uNjOkOw7i/AMIPzvX0A+u7giKTQYEQFpzujT34NuzFngG/+XJnPhV
	 c68wEHrF5r/X/MICacL6c4lr0BQB3CcU5MYplzGyx1AeMSG7+2IV0FvyOllA98/mpN
	 ULacPylBGgZcgjTJPi/pJVt0bRNnkctYij16N/IJzDqa2dMnVvr6Pivxaj4wx1OuBV
	 z+Z35MYiXHFI2YpfLT7mEPxUi4/xTVMJQwvK4dR1+bgG6MPZsoijPIKYEt/T7vHee/
	 ghLglatcW9C6Yb4cXcD/BsBI71DMSpAZWYkdCqERNkXtZkK/QlvgRzfKsQb/uTMj5k
	 Am7Gnivh9WxGg==
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6A93bxMx063732;
	Mon, 9 Nov 2026 11:37:59 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 9 Nov 2026 11:38:00 +0800 (CST)
X-Zmail-TransId: 2afa6af1401894c-56b30
X-Mailer: Zmail v1.0
Message-ID: <20261109113800391iViOGp-B7D_jQ82lqt8F4@zte.com.cn>
In-Reply-To: <20261109113753774uzCxndU_9x6G5W63TB1hA@zte.com.cn>
References: 20261109113753774uzCxndU_9x6G5W63TB1hA@zte.com.cn
Date: Mon, 9 Nov 2026 11:38:00 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDIvM10gdGFyZ2V0OiB0bXI6IHByaW50IHJlZl90YXNrX3RhZyBhcyB1bnNpZ25lZA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A93bxMx063732
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 09 Nov 2026 11:38:09 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF14021.004/4jNFqP4YWjz8Xs70

From: Shao Mingyin <shao.mingyin@zte.com.cn>

ref_task_tag is u64 but the message uses %lld.  Use %llu, and switch
the unleveled printk() to pr_info().

No functional change.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index db7388e207b2..0b719f3f9cdf 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -166,8 +166,8 @@ void core_tmr_abort_task(
 	if (dev->transport->tmr_notify)
 		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
 
-	printk("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %lld\n",
-			tmr->ref_task_tag);
+	pr_info("ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: %llu\n",
+		tmr->ref_task_tag);
 	tmr->response = TMR_TASK_DOES_NOT_EXIST;
 	atomic_long_inc(&dev->aborts_no_task);
 }
