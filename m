Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692DD13CC78;
	Fri, 29 Mar 2024 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711748267; cv=none; b=h8thZI7Vf1vrzgRqwmt4gisSSrLIVy9C64cS/M2WsK8CakXiuPBQESepqT6aSS2G0mDSRUC/XqRRbLYhEW179ZB+wz1h1+hnYVdO0aITlaft+SN/jUQY7GSogQ+EXrjXkixrmRooiMG5p+HchTI9oA69xKtV3DpJtLam9FHDS3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711748267; c=relaxed/simple;
	bh=FRIggP1YvWWV3rj+5WU1Cj2nMoZrQOSbDSPE/2jMC40=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fiJfLk3eS/D80OsL88NR2gNtWpY7HB0YaXBA+03XxnBZgEefuuVeuPOmR/fiMeWi+bc630FDVMIvujDzMWB2G7Dnyg1eEU9MgXIB8GpFn5Akvq2skLRnDlGY1JzwIcWQPBVFHn2zkX243Fyn7/f4DfNOzC0Jl0qoTf9PLK17Hic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lVp9b0yy; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lVp9b0yy"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5tzr6SlQzlgVnN;
	Fri, 29 Mar 2024 21:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711748262; x=1714340263; bh=FRIggP1YvWWV3rj+5WU1Cj2n
	MoZrQOSbDSPE/2jMC40=; b=lVp9b0yyhPEkOBQUKc3k9IL1WzQ6D2q4FDbVNtW1
	n9f0X7oA9nCAkwnP4EfkJA4/Xy2T7R/zCvNODJVshQkLc7rpXX1GBeuRHIp+1jdO
	Y3rNQbhIZxc5j6ZwKBDAC5Y3TleC92NrIOdYwRX2qW+mhc05Xca4wUfQrv9xVkqO
	StfNjvggsFL3yV5VWn7d2MFiDJnRh4C5grAXF5MoQonuRglIYr8BXr0y4vSFcQ94
	GB1VGot+Q4568i1AJ7D25hfPwWDS7DazRlr8qwV+C+77W7awPZYwsCuDoVmzc/sb
	LVgDkfr41FYnBfQI84n/txX11DVXnlxQgpnO81aV0xqDuw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rmFCaBO2ScoI; Fri, 29 Mar 2024 21:37:42 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5tzl6xfbzlgTGW;
	Fri, 29 Mar 2024 21:37:39 +0000 (UTC)
Message-ID: <99804615-6564-40bb-86ab-2b7bac7551ce@acm.org>
Date: Fri, 29 Mar 2024 14:37:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 21/30] block: Remove BLK_STS_ZONE_RESOURCE
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-22-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328004409.594888-22-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
