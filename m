Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8541DEFE8;
	Mon, 23 Mar 2026 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774287126; cv=none; b=aJ4fWbPesL7DlGSI65rSzodFwP7l6GPoXdkL8eeZZMRM4U9+RAXeMrKfdmu+SIb/hArrrOdgR2qA2losDLsqfDkUp9ksMPxhu8VHdYl4+WTBSJlE/NhGqQBTU3KcRW12kbL5HnarBqTTZPMcFrKo3gbi7Z5HlPOZINRfe2Juh1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774287126; c=relaxed/simple;
	bh=Uk5p4ExM8iYYus7d0CUZh2oMoDNmYurKBW2CMQ0z5H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QgcAN3E1N38bfG3eMus7ufmz3Rkqa6Se7I4sqQTloetjmJsVLIzEOHM2ztb8m7aM4ef1UzFDkFrv/tRHaNJZ1KWk0t7OHM3HQW19CraRXGQg+v84+OJYYtRLlLNDn67SfdqfDYv9Ceq0R+RKKEvETBGUOra4dvbITD3+YzHcZ2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=yxOLgmLJ; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="yxOLgmLJ"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4ffgGD3x7bzlgy1w;
	Mon, 23 Mar 2026 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1774287120; x=1776879121; bh=Uk5p4ExM8iYYus7d0CUZh2oM
	oDNmYurKBW2CMQ0z5H0=; b=yxOLgmLJBa174S3ejjz6leArmiE5FwlEfWAku8Vy
	8pQP87Jrx2yU/o/2S/YM5k+g5KMJ5jnbNiKNwl3sPTm0uIBKRZYd/yizbaC96aLv
	B8rNHDNW4iNjoxSlxQngCDKzWLuYOrb+sTARbOJjpGIZ3HBTMUentUZGGONIR9Za
	6H+sdB6RmZxxvdBvH0FHN9JHYf4EaVENpq1YT9fRuXFtGXortd75W81IOKiJzS2p
	BjoWbH/Mg+miQLgXahfs6k36xm29osPZ5ZYMSX1a6+8IW4nAZZ8cUvCzYNzbuqGC
	8xbsTc1FAxTLgNxkBy/ehE78yDx/UXqnnXc9aZY3stiD+g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uDeRpX8s45bB; Mon, 23 Mar 2026 17:32:00 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4ffgG507SNzlgwN1;
	Mon, 23 Mar 2026 17:31:56 +0000 (UTC)
Message-ID: <bdafac6b-3255-477c-a7ce-0ed72983c9be@acm.org>
Date: Mon, 23 Mar 2026 10:31:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] scsi: ufs: rockchip: Drop unused include
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Shawn Lin <shawn.lin@rock-chips.com>, linux-scsi@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
 linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Heiko Stuebner <heiko@sntech.de>
References: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260320215606.3236516-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/26 2:56 PM, Andy Shevchenko wrote:
> This driver includes the legacy header <linux/gpio.h> but does
> not use any symbols from it. Drop the inclusion.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
