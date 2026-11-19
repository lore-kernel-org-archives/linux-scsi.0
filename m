Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054574;
	b=qhjAL9KJJQBZppgWxiQep3Tctv0UZe4XZCLFuZ5Lzmm3QTF2q72EWc3CAoPK3Bj1uxGm
	 A1qPBMQZ/+jrVfsxoTQXDLBCOAJqXHdx6XGpj2/ATxizE4Iiu4x/+aOeEXizytLXFetsL
	 JXDDbjub1OhIwUwcNQUsRjM++L2xZkSyJoqtQ1y2N5bAP83S+VCOpX2dTJEb7CXZVSh3O
	 KOGmO8tEhZR2pyWrcprUGLStFVOyq7eJr+TvQS4Q4K6qHiB6bu/93ZqVdBirNUNQZo7oD
	 fLqsvaU8UcbbnR4vxf/XQ7bpKa2HWkEK40nGvvEm1dGJ+6ZqbNmKomfJ6A7QZfc7Nxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054574;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=VN0dkAoykjpPyuXs8qS8ALX3/rfMgri8haILYEWluaw=;
	b=iORPHI+a70YiBa6mYrD1sgIcgd+xeA2bY++hUQq27dT3pRj+YiVTh9nH+0XVq/lyvLtJ
	 Bvv53eEIa7ZS9k/O6aGS07ql2ZdkhhyiSk6R/yU6MSikRHbvgdU/goTeDjHnLdCcYDpQx
	 MphzuCCzxqLUG4M667dVgwjihpnY09ChWcgbMqe2uY0aeTaQjKw11fx0yyVp0yO91h6T8
	 DjUukCSZhBVKTMPgp3Id2vudAdAw/aSUysdSvdPhZWzgUn46ZAq+nslZYJqqt9rOFg0Cx
	 /sbGhgubZsAiQsgYiQdL23ZutdAUAclUIRoS5ezLEVJskXECn8TewMWElAU61gRt8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rTGmxNs+;
	arc=none smtp.remote-ip=209.85.210.45
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181DA606A330
	for <linux-scsi@vger.kernel.org>; Thu, 19 Nov 2026 02:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 181DA606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rTGmxNs+
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-862b3a39d0dso897550a34.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 18:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795054572; x=1795659372; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VN0dkAoykjpPyuXs8qS8ALX3/rfMgri8haILYEWluaw=;
        b=rTGmxNs+0ILYq2XHdDrlH1Nkd5KHtMjwlR66OuAL+lH5PU9S0/x2NgCntviKsZ+j4/
         tRa+nuHv5ukymPSxI9cOYttkr6QeXyu1EDW7Q1yhS76Y9SpjnjQ1xQlA24qWVNnCMJsX
         jIDWRZ4me9hfwK1xKzYUJ2LtOPvjIaqap5jyVCg19LEXBNfWoQQBt+efsm3M1iqINyY4
         3MwOlZqamsbQ5iX9f+bsmqgLDfhJnpetmhU86a9hBYVyoitREF5683L5DHtSoBx0rB5V
         K2I8VYrPRrqIrkznnQ6e3oYuq+T5HeyKSxavkZalmHI4TM/k8GOWYC6UJiBQ3dZus4IP
         7TTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795054572; x=1795659372;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VN0dkAoykjpPyuXs8qS8ALX3/rfMgri8haILYEWluaw=;
        b=pVuw1aJO/I0+Y1s3x/lYGv8J1UN0XIi3G/cbHAIg8L/QcFtWMpHHyeSNkiuByZ0nG4
         XkGA6s3/WO4PqmTSeoI9n5TTVWJDySxqXFZ9uWic6U3sZsqrgdqEiYlYVeFBXb+OqNCc
         uyTDgo2aJNmxy2UPrPGwTnU2hc62DcXtUcSgDB6440SV+kki1rZsG90u/n1Zo0HgWIkT
         1Pt1sBLLB7wPypwjZUa1pZkXRx69BBHhmMFTozavp4qAMat2vdYC/Od3sqKTpgOx84AM
         dTZb5e1YmEtuctmoi47AGw1oNYAwmZwaOTT1BaxTU0ryK+0v8/G5GsK7D6D86cMdEXPU
         KWFQ==
X-Forwarded-Encrypted: i=1; AL+hErFxlJqymF1PgDsUWCxyATUWJBq1iwpI5VSBgzSem2oKQCcYUq6kIwEtvrNWko6taUBW8E4fG7FEuNEe@vger.kernel.org
X-Gm-Message-State: APuU4Z/9WaeOCuAtSGZNK8SkXX3WZTsQLTpcmzyoqxOEQ0OWwlWrdJ/J
	DtRzvs4XoG1+RAPtAAcm4opsOiyxL1D0/DcEx9Jga2OqslhbIrQGpmRmAg/DPUjx
X-Gm-Gg: AYBFou0/x8NVisqJQGcDFhGB3CtlqsjLXEP5G1GsX/vhFvc8RbytqVddMPC+SLshzR4
	qv3ssBpG1/YBfRRcdUncgJgYb9EPT2m+wEHd4yR/NcpeofISdYTh/HHIB5t6cZnZwp0VIW6f4//
	SfCtVZ7yaXHIKSSr65Xj72f0HheWc/9D3z/Ev0wihPLRUKRu94yv3Nk68O+XREVjWTKGz0lGl/Q
	EUzTQLo9XxaiHfMg3llupPrnlRb+ZdrSJZUMdgxwK3uWPp93FDMhlv5V2wg+fJZo4szynAn9y6n
	WwT61i0yD7suvATbEs/MbqVnU18q96wPskPaHzHUh0l9JM1k+5K5X6K/axS8Bg4fDPFUfCYsv+O
	Tulki1+a1Fdz+/xjFrbaMvQNIaIYI8I/pg7QVmgFNfCUVT79GCrzaCG4Yj7s7hY1m5S5FLZEgSK
	zxflhhp3ReFBGxU+so1Ke883+mx8g66gDr/edD73FAS7hdOMoJ07gW4vlvIIzkPuQffZQ5vdLyL
	vAJKde8t4/GkSrP0kAacIav1PLemqkzwRdu9fn0UH0rfcnW9yUIao2x8NuSEQdt6wLKLBXyX+IN
	zAFipjEOb2NMzC7vwU06svs4ELMnagy/TNoA6xapdJ0A8gnGSDMzy8G7KiYHADu+j+vXhBp2vTf
	VtkPrEwhoNILVPa7btkX2YZrbIR8AEEuBfQz8OQI7D3Fc+LgiX8MWgg==
X-Received: by 2002:a05:6830:310b:b0:862:cbe7:668d with SMTP id 46e09a7af769-862f082c9c5mr5695809a34.2.1795054571925;
        Wed, 18 Nov 2026 18:16:11 -0800 (PST)
Received: from fedora-laptop ([172.245.82.59])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862f021298dsm3474480a34.16.2026.11.18.18.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 18:16:11 -0800 (PST)
Date: Wed, 18 Nov 2026 20:16:03 -0600
From: Ming Lei <tom.leiming@gmail.com>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	Mike Christie <michael.christie@oracle.com>,
	Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH RFC 00/18] scsi: target: Add target_core_uring, an
 io_uring based user backstore
Message-ID: <av5b4-b48QNzzyxz@fedora-laptop>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
 <avprIhtn1TuYLX1b@fedora-laptop>
 <20261117024640.3184554-1-qiliang.yuan@linux.dev>
 <av0CAptnbIZP-53U@fedora-laptop>
 <20261119010233.2917434-1-qiliang.yuan@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119010233.2917434-1-qiliang.yuan@linux.dev>

On Wed, Nov 18, 2026 at 08:02:33PM -0500, Qiliang Yuan wrote:
> On Tue, Nov 17, 2026 at 07:40:18PM -0600, Ming Lei wrote:
> > Can you share your setup? It is supposed that you run fio from VM,
> > otherwise you can just compare ublk with scsi backed with tcmu.
> >
> > But if you run fio from VM, I believe you can setup virtio-scsi backed by
> > ublk block device directly, which should cover your requirement, or maybe
> > I miss something?
> 
> Everything runs in one 32 CPU guest. For tcm_loop and iSCSI (16
> sessions over 127.0.0.1), fio runs in that guest on the initiator
> disks. For vhost-scsi, fio runs in a nested 16 vCPU KVM guest on the
> vhost-scsi disk, with the target and the backstore server in the outer
> guest. In the ublk runs, kublk serves the file as /dev/ublkbN and
> target_core_iblock exports that through the same fabric.
> 
> You are not missing anything. This backstore has block semantics: the
> kernel emulates the SCSI commands, PR and ALUA included, exactly as for
> iblock, so ublk behind target_core_iblock offers the same function on
> every fabric, and for a VM a virtio-scsi or vhost-scsi disk on top of
> the ublk device covers it as well. What the series adds over that is
> only performance, and outside tcm_loop the numbers I sent do not show a
> consistent gain.

But in your last reply, not see the setup(virtio-scsi over ublk) and
perf number/compare with your scsi:target optimization.

> 
> [...]
> 
> > My question is actually why there is regression wrt. 4k randread:
> >
> >  workload               TCM/USER (MB/s)   uring (MB/s)          change
> >   4k randread, 1 job      426 (409-463)      369 (366-384)         -13%
> >
> > Maybe you can focus on single job perf only, which is easy to compare and
> > investigate.
> 
> It comes from the scheduler moving fio between CPUs. The pwrite() I
> pointed to in my last mail is not it: doing that copy inside
> io_uring_enter() instead makes no difference.
> 
> tcm_loop queues the LIO submission and completion work on the CPU that
> submitted the command, so with one job, fio's CPU always has bound
> kworkers and ksoftirqd runnable next to fio. The load balancer cannot
> move those and moves fio instead. This backstore gives it more chances:
> the completion work on fio's CPU handles 14 commands per run here
> against 24 with TCM/USER, so per 1000 I/Os the completion kworker and
> ksoftirqd run about 57 times against 35, fio is preempted as often, and
> it is moved two to three times as often. With balancing on, fio's own
> CPU time per I/O doubles here, from 3.1 to 6.3 us, against 3.4 to 4.9 us
> with TCM/USER, spread over the whole submission path rather than in one
> function.

That is one disadvantage for running IO from kernel space, and it is also one
reason why ioutgt ( https://github.com/io-target/ioutgt ) performs much better
than nvmet, especially for nvmet/tcp, not mention ioutgt doesn't implement
io_uring rxzc yet, and there are also other network optimizations available,
all can be applied flexibly.

> 
> Turning load balancing off for fio's CPUs and nothing else reverses the
> result. Single job, 4k randread at iodepth 32 over tcm_loop, 6 s per run,
> five alternating runs, median (min-max). fio runs in a cpuset of CPUs
> 4-31 and the server threads are pinned to CPUs 0-3; the cpuset is either
> a normal member (balanced) or an isolated partition (not balanced):
> 
>   fio CPUs 4-31, backstore      bandwidth (MB/s)   change
>   balanced, TCM/USER               439 (398-462)
>   balanced, uring                  379 (371-388)   -13.7%
>   not balanced, TCM/USER           662 (544-710)
>   not balanced, uring              760 (575-798)   +14.8%
> 
> Booting the guest with idle=poll removes the gap as well: with fio free
> to move, five runs give a median of 612 MB/s with TCM/USER and 627 MB/s
> here.
> 
> That points at what each switch costs in a guest. An idle vCPU executes
> HLT, which exits to the host and puts the vCPU thread to sleep; waking
> it for a kworker, ksoftirqd or a migrated fio takes an IPI, a host
> wakeup and a VM entry, and the host may run the thread on another
> physical CPU, so the guest code then runs with cold caches. With
> idle=poll the vCPUs spin instead, stay on their physical CPUs and take
> the IPI without an exit. This backstore makes more of those switches
> per I/O, so it pays more of that cost, and fio's slowdown spread over
> the whole submission path looks like cold caches.
> 
> What is measured is that idle=poll removes the gap and that the gap
> follows the switches and migrations. Which part of the cost is the exit
> and wakeup latency and which part is the vCPU thread landing on another
> physical CPU is inferred: I cannot trace the host side here. Waking an
> idle CPU is much cheaper on bare metal, so I expect the gap to be
> smaller there, but I have not measured it. idle=poll is only a
> diagnostic, it burns a host CPU per idle vCPU.
> 
> [...]
> 
> > When userspace target becomes more efficient, I'd suggest you to think
> > about why these applications can't be improved or refactored for the
> > potential (bigger)perf requirement.
> 
> Agreed. Since this backstore only takes block commands, an application
> that can move to it can just as well move to ublk, and one that needs
> SCSI semantics in userspace is not served by it either.

Why? SCSI semantics can be served in userspace, just like existing
virtio-scsi user backend.

Such as, uring-scsi may be supported in guest IO emulation application(qemu),
or one uring-virtqueue bridge, the later may be done in both userspace or
vhost_scsi, I guess.

Thanks,
Ming
