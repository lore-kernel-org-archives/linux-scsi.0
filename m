Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6834547A61;
	Mon,  5 Feb 2024 17:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707155290; cv=none; b=tnJcxAUOT0Yzg5z/mHX76pSzDCyPXGFUVxbDUxyUKIbaD52urIIJNr3jyD02SRTKFFBYcaztL4V5iQ8xijOik7b32UtXZNkFDjzPSvccDzVbth4CkTIPP9piyC0aCAx+mkQf46rFnVmY30JD9pG/bTlwf+5bfOazUH7PltVoxRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707155290; c=relaxed/simple;
	bh=vkzFtbQdZjZispo3UhXXd/LLFzbR7QJ0hX/0RA5jzWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uaWbE3U/heDV6j3+PFcpNskAabAnGBw1eEK1+NR6beCP7eQRA/7npMNYMfb80RIrzPD8jNRkEBwxprDusAI634i62UJUA86t7Txno7fnXAMt9GBzDXs2MVtLIkBqTlopsM9Mnu2Fy9QPdEeMk+zRWoUmIz7ZxEcuW+t5rieQ4Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-5c229dabbb6so3024346a12.0;
        Mon, 05 Feb 2024 09:48:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707155289; x=1707760089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8KQNkaBYtky5goRSRqnguxMPyZfEM+iuBXnubHYKQgQ=;
        b=ZT7NpSt8Jk1jlzjTBeeM2QNJmhC+ErjDkCddNoxsIt3haaB/RyvpXN9W9EB5zYeLCY
         qoPIMNYFb5AToYmnASIQrhLSPMqvIRNh9eWui3UHjp/Y/IRfOgYDuzNRgROMdpzb3wuy
         tf2tJ2/e3MKQ0wWSwMdhzRaJM+zL82i9ZojMGNqNfL5XM/s0E7ldJaqJsq5+fbgJrXFy
         L4Do5h+Kxzpp33Q3CG8ekpkMnyeR11YMN9IZCVS7tIWzWKbIJBrYINMQdvjJ/FpJ9h/L
         kmuTFJ4D0jDoXIk8rfAxf6zMv1Gm4gC+mFbElqDSIYMlPgsGOmn+S3c/toUNQgAOCLSO
         6NWw==
X-Gm-Message-State: AOJu0YzHVqA01bmnYndFFvURJRZtnM/rM0mghVz94+9Xx5dPNAndQAIQ
	es/WZy6FycwDeuypLJHYi6pNKUlNtSpiKx0JgVAyqAmmEhg5e4Ej
X-Google-Smtp-Source: AGHT+IHJ6X721LPg5ymb106McyTY3TAqyEhjwf8OoCqL3uFxp9vZq3y33y8cNUFTPur97MHRgILPvA==
X-Received: by 2002:a17:90a:1783:b0:296:36d9:eefe with SMTP id q3-20020a17090a178300b0029636d9eefemr148467pja.14.1707155288649;
        Mon, 05 Feb 2024 09:48:08 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXp9H2B9362zCrRqE+aCiaIyQmDdtmgVlEEttzF4TzrvV+FUdGUg2IgG0N8HNjRoOTwihRwOWD4iKuLYRSb0Wxyi56dhFmKLPDySsPP0suKmLXmf2tnF7a0wOgmKcr4cIJEEbnLG/iMJXMK/OvK6JlCtv4YxUAGKUZ0B4qa+/r9UReMEYNW2bvMaumxKiS04uAZCg8NSNzM9bLM80jYuzaN5PBeroDMLYnQxOuvJEGWWZxl1Mbq75DcTz31D3bsL8LGsg==
Received: from ?IPV6:2620:0:1000:8411:be2a:6ac0:4203:7316? ([2620:0:1000:8411:be2a:6ac0:4203:7316])
        by smtp.gmail.com with ESMTPSA id jx15-20020a17090b46cf00b00296540086a5sm5488814pjb.23.2024.02.05.09.48.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 09:48:08 -0800 (PST)
Message-ID: <12bbbfe9-6304-495b-a60b-821becd1f326@acm.org>
Date: Mon, 5 Feb 2024 09:48:06 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/26] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-7-dlemoal@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240202073104.2418230-7-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/24 23:30, Damien Le Moal wrote:
> The next plugged BIO is unplugged and issued once the write request completes.

So this patch series is orthogonal to my patch series that implements zoned
write pipelining?

> This mechanism allows to:
>   - Untangles zone write ordering from block IO schedulers. This allows

Untangles -> Untangle

> Zone write plugging is implemented using struct blk_zone_wplug. This
> structurei includes a spinlock, a BIO list and a work structure to

structurei -> structure

> This ensures that at any time, at most one request (blk-mq devices) or
> one BIO (BIO-based devices) are being executed for any zone. The
> handling of zone write plug using a per-zone plug spinlock maximizes
> parrallelism and device usage by allowing multiple zones to be writen

parrallelism -> parallelism

> simultaneously without lock contention.

This is not correct. Device usage is not maximized since zone write bios
are serialized. Pipelining zoned writes results in higher device
utilization.

> +	/*
> +	 * For BIOs handled through a zone write plugs, signal the end of the

plugs -> plug

> +#define blk_zone_wplug_lock(zwplug, flags) \
> +	spin_lock_irqsave(&zwplug->lock, flags)
> +
> +#define blk_zone_wplug_unlock(zwplug, flags) \
> +	spin_unlock_irqrestore(&zwplug->lock, flags)

Hmm ... these macros may make code harder to read rather than improve
readability of the code.

Thanks,

Bart.
