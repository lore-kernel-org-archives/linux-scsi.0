Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0542C8289B;
	Fri,  9 Feb 2024 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707507408; cv=none; b=jmk0Pqvv7G9+pSffAI5nhas7RKU6TfuyLzg94OScEsADa5tKTKfpzKGSQkrDFTDqsZHN+31AqHh3KIplPViorWERLg6Lqsqnyr/dgFTeIT7CbOKD2SnrJ9vS5g4VGAJAltVlrwdUHhiP4ZNUOuVLZWzYRXaiSIL8VeKKWNOyDwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707507408; c=relaxed/simple;
	bh=2qOuEVJqjHfjmuCIFxKvzPggNz79dLmPFMaVWUe93DA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OXDdQ5pJh6U2jF3ARXVgVCDUpjoVYz2JEQzKdLvaSNJ1XNG/W6lpsIvFXMJ76hMyByN+KFtJMRlJpp5DRGIJEtu571tCYoUTDGDXJKOV4IpUWcoPmtYpf+ql+5sSPFx3TeNgCq2kzwZI6/ig4EWa/j3T81AUbOISyfjweX/3XF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6e09ea155c5so411607b3a.2;
        Fri, 09 Feb 2024 11:36:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707507406; x=1708112206;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qOuEVJqjHfjmuCIFxKvzPggNz79dLmPFMaVWUe93DA=;
        b=f6ngsNOAUkQ1sAlZJyryqi4WFOLdlPekXIqxJsMsZpHriVEUakMr4FPrL5Lg5JOSAN
         ZHkwrFSLJmRQ5pbR9JHJ39sdlOnD9It9RwL+CuLsv/BXGX/akksYUtNcmEHwGXBpmnWN
         8jIRldPAlIelqvKhJcM4LKRU1B/zkQVhnLYObHGVimameH1Ylkk51C4qfes3JCzAHgOf
         S9RDgjnyqF76tdbjXCPHLSK9lVVqoF4LbW5KJEslyADXeAMBi2jmqxzpB0sFoPC8gTIv
         dha0qmldDgTHCzF951q7Tdz4BAtN+349R0iY+MyQ259NFyyiSi5BGY6MkKxB1Wx8YyPY
         897g==
X-Gm-Message-State: AOJu0YytQKxt8NzHE9XPDYAd9WhUehm/6dc7SaoAyMizV9dvSdspEP+d
	R54M/UXZ7VEHybrpeGgPE8fciJTwBZPcYRRMfsBpb0VoAMX7JWaT
X-Google-Smtp-Source: AGHT+IFytf2Sre3jHj5B5HsndXcftLS5kunAz1JlEMMhI0gBgJPg1l3ITMhL1hxJyevCJgYmIJVcoQ==
X-Received: by 2002:a05:6a00:26c4:b0:6e0:57b0:80c4 with SMTP id p4-20020a056a0026c400b006e057b080c4mr210861pfw.24.1707507404972;
        Fri, 09 Feb 2024 11:36:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXNnpiczmDnkSTy0MDNLFRRbLXno+yzQV+sbjE4BVe1/PW0X+xTfgKDN6HSpLHg9KckTW4yfSHp2gMANN4qIawYCUP5aYDP2s8ujSN8JiE7AVgUs8HKAAQxkPXpqvqIpkFJqypFLob+/SkUGTaak0liWFfzaEhi4hXp/bQ7Ll7VO4GGeaVMshru9W47iNLTIxIlwpSOj4yma8EOG6/KT3VB+DToZwou9S85bvy93Ed8BZZhjEJfDxOHxggbPU5ZiY4DCqR1ZGxHyrYcYL63pqlM
Received: from ?IPV6:2620:0:1000:8411:9d77:6767:98c9:caf2? ([2620:0:1000:8411:9d77:6767:98c9:caf2])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a0023cf00b006e08f07f0d1sm902718pfc.169.2024.02.09.11.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Feb 2024 11:36:44 -0800 (PST)
Message-ID: <e2a1a020-39e3-4b02-a841-3d53bd854106@acm.org>
Date: Fri, 9 Feb 2024 11:36:43 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 25/26] block: Reduce zone write plugging memory usage
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <20240202073104.2418230-26-dlemoal@kernel.org>
 <09d99780-8311-4ea9-8f48-cf84043d23f6@suse.de>
 <f3a2f8b8-32d2-4e42-ba78-1f668d69033f@acm.org>
 <a324beda-7651-4881-aea9-99a339e2b9eb@kernel.org>
 <2e246189-a450-4061-b94c-73637859d073@acm.org>
 <75240a9d-1862-4d09-9721-fd5463c5d4e5@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <75240a9d-1862-4d09-9721-fd5463c5d4e5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/8/24 19:58, Damien Le Moal wrote:
> We still need to keep in memory the write pointer offset of zones that are not
> being actively written to but have been previously partially written. So I do
> not see how excluding empty and full zones from that tracking simplifies
> anything at all. And the union of wp offset+zone capacity with a pointer to the
> active zone plug structure is not *that* complicated to handle...

Multiple zoned storage device have 1000 or more zones. The number of partially
written zones is typically less than 10. Hence, tracking the partially written
zones only will result in significantly less memory being used, fewer CPU cache
misses and fewer MMU TLB lookup misses. I expect that this will matter since the
zone information data structure will be accessed every time a zoned write bio is
processed.

Bart.


