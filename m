Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794203805;
	b=bGhomlu4pJnT6gOVipXQye9GtmNjEKtNSEeJy4i35Zt87hDdGgVF1E1ZNsu1uWbE1RUz
	 axe4LZ1XAGzqfMMalA66jYJ33SXHX9hMHN7orj3GzY+vvkCM2h7bA/zxUVGc4Jo/Ywk5m
	 97XJx5n6jg/v6OLTdeCmrJphmGfoY1lOFd+4TmFjaBiKnxtmoH90vtW1iYj0KsE3RoZlG
	 N3ueDx8BzJ0Crom0LJRish/oOJBWGpQ0LChRx0VncLMvldKf8s3PGN+QesBLB880DAocQ
	 njVijL+BfUGq4/W/6RuX8Zgz6sLO1Ia4oZx/hxlcu4Q3y2YfJJY5fdAosafz2mwwLtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794203805;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Zmail-TransId:X-Mailer:Message-ID:In-Reply-To:References:Date:
	 Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:X-TLS:
	 X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:X-Fangmail-Anti-Spam-Filtered:
	 X-Fangmail-MID-QID;
	bh=83qiyGR/mdNGmDZogj1X7fCDBnM7EuT7FI2pwbBVqPs=;
	b=UmZQ+pXxAjB3qiVuUs7TLYzgqScSwO1graqOZRjkO9+GNwhRoCne2cU3uXktLgm8QYhK
	 Xae6Xb4v8BUN7hdPyTo3Aak5chZEMaietRL0LZvCsKRWZ1Vn3tZro9gOLd9zArxqIH90J
	 VqbT0ix3x0gkDMIBGMY9x6qieMDEHAQtwPtC1GFd0elTbktT1CQ449V1GiDQ6+ANZtRg3
	 ScVdghYfWz0b5uCSx7/iCQvu6pNkIoBuRzvbHGpdcofkPX897I3de7CNb2XPjcOUEiCbt
	 xLQTdBJiL0YMcqJQKLPTU6kd7YW12V2OwjaV8QyYFcAOR2kdN25QZqBr0WIra1sJLgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	dkim=pass header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=rM+lN30L;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5BD606A322
	for <linux-scsi@vger.kernel.org>; Mon,  9 Nov 2026 05:56:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE5BD606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=rM+lN30L
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jNJvF0kfMz8Xrrf;
	Mon, 09 Nov 2026 13:56:41 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1794203801;
	bh=rNWwUQQoGwqW0NWrOMEuVPwA61ZJpcSU2Vmmk7SQf5Y=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject;
	b=rM+lN30LeBiXuoh9qLNFt4tAc5MmidSOQhkv39QAHnXeTCe6QDbGRthbMgQMWPFkv
	 bxwWauolH4KMtGbWZPNEVYwXPQKuPvla5dpNXcwO36ALQJNnSxrI9FW5yHsh0m/rI5
	 unj4yBcDxBJ1R4oaFwB2WQtt56QQXBa/PFWWznT5slwA1kZdP0K5RhEuSafv71KFoU
	 QoA14nwlB+sxE+44gOZigP5sf8soECZv8UFJSPWGl1Wyxs+iPukSpo3OBtDHrBtgEv
	 TiUgt1u4aoBXPYOocWSxvqHprm10zfyE4pv8irGEugEVXZqWzi51G/KWmFrBoaMrtI
	 MuyArkfrGrF8g==
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 6A95uZre056914;
	Mon, 9 Nov 2026 13:56:36 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 9 Nov 2026 13:56:37 +0800 (CST)
X-Zmail-TransId: 2afa6af16095048-12171
X-Mailer: Zmail v1.0
Message-ID: <20261109135637666O3DiZDXCvYaX9_wQNXOmj@zte.com.cn>
In-Reply-To: <sashiko-outbox-204381@kernel.org>
References: 20261109113810258gK5WuYWQKt0HsI2ikxmHo@zte.com.cn,sashiko-outbox-204381@kernel.org
Date: Mon, 9 Nov 2026 13:56:37 +0800 (CST)
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
To: <linux-scsi@vger.kernel.org>
Cc: <mkp@kernel.org>, <James.Bottomley@HansenPartnership.com>,
        <sashiko-bot@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gc2NzaTogcHJvYzogdXNlIHNucHJpbnRmKCkgZm9yIHRoZSBob3N0IG5hbWU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A95uZre056914
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 09 Nov 2026 13:56:41 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AF16099.000/4jNJvF0kfMz8Xrrf

> Does keeping char name[10] still truncate 10-digit shost->host_no values to
> 9 digits?  Once shost->host_no reaches 10 digits, proc_create_data()
> collides with the existing 9-digit procfs entry, and later calling
> scsi_proc_host_rm() removes that active host's entry instead.
>
> Formatting a 32-bit int with %d into a 10-byte buffer via an unchecked
> snprintf() also triggers -Wformat-truncation warnings under W=1 builds.
> Sizing name[] to at least 11 bytes and using %u for the unsigned int
> shost->host_no avoids both truncation and the compiler warning.

Agreed, and thanks for catching it.  snprintf() alone stops the buffer
overflow but still truncates a ten-digit host_no to nine digits, which
would collide with an existing nine-digit procfs entry.  I'll widen the
buffer to 11 bytes, use %u (host_no is an unsigned int), and repost the
patch as v2.
