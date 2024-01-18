Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4118517C3;
	Thu, 18 Jan 2024 00:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705539272; cv=none; b=Ya4GGdnf4aXCmstU2p7UwvOgTIhxCnI8Opy6lVFMUCMLDgDtdsLZsWDVZVBZZCRBPItYhvMTczbN30sLw3WISktTAZI8jVpjopewIx+SeYPc9ArSqVpZdxko/fA9gsWH1ExpgFGgLSIDsiFUp7U5PDmYHjd3mmawEGb79+RCWMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705539272; c=relaxed/simple;
	bh=U0wYbpkVCX0nOWn+y9CyglGR9SY/KEry8JLYHWUQw6Q=;
	h=Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Google-Smtp-Source:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding; b=N+1/UvNS0kcIlQ2m9jHWHQqempJ78I4k5fSU7K9NyuUBg2uN/NQaqtdi0Fl0fTOsESW3+jQ+gfAu52+8y7cxSEeRaPW3URHhg9JCyssJqDUjck1KOHDFEUjzRitqsfI85nxhR+1SAaWRyfxOWeSG0XrYWaMfKLCKM0YwbuT5k80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-36074b286d6so59221855ab.1;
        Wed, 17 Jan 2024 16:54:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705539270; x=1706144070;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I45qqr9n38DIIRtEluaEbO4BQdx4bUm7wkLvhBzuhuU=;
        b=pZQWtf+ryje0BhXLDSmrES6xc87ayG/XpYIt4P49KzK1Dr8oHbvkoMRlXze67aTzq9
         7ITNo+/Ik72QsxfajkmaTxdwX4ojwGY3Zpyw8oMP6XkOfjXFYBNO79Ts8+QXYvl78CSf
         0FTAUX+5cgttwV9wKqIlb9HaFQx4/SC7RtgXf3dK6zO/+iV5tBVHs6AIDHJRf3mrdH1L
         rdRyP/U2BlfK/6y8bOtuJvMu376jx2uSQDM5gskmmNYzv/OiL0n5A2YIXnGmredikKST
         10D1kMuEqoa0C4LrSf35VheTa7fWJuW1yqVMR2NHF8Rg6x5kGzx6tAyKM/PqQtfhjSja
         pdyQ==
X-Gm-Message-State: AOJu0YycxnAOcR9MKkjtypGuieGa54avPQEbvk7fEzdp6xLaADRxPSyn
	BxH0J6C+k3VW8iaoRdnNkKBKWcQEwQhGOW6GRq+xvU+NZ/nM0vp+38s3hL+Z
X-Google-Smtp-Source: AGHT+IHesprjDRDHKDmWAU1kXOqX9BSX1AEcL/MOMAN2IhfSYFpDHbPo2rnOkF9E8n7AzllJQIuYag==
X-Received: by 2002:a92:cec2:0:b0:360:70a9:12c5 with SMTP id z2-20020a92cec2000000b0036070a912c5mr173583ilq.11.1705539270228;
        Wed, 17 Jan 2024 16:54:30 -0800 (PST)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id y63-20020a638a42000000b005c2185be2basm281448pgd.54.2024.01.17.16.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jan 2024 16:54:29 -0800 (PST)
Message-ID: <0853691b-0b70-48c5-825a-4b709d066e20@acm.org>
Date: Wed, 17 Jan 2024 16:54:28 -0800
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
 <2955b44a-68c0-4d95-8ff1-da38ef99810f@acm.org>
 <9af03351-a04a-4e61-a6d8-b58236b041a3@kernel.dk>
 <c6dfb4f5-10f9-461e-8743-b730a8384f95@acm.org>
 <e19746ce-fdea-4372-bc26-1ee7b1a9a22d@kernel.dk>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e19746ce-fdea-4372-bc26-1ee7b1a9a22d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/24 16:42, Jens Axboe wrote:
> On 1/17/24 5:38 PM, Bart Van Assche wrote:
>> On 1/17/24 10:43, Jens Axboe wrote:
>>> Do we care? Maybe not, if we accept that an IO scheduler is just for
>>> "slower devices". But let's not go around spouting some 200K number as
>>> if it's gospel, when it depends on so many factors like IO workload,
>>> system used, etc.
>> I've never seen more than 200K IOPS in a single-threaded test. Since
>> your tests report higher IOPS numbers, I assume that you are submitting
>> I/O from multiple CPU cores at the same time.
> 
> Single core, using mq-deadline (with the poc patch, but number without
> you can already find in a previous reply):
> 
> axboe@7950x ~/g/fio (master)> cat /sys/block/nvme0n1/queue/scheduler
> none [mq-deadline]
> axboe@7950x ~/g/fio (master)> sudo t/io_uring -p1 -d128 -b512 -s32 -c32 -F1 -B1 -R1 -X1 -n1 /dev/nvme0n1
> 
> submitter=0, tid=1957, file=/dev/nvme0n1, node=-1
> polled=1, fixedbufs=1/0, register_files=1, buffered=0, QD=128
> Engine=io_uring, sq_ring=128, cq_ring=128
> IOPS=5.10M, BW=2.49GiB/s, IOS/call=32/31
> IOPS=5.10M, BW=2.49GiB/s, IOS/call=32/32
> IOPS=5.10M, BW=2.49GiB/s, IOS/call=31/31
> 
> Using non-polled IO, the number is around 4M.

A correction: my tests ran with 72 fio jobs instead of 1. I used
fio + io_uring + null_blk in my tests. I see about 1100 K IOPS with
a single fio job and about 150 K IOPS with 72 fio jobs. This shows
how I measured mq-deadline performance:

modprobe null_blk
fio --bs=4096 --group_reporting=1 --gtod_reduce=1 --invalidate=1 \
     --ioengine=io_uring --ioscheduler=mq-deadline --norandommap \
     --runtime=60 --rw=randread --thread --time_based=1 --buffered=0 \
     --numjobs=72 --iodepth=128 --iodepth_batch_submit=64 \
     --iodepth_batch_complete=64 --name=/dev/nullb0 --filename=/dev/nullb0

Thanks,

Bart.
