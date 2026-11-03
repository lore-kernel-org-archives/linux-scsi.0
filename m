Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793707160;
	b=u/kuUqb6aLio8XDleX2zoTKdF+Dv3OIo7scNbxm3/3qjBw9fWPSTaE8Y/STof01rnHqh
	 2XQblLVfslKTn6R0dUYU1u8nCmdqSN+iTvdV6pazCQkn6a57XdVIXRyI3ryeeZglr+vNq
	 EwtuFjX+Luj0gfPGQKFIQcIskjRyEDEEIz9Qxyw5NPeUqbj0rZnlohpW7PhHpy29i5leJ
	 wiBIVvbATShP6wMZaxuej+Y0VXqfWn5WdYgPlLsj8t+RP2ZYc2KJHnAqYY0Dy1ZxCp5Xg
	 xSMAf4Iy2yNScKbXePwYhGs36JIShIte2szeqtArE+MTTjEylecF6TXj+eP2Nr+RrJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793707160;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=yEUMwJVu96HRh6hOHs3XR92mos2IGfXBgOLwstTXwEg=;
	b=p/qyV98JgWWwco+sZz8tHSuf+OS6SClxd+T9Sgh19/I2LDiUDmR8xv99Rim9vJU7xDW3
	 Xf3ZCUTMbDKp2uqtFuHh9ZgkYHcckqaR8Z0kv6/n3lasTYFHawNCuLRwkSFjT6oLAYIg3
	 vu6xKpkSd8dpK2qJcXchtWNGZ33A/TK9aiviaB1ZGImjzcQ2nDRwEDmQA4XV9sO9mSdBr
	 z68S98xbnXdPt7XfKRiQlAfOaS3T4qrirdawJNQtZSh/Glrr8PVf5PjwEyaNpbAY478YD
	 XyfA3mBduDDJZiQgJ1SBeUnn6URdrWBf/9e2wVKmgUp+oOfuwLlEhOIQhu5Zbyx8WLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D297606A329
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 11:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D297606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jJnDN3kxqz5B104;
	Tue, 03 Nov 2026 19:59:16 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6A3BxBkK011173;
	Tue, 3 Nov 2026 19:59:11 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 3 Nov 2026 19:59:14 +0800 (CST)
X-Zmail-TransId: 2afb6ae9cc92de3-164e5
X-Mailer: Zmail v1.0
Message-ID: <20261103195914658qezb1CImrp1I9j3kmMovp@zte.com.cn>
In-Reply-To: <sashiko-outbox-195103@kernel.org>
References: 2026110318534911091Mvzh5diLU9SKNWyne2p@zte.com.cn,sashiko-outbox-195103@kernel.org
Date: Tue, 3 Nov 2026 19:59:14 +0800 (CST)
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
Cc: <sashiko-bot@kernel.org>, <mkp@kernel.org>,
        <James.Bottomley@HansenPartnership.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gc2NzaTogY29yZTogcmVqZWN0IHNob3J0IFJFUE9SVCBMVU5TIHJlc3BvbnNlcw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A3BxBkK011173
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 03 Nov 2026 19:59:16 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE9CC94.001/4jJnDN3kxqz5B104

Thanks, you are right about scsi_execute_cmd() zeroing the residual
tail, and my changelog overstated it: with a host that reports a
residual the header is not left uninitialized.  What the check does
catch is a transfer that stops inside the eight byte LUN list header,
where the bytes that did arrive are read as the LUN list length.

For a host that reports no residual, resid stays zero and the check
cannot fire, so v2 will allocate the buffer with kzalloc() and describe
the residual handling accurately.  I'll send it tomorrow.
