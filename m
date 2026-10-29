Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793271567;
	b=hQ9o9eZYguM+FEUQjrgN3QpQgd0h+mwimzGQhxFmVXgFdPKJ/TN8n8foWk5fc9PGN7B0
	 VcNWvI7KbX9+AQ6kFsBjoDy5DafCwjo+i31a+kcixs4yfQYm/XTNYbdBWVxfLXY0qyAyu
	 4w7ws2EW4CfSdxrpCp29tTfqBysO8NQ8Chae5Bd2/7UmNYEUcIrPqPobZ0Zl32/KJTQPf
	 ZNQHlcuCD+Xzq+Zf9EOC4OEHaPpWSsWYKkI9Abil7OwH3YvsLhwapL4Z1xOCsZ9Yw0VPe
	 xwHC0CrJnRZDU5geRwduSrQ4u2HymIOCFJIKEA8jg+zYgD0zIT/eQmU+meUGASFE5YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793271567;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=BjLzw1kM6LZTzUaUxJhqUTMufk3/F/G637drKyKaiJE=;
	b=IiEQd9RMVW1bDRbAq6dsIJAhqCbTRKtnxzQAa/rjOekrqIiXj5UwMfK7DqXboSbaeTV+
	 DW7T+2U8SyRAKwLBxjzQj+PjmZId6oZEximTAh9qa2y4FH/lbgOBqqw/LWMAkfATOa0tC
	 XpcgU3orZdFS3+VC83DcXSNIglo/DlVl5FPgVjIiEseQDhY6i4RH78X2WCEZRPdEDPaY9
	 E4upmMWZ0iMUEgCSaVltb1zQEFo1YLLo7zA/aViI3HzrEYpbXH876DnW11Od/RW6dXmmu
	 9sI1/2xgvz2C0OYD4G+3oc/vwWswWvkWL77xZLLKmes2Gnt5tOVGCQi2Iq1cri3nJEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="p/QONaBU";
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BBF606A31C
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 10:59:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32BBF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p/QONaBU
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a215e64962so21169355e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 03:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793271566; x=1793876366; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BjLzw1kM6LZTzUaUxJhqUTMufk3/F/G637drKyKaiJE=;
        b=p/QONaBUeuWz8ele7CgjVKq2RtfloFiauiV98PyQcOH/LZQH6jHOetr6yagJOYtMUl
         U1YtJGLhpSHmKRtFecnJbcTk54YPpHMUaqCMMFdyrVxBNn6EosuSX2WN/D5tNqtutHgk
         W9OsYWZQSpV/NKOSfCBOurFMr6wNFE+4CgRjaWrhI66qcpSQfxiVga0/CkWzGPI0cwx/
         yCucYOlC47cPL9VNX7PosOHYPolW8v5+1x9wkBF+bXv+pDpzZAChsjjB9MrcK9I6UEVD
         GXz+Ns6XSlqwvlwjqn3oaBCKeTht+Vk11lmzuYCghqfw8nILm3+AI86vOVzmK6p93dhA
         hYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793271566; x=1793876366;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BjLzw1kM6LZTzUaUxJhqUTMufk3/F/G637drKyKaiJE=;
        b=Tps+aSFYD+n4YcZUKeodhPwOzcHEhT7fqi85Qg1UorHuEUF/khhTsyqqVFL/PnXbUx
         IPkk217Ej+apHacmLJ0uqERjvnyzWLNeew9jUwdLE5/9c8oTgSGWvCG7wt0NJC6qApN+
         mJfEgOXdXQRZ7SSGbiE6t9Pf1NDEdZGI9/iMIkgpSAMORYycQRBT3e7GT8MbOTJRrvmK
         hDs+Ah5jugEaU7sSo2+6tmsbrgnVyKEmdmUmaDx1hBd6+YgVOcQXzr6eUahUyxEypyP8
         6rjoU8TzvaDMjSG8z8QBO6xd4yEUiwvGiC8IoXQ1NhtjxHFcTFTc2SITqRxR6s4X7yPK
         PLBw==
X-Forwarded-Encrypted: i=1; AKwUvBzqE6FK8136L9a4ZIW7jH9TZE+in583tghfLfbTQT5Eg5H0ENkB1dgHoENO48IHfETIGure1Y4YI5Iy@vger.kernel.org
X-Gm-Message-State: AFq9FYIIeUEYKlrKOynf35HTJl5G7zp8If8h4Q1MnIXOZed+Gw+l8lIu
	sVsMccnS6ucMsUaksdtpk7W/CXOT1KEf8Eea/hua/WANTB+CmIDecU+x
X-Gm-Gg: AYBFou0rb+ql+ursoNvKL0jnDiogEvurAOMt+zyiAyRcyCu2T0n4rXH5uVWdaE9VrRn
	vy/FvW5xFncMdqJ77QcxW3aaizd67aL4PRtS5BEeFvv5zkCxIlnZbjOOHlMjeDLOZvqEySuVgtE
	9A5ua3DpMwyjWTnhwjWoijZevfxm/31xpxjQqctVRV/kWAAo1Qjd7U+sNbTHEJYJYCin+QlYuZm
	ms0vY+1fh5RWuFCTR/J8TULVjeGcd4XLpYuPNJBFUnY6+6/Rrmmk1Gluw3dxSkVBBlY1Zos70r2
	0KW9YeYPhIqSsiETfUsODzPBJZtW4p/jV8NqQGppB4928HWHIOb+p/5sMqMk74glCmGjL9EPZDR
	aTULME+xbxOaKXRbiajv57jH/6ah/7Oa9Ud63sSAoCvZceaTEMoMvDcloss4cR4aZPb6vvS/D0J
	usmjhPD9O5uT+3fh7Mb3ZFD+MTIvLQUpEGPTUD5FZsikGHUJo6N9uKVTtUFMuUyZyPXzdWX2NKt
	hQD6HhJy1r8ZsSjEef62sijcP1QUZlP9ROIaj2/eA6rtiEh0+3peFi44mQ2mbrzNqu3iKqRnNA1
	0Cj+7dQ/jjjyV5Jtvja4q+HN/B7foPtbb0ctLhZ31jwDLtJuU3dGzeWpckFKoUBEzkdtyNlZc1a
	cVYnlZ46JmlyJQk1b8g8IvjMcf8IQ2j6PR38ba+jLT8DYmW7WxasSZBCp0Ziy67YQGnRsJISVhE
	z+1Q==
X-Received: by 2002:a05:600c:4f89:b0:4a1:c6fd:4db0 with SMTP id 5b1f17b1804b1-4a966c41836mr125002085e9.19.1793271565710;
        Thu, 29 Oct 2026 03:59:25 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa7ee575e2sm58301065e9.1.2026.10.29.03.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 03:59:25 -0700 (PDT)
Message-ID: <c4acc3b3-be8c-49c6-b1ec-b25431d28d8d@gmail.com>
Date: Thu, 29 Oct 2026 10:59:26 +0000
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
Subject: Re: [PATCH v2 3/5] io_uring/uring_cmd: support dma-buf registered
 buffers
To: Anuj Gupta <anuj1072538@gmail.com>, axboe@kernel.dk, kbusch@kernel.org,
 hch@lst.de, sagi@grimberg.me, James.Bottomley@HansenPartnership.com,
 mkp@kernel.org, bernd@bsbernd.com, joannelkoong@gmail.com, miklos@szeredi.hu
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 fuse-devel@lists.linux.dev, joshi.k@samsung.com, anuj20.g@samsung.com
References: <20261022144501.2478417-1-anuj1072538@gmail.com>
 <20261022144501.2478417-4-anuj1072538@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20261022144501.2478417-4-anuj1072538@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/26 15:44, Anuj Gupta wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Let callers of io_uring_cmd_import_fixed() opt in to dma-buf registered
> buffers with IO_URING_CMD_IMPORT_DMABUF, and attach the current map on
> import.
> 
> The map has to be dropped at hardware completion rather than from
> task_work. Add io_uring_cmd_hw_done() for drivers to call from end_io,
> which drops the map and queues task_work, and warn if task_work is
> queued with a map still attached.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov

