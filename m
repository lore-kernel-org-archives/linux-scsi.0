Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793950976;
	b=QQHyK8cj6XU2eMSrxRlvYX32wo4ldomhiCxvb0uf5zqgmHAO5Tld8fSmPMcmr4R9Kv3F
	 lc5ho0awLNJU8ml2U9iwpixFtuqQRXhkBaKW3XTNkX+HxMQGvvBvQi77JNY/nGJMH5FE8
	 Vtqax8mO9J7i9qT968urB6H8MWG6JtaomH3scWdn9lnW9U7X44plsn2Bg/x47yYhA7i9i
	 2sbWxtAfZROLgRjGdk39Gq/FX72UzOVGBh3cv/z4uuQkJn06m1wj/s9WtBgiMxuMBOQyn
	 wYKzFt0FUax5cVttn97a8EY4lW+6ZoLp8d4/68iRVa3WSl0AArQrIRlwxCSLXtZ5ATg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793950976;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=vYHgODIRXT82/HAf7og9CYq0G6pHmdVrUA1/tXPjYjQ=;
	b=emnpgV/nTv00GNLHqD3ueBypsYP9wewIRTNNlH247ho2FYLoCZxLQaQ/aU8oeoAWPwty
	 YQ+KQgBV4ovAybxAVzWa0vgMCdLfa1AAnRUze2/8N4XhpRaNmi20VSZovxf66snyWRI4a
	 zNQGM2D/F68ikVh5kLwJ7bo3zr+RJGZ3f4tqQ7hHnD7I6t7VRMrX9VhxVdL6kb76HXyRS
	 6YDEhsBroIdpoHt5q5Pmu8+ycsvbkVWMOJ4fVUkBiOMdQ59L99TKC1m7MehBjNoUQYvlP
	 5DsvHXakxSIepQ/fLh5uGr3Jv8h8gVGW2cQEarEcorq1bxGDY7j2ABvAjR3YbbuH6Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.35
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7572606A328;
	Fri,  6 Nov 2026 07:42:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7572606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jLWP76sc4z8Xrrf;
	Fri, 06 Nov 2026 15:42:51 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6A67glBN013372;
	Fri, 6 Nov 2026 15:42:47 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Nov 2026 15:42:49 +0800 (CST)
X-Zmail-TransId: 2afa6aed84f9028-1b238
X-Mailer: Zmail v1.0
Message-ID: <20261106154249022eo5VZDXUxlkDh8AvV93iA@zte.com.cn>
In-Reply-To: <36444b01-a31f-4ca0-bbd9-49c83d045965@acm.org>
References: 20261105193338195knvPnRIVc5cwFpUvGK9yw@zte.com.cn,36444b01-a31f-4ca0-bbd9-49c83d045965@acm.org
Date: Fri, 6 Nov 2026 15:42:49 +0800 (CST)
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
To: <bvanassche@acm.org>, <mkp@kernel.org>, <linux-scsi@vger.kernel.org>
Cc: <James.Bottomley@HansenPartnership.com>, <alim.akhtar@samsung.com>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>, <loberman@redhat.com>,
        <jmeneghi@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCA0LzVdIHNjc2k6IHNkOiBkcm9wIHRoZSBkZWFkIC1FT1ZFUkZMT1cgYnJhbmNoZXM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6A67glBN013372
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Nov 2026 15:42:51 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AED84FB.006/4jLWP76sc4z8Xrrf

On 11/5/26 09:20, Bart Van Assche wrote:
> Please mention in the patch description which commit removed the
> -EOVERFLOW return statements, e.g. as follows: "Commit 72deb455b5ec
> ("block: remove CONFIG_LBDAF") removed the last -EOVERFLOW return
> statements from read_capacity_10() and read_capacity_16()."

Agreed, I will use that wording.  I checked 72deb455b5ec in the tree: it
removes the two -EOVERFLOW returns and neither function returns that value
any more.

Thanks,
Shao
