Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794195482;
	b=tiZMbuQxJlzuOK0MHzVBQUm2d1/wFbRnr+PBCkHBbl15NGTh5xxEFH/2tnCaoZRZww7b
	 3i7SElbXUDMU3iSlD+jEBVsVy+LyTwcdh5Rab5VT1xtuBpWMpPkOBhvbsJLb8+jFzn5i+
	 0oKxr/idcvhEixIJQhMryhFZOk4PjNfJbVoDwk5VIKel1AOa9wu+5R1gA5SEckI03q1KL
	 r3jeaUQsKPWZ9goF2+03ZJUbQx06nJAA9xfX8Ea22CuI1e/XXsbqhPpp5RVzyy4MW4mjC
	 imvafZnIYxLv8z1wBYVAoRnGeJ8DviPg3+MxyEQavhm+AAw170H2tU9jJp1jJOV7eYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794195482;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Zmail-TransId:X-Mailer:Message-ID:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=QR6SnSFlCFw/lgO9lpC7SNUztBTZE+xdnWmajoMdqy8=;
	b=WqZzTRNGr1XLuXPWrnRMPKt9PI9U6RQrp4D9LVisTLMJ//b7XZXuNYYJAoLCICai1Tjj
	 iUq01PyyuWVVPxHv1+wxJ1Rw3ZTZZNNBzMi8VwdHV57MUBoyeYQX2ctLDH0OzkR0bEGcZ
	 Il/LLszK5R599qAvsrQl+th2P7cgwVqEntM+Smtp9GwX/kfMnuzQsa8Z5PRVo011JGm0w
	 PuTdGRa0isasFdpkf/r+nI3MOjIBFArgehfU2q+5UGmZlssvI56gYOCfFwnIQdnyJSGSK
	 zSINuqd9zCcicIA31PUGHVsdwIdEF1ifNZVw54d0o5yK+apaSUpcHHIex2/PsI2eINA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	dkim=pass header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=FhvrH6aV;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33EA4606A31C;
	Mon,  9 Nov 2026 03:38:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33EA4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=FhvrH6aV
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jNFqB73ZJz8Xs79;
	Mon, 09 Nov 2026 11:37:58 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794195479;
	bh=70yvcFBEizJ9BF630Dxm5ylJM6qPfCYSUPjWF0wQ6Aw=;
	h=Date:From:To:Cc:Subject;
	b=FhvrH6aVJLr0RI5BKxLHWFCI3HCiQaQPXohhEYEXkDf7mlvgkLLKOresS2VtLYn0+
	 Fvh5X6m3cgCO5NHKQaYBH50z0GTTaS3gsSn/VtVQDcmdOJdKUNlwxr8Xqn1kRE/JLQ
	 ZPE16n16OmZz2PLMVUoO7BJDuizmf6u1IU2fgLiyCSgjSFCifsKViXsW30fKG2t69o
	 TzJbMrSNTkwS2569xcp6aWxr7QBZQJWyWqSJoUjQcOA8KBf5aAuQ2I1tFtBm09J6CA
	 uxyrOKsmVgrdEbNvuJRqdUCLvh2oLXam+OUdJlmiYj4mrRPzqazR89fwGhwK6nfeX5
	 E0mG7SekEpEUQ==
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6A93bqSA025922;
	Mon, 9 Nov 2026 11:37:52 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 9 Nov 2026 11:37:53 +0800 (CST)
X-Zmail-TransId: 2af96af14011c7b-40e75
X-Mailer: Zmail v1.0
Message-ID: <20261109113753774uzCxndU_9x6G5W63TB1hA@zte.com.cn>
Date: Mon, 9 Nov 2026 11:37:53 +0800 (CST)
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
Subject: =?UTF-8?B?W1BBVENIIDAvM10gdGFyZ2V0OiBmaXggZXJyb3IgcHJvcGFnYXRpb24gYW5kIGxvZ2dpbmc=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A93bqSA025922
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 09 Nov 2026 11:37:59 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF14016.001/4jNFqB73ZJz8Xs79

This series fixes error propagation and logging in the target core.
All three patches are independent and can be applied on their own or
as any subset.

Patch 1 preserves the error returned by the fabric make_np callback instead
of replacing every failure with -EINVAL.  This one is a functional change,
so it carries a Fixes tag.

Patch 2 prints ref_task_tag as unsigned; the field is a u64.

Patch 3 makes the LUN_RESET drain message match the condition it reports:
the message is printed when __target_check_io_state() returned false,
i.e. when the command is already complete or kref_get_unless_zero() failed.

Shao Mingyin (3):
  target: configfs: preserve the error from fabric_make_np()
  target: tmr: print ref_task_tag as unsigned
  target: tmr: fix the inverted drain log message

 drivers/target/target_core_fabric_configfs.c | 4 +++-
 drivers/target/target_core_tmr.c             | 6 +++---
 2 files changed, 6 insertions(+), 4 deletions(-)

---
base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
