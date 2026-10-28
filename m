Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793218568;
	b=I5B5czcbp3XYmLUXLm2tx+YPmxQE+GnJVov+nwJGKfnNtNeDUFkvtwacueg8AgRBqcwW
	 3um6ehvpoGVUSrxHUyleRUTEvwt0OomD0NnsE2HEeek8y6Zlb+CEMk0JwFzQozUlqYbW3
	 rVZtbwKJkcssSG9VxmjHNhef79lE+dxS17W3Kqns5Fr5u+2tWdnt1AoSkxB6hHL86U/2O
	 4Qubr5euquR80HTQcd0iWn9PR7NFEOHCKL5z3nM7zLYjcJ0h2T/qoClq0Uh5kS27Q0sHT
	 3jRrxpak3p3PmkqQ77XlC8ZwzQ+ZXPqkjISBmCZqwkd3cSDo38vzRXpjvF2TZ2vkm6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793218568;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=d1WzNJAb4UJ72QcrWGxBt/3DPnxEO2/sr0xCE07N2bg=;
	b=ggAkb6ch0JmdJCAo0ZkZuoOLCKV/LS4b9KZe5uG5C5zWK2aM17711GidkLa6M9jwJfZN
	 J5kJFXbbcS0rPIP6y9Uh9MZ047sihJN419g7pJowuR1WQwcy/qryBmf7tFvDiPeTmtRma
	 yxhRC94WB8J2dDPZnigLul0ti1g+CLbJlIanRTjKV155jeVNLyXdXyBrCXTmB6Rv4U5vb
	 D+ex3lMd48YxX966GN2/dvqXOyqNJ5jgFYkHCwMnv9xzd8CISfu2Q58hqzJsk4l1Jq8xR
	 fM+rypJO/Y0ZJAWUs48OucR9pTJKh2Lg7wSB3zfQVEWBaV1XaG3knSORwBNdORJKaZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=pqojwuKS;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DF160A2605
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 20:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42DF160A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=pqojwuKS
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4jFJXR45Jsz1XM4Tn;
	Wed, 28 Oct 2026 20:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793218563; x=1795810564; bh=d1WzNJAb4UJ72QcrWGxBt/3D
	PnxEO2/sr0xCE07N2bg=; b=pqojwuKSQXJu3eqU92Pdtlgg8v+dk/L7G72Qf41U
	CUE0esFn2bKcc+0MFSXtLKz+g/e4obfwQ7VSMAAWuCTOYCLMKKZOIDkKTvBC6yb7
	ip7yIbGNnuV3M6vpZQbfdgvGCda7we/r/pmguyDZklXkuPfl5RWdRHpxyY7ZW1yV
	+gBjcLDvC+ErjZ0C1ttTBdvl7QPZfJK96OX74FVw/vArRYn/jz52TEqw64z2/45c
	vexok5I2EBy94JNesuUk5vCByARMp2TAOWfd2OOIYvqDLjbb3SoPGoWVeT0R1HdV
	Q0yoJdD5hUwRImMQXSAKdIKWKqV785ZlsGOiyOi6fM2NSA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HMiw1daGfDo1; Wed, 28 Oct 2026 20:16:03 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4jFJXM2TCHz1XM4Tl;
	Wed, 28 Oct 2026 20:16:03 +0000 (UTC)
Message-ID: <c494f758-e3ad-4638-a17e-44d5f9234ef2@acm.org>
Date: Wed, 28 Oct 2026 13:16:02 -0700
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
Subject: Re: [PATCH] scsi: ufs: core: Retry the full device init on fatal link
 loss
To: Shawn Lin <shawn.lin@rock-chips.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <mkp@kernel.org>
Cc: Bean Huo <beanhuo@micron.com>, Heiko Stuebner <heiko@sntech.de>,
 Stanley Jhu <stanleyjhu@google.com>, Alim Akhtar <alim.akhtar@samsung.com>,
 linux-rockchip@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20261028073129.1661829-1-shawn.lin@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261028073129.1661829-1-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 12:31 AM, Shawn Lin wrote:
> +retry_init:
>   	hba->ufshcd_state = UFSHCD_STATE_RESET;
>   
>   	err = ufshcd_link_startup(hba);
>   	if (err)
> -		goto out_release;
> +		goto retry_device_init;

Move the code that needs to be repeated into a new function in a first
patch and add a loop around the call site of that new function in a
second patch. Don't change ufshcd_init() into a goto-spaghetti.

Bart.

