Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793756798;
	b=WnWaaPVdel02taxW6EJ4KizQBq5aG5l8D9pNuEPQhqtzbjQljx8BJ/bPhyc+nT4Unv60
	 kMaSUbZRaTc2/0VzpKQFBiKGkeqMBkPS0rWIe2qfM3TgPkm3Q/WWDe4YbQGSLNwMge1Sr
	 YrNFEweQRxHl3kYtXzu4+5YhY7Mhiqulw4Px1PsOmKy1WN7XhwD6qx+7iFf12fe4jwnGp
	 P45+7RoJ/W9ktuH1dXOlzSjcCOzVyNHf4CziGwI8F8Sg9dLLr+tELS6u1Obk9asPwzRmR
	 nkxRbcykZ8x5B8X8WTWCUTu9/5Ewhvde5s4jnZlBgaF15IAvfX53pvFn4j/tFVjUNLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793756798;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=RXOjzv2ekKXMhRrGDhixdimxSCblG2FyP7f/BYRRsGo=;
	b=lKDvcvAIXCoVXeSmdgZ+9G4603r68LeIW8XZJ81hDMBu9P8snLSRRuY2xQDGqYIHFaEa
	 yu803P81Sj3lvhBKd6ieBlNJ9cISjckICs3EKwvtFnj7QdeCz140stllg7vGDikjFCu4O
	 cwKZ3rTmvEVaMvcwIGWDg5mbYyuu5k3o+hiukWg3EBJQO/S92la9W6ilptv7Cwbeb04GO
	 a/JiODjgguzuJOboQhAkur/MKt5ebWey0r3EPxIaFwBwtlpqPZFErLDvGzL7gxrCTqLfl
	 LhoQ0RCywwM2LnF36zct1ZfINYeaI+OD4MZgF8/rASqrxysphA49u/lDnWfgfb0qYSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=aZpBjDda;
	arc=none smtp.remote-ip=199.89.1.16
Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEB0606A326;
	Wed,  4 Nov 2026 01:46:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BEB0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=aZpBjDda
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4jK7b12Jh4zljKMQ;
	Wed,  4 Nov 2026 01:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1793756795; x=1796348796; bh=RXOjzv2ekKXMhRrGDhixdimx
	SCblG2FyP7f/BYRRsGo=; b=aZpBjDdak5Ql9CoGeSJUEyupksMrvDe8XjeMyPXa
	SshmvpFs+WINcchIU4NoS/0LmMaUgrtUpG/jP7tB4Z77Gd5XDMECXusGsClfCKkT
	kwYs0zGlk0CaYmelyWX6yO2FEcTPhjD/GzN58C3SxJoBaks4y/7GHQ5kQIobmKXr
	wJ9wheVYLCuWK6q/F1k/61j6Futb0sgz21ksDQECbc0i7DycJoo3rcWyJrX1Ph2z
	aL+biQ/rsOtn4PkkyUN9dhzcQs+uVfEOM54pEQu8bYn4afM2DVlb5a9+1YWe2SKc
	dEf8jaQHEk2U/eyzJFhRK5dRa9CjiaOeCZbTrCQGcP5hyQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1DqThOFT3LrU; Wed,  4 Nov 2026 01:46:35 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4jK7Zy6YGlzlffvQ;
	Wed,  4 Nov 2026 01:46:34 +0000 (UTC)
Message-ID: <703c41b5-537f-4897-b852-fed4097a0193@acm.org>
Date: Tue, 3 Nov 2026 17:46:32 -0800
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
Subject: Re: [PATCH v4 2/2] ufs: mcq: poll OCS after sq cleanup for device
 management commands
To: Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, alim.akhtar@samsung.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, kwangwon.min@samsung.com, hy50.seo@samsung.com,
 cpgs@samsung.com, h10.kim@samsung.com
Cc: stable@vger.kernel.org, stanleyjhu@google.com
References: <cover.1793598099.git.kwmad.kim@samsung.com>
 <CGME20261102055317epcas2p48b638d0c25fd024ce01960afd1e6dee6@epcas2p4.samsung.com>
 <8c4bbbd746e7fc1d8c27b6b87b2d684abb74a3b3.1793598099.git.kwmad.kim@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8c4bbbd746e7fc1d8c27b6b87b2d684abb74a3b3.1793598099.git.kwmad.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/26 9:52 PM, Kiwoong Kim wrote:
> +static enum utp_ocs ufshcd_mcq_read_ocs(struct ufs_hw_queue *hwq,
> +					struct ufshcd_lrb *lrbp)
> +{
> +	guard(spinlock_irqsave)(&hwq->cq_lock);
> +	return READ_ONCE(lrbp->utr_descriptor_ptr->header.ocs);
> +}

READ_ONCE() is sufficient. I don't think that the spinlock helps here. 
Additionally, if the spinlock operations are left out, the function
ufshcd_mcq_read_ocs() is no longer necessary and can be inlined in its
only caller.

> +	/*
> +	 * For device management commands, there is no order guaranteed between
> +	 * OCS update and CUS update, which is why we need to wait here. SCSI
> +	 * commands are excluded because the OCS in their UTRD is not updated
> +	 * from the CQE.
> +	 */
> +	if (!err && blk_mq_is_reserved_rq(rq)) {
> +		enum utp_ocs ocs;
> +
> +		err = read_poll_timeout(ufshcd_mcq_read_ocs, ocs,
> +					ocs != OCS_INVALID_COMMAND_STATUS, 20,
> +					MCQ_POLL_US, false, hwq, lrbp);
> +	}

An error message should be reported if the above loop times out.

Thanks,

Bart.
