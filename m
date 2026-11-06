Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793974921;
	b=ArP4R6K+YHwxa5jZQ7aAJYgO51JWLpMnvf/bMuf59NXcTX0h/VFjc30WAnSl53VbhLvE
	 E2Dbj/XsUf9NajGy6xGTPIjHddsqRLAraPZLPUQBu6WPGjfzb3r06YOFZmP2Hb0pVTu6n
	 ycwZ3qfk+XJRMHIWXimt7erYA8/fpCOdiJOJMJf0hogej7urFf+zxxW4l3J7MvvQWAMqY
	 uG1cVT+7HKAvWlVZmbt8rYnCDX/8xrd+YkBoOaN4dfYGdN73lorhIbhGwUgggMg+Y0a3K
	 zon0mvJKVCv9Say4Fy2TA3qtVc9ogZH04O1RzYZNkRZCaWY3rJjP/75M/bKlC0xlDww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793974921;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=odh+zzytzLU3bhAXDa2Ovw0+16X8iGnID+qwhl0zNIc=;
	b=iC2OR5Me02CvEsTpnJZcsWzLtajyAkRCwBzHAb+x1qG+ol+f832YElq7pDJRO30S6KJ5
	 mHN8VaSXQK1wnTfFuFJD9j7vGMnGrrP1kYTJFy5d5pj49n/2qQ1V5Ph9Sd/6Uz8o0p9KI
	 oN3XgqmlT9PqJYwN/am3DzO1TzQuH4A5JQ6nUE6AnEjxXoXEvJMIUacGRcoj4p+xjcSUx
	 lJ2odxbQBJ1Qi2vviuA0aNTV3s0jFd+AJEHF6n1oZWzdKUgLHgI9Dj8jXrRCTsSUm3HyJ
	 uA14MeShHDcEi/HkykO88xdUwCx6cDNQlKTrIt8RzSCSk9oTDTjCx9ZU40jV8K2dGCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9D1606A329;
	Fri,  6 Nov 2026 14:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D9D1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jLhFX3gwTz8Xrnt;
	Fri, 06 Nov 2026 22:21:52 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6A6ELk9E017230;
	Fri, 6 Nov 2026 22:21:46 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 22:21:49 +0800 (CST)
X-Zmail-TransId: 2afb6aede27dd94-40d81
X-Mailer: Zmail v1.0
Message-ID: <20261106222149748zg7NdjUUPBdZ9PHk6AXKN@zte.com.cn>
In-Reply-To: <e89f5d5656ef983e21e27a8557ddd178e108295d.camel@redhat.com>
References: 20261105193339565ydLHLai73bbBko0TtjrtV@zte.com.cn,20261106154249447T0sEhKHXg8J8MF0Fo1Op0@zte.com.cn,e89f5d5656ef983e21e27a8557ddd178e108295d.camel@redhat.com
Date: Fri, 6 Nov 2026 22:21:49 +0800 (CST)
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
To: <loberman@redhat.com>
Cc: <bvanassche@acm.org>, <mkp@kernel.org>, <linux-scsi@vger.kernel.org>,
        <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>, <jmeneghi@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCA1LzVdIHNjc2k6IHN0OiBmYWN0b3Igb3V0IHRoZSBlbmQtb2YtbWVkaXVtIGNvbXBsZXRpb24gdGVzdA==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A6ELk9E017230
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Nov 2026 22:21:52 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEDE280.000/4jLhFX3gwTz8Xrnt

On Fri, 2026-11-06 at 21:42 +0800, Laurence Oberman wrote:
> The refactor looks correct, but I don't think it buys enough to justify
> touching this code. [...] NAK for now.

Agreed — it is a pure refactor without a functional need, and keeping the
condition inline does carry context.  I am dropping it; v2 will contain
only the four scsi cleanup patches.

Thanks,
Shao
