Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DE131E844;
	Thu, 12 Mar 2026 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773325671; cv=none; b=I1TfjsdT/+xYAaXgSO6jjBNX7Zpx28KDY//F8xUW+3ExjKIhhPNzNrWCD+egDazd6acZvP1dthuJXlwh8hkPrTsTRGyeb9PNbXpEh9HgYAWJajwccr6gZQBhVhS4lFjJKM6lKecj4dzV1g3MUDnZGto2OwhAB/PwS1mRNGkQAM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773325671; c=relaxed/simple;
	bh=6w3iownXeFekbzjNaPQh6owAJuDVgW0ExGPDfHWK3vk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BmtdFoygBzSi9Saky9zXWRLtkR1hlnVlxGzjcRCjI4BbmsEZ/BvwfLbVXPf/hl2NhxbT/Wkk5Gm/z0983NMwSi1s4UD8JgJpcDiEo8ptnJSRuSAok/xQbPHAwacNrm0psuYYZ8hAZ6kp86gqpwaBgZ3O0y74FrLrU5FwyaIJ6d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=05eBr5S0; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="05eBr5S0"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fWqhj1FLFz1XM6JX;
	Thu, 12 Mar 2026 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773325664; x=1775917665; bh=+tuZgfcLJAnWsfI0aB3bhUnN
	FFvWKB9/WEveovfYRBE=; b=05eBr5S0EjkCJDvNrW2yk+Rr9HQ5N9CiBrfSVSoi
	G9Zm8cdZJtwY5cOdoL1HJuDdiZNJGVhtuAquKGXrJ9CagZZfzKrDCmlapqtY40Pg
	429Gxy5uLUOydBEQUNs7nEStp1Dwq8d4VaTIu+BXh6lzrLuxIGQnN19plOHxu9Vj
	G10MLl9E5hcBm1q4e3y9nc01I61y6/isQGblyCoVGS2o+7naeB0YBL3uMPD/+1B7
	0EGAM4TxC1Gqo6A+T8hi0x0D02fllZrwig8or/zHaRLMqKLYtDJiPG5o8Ia5rBMQ
	GN7lK9ltj7LsZjLdprm3H7IvNQzC2SpSDj0iXYYSk+EAjQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1CCMRBkKlill; Thu, 12 Mar 2026 14:27:44 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fWqhX2qRsz1XM6J6;
	Thu, 12 Mar 2026 14:27:39 +0000 (UTC)
Message-ID: <b9024d90-6df7-4a2c-85fe-7f5178e7d1cf@acm.org>
Date: Thu, 12 Mar 2026 07:27:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: drockchip,rk3576-ufshc: dt-bindings: Add
 new mphy reset item
To: Shawn Lin <shawn.lin@rock-chips.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Heiko Stuebner <heiko@sntech.de>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, devicetree@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-rockchip@lists.infradead.org
References: <1773276707-24857-1-git-send-email-shawn.lin@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1773276707-24857-1-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/11/26 5:51 PM, Shawn Lin wrote:
> Add the mphy reset property to the devicetree bindings for the Rockchip
> RK3576 UFS host controller. The mphy reset signal is used to reset the
> physical adapter. Resetting other components while leaving the mphy
> unreset may occasionally prevent the UFS controller from successfully
> linking up with the device.

I see "drockchip" in the patch subject instead of "rockchip". Is that 
perhaps a typo?

Bart.
