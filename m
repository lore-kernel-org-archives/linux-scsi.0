Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793625403;
	b=f08QnXBkDcEkl85MRNgG9zahqGzidFxxIK/KOVfCxFU70gmetYoy/9yrBvU0gnw7SmAh
	 U+/kvWQ8gdRk12zsGVDIKSa/Oc7YdB5lK4wX9UiVqqf8rmD/6oikTMWphqIHpmIHl5FcG
	 BJT0ztYyULyHUkdDlUi4WXa3G0xLypiT9S0bEQf2ei7d/koMWfaTZACHLpuPGfw2A3dYc
	 LWOtPzD/fWNLPjsjpOh2D+7+bKY5ECTOfE2MhwCoG3vtYHD22QWmQe9rQT9q7Z8vXjI8+
	 Pvb81O3gsPeOXGWdOv3ThV+tMQoTwMP8M/ipfHnxOLqFkz22rI+K0PqQQhPCmo97rxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793625403;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=+Oc6jTzV6cd//BNmZjbVeL349QlJ2qzTv71gr8ZXho8=;
	b=UKTzjA9U+pmqTaImhLxDW4tAxhAM4LjPeNw0V5T0aNPE6Ns9O9cYg96ipuzu488Zp00t
	 63fvb3TLNaF2dmvCeE89DM+mrS3iSl4SyMWwuQyex3bGDbRDF5rYr6vWvmL9GJqfgEMJz
	 StMScMqe+xgTK+O2HT5Indg94Q2GZSN3SGA1n1fS1gunE/A7AY+ouBB1H9KrcS7hO76kc
	 Qlhu8HqqjzrlG9EXO0fQSzBBWyjPqKEJmVt53Ca1tg3Db7LIa4PSMjCphnbx9B+9AZY5c
	 wsmlP4JrSwXd+bo1oF8IhnLyQhZ/a1omO7ir2TPIw1iRqj/zCXKvZiRsNQxHG4DGPdg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uy0Iz1pE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7A1606A337
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 13:16:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE7A1606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uy0Iz1pE
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cdb15cd8558so638794a12.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2026 05:16:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793625402; cv=none;
        d=google.com; s=arc-20260327;
        b=EBukYwUxJ9B0orSwCa0elec++Gsa0M/kPUc/flqdrChvec9+sd3+zghYxCDWwoUSkm
         bn49NJpj5ZWv+Hgp5bVz0ze84m+TAJDMNC9TsFE4KFjrCKsR0gDCJrTdzzJl1opArUem
         lHiPVo3v0sL2CFztEgADzj1T8VJbC7s8+tQVDDNavd15KdIIHdBVpkS5DTOGXC7kCqXu
         tzP5bEJD+7s6+WYE8kmEwczhQ8EGVC7NhVI0yBqdHW3Rvd1gilup1XYYslHubgxYgFNe
         KNPWmYD5q4/FYyAWlY0jnZTjUm3fNAcLc1XmeS4Mh3wfpG15y7jxdYjidnuJ8+qQJb3l
         GovQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+Oc6jTzV6cd//BNmZjbVeL349QlJ2qzTv71gr8ZXho8=;
        fh=6zhA3LrUyqz3pyxB1SNcxnfE2FzEct+gvcvGu5dLLBQ=;
        b=DN7bvE7YCjDsf5zkL1ixfArQVG3wCcQmyHivBujnzgR7Os8OvQLltD9XOBgJIYT+nm
         G182ITYs1P8N0UDSGJtnWo0d7VGsfgzjqkO7ATSQQHzAdS8B07N2AUzEZso6MZXYegsY
         5wdttiXMmBiCz+dMgqHTnrSKEAKKz+Vh+RRw7R5zlTJkQlCw0vDDq1Fz7YNB7SUrmUyW
         gbH9aglP5q8dBHIDZG1wROBggkRDdBcFTIq9GW6gKaFd+OfZHKr81xgK344JMgB2Wv8n
         2YY7/YQDDH9h98rGN6dUhAJ5ASZXmF5wgk1MsNvT/758TXHr8KTIDxO4N7SqKtj8G09G
         XUMQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793625402; x=1794230202; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Oc6jTzV6cd//BNmZjbVeL349QlJ2qzTv71gr8ZXho8=;
        b=uy0Iz1pEC0eUzpEdQgMeHeMmK5OS3w7cIZbWv9fE9oLf5OIXdSxaqsNpQ+xastIoLE
         LPeZ6CNQtd6XMk1oGnPDmARJHJVI/iH+2tE9UQHsGhdrhIjkfP0TPQ/hXndxj6u154Mr
         UuEHlNHuw247o5KfXxwO8d9KPK2ZqyomxScCKKaISJvbhxLl8L/5ndz1kSE92Ig2gAqB
         enjyLrRhcK0AXPb7rlhZS+I//73RYnacNK8s80zZovf1Q2Thac3GCo24g3d29PSuidMT
         5VYVuLkSULDIWS0VqgOEBKGxShHhTNZ4rIFjFpNinRx8Fg5C263vY4AqoS0+WKh3ktS/
         vinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793625402; x=1794230202;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+Oc6jTzV6cd//BNmZjbVeL349QlJ2qzTv71gr8ZXho8=;
        b=iU0cpd/wX+gMl1mTA69lPEC3/HEK0lWHGZo0tIWCsOWbTjojeCwnqMD4YgXGQ5qDBc
         /zfRd5xaodaWMVyqhaMD9alj3Glcj0L0jxGSiJ8IqaH4QvCy4zEBNpXYCZqYOM7QjLxM
         Kvrx03FGj9tVAlUzkG6YtZelCZ+HQk1RgKQYjqcq/n5pL8TvDGaC4Zzt2jiB1CH+lL2r
         RJGV2pmOPV2vzcizD85wUgfQ2Wvr6ix1BZbvCFF78c3ioPCdn8wci7ifwp/BiK2I1FS+
         4iMZt3El6+w1lDb1Xc4SEPbrZhxvnn82IS0jAUVe16f4+59MrLTK2cZ5iBLaclRFpF2F
         DYwg==
X-Forwarded-Encrypted: i=1; AKwUvByc2FQXmFhcJfmGyC4NCNDMBhpe8awT2JdmM8DUFQVIFkZXNvCiMyuPM0TUp2WP/RmgKeAAlb3LkIAl@vger.kernel.org
X-Gm-Message-State: APuU4Z81OixXYCQZXwtSBXXWYf/VoH/DWLJdSJsNKQqZIYzmF8HmHE9U
	v3tOaAwanSAhangTnRzPqZpV6Byz2QTgl6OQ3Al9kkJbdkaVG7R0oTtt58PB4ZXl/tdRaY4egiV
	DzmHV2U2l27b8+35IIVSDEX53IQrJCA==
X-Gm-Gg: AYBFou2zUXFHM9XMLtEDPnbVOgneGCNdr0jAKKT8XJapwO1EFdDW7S7TsWl++nudEwI
	QdKnSo4Xo+FQWxOiWt3SzdTEoV88A3LE6AqWJAfh5K+UXZ6dR0+sQYzO0vVxhywFGJJrOlacVkv
	TTx4XGPJAZkrB67G3zzMBWRAq1j1/K/W+LiUeWqXYm8kIxq1CBpLirM/gDFZLydIoPtjVgiqJqf
	N+kC+H8Po3tgHV6pDBSLYEBPPIMwdPXMyraX9qWb/2KZsqFwS8nOMCfK3TcvuT1j0tynCJ7RyrK
	wQ81A8PBTOP0PhLd495fNOMW5/Xg5fJr67h9O7oIip4hWGjsvKeOn+tIgAS/sebXQU0yGJs0Gmy
	cT44dizPWw4Js0p+OV6EI2OF/R27F8y7j3yuF
X-Received: by 2002:a17:90b:3d8b:b0:3ac:aa8d:19eb with SMTP id
 98e67ed59e1d1-3ae89573c91mr7474736a91.3.1793625402141; Mon, 02 Nov 2026
 05:16:42 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102003607.341651-1-korryasdlerto@gmail.com> <bc9e2b99be871ef8c7e74a5ee7d573082cf61545.camel@mediatek.com>
In-Reply-To: <bc9e2b99be871ef8c7e74a5ee7d573082cf61545.camel@mediatek.com>
From: Asdlerto Korry <korryasdlerto@gmail.com>
Date: Mon, 2 Nov 2026 15:16:30 +0200
X-Gm-Features: AclHuK94KlhySgh0x-kcv11s1LNVnedbguG09GxxTbahbyWbf5_kpbfzXgsG3DA
Message-ID: <CAARotkefEP3aVTvHJn8d5JgWR7ra5y8_8K4msnA4Q8cg-HV3bQ@mail.gmail.com>
Subject: Re: [RFC PATCH] scsi: ufs: core: Allow error recovery before the
 device W-LUN exists
To: Peter Wang <peter.wang@mediatek.com>
Cc: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Bart Van Assche <bvanassche@acm.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bean Huo <beanhuo@micron.com>, Can Guo <can.guo@oss.qualcomm.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I'm a bit curious why the first link startup fails, while
> the link startup after a reset and restore doesn't.
> Shouldn't these two flows be identical?
> I think the driver is designed on the assumption that the
> basic init must succeed, and that only a re-init can make
> recovery possible.

Hi Peter,

Thanks for the question, you are right. I went back to my notes:
the first init failure was caused by the board, not by the core.

The vendor device tree of this phone has the UFS VCC and VCCQ
supplies (PM7325 LDO7 and LDO9) without regulator-allow-set-load,
so regulator_set_load() from the UFS driver is a no-op and both LDOs
stay in low-power mode. Under the load of the first transfers the
device does not answer the NOP OUT, the host sees
TCx_REPLAY_TIMER_EXPIRED, and the PA error / LINERESET storm I
described only starts after that. With regulator-allow-set-load and
an HPM initial mode on those regulators, the first init succeeds
and the error handler is never needed.

Also, my claim that the device always comes up after the reset was
too strong: in my tests the second link startup succeeded, but
ufshcd_device_init() did not always complete.

So please drop this RFC. The races Sashiko pointed out are another
reason not to remove that check. Sorry for the noise, and thanks
for the review.

Asdlerto
