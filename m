Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=183.62.165.209
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732462;
	b=4kdhRAVhzmtDa/vdRNXaFGkuFpa1vZbwhTnbVZWqvAgatZXX6kQIYA/U/uEQE5MxOikT
	 HMNB6kTyAFJjP3PYFKrGQSqCGp6LANqgPxp0Fc0YNt3HHwhE3YV+3T4Tkcur54IdH6gUX
	 JBmNP4lSvkqM86w5IXRKNV/i9zR3YRoxPnOP0fDfckzRQ9oiasCJm0uhNfLh+PCLlBGQi
	 oHDGqoGAAI7JWGe23eP9prqJ97mv8Dx+iYXZnQFgnJ61vtMso8PhTNiXMvYdk/AEceTFp
	 TXzrPRiFQZELhI7jCs3rTdQku88DFas54RdFYhpYbMsKNDqPjxi5550k1APz0oRJ/0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732462;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:In-Reply-To:References:Date:Mime-Version:From:To:Cc:
	 Subject:Content-Type:X-MAIL:X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:
	 X-CLEAN:X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=/Wb2hWe4KA32hKCHvZDkI6uBk6DsPpr/yrXxExmyUpw=;
	b=M3Oc4c1xFNV9N7EMCO7rpJrN9ABapundJlGgGG1djEhYb16dvXbvxhP9DPcmnXxFuZR5
	 q2H3s2JxugUBxkChaBl1Y1WjUITfFAxJUP+xAmDxZmZR0RWncRnOTPAmQ9q3FkiYeLm1V
	 YickeNEj0nzE2dQDibcIJqQeyJOFGSOqjpL8STnZS22/TyHWFBHVL3/ZuGtMTXWTskbfY
	 zydwmpOZnBGhYz52bWTvZLtjyaZFKJjIn5Ic2QA3EObIOFhjo+DKsd5qasWBHMv+Xq9o4
	 3BR0pq69qjQhLcib32KNRIwrU8Hm9NxgAvTAmaesn4O1ZbmLEquRO819KTm1SSfMD8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=183.62.165.209
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB0A606D806;
	Tue,  3 Nov 2026 19:01:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AEB0A606D806
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jJyZy1wZ8z5B13X;
	Wed, 04 Nov 2026 03:00:58 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6A3J0n7R079058;
	Wed, 4 Nov 2026 03:00:49 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 4 Nov 2026 03:00:52 +0800 (CST)
X-Zmail-TransId: 2afa6aea2f6405e-d45a2
X-Mailer: Zmail v1.0
Message-ID: <20261104030052059PG6LDNeanA7C3vQaZAOff@zte.com.cn>
In-Reply-To: <4f38227c-a524-4d42-a3e4-ad0157939b41@acm.org>
References: 20261103185229490gmhePBF5_11x_thf4X-Rw@zte.com.cn,4f38227c-a524-4d42-a3e4-ad0157939b41@acm.org
Date: Wed, 4 Nov 2026 03:00:52 +0800 (CST)
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
To: <bvanassche@acm.org>
Cc: <martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
        <james.bottomley@hansenpartnership.com>, <peter.griffin@linaro.org>,
        <beanhuo@micron.com>, <stanleyjhu@google.com>,
        <linux-scsi@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwLzJdIHNjc2k6IHVmczogZml4IGFuIFJQTUIgdGVhcmRvd24gY3ljbGUgYW5kIGEgc2hpZnQgVUI=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A3J0n7R079058
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Wed, 04 Nov 2026 03:00:58 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AEA2F6A.000/4jJyZy1wZ8z5B13X

On 11/3/26 09:51, Bart Van Assche wrote:
> This series no longer applies. Please rebase it on top of Martin's
> for-next branch.

Done, thanks.  The problem was the base-commit: v1 was generated against
linux-next next-20261030 (7649ba73f9e7), which is not an ancestor of
for-next, so b4 refused to apply it.

I rebased both patches onto for-next (v7.4-rc1, 6628e7d4c6b2) and resent
them as v2:

  https://lore.kernel.org/all/202611040259247915t_cYYK0k5pPbEqfdTAQu@zte.com.cn/

The hunks are unchanged.  While testing patch 1 I also confirmed that the
teardown path only becomes reachable once the "scsi: ufs: rpmb: register
and unregister the ufs_rpmb bus" patch lands: without it device_register()
fails with -EINVAL.  On top of that patch, a synthetic hba on QEMU shows
the rpmb0 class device surviving ufs_rpmb_remove() before the fix and
disappearing after it.

Thanks,
Shao
