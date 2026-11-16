Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865330;
	b=ShPydXa1lWGLNMW6JFyC56ia4YIhGQO09D5318C9Ler6qpHHhVcf0naIEKGn/FrTXaxW
	 LzGsmFgU83rrEUWFE8H9UCo1ey83919kvejnMZMUq09YuepsWmQNFkTdILMgwQPIqqKg9
	 pvVJmhS2lGsKeMm7Aga8KKo07oeZmO9iU2/wtNIYM2VXIuww3f1MhHNaYgDeHRm0DsPDO
	 5VLcmrcyh5QAWB8Oy3SGcHtFUWuoSagODAxYzSVoKFpsEpBo/tKlSl5AgxGnbqDDlDl6c
	 QNC9o3QVDX8j+rZr9vIijuMzAbqhHH9VAgKKIQdwX7syqpvcM7OGXAvpH1gHoGzgQ0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865330;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=UmYC11x8AlXeRfSKBkm7I/+J5DM15/0CFHUvoEFRp0Y=;
	b=uOqxOgHtLAC1Vh1mdUalCkIsCp0/e9PLcPxO3KOkr29sbUj+UyOWcJ7tCWRX3BaKVwQg
	 vugkYhlX2yCazxm5r28SXQ7syag28SdFf17FoKZWHrJzZAgVSiA4Z+SC6oeLXEtV0v4KG
	 7TlO4EQ6i2sWjHseFjQiA7OSr97Y82DNRwqwo9uWcoMA6jNFXicdLPu9NscSJrJWlEf1i
	 IS0aod2I++35GP6wtV8GuVPSxMm2gXkM+DW/ZsOyPZMYbUwXgy6c3Q+sA8EXwB37HRcjh
	 Ff7iMfFHyAE+TSMBBiZi1aHqRGibryGPad+QxXgBzjcOfzHBVoWi1nz1T6vp2SbdsqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JeD5aMby;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F5F606A337;
	Mon, 16 Nov 2026 21:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JeD5aMby
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDA11F000C4;
	Mon, 16 Nov 2026 21:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865329;
	bh=UmYC11x8AlXeRfSKBkm7I/+J5DM15/0CFHUvoEFRp0Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JeD5aMbyHJUCqmpKeuvvkpwjisKPTZzzkpXbDTIPCivuSAd3WXLbkwAg2Vlpj4Zxc
	 s6Db4oiEaf5Q59bho+OwW69AYzXyk6kj3Y34df3NFqQXAv7YLgX9z/ZuhhDJI9OQHb
	 ouy1ty/KsfcVlOfld4mb14diBrgbRGGjnv5rfS2Ufvgj2vKW/aSMFLVkzFTH491aSs
	 fEy3jwaqWgN65MeVNjLW9V+5PqQbTwaFs7NUoJ61ByX+fPPt0Zm0JiBvDEqGXWabw3
	 /khUyngP894PyWLTUHB5e3m1rzG21UAizuQ/8syM0AKHm4HW8udOAcnFDZz0KmTOLg
	 idh9tQsx6p8VA==
Message-ID: <dbb87d33-095b-45af-9e5f-c2d8fc94ebfc@kernel.org>
Date: Mon, 16 Nov 2026 13:42:08 -0800
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
Subject: Re: [PATCH v2 0/2] scsi: scsi_debug: fix zone reset with virtual_gb
 and DIX
To: Tal Zussman <tz2294@columbia.edu>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>,
 Douglas Gilbert <dgilbert@interlog.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261116-scsi-debug-zone-reset-v2-0-83c8a9841f4c@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/16/26 13:06, Tal Zussman wrote:
> Resetting a written zone on scsi_debug zeroes the zone's blocks in the
> store, but does so with a raw offset that doesn't wrap around the store
> like writes do, and without resetting the blocks' protection
> information. With virtual_gb set, resetting a zone that starts past the
> end of the store oopses. With DIX enabled, a reset zone can't be read
> back. The first patch makes the reset wrap around the end of the store
> like writes do. The second resets the protection information of the
> zeroed blocks.

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
