Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5242522EFC;
	Wed, 17 Jan 2024 18:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515732; cv=none; b=qBFWONCntQJULW3XOBX8FYE+EkKbVH21L7niKqsDsjfYa1zIbCdxcxcWpc+k5blJUjPwyflo5bzMoJEjswPmOCrP1CjVR+gBsZMr+RT6eXE/ldb9qCldxJoYGwpgfDOe6N1uX/RwkzYLola+4zTZLnAXCwKzn9dY7KZ5A9pPwQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515732; c=relaxed/simple;
	bh=Zi0Od5m6Loerhz2JEA67PvLsbixKNMaoXlF2zKzjziU=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=ofwQHjsypkqiMo+r8SJU/om4JSHKjSE+UL3iCrBVxc4K4iTN9IjAXPoLJ8vtSEfuiyS6LYIA9SxhnkOL7QP/IyznrfWG2BOCCn8dec1f+6fujSeMTira4uEiX0hD343Pb9DCFxv//bb+WSC12RMCXjaJKNOmqn82zfnBlJaK33k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6d99980b2e0so9350482b3a.2;
        Wed, 17 Jan 2024 10:22:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705515730; x=1706120530;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d4/T24RnyFB/ADa9apgCOMR0Hlg54AQd0st7W68AxiE=;
        b=dwhO4YR63GbOFpLAsqH3wDjsJ+8pNFuyHJ+u3l3uHXkP6lEjSd4rmha6ZiUrvWCoq8
         iHKJjDwajTU0XUUn884xIBcbucX9mCk8Yq7ldjSwefc5IKi5N0e+hvbRkatTbYghe8Xj
         7SGTC9Rr+pUFlELJdrYao3syZe0F7DSehN6AnKZsgWBPySIkhP+PNpn3bC3YDN0T+jRd
         EpU1hjG/U1c5wa36xa2MtJJLzoBQd4wqOhPmtQnw5BfLmA8uOMmd+Zmu/GGkg61yZj7t
         QHI498Nx/8lPI02M6DWVyc9i1qEmztxtoVDEvAm/jvz2Vp56GEDHaDWtO3nM3cRlEIuZ
         9Agg==
X-Gm-Message-State: AOJu0YwN0tNDtievTJ2/6nDQho2AnNbecGVa0KhWAtcJKl44X89iPMs2
	p/mAqNu4BpE2EEHndIGU4Z8=
X-Google-Smtp-Source: AGHT+IFYbqyZvwDBQ8Mkv8SlzrFfh46Y79vWdOi7CaVoyBYiuWFAXxheUzXz7hIxq7nhlrH+i8/L/Q==
X-Received: by 2002:a05:6a00:1d01:b0:6d9:e7d0:327f with SMTP id a1-20020a056a001d0100b006d9e7d0327fmr11472379pfx.23.1705515730356;
        Wed, 17 Jan 2024 10:22:10 -0800 (PST)
Received: from ?IPV6:2620:0:1000:8411:5421:8f53:45a:4e37? ([2620:0:1000:8411:5421:8f53:45a:4e37])
        by smtp.gmail.com with ESMTPSA id kr8-20020a056a004b4800b006da73b90fe4sm1805094pfb.14.2024.01.17.10.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 10:22:09 -0800 (PST)
Message-ID: <2955b44a-68c0-4d95-8ff1-da38ef99810f@acm.org>
Date: Wed, 17 Jan 2024 10:22:08 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improving Zoned Storage Support
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
 "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 Christoph Hellwig <hch@lst.de>
References: <5b3e6a01-1039-4b68-8f02-386f3cc9ddd1@acm.org>
 <cc6999c2-2d53-4340-8e2b-c50cae1e5c3a@kernel.org>
 <43cc2e4c-1dce-40ab-b4dc-1aadbeb65371@acm.org>
 <c38ab7b2-63aa-4a0c-9fa6-96be304d8df1@kernel.dk>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c38ab7b2-63aa-4a0c-9fa6-96be304d8df1@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/24 09:48, Jens Axboe wrote:
>> When posting this patch series, please include performance results
>> (IOPS) for a zoned null_blk device instance. mq-deadline doesn't support
>> more than 200 K IOPS, which is less than what UFS devices support. I
>> hope that this performance bottleneck will be solved with the new
>> approach.
> 
> Not really zone related, but I was very aware of the single lock
> limitations when I ported deadline to blk-mq. Was always hoping that
> someone would actually take the time to make it more efficient, but so
> far that hasn't happened. Or maybe it'll be a case of "just do it
> yourself, Jens" at some point...

Hi Jens,

I think it is something fundamental rather than something that can be
fixed. The I/O scheduling algorithms in mq-deadline and BFQ require
knowledge of all pending I/O requests. This implies that data structures
must be maintained that are shared across all CPU cores. Making these
thread-safe implies having synchronization mechanisms that are used
across all CPU cores. I think this is where the (about) 200 K IOPS
bottleneck comes from.

Additionally, the faster storage devices become, the larger the relative
overhead of an I/O scheduler is (assuming that I/O schedulers won't
become significantly faster).

A fundamental limitation of I/O schedulers is that multiple commands
must be submitted simultaneously to the storage device to achieve good
performance. However, if the queue depth is larger than one then the
device has some control over the order in which commands are executed.

Because of all the above reasons I'm recommending my colleagues to move
I/O prioritization into the storage device and to evolve towards a
future for solid storage devices without I/O schedulers. I/O schedulers
probably will remain important for rotating magnetic media.

Thank you,

Bart.

