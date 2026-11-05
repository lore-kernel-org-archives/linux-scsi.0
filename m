Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793899112;
	b=32cmJ5+re9GNEDIyFI57KrV9p9m/w/97jD9JiD0/Xr2BY7WHlyZTQE002qByTlAuUCMf
	 1PM6bEmsu+WJiLz4elze/4wl9w/U2/G3gYqJRzfwVfZECw+GDbR4nnGA+2np6GCaVj8Fa
	 LxC+cf08gkZzkw/MaB8AP2St6mJOyuvIAmh0tDSTl1wrsxFcUn1CCZrAQdlNWUkkaUIJH
	 UrQZoPzPp9H3G/+1KLrzn5xFOlQvx6z0tQxK78YIyIE2UQiCqB6KlOmIDYaoDNLvGEslb
	 Nz0Ls8Q5dgbL+ePnRnjFKnFRE/HQDoq9j4q9aVxH4m70cPcUgBkI9wNyP4OhSfgfkcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793899112;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=n0wp3nqIJF1XDBxHlZQWmEsvfb5rDdiG3Oe+tSS7WYY=;
	b=pNFHe7S7gLGcni/Xyj9qkgX/5iRjMm21lCckCYR1La2VkVdzYL4Ke2VELsve/9SfQJJV
	 U/8rDO7T/j+YrX7tiaUlwLskm/JkguSdOqVTmPksPs+iaGyGu2BgqUxnF25xdswKnDEO3
	 bzNwNipH0X4f4aHTrZFJk3W8uPOcw9lwW9Blnt7V6jwI55jcjmiu3kkxsOAS/ngVTIkbn
	 o9WgkLvUfgW2eVyu3CzE2Zq/Wutn4aprxG4tb4cbFAmsQd86nEpyLjlYrVQLx/4JSZlrG
	 BokoA+Gx+ws9TuUaHmR3kVxF+uTcxM+Xuc9yZvM51eYmc/QPRxAstOZEKZ4pbGP1rYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=QlRNRUSv;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F13606A338;
	Thu,  5 Nov 2026 17:18:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67F13606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=QlRNRUSv
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jL8Ck2TbKzlfvpH;
	Thu,  5 Nov 2026 17:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793899104; x=1796491105; bh=n0wp3nqIJF1XDBxHlZQWmEsv
	fb5rDdiG3Oe+tSS7WYY=; b=QlRNRUSvNNkGtz6+MwXHuIDYDOiTOE2ejyQTxeYE
	hYehS38iXKz0S/nfsDVpzeYadsj+Nc7yYxopUoVxvo+GTavVsz5KrxgWkzAfbCZ7
	uhEep7BXJ2LFTnTL8z1XqDJPSUWOhwK5nQkpGdWPIEE5c2VrBE48/rKqx68t68rE
	SPB7cFAzB04Ry3gcuRxlN5gpOy17SRYHfTMQkRWFBQLv9Aeoq1RtFcbF2Il8HTRE
	koNjNtFEYkeT+9MWG4jATBhbRngGdvhoCHAga/quD9ZxX1wtF0ZjQpQG0FsJ71Z4
	cOmGs4gONrYvfAOjU1G8Hx6oZvscJTAOem9o82dfVxns4g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hL7zpPmZ0FIO; Thu,  5 Nov 2026 17:18:24 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jL8Cg6ktkzlgyGg;
	Thu,  5 Nov 2026 17:18:23 +0000 (UTC)
Message-ID: <09f06fcf-d118-4440-8712-ed0ed19735b4@acm.org>
Date: Thu, 5 Nov 2026 09:18:23 -0800
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
Subject: Re: [PATCH 1/5] scsi: ufs: drop the unreachable offset check
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
 beanhuo@micron.com, stanleyjhu@google.com, loberman@redhat.com,
 jmeneghi@redhat.com, linux-kernel@vger.kernel.org
References: <20261105193333968SpAtZ8KtfXSeTZlDpuSOO@zte.com.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261105193333968SpAtZ8KtfXSeTZlDpuSOO@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/26 3:33 AM, shao.mingyin@zte.com.cn wrote:
> ufshcd_read_desc_param() rejects param_offset >= buff_len before it
> reaches the is_kmalloc block, so the repeated check there can never be
> true.  Keep only the memcpy().
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

