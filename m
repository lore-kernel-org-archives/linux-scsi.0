Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FFB1362;
	Tue,  6 Feb 2024 00:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707180784; cv=none; b=QoxwfmqaOY1hY6WT4awRTANDziuMlrgKJpwJE03eN0S3ay9JueEq27h6cpmpkpLQDWilL2/IXqmhxpyNL+mMrYypc/vy55/RO9cm7JpFqpS/VDc9+7nkUircZgkou5jajTJ1ClxvIxy8aM7k6ufPiYoVHw+oqdFA2DuRK5Ew72k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707180784; c=relaxed/simple;
	bh=1VorCGD/83w7sb3V8vm79WrearZtXxj9E0YLI+zOg+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lck6niYAMGECuysmyHh6vVIN+GsWMC/byg8sXDotjqvkXefVz0wtJqeqntV2u8fF4zA0PLP+Lv9dOs+lMEba9sNje2xrVtOp8F1PRZVOjFWIlT11nAwgqbNd1wZNbLi84UL7nvM1UQmqGRBOWvy/EXE4l6oxcFsIxvHPLheXaP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5d42e7ab8a9so3870371a12.3;
        Mon, 05 Feb 2024 16:53:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707180782; x=1707785582;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hyfSBB/1Bs9OX6T5OHVDSbXWW+UvHyrp/sfO1v2nZPU=;
        b=dTP5qBd88vrLSzsZlAu9KVkMF43Pj/LvNE0Gdl9dK0nO0IwBtcKhUaPYjup/0S/Rmf
         jeMcve/XHfV/dIAa0x0mFnblfjgxw8m79U7XdtADdNL0CVtUNj5cUotBKEhaLSnieqZd
         l9nIgYALcN6Ofnctyef6K/KFfTulbdLmSm7TEakK7U2sD2uYuOrdbrlsfuyxJcB0x19E
         0+j6xN8OM8CNIab8CHPW9VAnitzEEvd54uMxGlFqKd3r5XURIGcq6zWCMK/Ukaqcv6+Z
         LJIdPjXMoZyHfPHGnTKo2t5GI5IFDrPrOhVHyOXsSC08OmEXXD8ELI7ujuT3bAXm73n8
         nzMg==
X-Gm-Message-State: AOJu0YwAL6nPqvIUIHlPxBOPjbz/BkEGLqXCzDGkYUdXNYeOWyVfKH1G
	rVxwoq1HsH1xEKMrq0f1dzvbgTE0GGkxe+DlCXlhy77XlnhN8qn3
X-Google-Smtp-Source: AGHT+IFzXQa+D+gW3a8XnrvcCKpkT5UjRe4bsEEadmO6vJNc3nZe1KL8qNaH2Bt0d0peMyz9Rkaw6w==
X-Received: by 2002:a05:6a20:3598:b0:19e:986d:7a6a with SMTP id j24-20020a056a20359800b0019e986d7a6amr163371pze.7.1707180781876;
        Mon, 05 Feb 2024 16:53:01 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW+h1GVhAXjhixkpGgn/YyKH703Ow4PvsvefcvgiU3sIFFSLtmSsemziHd8BHn3AcAXb334P55ZSuI+pCIBmqQ4QSr8StULKLcGaKt3yogzsMaerlrM7VKVKrdb+AZUvnwJ8pyr0bBRZBXkj+sBjOScW80VZqEehPwxS6SnKMrgvqAxZn/EmWxgAjksIK6BjnZzNFz7H0YY8a1/1zo7OBvu6wEfD/OMpEgRmZo07jEJidAa6JV9h3wPK7oNSZDAenEw0A==
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id e17-20020a170902cf5100b001d9537cf238sm495824plg.295.2024.02.05.16.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 16:53:01 -0800 (PST)
Message-ID: <ab187793-7fae-4673-9a98-10137263a85d@acm.org>
Date: Mon, 5 Feb 2024 16:52:59 -0800
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
 <12bbbfe9-6304-495b-a60b-821becd1f326@acm.org>
 <d909a331-75c7-49e1-91fb-374e48b47543@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <d909a331-75c7-49e1-91fb-374e48b47543@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/24 15:48, Damien Le Moal wrote:
> On 2/6/24 02:48, Bart Van Assche wrote:
>> On 2/1/24 23:30, Damien Le Moal wrote:
>>> +#define blk_zone_wplug_lock(zwplug, flags) \
>>> +	spin_lock_irqsave(&zwplug->lock, flags)
>>> +
>>> +#define blk_zone_wplug_unlock(zwplug, flags) \
>>> +	spin_unlock_irqrestore(&zwplug->lock, flags)
>>
>> Hmm ... these macros may make code harder to read rather than improve
>> readability of the code.
> 
> I do not see how they make the code less readable. The macro names are not clear
> enough ?

The macro names are clear but the macro names are almost as long as the
macro definitions. Usually this is a sign that it's better not to
introduce macros and instead inline the macros.

Thanks,

Bart.


