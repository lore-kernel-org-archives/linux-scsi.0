Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44D134D382;
	Sat,  8 Nov 2025 01:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762565977; cv=none; b=T9lJ+ZTr2VvQ/R0he04PMoJPOLVX4Bpkhdom84s+gclWFM1AuBINWbPL7iKUDSiRBAx8x/6jShQTPpjIiK9MyubuteUsHftaHBD3zLNGbeC0W1XuOEzZ8zxhN73QcOPXExc1bOiH4kxN4ZEaUGMfe6yC/OlPZqTZz73EMKbLa3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762565977; c=relaxed/simple;
	bh=JW1ug37roxoSjPLBgz3/FqVl1lvuRyEeYMEJGlXhVEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pm1gMSWy8QGlpDNvqOcRJaFeO2zvOvL2/Va6iEYLnFy5I89BWaOKg3HjbC0LUF0Igc9HD73LF0Lw4k0BaqngJMYpmR+23UZ2TWTGT4dTFiSMU25VoKUrbRokZ/ofUl5pyu+DTAQcw/yHsu3Aq1QEpzRCw+g6LUlucYPZxZFepJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IcU7PLEP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IcU7PLEP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5883C113D0;
	Sat,  8 Nov 2025 01:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762565976;
	bh=JW1ug37roxoSjPLBgz3/FqVl1lvuRyEeYMEJGlXhVEU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IcU7PLEPS9O04B9GHYbX4LYKNBnGFYk6Wzf+1RmrnYXYlFmawAwRtoZft61AYIdqH
	 iMygpHWKVhLRJeIWKD2Usxh/fyPt4bccnnWAGmGGBRWEEETPPV/3JpxEYlkgBMwbj3
	 MNDOD6yn1SDQfiSLWNoOwQf0a7GBgUWGvosb5Pup5bWFYoODmRe7wnMvIEcbr6HcBg
	 LDAvwANdAr8D5UFBBkhJp8RPmzajfs7XQOLR/+oBDyKYAdekdmhVsoVCIq9RvACzBN
	 ZSuREggbI5c69qXMKxF0rTZ76fwmeOF1o8cmwW2f6hs964l6r+30Ko1aePB1ih4xGq
	 woj4pXD65/zvA==
Message-ID: <46670499-4e0a-4e98-aea6-0c350b648c70@kernel.org>
Date: Sat, 8 Nov 2025 10:39:34 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v26 05/17] blk-zoned: Fix a typo in a source code comment
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251107235310.2098676-1-bvanassche@acm.org>
 <20251107235310.2098676-6-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251107235310.2098676-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/8/25 08:52, Bart Van Assche wrote:
> Remove a superfluous parenthesis that was introduced by commit fa8555630b32
> ("blk-zoned: Improve the queue reference count strategy documentation").
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Send this separately from this series, in a smaller series with all the other
patches I am suggesting can go in.


-- 
Damien Le Moal
Western Digital Research
