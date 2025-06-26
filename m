Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E56E19F41C;
	Thu, 26 Jun 2025 16:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750954586; cv=none; b=B6ffwTgC2BaaJtCVdBnCqb3Wh8nFONdxTgRbR0YBUbofe0NSMImv6dB430oGXeXDXCztySQc7lITMR/V3zaWLrFj/PvhGkI17RhbeACB9Xnn/c/ALGNglhKtyxDvgG6KhpVLHOgDC/Svz+ZB9WUdxeXZ3AnThM6YkcfGBAvWGT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750954586; c=relaxed/simple;
	bh=P+DQ3JT86pgMk/0nGBuZXsHt2n8S/5pukRAkqwLdVZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tf07KtThOZhBoFA1DXM5vhO4X1MMcDvO91wiYAgVSCL0zKZhq7FFjJTj1BFB33mOo6xRdOFFeyOeZsSQnjLZTcpFQ36+FAwH69ZWbBxEsDDPo/mn6nPZ24GFcJTJVpwDvinPoTkgqQxni2bRebdR7uDiamjR6mscflkEOyK6YzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gUI/M8XQ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gUI/M8XQ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bSkMX0g6czlvfGx;
	Thu, 26 Jun 2025 16:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1750954582; x=1753546583; bh=jRugcoVYqOz0MeUr2LfYYHnP
	iwWrfuZlPKBUG26FCi4=; b=gUI/M8XQBKpjZYBOlc9pbYdFH6gtOGwBBVJWPxVD
	oE9SK2G5Oli9e9jrmNeZ17tfaScWCTU4goFLXNmN/8Ddv72mSoY3ySXajk8VzOWU
	sgAMOXpwgon16qiDyfJAztW6iihWh52M+BGnFD6zvnkhN3WjdL5zKCd2oTXnYnUz
	B35RwrLB231yoNM8jxiqjY9OTkbR2DmVX2qAxKXB0phBw4/IP9fjShPwz5JxHXZZ
	5TE4m9bUA3RInXSM4PyUZPWRHF80VJ8Vs5NQ72JObHZJiO3rU76laHcgFL4MNNdL
	SLg6dMKfm8gw0WB5cA9reOzOa9Osv6IdzUXsrTzTkMn7cg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id s0ysEJHGUDHd; Thu, 26 Jun 2025 16:16:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bSkMQ53vqzlvfGp;
	Thu, 26 Jun 2025 16:16:17 +0000 (UTC)
Message-ID: <159d1b84-665f-4bc7-865c-59b15232a477@acm.org>
Date: Thu, 26 Jun 2025 09:16:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Format scsi_track_queue_full() return values as
 bullet list
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux SCSI <linux-scsi@vger.kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Rob Landley <rob@landley.net>
References: <20250626041857.44259-2-bagasdotme@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250626041857.44259-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/25 9:18 PM, Bagas Sanjaya wrote:
> - * Returns:	0 - No change needed, >0 - Adjust queue depth to this new depth,
> - * 		-1 - Drop back to untagged operation using host->cmd_per_lun
> - * 			as the untagged command depth
> + * Returns:	* 0 - No change needed
> + *		* >0 - Adjust queue depth to this new depth,
> + * 		* -1 - Drop back to untagged operation using host->cmd_per_lun
> + * 		  as the untagged command depth
>    *
>    * Lock Status:	None held on entry
>    *

Here is an example from Documentation/doc-guide/kernel-doc.rst:

       * Return:
       * * %0		- OK to runtime suspend the device
       * * %-EBUSY	- Device should not be runtime suspended

Wouldn't it be better to follow that example and to move the list under
'Returns:' and to move it more to the left?

Thanks,

Bart.
