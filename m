Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C563CC120;
	Sun, 11 Feb 2024 03:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707622822; cv=none; b=ujgFKMgKcP6f0J4qK/Jgqt7mojadkhMbgjJzBWXw/oaG8nHsx1Mvovi2W5MiFFGSLWrNkEpDrKyXcufVo85UvEQAGr87JTXcQQskbQpkmp914g1MpS6QlVdxNthybBJETl8OyoZjY8XSMFo2YA0j+idZcTEOcwIly6ugVlkSJRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707622822; c=relaxed/simple;
	bh=qAofQFRNn5JOYKBu3rH93zn1we+MRS407FLoTMBaCVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QqMqkawxrdFNcVLgqBOEgR7ggj63bpaVgtdlqgLsFGMR6vlKmfPjZ8F81hcwxwPMclrYM/W7XjMzUkPKPRLQC3HwHIoNcGhm81+trJpXrbA7KPaJuVIfabh59LPx6azbZV6Z1/3I/Y0WSSYFdF3XtSpYK6aebyor1AWVHZ/RJ90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-218642337c9so1389596fac.3;
        Sat, 10 Feb 2024 19:40:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707622820; x=1708227620;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hMYgiHBEDavj7uIzhw2tvkbewX2cx77PDc9OLk7jn/k=;
        b=TLddgr7srpqEKeiC///1i72Hcyn0ZmdMrM2hTgfar+0o21LIFh/LQ5NqRdjplSjKeo
         EsvGdTXs3Su86S/BbLDaFxU4pId55NF2LswvDQkV19lUstykXb6B2mh51yLFpqwp1AmD
         A/q7xzI7DVVGEVpMnrnaL0aJPGG9GPLRONMUmx21xf9By2GP/c1gb89gFTqwisedcw64
         GNiP4oRrT41g+1RM0qkv0h/ilW7UlmyYAAhE4SKCmOJYl5AmAc/iDISZq5vFqOGF61UR
         qzAEWSNd+eJNxR2RUl0uzMgxs/4LyMXtJzGaYzZkS3DqDKByqLadLzd6UsZALLqO1fOz
         4HGQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0m192lNuoPbO74r4bjIxc96DyDPddQwluui74Wc9Lnkh5lmi5RYhYwWbztLaGw2I3GiGpRGT2kgfEZK+o/FkzAUo5oZlzyoKav3zRkbDX8ucZf+C6ejxdNga9WL5Mn05e4p1rfsNu
X-Gm-Message-State: AOJu0YxgbC7fa6jAmFA34EHPe2qiw/Qq0CMdKBjl/9uXkKbF0i6bEJjm
	fwwfsd9lISMT+swUTkD7YwxbTAM1S9eCS2SThA/axjNoLC1piH9d
X-Google-Smtp-Source: AGHT+IGR4P8pGKs+ctCklf4XqK/ylZuLJWQJ0EO9ZKQtD/TUh1WRmTCeAUQBhkgAkZGaHUs1ZTNcFQ==
X-Received: by 2002:a05:6870:b48a:b0:212:42f4:82f4 with SMTP id y10-20020a056870b48a00b0021242f482f4mr4817221oap.4.1707622819693;
        Sat, 10 Feb 2024 19:40:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUxEhV9yJrJ24Jyyy7aLZmf4V0fw6ZPd0WLNVjRFQC0RNX0R/GJhy4LpgeDgqciTtru6g0MOUXaR8Ga/dHnufxYziotVgVhT7uDVDgHENPtV/8lmpUDW4+3cD4WDEsmUyk0UuB2xWPtYMtgXbQ3QL3YlN6r3o9rhY8wndYroVE7atBeIlK07Bj+4Dl1c7VrlLS5wMkP2OLfTS7ttwjlsoF63B2nsTmd3egehKOvbv5hsqTrr9CRf/kV+wCluc3QOt6fclBcIcyBHCvQy3l88Vq3
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id w13-20020a17090ad60d00b00296a7ac8b5fsm4361773pju.6.2024.02.10.19.40.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Feb 2024 19:40:19 -0800 (PST)
Message-ID: <a1531631-dce4-49a6-a589-76fa86e88aeb@acm.org>
Date: Sat, 10 Feb 2024 19:40:17 -0800
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
 <e2a1a020-39e3-4b02-a841-3d53bd854106@acm.org>
 <c03735f3-c036-4f78-ac0b-8f394e947d86@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c03735f3-c036-4f78-ac0b-8f394e947d86@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/9/24 16:06, Damien Le Moal wrote:
> On 2/10/24 04:36, Bart Van Assche wrote:
>> written zones is typically less than 10. Hence, tracking the partially written
> 
> That is far from guaranteed, especially with devices that have no active zone
> limits like SMR drives.

Interesting. The zoned devices I'm working with try to keep data in memory
for all zones that are neither empty nor full and hence impose an upper limit
on the number of open zones.

> But in any case, what exactly is your idea here ? Can you actually suggest
> something ? Are you suggesting that a sparse array of zone plugs be used, with
> an rb-tree or an xarray ? If that is what you are thinking, I can already tell
> you that this is the first thing I tried to do. Early versions of this work used
> a sparse xarray of zone plugs. But the problem with such approach is that it is
> a lot more complicated and there is a need for a single lock to manage that
> structure (which is really not good for performance).

Hmm ... since the xarray data structure supports RCU I think that locking the
entire xarray is only required if the zone condition changes from empty into
not empty or from neither empty nor full into full?

For the use cases I'm interested in a hash table implementation that supports
RCU-lookups probably will work better than an xarray. I think that the hash
table implementation in <linux/hashtable.h> supports RCU for lookups, insertion
and removal.

Thanks,

Bart.

