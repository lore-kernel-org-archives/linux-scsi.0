Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106271361;
	Tue,  6 Feb 2024 01:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707182749; cv=none; b=XCXddGxZUM2Xl47SINIiaFPD/0rZw0LnxWDycncMP9RjeQMWqHvAygpPzrIS+BCfQ/GEdots4C5cVNOVXepZZiCtlF1r5+MT1+PFkqBdVwcv/lh03x/fSN9dt05I0XaL3wAbFkNH8P0fwJ7UBeYknFzXeIXNn1nIoTxE3YIZm8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707182749; c=relaxed/simple;
	bh=xPhVl2iyOivm3Z8E/ftGw19JdA9+2hfmNugZ8ePuDhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uo+KxHvsFl8v6fiNYaIMlNeaqjWw1+HKoU9d+BXz0kbQJYgS7dzij0b0SavdO/OjOu3NLbijimRGVxWJFVwk9h15LOAfWFayFb6uqAwSek3JvyMzo+9pvi6nQTkwzo7CX5qacbI/CbvjAxuc2LxqX/XJZU90vhJwS5Ciupr1D8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d93edfa76dso43259235ad.1;
        Mon, 05 Feb 2024 17:25:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707182747; x=1707787547;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EfH74TYuZGZBD3gnqL6oIjRHEvMXzZ6fQIQB4Pz4Ego=;
        b=kF1flErdx+3HzgoCbn2ZqL6N8bQMc1cnbeIDPzGebFi10HbCqR568nmfSdLNUQoYmV
         tWeqBkyfcGEBjuejGiSyDyQ1b4l1aryVBl+xrlnPV03x7jfzgFCJ07cBk8nJrKQwWV2m
         GJNe90fb1jTWRZ0wRmILjtLTtprK40fc+IOYMpSsFdeshzydLzPMAsN9FVc0X9Wka+1w
         jSK4BuFPpkiu9eUvcSpbNnOuVm73wcGIhhDNtpaOqsitKS6zhj4+idSirUL6xPxD+iEV
         j7zsTFsnlQhzGIdUvBhwEDkMystZHvsxD4hG0YL2XfAwkuetTuCBPqeltn0j3PHGB9PQ
         a8Vw==
X-Gm-Message-State: AOJu0YygrJJoy26f12udp754FNVckRIZzmqx07gDzINkNuZJmPM9q0sN
	0vvWXPEcTZ5LvL2Nj9U8J1SCZQydSBmfgNACe4oE4Fr58TKP7HoKg2bHax3t
X-Google-Smtp-Source: AGHT+IGeXKRtT9W1LJG6mPRgiHjBJ4zC8hNfCDVBubWzCzv6teg3jEEUa51cp9v1QpDpzST//Kmftw==
X-Received: by 2002:a17:902:7ec2:b0:1d9:ca7e:f0b4 with SMTP id p2-20020a1709027ec200b001d9ca7ef0b4mr233109plb.16.1707182747168;
        Mon, 05 Feb 2024 17:25:47 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU9x8L+y+lWN/r9zFUjKzGBPv9YXMGwNjJzW3oy8qIiBoJWDTsmispFFCYlcLYR1sAiYqqQJ0WJsFHMlfW3RKzpB3W9aIDQpgK9dP7/crIJ3PJEX9TDM8DAXz9WiNdg6gVYxtfzI4xeCHULYhC08XODtY85eARSYOmJlSoN31aMs0eJp540BUpzQHGE7efN/YWOQ3MYBh6kFVuNjPaX5skz/XkNIMLyDoC5HREP+XvKw1/frqAlnqPRedln62lT0AKH6A==
Received: from ?IPV6:2601:647:4d7e:54f3:667:4981:ffa1:7be1? ([2601:647:4d7e:54f3:667:4981:ffa1:7be1])
        by smtp.gmail.com with ESMTPSA id o9-20020a17090323c900b001d94a3f3987sm522408plh.184.2024.02.05.17.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Feb 2024 17:25:46 -0800 (PST)
Message-ID: <04fb99e4-3e67-4c69-b1ff-d8563dc3098d@acm.org>
Date: Mon, 5 Feb 2024 17:25:45 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
 <fc7ab626-58ed-49bd-b692-4875d17c6556@acm.org>
 <548aa284-6c80-4f01-a5ce-bb16f64e9c85@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <548aa284-6c80-4f01-a5ce-bb16f64e9c85@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/24 16:07, Damien Le Moal wrote:
> On 2/6/24 03:18, Bart Van Assche wrote:
>> Are there numbers available about the performance differences (bandwidth
>> and latency) between plugging zoned write bios and zoned write plugging
>> requests?
> 
> Finish reading the cover letter. It has lots of measurements with rc2, Jens
> block/for-next and ZWP...
Hmm ... as far as I know nobody ever implemented zoned write plugging
for requests in the block layer core so these numbers can't be in the
cover letter.

Has the bio plugging approach perhaps been chosen because it works
better for bio-based device mapper drivers?

Thanks,

Bart.
