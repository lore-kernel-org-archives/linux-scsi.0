Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793580304;
	b=TE5DiWudwKMGDoWX7uOvNTjx/9Iww664i3xS6f2CgqfwaJtOy3Kp+mnGximwcyUsETIL
	 WUG2owsf9yLZBTPNC8KmqYx0Wd9H7EXCSYt22ZB1edHgQRRPbYx2u1bnPrQyqPoZv11yS
	 pZSsgs9TqzTHUaRSsqYww9pbp8RNeIYIeW7XtZOEVYiUfHx47/4WKoBts7jt2n1IBGwym
	 I68kkYtR1Mekr23fa5+siP99FS6td5y/j2d7Tr5+c8Q2lpE2r2AHOEnfy/otizS87c4jz
	 r2ghV4g/YYxwwVZNjA/DFYpp6qEiwmSzPQWcVZ+keJBM0zXnN89LaFaSKFprm/RR5KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793580304;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:Content-Language:To:
	 Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=KgTB+cignjVRgjQLxHLa4kjWTCIUS/wqnaBRjGnD9Jk=;
	b=2I2HMRx+mSb1+tBtnWHgqDlROXQ9EpfFpaPxJzyPfYitkKEjHwpJmVHEYGorYCQTjtCH
	 XHtgNvG2bnbWqDiZSLroFT0mDhMkVIYGWNi6V/lbaOICeTHbCNFOwvYnNmES0HwnBAnyU
	 jc58KodoMzOderbzmJYmHKx5N7HGjtaTTVY7FAxzG/n9v7khqFY3QhLv9XY3baTbCfrbP
	 8k83/EkZvf62Sv4ABEwHx4cHvyMYUmFweaxkpKPXn/bmWGVR7yZek0OKeo5eeWlDYfyCE
	 O7ndpC5Jjl/rgGSWLrJptakzUdODDibx0Eiw4xT7gdUTYQahCNn4oTd6vnmofAZR0Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e5mVdzUs;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBA0606A32D
	for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2026 00:45:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9EBA0606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e5mVdzUs
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-3514b90bb89so5020114eec.1
        for <linux-scsi@vger.kernel.org>; Sun, 01 Nov 2026 16:45:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793580303; x=1794185103; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KgTB+cignjVRgjQLxHLa4kjWTCIUS/wqnaBRjGnD9Jk=;
        b=e5mVdzUszWOQ1k0lfWiGZN7UQZO2C5j4Zqn2HgMmKnJtlhdYoUScQCeZLmwWj19Aup
         gdhy1ssuu6zwdYQAz5L8tv/KohMt73cBmyyYXMT1pomVW+rdbFxX7c4gMCzSfIx9Jc7l
         Y1uw+njWLWcD+glz55kQJG3lhKa9KHWZaUSJt4Jja5tUMEDcWc08/kjzwZAvpud6115H
         2PlePqxdytxVNYbtyRqGcK5iCviblwUV7L2evOA6kCovO0yzAOB6BzEDbf1yZe28BCor
         UHTatKhOqQE7ZBpqGunC9DOVBv19w6JyYMvvmiHkXIzBQCvfFr1KPeUozIyFDHhsLw5h
         zitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793580303; x=1794185103;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KgTB+cignjVRgjQLxHLa4kjWTCIUS/wqnaBRjGnD9Jk=;
        b=QpbW8VvZy/uGd9508EAe27NH/Snawhsu/D09ozCx8Q5Q8fUlbe7psPH3JsB02YrcBr
         6U7FlYCcpmkRb/uYzqCpSFKaKODi90ZGxtjQA8dZ3uz3R14HqkzwV7UTeGVzpMggYxG+
         1Z/z+Af8q7OYDeEwhCnGPra3/j3vE9IbtdvaYnZIV6SfS59sUqj99sU9CkU+RkmIB8ez
         mQsILBIQig5aPRSHFg27dj/jed7Liy4/9WbXh4KPdOrjdG3y4/+UtN7SRfJPjQNH1Ue7
         xxs9ZbCsPmwedk5Km8BaQQHnXM18Ik79BTEOvbkN5Aoh/qgfcjMU8Ltk1G7Kg7R/hKzK
         c0zA==
X-Forwarded-Encrypted: i=1; AKwUvBwUiZfbnnGfzS1YcNG/iA8xtALLIL2N+kdIO+bUsCYaHP3raRL2VyaiDJKFxZwReggtoz0YG1xwECoA@vger.kernel.org
X-Gm-Message-State: AFq9FYKI0yrh8b62Ffe06VZnEopPDikkqBAbfb2D9marUqp7/wuGQZJS
	qnOWmZ0+2+Acs6GSR/ET29ic1hKL2AYKqJhjAGa/ezNC2YRJXP+fTr9D
X-Gm-Gg: AYBFou1i8fC6XZsHRcEJ7CtWGawDIfUoag6rJ8aykqXXkbOYJLkm4/pTnZjM50O5/Wm
	zhFFZivIZtAxphpR8/PBtsgAX3zPfu63HF6hMnPWuaF9pJDMt2GBBYwhTO0Ht2jvU6+F8Rs82zJ
	MhsCikvlvw+MY7PYgYIMIznwbfwsdF3f59YO3daV9FOjVpejjf1iq5ekHtb5w1s7L0bcGtjJlRq
	RrR48gEL79fVlJ7qB0tRzH5US5pRqNYiRmju7tUcG9koJeGrX7HCPEO4EEvCCiLpdAOE+Ckyf+k
	ul/rzBW/MqT2Y62+gpzKoAWiGucaJR+GYlMLkQgvzWF4JLAZYf2VjxMQSL2pOjHayFIfZfR968V
	dawTOsJHQHKF9kdxZmGg3SPdx2IUnTJEtfLsOsja4pIpLxB5q5tDQDzSJ1J1Ym1NeHG2UQJrR81
	iRnGygjadmKpndjoLsubQiaJ1KNpDIQLzfDgWrrs9kcnLyHPZG0IyMn0Vtz662nzmmLhZcbLoqG
	Z/T1oQpCZMABziI5tnwzWxDQnbTrvSuhV4TlHxi7h6H6y6m66OVp00+ueKdCr0+kDMnzESU4OL9
	NW7We0OkiJ6xa/hiqDXAHzavgqnQx7IY9biOmCgNQPioyjqA/Xm2WHMCzJl4pFKwpP3twsX8kqi
	D5Q==
X-Received: by 2002:a05:7022:ef07:b0:188:ea93:6cf9 with SMTP id a92af1059eb24-1ac5eea1fe9mr15602497c88.43.1793580302546;
        Sun, 01 Nov 2026 16:45:02 -0800 (PST)
Received: from [192.168.0.22] ([211.226.54.223])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1854d925sm49255251c88.7.2026.11.01.16.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 16:45:02 -0800 (PST)
Message-ID: <e11a0f9b-e703-4f83-a5e9-cb28c85aadc2@gmail.com>
Date: Mon, 2 Nov 2026 09:44:56 +0900
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: mcq: Reap aborted CQEs before returning
 from abort
Content-Language: ko
To: Peter Wang <peter.wang@mediatek.com>, bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
 avri.altman@sandisk.com, beanhuo@micron.com, can.guo@oss.qualcomm.com,
 cw9316.lee@samsung.com, hyenc.jeong@samsung.com, j-young.choi@samsung.com,
 jeuk20.kim@samsung.com, john.garry@linux.dev, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, mkp@kernel.org, ping.gao@samsung.com,
 rafael.j.wysocki@intel.com, stanleyjhu@google.com, vamshigajjela@google.com,
 stable@vger.kernel.org
References: <20261030011321.1868029-1-jeuk20.kim@gmail.com>
 <c6c84b433923fb2c4d332dfd79875be9ebbd1681.camel@mediatek.com>
From: Jeuk Kim <jeuk20.kim@gmail.com>
In-Reply-To: <c6c84b433923fb2c4d332dfd79875be9ebbd1681.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/30/2026 5:00 PM, Peter Wang wrote:
>
> On Fri, 2026-10-30 at 10:13 +0900, Jeuk Kim wrote:
> > From: Jeuk Kim <jeuk20.kim@samsung.com>
> > 
> > ufshcd_mcq_abort() can return before the OCS_ABORTED CQE is reaped.
>
> The Initiate Cleanup procedure polls SQ_CUS until the
> MCQ_POLL_US (500000) timeout expires. So is this issue caused by
> the hardware completing the cleanup operation only after the
> timeout had already expired?
>
Hi Peter,

No, this issue can occur even when SQ cleanup completes within the timeout.

SQRTSy.CUS indicates hardware cleanup completion, but it does not
guarantee that the driver has finished processing the OCS_ABORTED CQE.

Before this patch, ufshcd_mcq_abort() could return SUCCESS before CQE
processing completed, allowing the SCSI core to retry or finish the
command.

Thanks,
Jeuk

