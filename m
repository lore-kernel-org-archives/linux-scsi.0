Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703163;
	b=sufIiQosuOTz2YnqfEpuoE89jvztKBNkSJBM3DGsfzlmV/H9kN9o49tMfRCDeBAHt0u7
	 sqd1W275L453ZoeVn3rHmujuh2XYWjfb3usqmw48m/ofcrA4VKSst06nyyGgh1JoqtAj5
	 dT3vkD+bcj5aiBMJ7ba+U9ODoUShHIywdyF2aZl8/g4Ihs0wyXfa2ygNNh1miTrGqemzH
	 1z4ww/POhx4qjZ/YN3bwtReb0c9UaaE29jky2yhS/1tl1jfYxKj8yUCIUP0xLYWpRbu/f
	 CyYcdQj6Ckjx+wYSuJA68+kMvWMRbw91z8x0tLIAuaFoP+1qHK3L8Gi6ElNfe5eBxNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703163;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=McOGr5STNoAilBTMiJStvIEGB87HnHoP+CADhg2m0sc=;
	b=XQrmqVwvvd31Owhwn//XZWDcF0/P//xVuMMaeEKZK4JLULDGt04uIMrwaLHd4LFwewLU
	 281z6kmfzubkYu4388VrFR26/MjHyJDZ9CN04Lij0HGW6gDotkiItBp9ZvCOpKoD6sjAV
	 6rHnjp5bpnn6cW9LoOfx2MgjhcEvtvlCapuz4FbeH2nnKJtO+UOT0XwtNvQRMH5JnhC6+
	 tlu6ZMlgt0pjkeiLhn3OfMW8lubjtCDlDkuyl16A7X6K7QZ6YZgk/Vj1oapq1cykCLgVi
	 rlA+7pvW2KDr1edNYWtFUhGf5HXXdG/dZv9AQoSGsaGMrMjssHqGjIM4sitY/8vQ+8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA28F606BF84;
	Tue,  3 Nov 2026 10:52:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA28F606BF84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJllP3wkkz5BNRf;
	Tue, 03 Nov 2026 18:52:33 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6A3AqQkX086904;
	Tue, 3 Nov 2026 18:52:26 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 3 Nov 2026 18:52:29 +0800 (CST)
X-Zmail-TransId: 2afc6ae9bced8b6-a9024
X-Mailer: Zmail v1.0
Message-ID: <20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn>
Date: Tue, 3 Nov 2026 18:52:29 +0800 (CST)
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
To: <martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
Cc: <james.bottomley@hansenpartnership.com>, <peter.griffin@linaro.org>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIDAvMl0gc2NzaTogdWZzOiBmaXggYW4gUlBNQiB0ZWFyZG93biBjeWNsZSBhbmQgYSBzaGlmdCBVQg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3AqQkX086904
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 03 Nov 2026 18:52:33 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9BCF1.000/4jJllP3wkkz5BNRf

Two independent fixes in the UFS stack, found while reading the probe and
remove paths and the task-management hooks.

Patch 1 is in the core RPMB glue.  ufs_rpmb_probe() registers a child
device whose parent is the RPMB device, then registers an rpmb_dev on top
of it.  device_add() takes a reference on the parent, and
rpmb_dev_unregister() is only called from ufs_rpmb_device_release(), i.e.
when that reference count drops to zero.  The remove path and the probe
error path call device_unregister() on the child directly, so the
reference held by the rpmb_dev never goes away, the release callback never
runs, and the RPMB child stays registered while the devm-allocated
ufs_rpmb is freed together with the host.  Unregister the rpmb_dev first,
as mmc_blk_remove_rpmb_part() does, and let the release callback tolerate
an already unregistered device.

Patch 2 is in the Exynos host driver.  The nexus type masks are built with
(1 << tag); controllers can expose 32 unified task tags, and tag 31
shifts a 32-bit int into its sign bit.  Commit 01aad16c2257 fixed the
same expression in exynos_ufs_post_link() and noted that the UTMRL access
should be changed as well, but the four remaining mask computations were
missed.

The patches share no code: patch 1 is the core RPMB glue, patch 2 is
confined to the Exynos host hooks, so they can be applied in any order and
need review from different people.  Both carry Fixes: and Cc: stable.

Related work: an earlier series by Stanley Jhu ("scsi: ufs: rpmb: Fix bus
registration and device lifecycle", v3, September 2026) also calls
rpmb_dev_unregister() in ufs_rpmb_remove() to break the cyclic refcount, but
it is not in linux-next as of next-20261030.  This patch is the narrower fix:
unregister the rpmb_dev before the child device and let release tolerate an
already unregistered device.

Testing: both apply to next-20261030, pass checkpatch.pl --strict with
0 errors/0 warnings/0 checks, and the two touched objects build with W=1.
There is no Exynos board and no RPMB device on this machine, so neither
path was exercised at runtime; both fixes come from code inspection.
Patch 2 is the easier one to confirm: with UBSAN enabled, tag 31 would
report shift-out-of-bounds before the patch.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
base-commit: 7649ba73f9e7e1e04d0b46213e39c79ae09dd55c
