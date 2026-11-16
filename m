Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794848589;
	b=mHB2qKDExf5miscDuoI3mesp8+g9I7XT+xqoMaloFAOnpmfW3Ih7j1If1aow1SVFIs2L
	 AAqyWnTmJf7zI1S4KPL4e/5UqZfLRztpSQr96dLZZ6r5dOtWAtI5xcS6GumK5C091EJLF
	 uL4Lc+6tmXX+LCwgsXmeUt73W24+uYnhJ+ZrsAp4wlTEUc22uOejOaNyGd1DgtSnOnFHf
	 Qhlh8sutvO66o+/Q8z6bBbjtYzQoZWF3yqPCVvjGdngfkhPtnVaPH55axUjJKd0iCbYKf
	 16+kYuBEYnaF/hUNHnn5Jl61OWr3lqfcBCnTr/6aAN7owFJijEx17NBkRuKgn6cp+iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794848589;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=dErzLNRvBxXtOvVGiON0ydSBhI6280GOhN51Vz31A/Y=;
	b=SDxfx/55XZHTw6OpeYa+cW3dBXkx09eTbZzRqvDfcU6JN34S1XwUmajtdif8xKDECAIi
	 xuWexlf8G5sA4RFhgSSGGcRzDA2AsZNYEQnhcT766Xl2DQqxmTzFanCx81kgX2eqOTrHF
	 suzKj64avHP3jXy9rvkAdwmGuvkraaW621mbvS+7ximFiSQEf/xKk0yjOvJVVpFKDW6Pq
	 kTE+kbcxOzX8ExTPSD1mHhQdEFl+o7sIMRKAvxmGo3MPFsA09gEUYES4M8j8DlE2JRnBA
	 2uUwCxXtGlAZaFYIplOKSrkXtBt2N7DTTw1hiGb5yld1MhFVJaP48M9FMhlZGRK9c5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q0gJd2q3;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DF2606A898
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 17:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24DF2606A898
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q0gJd2q3
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3791619605cso7000915eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 09:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794848585; x=1795453385; darn=vger.kernel.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dErzLNRvBxXtOvVGiON0ydSBhI6280GOhN51Vz31A/Y=;
        b=q0gJd2q3EKYFQXvNi1Eigsvps9eW1V7otKakLftrV3NrwIZfxWggLdNvE6xS0qjzVC
         j4+quA6tWexrOFgnODWLzsAL6bMnGSsldWm39Z4ju5ac57rY8QLdHehiSzoaoiGRdKqo
         MWjQrAt5QEiInwszh9pAsavtAqdfCYHHhB7lzFxz/+DKrCh2vg97819+0CDhPk9ET7Sf
         qAb4uI57oZ974SEsFWAMTZ1oxN7Ol/670+fzEWiBKp1axqMONiX+6BW1niC/47gtDIhn
         Jw5ib2dJOxP8k4p6Jg+PRxqR7cQ4Zi1df2lA05rDr63Zd3H6A6+Cjb4Kyi/Lgp7fFRM5
         LRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794848585; x=1795453385;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dErzLNRvBxXtOvVGiON0ydSBhI6280GOhN51Vz31A/Y=;
        b=bUq7BRZlrAjVWvC4OiubPzejjlQukNG32QGAlp8OtgmJtne6sBTk2zpGjqZ1BbLjyB
         czwyW4Z+YBu871uQnbAtmIU6nHviGgXDN9KiBbQMpV42snMTeQqfbjy6JMLEPk2yGuC1
         6e8XNNvU1ML4lZUqwzJR+Xp0SY4WX+nE4crs0Wg9vrWutI58jwp/gGsbj5BESccmSDn/
         CkGRz452oTeM4LamySwDgInn8J7LFc438UdLne/kFhzE2VhUvkxWrSmit84xksW4Tjtj
         lntcSBl1u/n5eUoNAaGtZ2nEbd79kiDN+Jazt7NvRb7S43HogE5yQ3j6m0Ik4nG52iMw
         1/OA==
X-Forwarded-Encrypted: i=1; AL+hErHTgKxE2DFIqlHubdMWAD4Ky8UmVHI9rD+NyYA9FvoqtDEAKu7MW072jJhttDWltLZyNuk59GuFbeQv@vger.kernel.org
X-Gm-Message-State: APuU4Z+T0eU/lgnGF02zYnIGnuekKGGbXrdo/ShlZ0gf39AGMv7RHY7H
	NF73kd/xV7kdHpJ2hPuVNOKOVvr7bCVPS+cyxp6nn8ki16oErB9DBIqozoOOhSuT
X-Gm-Gg: AYBFou3/1aJG/BZINRqyyrZxXNTmkW2NBchtg8x6fj5iMofkd/iQDo3zRcxNPsnZeZf
	lUyrlgqqKZci62VIJhCiKPfsnFGPvI51gUsWnpPQTS2i78xO4HQmR2KN3ytF8coTHsYKc0H6inc
	GUBDSWyls2z8mgXaRSZkrlPT8rm9c9PskNNSfaIr7NN6qXje/vLkLcHDwRSr8sCh4Cv0SSe4wMj
	FEmlG1Pf3/VlRLf69SwyE0ya6WxRsmEkV4oR2jQUggMlMFFhr2PQXi3K/nBRKadfQiDkde2blg/
	Rk/68NseZ0TsS5wVVb6wjZwMJSAPqGjkZsgn+ttY7kmsHbi6gcu7lxSjGuBDoO+1BiMrbCkxdGc
	+XfhhgWMJ2huapRunzLUchjB0YBjJ19uSRUDD4FmQrzLChRSXOJlnMGMBADemPXeceQViQiJLer
	o8P6mBFIrQr69KDT6XlHU6gzyJH1sXcdgif0Q6EkGE8PdeaFQV4/mRT5NlzrcuxwBQ85/re+7Kb
	u18GajyrhOSQ0PIvlZrWyO/jGZBJirlWGkhJM9CHT9tGuUZyPWAVv4mXmw2gZTAnvHrs8N9xXmG
	wN3McW7yRfYQkwlJWzZy/IHBiSAdM2k4dyXU
X-Received: by 2002:a05:7300:6da8:b0:36f:14ef:ad08 with SMTP id 5a478bee46e88-37965abb5bbmr13878650eec.9.1794848585025;
        Mon, 16 Nov 2026 09:03:05 -0800 (PST)
Received: from [192.168.29.85] ([2405:201:8026:213e:e2c9:cd5e:3a2c:ae0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955a1c5c2sm36363384eec.14.2026.11.16.09.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 09:03:04 -0800 (PST)
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] scsi: be2iscsi: Fix NULL pointer dereference in memory
 cleanup
From: mdshahid03@gmail.com
To: sashiko-reviews@lists.linux.dev
Cc: mdshahid03@gmail.com, linux-scsi@vger.kernel.org
In-Reply-To: <sashiko-outbox-202780@kernel.org>
References: <20261107093611.42311-1-mdshahid03@gmail.com>
 <sashiko-outbox-202780@kernel.org>
Date: Mon, 16 Nov 2026 22:32:39 +0530
Message-Id: <179484855979.18018.6059499367901614954.b4-reply@b4>
X-Mailer: b4 0.16.0

Hi ,

Could you please review and give your feedback ,when time permits.

Thanks
Shahid.

On 2026-11-07 09:43 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] scsi: be2iscsi: missing Fixes trailer in commit message for
>   beiscsi_alloc_mem()
> --
> 
> commit 3a59c9fd50bd58745d465b3451671b988442c55a
> Author: Mohammad Shahid <mdshahid03@gmail.com>
> 
> > scsi: be2iscsi: Fix NULL pointer dereference in memory cleanup
> >
> > During memory allocation ,DMA memory may be allocated successfully
> > before the descriptor array allocation fails.
> >
> > In this case ,mem_descr->mem_array is NULL,but cleanup path tries
> > to access it.
> >
> > Use mem_arr_orig to free the DMA allocation of the current
> > descriptor and handle previously allocated descriptors separately.
> >
> > Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
> 
> [Severity: Low]
> Since this fixes the error cleanup loop in beiscsi_alloc_mem() from the
> initial driver commit, should the commit message include:
> 
>   Fixes: 6733b39a1301 ("[SCSI] be2iscsi: add 10Gbps iSCSI - BladeEngine 2 driver")
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261107093611.42311-1-mdshahid03@gmail.com?part=1
> 
> 


