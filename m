Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5198A1AE877;
	Mon, 28 Jul 2025 10:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753700166; cv=none; b=pO6o6QJwl8mjFekcyol5GPW8O6Xu/dek2tJy9eIyff1ISUqI791ZFJs56CkoOVe61DaUYmTQY8TZ3Kq5YbcIlYikBrB+teXpM3hvhk9u78SlNCwpaTy+hLLxTRglMVck0txNqLJzMKdnrglMc7ZRXtAheQgkgrNUTvG2h6OZ6YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753700166; c=relaxed/simple;
	bh=FjkNTTj5gKlWk2PF6lYSA4V/G5zG2p/S3li0BVxdgv0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y1vhqqbgU2LkYi5NnxMF5Cq9vL01FZ3LtIHVMakaTbcNGw2dTdg+h/girMtzVvHfqLQ8f98MVA97auZzCYosANokMS5dqkx0mtWj9W8GcvfAVtMGucvmtshFtJfvxckRQyZqqwLsZvap/ReybZpT4lwb3eLoXAz5s8UKyMDm6os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fg34Sqaa; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fg34Sqaa"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae0dad3a179so694274266b.1;
        Mon, 28 Jul 2025 03:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753700162; x=1754304962; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Df0lRDERPeJBnHzVHXNWOKr3aZnGoRabXiAStZjlOVg=;
        b=Fg34Sqaar3d05k+Uxz5UymLoU0StNitEGsN7YiU9OwXmwh8wEBQByUV5hMyxYXatXH
         9V1BUrclv7nODkYFpTzAbMR0dRrFIfGOvrR12GAkc+mCZjpjaviF8xIzUjM9fMbxsJJK
         RqpMK5VyWozFMGGPNHoP9GyjP7XYUm8LK4oNUZ0cEoBhkkWWWA3b8178GKnWTXqbUiU8
         Or0MEslWMdu815Kw5++YsL6eB+VBXZtz//i/nrT/WFI7DW3yPVlnX908MD8yVJn5QQoK
         B9a2vxPu3iy2+nzR+W74vngvsAp52qS6uqAYP3bbQh8/PxWPG/XPXh5yN0NuXY/l33On
         IG4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753700162; x=1754304962;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Df0lRDERPeJBnHzVHXNWOKr3aZnGoRabXiAStZjlOVg=;
        b=cj1A+MO2/y5EVi45avujvOSi80lf6TqX03J57HYF1A6nEpNS91g94Gg3LlravIfckC
         RWSlKC0z6fUnVCxe7wHG3yfDqVhyFkuBYfCZhFcTxJtuPzymoKhP70nqL65e2ydA5WqL
         z9BOMXbn/pXiEMlx7JHKJU3CWH+8Ljxr/m6+/iGSAAFBoSgewysvsk6jBR8iFwWQDLG7
         JNfGtzpBdfeIc0T3YOYZoJkDKvNU2FExt5qMTRUezfB3uBh3+4ulFrNcbmfA9GEPPuOb
         4BfJILWqDzXFz3ZNivvc9yUzAsj9HA9R640vTh0mt2RI+POewFHjL4UtesSaZ9/aEkk1
         zB6A==
X-Forwarded-Encrypted: i=1; AJvYcCUoZOc3zVHtOwUuMj2MHM8GgbpTIF26Z8vTCLbakNbpRP7ZbYO5BaoPVubVAldZ6l382K89CEmndREW@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf5G4vZ0TulZ9fznK0HZ5+Qv/kk0mM/ZBqKZ4TgNWNBpR2/RYr
	rkYudbq2TaEH98IiU4DPQj+fifnb4GngAhQ0P8lfNc0fCj5Z2Swq2vFg
X-Gm-Gg: ASbGnctYxjoE3xsrzbMdIwvVa7+m3gsQBgGz5X640eJBKftVz+IBE66ldBzp3gwplNy
	uQL3b0gZToPput4zT6WJ65+QlbmXpJ6Yk40vjPr+/QD3JkLssM3PKAO7LNWj810zXCRW+UdbCI6
	R1yhXtvgVKEQDVBQcpN5hE2XwD6Q7E+dYtkgbtnZ24bAgszbQ5yMBQmYHz2RwxYLLE5blTyiL1H
	pDZL5UJQMWt5owT0AgaKNHPjEJC45R34hWmTdRWOFy8TxgvcxN+WSxxLSLkU6F+zPcEYhLPNJMH
	DeLIoB4RfnIOwuh1aeIIj4TMCMNyPpJ8dQBeuxM60V//i/GHct14Ohhq6BAgL51MKETi9txFUeB
	cxPHF0ecQDPKvNDHlr5QR51fMEP1QKBrwJ3fqQdMef0WnvGhObnjViaOpd2L18uUyDduhp53N3b
	rTG4IAORQgOvyA
X-Google-Smtp-Source: AGHT+IEzb1gPenVkAzxlHuveqMX8WM+dE45hI+7ozQ3XP+Yn6hAj5fgzXQesTAYGhzBmQHf0y4/+PQ==
X-Received: by 2002:a17:907:96a4:b0:ae3:5e2a:493 with SMTP id a640c23a62f3a-af6196064fbmr1328391466b.49.1753700161985;
        Mon, 28 Jul 2025 03:56:01 -0700 (PDT)
Received: from [192.168.72.73] (catv-188-142-181-47.catv.fixed.one.hu. [188.142.181.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635ad656fsm404143466b.121.2025.07.28.03.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 03:56:01 -0700 (PDT)
Message-ID: <1c6851f4-0027-41ee-b971-2aaa6d505666@gmail.com>
Date: Mon, 28 Jul 2025 12:56:00 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improper io_opt setting for md raid5
To: Damien Le Moal <dlemoal@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 Coly Li <colyli@kernel.org>, hch@lst.de
Cc: linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
 <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
 <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
 <655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
 <4767823c-2332-b3e1-67a6-2d7f55b48156@huaweicloud.com>
 <a1626eef-9846-4824-a899-2fbd8e369fac@kernel.org>
 <9c6f300a-f78f-de6e-4b99-453df377c7ba@huaweicloud.com>
 <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
Content-Language: en-US, hu
From: =?UTF-8?Q?Csord=C3=A1s_Hunor?= <csordas.hunor@gmail.com>
In-Reply-To: <fa2f9406-4ee8-45f9-a784-b5042e9f4411@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 7/28/2025 11:02 AM, Yu Kuai wrote:
> Hi,
> 
> 在 2025/07/28 15:44, Damien Le Moal 写道:
>> On 7/28/25 4:14 PM, Yu Kuai wrote:
>>>>> With git log, start from commit 7e5f5fb09e6f ("block: Update topology
>>>>> documentation"), the documentation start contain specail explanation for
>>>>> raid array, and the optimal_io_size says:
>>>>>
>>>>> For RAID arrays it is usually the
>>>>> stripe width or the internal track size.  A properly aligned
>>>>> multiple of optimal_io_size is the preferred request size for
>>>>> workloads where sustained throughput is desired.
>>>>>
>>>>> And this explanation is exactly what raid5 did, it's important that
>>>>> io size is aligned multiple of io_opt.
>>>>
>>>> Looking at the sysfs doc for the above fields, they are described as follows:
>>>>
>>>> * /sys/block/<disk>/queue/minimum_io_size
>>>>
>>>> [RO] Storage devices may report a granularity or preferred
>>>> minimum I/O size which is the smallest request the device can
>>>> perform without incurring a performance penalty.  For disk
>>>> drives this is often the physical block size.  For RAID arrays
>>>> it is often the stripe chunk size.  A properly aligned multiple
>>>> of minimum_io_size is the preferred request size for workloads
>>>> where a high number of I/O operations is desired.
>>>>
>>>> So this matches the SCSI limit OPTIMAL TRANSFER LENGTH GRANULARITY and for a
>>>> RAID array, this indeed should be the stride x number of data disks.
>>>
>>> Do you mean stripe here? io_min for raid array is always just one
>>> chunksize.
>>
>> My bad, yes, that is the definition in sysfs. So io_min is the stride size, where:
>>
>> stride size x number of data disks == stripe_size.
>>
> Yes.
> 
>> Note that chunk_sectors limit is the *stripe* size, not per drive stride.
>> Beware of the wording here to avoid confusion (this is all already super
>> confusing !).
> 
> This is something we're not in the same page :( For example, 8 disks
> raid5, with default chunk size. Then the above calculation is:
> 
> 64k * 7 = 448k
> 
> The chunksize I said is 64k...
>>
>> Well, at least, that is how I interpret the io_min definition of
>> minimum_io_size in Documentation/ABI/stable/sysfs-block. But the wording "For
>> RAID arrays it is often the stripe chunk size." is super confusing. Not
>> entirely sure if stride or stripe was meant here...
>>
> 
> Hope it's clear now.
>>
>>>> * /sys/block/<disk>/queue/optimal_io_size
>>>>
>>>> Storage devices may report an optimal I/O size, which is
>>>> the device's preferred unit for sustained I/O.  This is rarely
>>>> reported for disk drives.  For RAID arrays it is usually the
>>>> stripe width or the internal track size.  A properly aligned
>>>> multiple of optimal_io_size is the preferred request size for
>>>> workloads where sustained throughput is desired.  If no optimal
>>>> I/O size is reported this file contains 0.
>>>>
>>>> Well, I find this definition not correct *at all*. This is repeating the
>>>> definition of minimum_io_size (limits->io_min) and completely disregard the
>>>> eventual optimal_io_size limit of the drives in the array. For a raid array,
>>>> this value should obviously be a multiple of minimum_io_size (the array stripe
>>>> size), but it can be much larger, since this should be an upper bound for IO
>>>> size. read_ahead_kb being set using this value is thus not correct I think.
>>>> read_ahead_kb should use max_sectors_kb, with alignment to minimum_io_size.
>>>
>>> I think this is actually different than io_min, and io_opt for different
>>> levels are not the same, for raid0, raid10, raid456(raid1 doesn't have
>>> chunksize):
>>>   - lim.io_min = mddev->chunk_sectors << 9;
> 
> By the above example, io_min = 64k, and io_opt = 448k. And make sure
> we're on the same page, io_min is the *stride* and io_opt is the
> *stripe*.
>>
>> See above. Given how confusing the definition of minimum_io_size is, not sure
>> that is correct. This code assumes that io_min is the stripe size and not the
>> stride size.
>>
>>>   - lim.io_opt = lim.io_min * (number of data copies);
>>
>> I do not understand what you mean with "number of data copies"... There is no
>> data copy in a RAID 5/6 array.
> 
> Yes, this is my bad, *data disks* is the better word.
>>
>>> And I think they do match the definition above, specifically:
>>>   - properly multiple aligned io_min to *prevent performance penalty*;
>>
>> Yes.
>>
>>>   - properly multiple aligned io_opt to *get optimal performance*, the
>>>     number of data copies times the performance of a single disk;
>>
>> That is how this field is defined for RAID, but that is far from what it means
>> for a single disk. It is unfortunate that it was defined like that.
>>
>> For a single disk, io_opt is NOT about getting optimal_performance. It is about
>> an upper bound for the IO size to NOT get a performance penalty (e.g. due to a
>> DMA mapping that is too large for what the IOMMU can handle).
> 
> The name itself is misleading. :( I didn't know this definition until
> now.
> 
>>
>> And for a RAID array, it means that we should always have io_min == io_opt but
>> it seems that the scsi code and limit stacking code try to make this limit an
>> upper bound on the IO size, aligned to the stripe size.
>>
>>> The orginal problem is that scsi disks report unusual io_opt 32767,
>>> and raid5 set io_opt to 64k * 7(8 disks with 64k chunksise). The
>>> lcm_not_zero() from blk_stack_limits() end up with a huge value:
>>>
>>> blk_stack_limits()
>>>   t->io_min = max(t->io_min, b->io_min);
>>>   t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
>>
>> I understand the "problem" that was stated. There is an overflow that result in
>> a large io_opt and a ridiculously large read_ahead_kb.
>> io_opt being large should in my opinion not be an issue in itself, since it
>> should be an upper bound on IO size and not the stripe size (io_min indicates
>> that).
>>
>>>> read_ahead_kb should use max_sectors_kb, with alignment to minimum_io_size.
>>>
>>> The io_opt is used in raid array as minimal aligned size to get optimal
>>> IO performance, not the upper bound. With the respect of this, use this
>>> value for ra_pages make sense. However, if scsi is using this value as
>>> IO upper bound, it's right this doesn't make sense.
>>
>> Here is your issue. People misunderstood optimal_io_size and used that instead
>> of using minimal_io_size/io_min limit for the granularity/alignment of IOs.
>> Using optimal_io_size as the "granularity" for optimal IOs that do not require
>> read-modify-write of RAID stripes is simply wrong in my optinion.
>> io_min/minimal_io_size is the attribute indicating that.

I'm not familiar enough with the all the code using io_opt to be certain,
but I think it's a little bit the other way around.

The problem definitely seems to be that we want to use one variable for
multiple different purposes. io_opt in struct queue_limits is the "optimal
I/O size", but "optimal" can mean many things in different contexts. In
general, if I want to do some I/O, I can say that the optimal way to do it
is to make I/O requests that satisfy some condition. The condition can be
many things:

- The request size should be at least X (combining two small requests into
  a big one may be faster, or extending a small request into a bigger one
  may avoid having to do another request later).
- The request size should be at most X (for example, because DMA is
  inefficient on this system with request sizes too large -- this is the
  _only_ thing that shost->opt_sectors is currently set for).
- The request size should be a multiple of X, _and_ the request should
  have an alignment of X (this is what a striped md array wants).

And, of course, there can be many other "optimality" conditions. The ones
listed above all have a parameter (X), which can, in the context of that
condition, be called the "optimal I/O size". These parameters, however,
can be very different for each condition; the right parameter for one
condition can be completely inappropriate for another.

The SCSI standard may have a definition for "optimal transfer length",
but io_opt in struct queue_length seems to be used for a different purpose
since its introduction in 2009:

- It was introduced in commit c72758f33784 ("block: Export I/O topology
  for block devices and partitions"). The commit message specifically
  mentions its use by md:
      The io_opt characteristic indicates the optimal I/O size reported by
      the device.  This is usually the stripe width for arrays.
- It actually started being set by md in commit 8f6c2e4b325a ("md: Use new
  topology calls to indicate alignment and I/O sizes"). The commit date
  is more than a month later than the last but as far as I can see, they
  were originally posted in the same patch series:
  https://lore.kernel.org/all/20090424123054.GA1926@parisc-linux.org/T/#u
  In the context of that patch series, md was literally the first user
  of io_opt.
- Using the lowest common multiple of the component devices and the
  array to calculate the final io_opt of the array happened in
  commit 70dd5bf3b999 ("block: Stack optimal I/O size"), still in 2009.

It wasn't until commit a23634644afc ("block: take io_opt and io_min into
account for max_sectors" in 2024 that sd_revalidate_disk started to set
io_opt from what, in the context of the SCSI standard, should be called
the optimal I/O size. However, in doing so, it broke md arrays. With my
setup, this was hidden until commit 9c0ba14828d6 ("blk-settings: round
down io_opt to physical_block_size"), but nonetheless, it happened here.

> Ok, looks like there are two problems now:
> 
> a) io_min, size to prevent performance penalty;
> 
>  1) For raid5, to avoid read-modify-write, this value should be 448k,
>     but now it's 64k;
>  2) For raid0/raid10, this value is set to 64k now, however, this value
>     should not set. If the value in member disks is 4k, issue 4k is just
>     fine, there won't be any performance penalty;
>  3) For raid1, this value is not set, and will use member disks, this is
>     correct.
> 
> b) io_opt, size to ???
>  4) For raid0/raid10/rai5, this value is set to mininal IO size to get
>     best performance.
>  5) For raid1, this value is not set, and will use member disks.
> 
> Problem a can be fixed easily, and for problem b, I'm not sure how to
> fix it as well, it depends on how we think io_opt is.
> 
> If io_opt should be *upper bound*, problem 4) should be fixed like case
> 5), and other places like blk_apply_bdi_limits() setting ra_pages by
> io_opt should be fixed as well.
> 
> If io_opt should be *mininal IO size to get best performance*, problem
> 5) should be fixed like case 4), and I don't know if scsi or other
> drivers to set initial io_opt should be changed. :(
> 
> Thanks,
> Kuai
> 
>>
>> As for read_ahead_kb, it should be bounded by io_opt (upper bound) but should
>> be initialized to a smaller value aligned to io_min (if io_opt is unreasonably
>> large).
>>
>> Given all of that and how misused io_opt seems to be, I am not sure how to fix
>> this though.
>>
> 

Hunor Csordás
