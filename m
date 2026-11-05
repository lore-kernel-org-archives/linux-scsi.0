Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901281;
	b=FMMnTEwdMk3wEJQ19doQ9VCZcC55XGUxvs95cX5Nfw/IqXpC+3ZA4eESxLF7CuNWEJWM
	 HgTaNHBfze+3Dd83ZMzJ1D+tx1h394jWiM74qbhaOJP7B4bz8NQbUyMjr3uURbTjZpcfU
	 rQykn1ojgQfGWab/XAjm7LN1pdimAKOL1Ect7s36fq20RSTPkybRkDJSsUkHjUqq0bRcK
	 s/1FooIFOjpOdFSrgFvIIJo1ixKfLoEc0htp6B9R5CedOlVgPDlPKgmY8j+LVBSE5r1V8
	 /l3GYsggln5KsLdoEJ1qOHs650j5QYO9v4DVi+AQZyoC78FlvBqhzhiNM+0xxRP7SpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901281;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=5+IjkulH/41uJDVRRhy5A1j08msFct8na960h1PoJ4M=;
	b=tY2QoLP/e9Bgt97KPdG/dZ3G+szhmxesT9ft0wvBRggMdPihK4OnZB2cE7maq3i13FYy
	 3837dhTi0ipIEIz2dxamFvHko1Bcaka5EOWBtlqnhxjIPEnbhpm1X63ke7GUdXcknAYam
	 2mdBeEZPZC5GBBZ6Fao+siMRJmRj1eOMPsSuDxPqm7ojaQhDNuuo3ZWRw/v7YuZXUgAwM
	 /a7Z9GeLC0AmT+W6GXU+NQBnboMyvkDjJ/Vs58YUDlMPyGVVL5hWmr/n6uFMSUMUXFxjG
	 BrGG4cXX7SKFQIHoHLkucbCjcdgl++AI2jNy0awtJnIolx5wf4HvMM7r8Sg2NzCq3Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=qUcgnBP3;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444EC606A326;
	Thu,  5 Nov 2026 17:54:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 444EC606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=qUcgnBP3
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jL91X5pJNzlfvqH;
	Thu,  5 Nov 2026 17:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793901278; x=1796493279; bh=5+IjkulH/41uJDVRRhy5A1j0
	8msFct8na960h1PoJ4M=; b=qUcgnBP3xkx+F+jgn5bfFNgbE5PpiuNT254GEgwN
	yrfpAdMQ0zvC59Edt0HFVimxHL/mTum6dfNeQuZNp+GPmaHWsShw4ACLN4qJ0O+8
	n13ewIBIGQcvZtb3M1qgdg0kY4eVYNB4WRNHVVSCk1wQzFmZ+Rj1rbVkEL0+1qSb
	I9z8gfzRm5JUr3pHG6EtqbXVLMoOI7L1Mj8JRc+RmQXvCh+pzyy1EDR/LxjnPnLY
	UK/r++fQK2UTuuLtIatAAMUilGEzc1HXOA1+C6lmfc9DQGc93IqNDYoAsfT/xh/0
	AKBSq5oTQ9QoNjbVIt/VWWQyTZx4mEXKow+am6h41DHPzw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FndtKitPy4uo; Thu,  5 Nov 2026 17:54:38 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jL91V04QLzlfvq1;
	Thu,  5 Nov 2026 17:54:37 +0000 (UTC)
Message-ID: <b2614f98-e21c-459b-8dfb-f2a1cea93214@acm.org>
Date: Thu, 5 Nov 2026 09:54:37 -0800
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
Subject: Re: [PATCH 0/5] scsi: remove dead code and redundant checks
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
 beanhuo@micron.com, stanleyjhu@google.com, loberman@redhat.com,
 jmeneghi@redhat.com, linux-kernel@vger.kernel.org
References: <20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261105193328462jmyNd656AIL6fPlbEJ1Ki@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 3:33 AM, shao.mingyin@zte.com.cn wrote:
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

A cover letter doesn't need a Signed-off-by.

Thanks,

Bart.
