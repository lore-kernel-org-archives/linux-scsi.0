Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=34.202.193.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795724661;
	b=ujUcdsn9Jyphc4GQwOfimXzcvXsIwcMKdrbITTmc2qWnHkhJqCpNMA5PIJCSm3sqgTYy
	 4K1xKt4nSk4MACsSbAQ73E0twRNkvfgov/1xv0IQVWRUM5afQV0WMnueMBIfpkW19vs+y
	 kNFtWMR4rkPRCbkH8z8JB0u3VoRH7eML8CXHVtXHpfwdB/AFV1EHMOm8BIk2TU9MDRUC3
	 p9b9+odQd9lgKvHiWQEHLtjXtOffW6VfE227P2MGvo6hd/06vS2wjshAORuqL71RJ3KN8
	 2J2bBpbUw+SzoWsFKUT96pn1l0wYB04G/w7Y7pAAInZlOwFivMS094DE6nFXesTK6hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795724661;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Feedback-ID:
	 X-Pm-Original-To:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qlDtvByb+h+v2PeUfKsYekOy95yt8JgKZ2ji6G3aweE=;
	b=T7jtgm8o3UuFaKiLXGqYn07mJ78L1HTRrPUTN3tGfJ3gSt6NagUTnCOtEKG8gv3Ko8aH
	 vsH7/U6P/oqoK6zd4Ih886IKujFmxNwTvD89FcNR69cK2194cz73xnYwjm0T8Qk1pI7o1
	 wKmBIVpakLYYwlmXw9zcdAhG0Erl/17MViIgZm95OZVrItJGsUlOVk9Fa47tXQindbkm+
	 rezsg4xxbHWJjop6qKarEo9T9myv/Oqsf/o3u6jRy52Rk0asQmh+Cark42yGFCqunTXnI
	 3mFYuymzhRWHkNNBAt9/uY3y9+9Vr9t/VvWb4QWPi7LmBY4M5lN3iErmfXhGpIeUaSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=atomlin.com;
	spf=pass smtp.mailfrom=atomlin.com;
	dkim=pass header.d=atomlin.com header.i=@atomlin.com header.a=rsa-sha256 header.s=purelymail3 header.b=akTKKui8;
	dkim=pass header.d=purelymail.com header.i=@purelymail.com header.a=rsa-sha256 header.s=purelymail3 header.b=nRatYBdr;
	arc=none smtp.remote-ip=34.202.193.197
Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7A9606A331
	for <linux-scsi@vger.kernel.org>; Thu, 26 Nov 2026 20:24:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D7A9606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=atomlin.com header.i=@atomlin.com header.a=rsa-sha256 header.s=purelymail3 header.b=akTKKui8;
	dkim=pass (2048-bit key, unprotected) header.d=purelymail.com header.i=@purelymail.com header.a=rsa-sha256 header.s=purelymail3 header.b=nRatYBdr
DKIM-Signature: a=rsa-sha256; b=akTKKui8+8+YY3cMWxcBXhzvhVE4ZB8bVH6aX+GRCrz84HHLVcU+pJQw3tmZd7k+vxMhzKILHtv6ET8wuSt/eyRgUATDGTXyz498d8fm+9xfvcrG4uQNBS9U3ALVpt46QWqIt8rluVbcRNR1Hdfn+H3rHrAizV3qwblMMdeyjE+GOt/NBb0DC0wz3aTo7iARc0mSEn85H3LrJv4LjQe6X/CmxGikGbqUmN4uBPFa9zIFHXZyuD+lhKyK5BE9WumjxU2oq3Atdn+VloR2I5pyQ/cGlAfjJ+sIEzhVFw9+nsEKaQAeISPlGShPdJS0vVTxwVrw36rqU6UUIgZSSF3Izw==; s=purelymail3; d=atomlin.com; v=1; bh=fVY6CisFDNCM3VjlaM/7t4uq5vP89xYRwO7bUsN7UJY=; h=Received:Date:From:To:Subject:Message-ID;
DKIM-Signature: a=rsa-sha256; b=nRatYBdrQcz28rFzoW0PRZLJwUHBoOJvTbN6DcBo3H2PpXUR5j5QgHR+LqRjUf6hccupScUOkdFHMQ7cm556LMUjDKeGlK1AT5qFnLHNlxSNRO/psnc8JKukYyjPGHSgU9In1DqTO2CdTB+7PmvV/zrUhfGKCGCqYR4D9kWlraMB2qnwhrugxsv9LM+V8I5R0pcPWUOz8/4Wq/P68iT9cAKS/WxfvevfbLoszKG7Z0hvfKlPn4Y0hfqaRhs3SeihrWtUnl6FDHSM56s0YjlYGxvHYquidoN8kBEMsFJX1EvOnbS1Quksfh+x6R+CLiTpTAWzsxlmpofV4GW1/izupA==; s=purelymail3; d=purelymail.com; v=1; bh=fVY6CisFDNCM3VjlaM/7t4uq5vP89xYRwO7bUsN7UJY=; h=Feedback-ID:Received:Date:From:To:Subject:Message-ID;
Feedback-ID: 1802931:67223:null:purelymail
X-Pm-Original-To: linux-scsi@vger.kernel.org
Authentication-Results: purelymail.com; auth=pass
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id 1058859251;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Thu, 26 Nov 2026 20:23:32 +0000 (UTC)
Date: Thu, 26 Nov 2026 15:23:31 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Cc: axboe@kernel.dk, bigeasy@linutronix.de, corbet@lwn.net, 
	frederic@kernel.org, linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, marco.crivellari@suse.com, 
	mingo@redhat.com, mkp@kernel.org, neelx@suse.com, peterz@infradead.org, 
	tglx@kernel.org, vincent.guittot@linaro.org
Subject: Re: [PATCH v16 0/9] blk: honor isolcpus configuration
Message-ID: <rfppj6h3dfwsyvstju6k62cigzicdhoqy7j6yo7fnne7tcy3no@fvjpn5glg73m>
References: <ul7xqsblqnrzx67s7urmtc34qpemuf3jeduxmsuwxwlnky7eli@mzdpwwgug3hg>
 <20261005152449.468696-1-ionut.nechita@windriver.com>
 <20261006135749.348637-1-ionut.nechita@windriver.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261006135749.348637-1-ionut.nechita@windriver.com>

On Tue, Oct 06, 2026 at 04:57:44PM +0300, Ionut Nechita (Wind River) wrote:
> Hi Aaron,
> 
> Follow-up with the controlled data I promised, and a correction. I was
> wrong to point at your series in my first mail. After a clean A/B the
> control-plane stall is a shared blk-mq queue-contention problem on a
> shared disk, reproducible on *plain* managed_irq. Your series does not
> introduce it -- but it does remove the per-CPU-queue separation that
> otherwise keeps it from happening, so I think there is still a real
> I/O-QoS question for you. Details below, each claim backed by a debugfs
> capture.

Hi Ionut,

First of all, please accept my sincere apologies for the delay in getting
back to you.

Thank you for following up with such a thorough, well-instrumented A/B
comparison and for taking the time to trace the per-hctx behaviour down to
the exact queue mappings.

> 
> Setup
> -----
>   Kernel:   6.18.15-rt (PREEMPT_RT), v16 applied
>   CPU:      2x Intel Xeon Gold 6338N, 128 CPUs, 2 NUMA nodes
>             112 isolated, 16 housekeeping (8 carrying managed IRQs)
>   Storage:  Dell PERC / MegaRAID (megaraid_sas) fronting a SATA SSD
>             (Samsung PM893), passthrough. etcd and the fio target share
>             the SAME physical disk (sda4 / cgts-vg).
>   Workload: one fio pod, libaio iodepth=256 numjobs=4 direct=1,
>             SCHED_OTHER (NOT RT -- RT is not required to reproduce),
>             pinned to one isolated CPU (CPU 2) via the StarlingX
>             isolcpus device-plugin label (verified with ps -eLo psr).
>   Method:   per-hctx in-flight snapshot from
>             /sys/kernel/debug/block/sda/hctx*/busy during the run,
>             cross-referenced with each queue's mq/*/cpu_list and with
>             etcd's CPU set (ps psr).
> 
> The decisive observable is not "etcd alive/dead" but which single
> blk-mq queue the isolated pod's I/O lands on, and whether one of etcd's
> CPUs is mapped to that same queue.
> 
> The clean A/B (identical kernel = plain managed_irq, identical fio 4k
> randread, identical nr_requests=5089, fio always on isolated CPU 2;
> only the device's blk-mq queue count differs)
> ----------------------------------------------------------------------
> 
>   (B) default MSI-X -> 120 blk-mq queues, ~1 CPU per queue
>       All ~35 in-flight land on hctx61, a queue mapped to the isolated
>       submitter and NOT used by any etcd CPU.
>       -> no collision. etcd healthy. Device load ~82k IOPS 4k,
>          sda aqu-sz ~1020, r_await ~12.3 ms.
> 
>   (C) megaraid_sas.msix_vectors=16 -> 15 blk-mq queues, ~8 CPUs each
>       All ~33 in-flight land on hctx7, mapped to CPUs {0,4,64,68}.
>       etcd runs on CPU0 and CPU68 -> same queue.
>       -> collision. etcd apply 2-7 s, "request timed out",
>          "context deadline exceeded", /registry/health failing.
>          Control plane down -- on plain managed_irq, WITHOUT your series.
> 
> Same kernel, same disk, same fio, same depth; the only thing that
> changed is whether there were enough hardware queues for the isolated
> CPU to get one that etcd does not also use. That is the whole bug.
> 
> Supporting data point on the strict kernel
> ------------------------------------------
> I also have one capture on the managed_irq_strict image (earlier run,
> so not parameter-matched to B/C: it was a 64 KB read profile, and
> /sys/block/sda/queue/nr_requests was already capped to 64 -- that cap
> was my doing, the only way I could keep etcd / kube-apiserver alive
> enough for the node to stay up and for me to collect the capture at
> all; the default 5089 took the control plane down hard). It is still
> informative directionally: with 0006 active, sda is confined to 16
> blk-mq queues on the HK CPUs, fio on isolated CPU 2 funnels all ~30
> in-flight onto hctx0 == CPU1, and CPU1 is an etcd CPU -> even with that
> nr_requests=64 cap in place, etcd apply still blows out to multi-second
> with context-deadline / health-probe failures. So strict reproduces the
> same collision by construction, and the nr_requests knob only partially
> masks it there.
> 
> Conclusion
> ----------
> The failure is not strict-vs-non-strict. It is whether the isolated
> pod's submission queue coincides with a queue an etcd CPU also uses:
> 
>   - On a device with enough hardware queues, plain managed_irq gives
>     the isolated CPU its own blk-mq queue, disjoint from etcd's, and
>     the heavy pod I/O does not head-of-line-block etcd (B).
>   - Shrink the queue count until CPUs must share a queue -- via a low
>     MSI-X count (C), or via your 0006 "use HK CPUs only" confinement
>     (strict) -- and the isolated pod's deep queue lands on a queue etcd
>     uses, and etcd starves.
> 
> So this is pre-existing shared-queue contention on a shared slow disk,
> not a bug your series introduces. I retract the implication in my
> previous mail. (It is also device-level, not CPU: during the stall 7 of
> 8 IRQ-HK cores are idle and the backlog is pure block-layer queueing,
> aqu-sz ~1020 at ~70% util.)

Your diagnosis makes complete sense, and the A/B comparison between (B) and
(C) illustrates the mechanics very clearly.

It is worth noting why configuration (B) gave isolated CPU 2 its own
disjoint hardware context (ctx61) in the first place. With 120 queues
distributed across 128 CPUs under the legacy post-allocation
"isolcpus=managed_irq" behaviour, group_cpus_evenly() assigned hctx61's
managed interrupt affinity mask solely to isolated CPUs. Because that
vector's affinity mask had no intersection with the housekeeping mask, the
genirq steering logic could not move the interrupt off the isolated core.
In other words, configuration (B) only avoided sharing a queue with etcd by
leaving the hardware queue and its completion interrupt on the isolated
CPU, which is the exact isolation failure this series addresses.

Also, following discussions at the Linux Plumbers Conference, the consensus
is to drop the separate "managed_irq_strict" flag and instead upgrade
"isolcpus=managed_irq" directly in place to enforce strict pre-allocation
queue and interrupt confinement. I will also fold in your pre/post
reserved vector patch under HK_TYPE_MANAGED_IRQ in the next iteration.

> 
> Where I think the series is still relevant
> ------------------------------------------
> 0006 confines blk-mq to the HK CPUs unconditionally. On a
> well-provisioned device (B, 120 queues) that is exactly the config that
> *removes* the per-CPU-queue separation which was keeping isolated bulk
> I/O off etcd's queues. In other words, strict turns a
> "only on queue-starved devices" problem into "always, because every
> isolated submission is forced onto the HK queue set the control plane
> also lives on." That is a deliberate and correct part of the design --
> isolated CPUs must not host the queues -- but it makes an I/O-QoS gap
> unavoidable rather than incidental.
> 
> Mitigation
> ----------
> Capping /sys/block/sda/queue/nr_requests on this device (megaraid_sas
> with the SATA SSD exposed transparently / passthrough, e.g. 5089 -> a
> small value in the 32-64 range -- lower for a slower disk) shortens the
> head-of-line backlog and helps, but note it is weaker under strict/low-
> queue configs: when all submissions pile on one etcd-shared queue, even
> a depth of 32-64 on that single queue still hurts etcd. For production I'd
> prefer cgroup v2 io.max / io.latency to protect control-plane I/O, or a
> dedicated device for etcd.
> 
> Questions
> ---------
>   1. When 0006 forces all isolated-pod block I/O onto the HK queue set,
>      do you consider protecting co-located latency-critical services
>      (etcd/kube-apiserver) from that I/O an operator concern
>      (io.latency/io.weight, dedicated device), or is there a case for
>      the series to leave a per-CPU submission path / reserved HK queue
>      so bulk isolated I/O cannot head-of-line-block them?

I view this as an operator and configuration concern. We cannot give
isolated CPUs their own hardware queues without either routing interrupts
back to them or using up housekeeping vectors. Reserving a dedicated
housekeeping queue in blk-mq would also put workload policy into the queue
mapping code, when the block layer has no way of knowing which I/O is
latency-sensitive. Since all queues still hit the same underlying disk,
using cgroup v2 I/O limits (such as io.latency or io.max) or putting etcd
on a separate drive is the right way to handle this.

>   2. Is there an assumed minimum HK queue count relative to the
>      aggregate block I/O of isolated pods? 8 IRQ-HK vs 112 isolated on
>      one shared disk makes the HK queue set trivial to saturate on
>      depth even while it is CPU-idle.

The kernel assumes no minimum beyond at least one online housekeeping CPU.
However, when many isolated CPUs fan into a small number of queues on a
slow shared disk, an unthrottled high-iodepth workload will saturate the
shared hctx request pool long before the housekeeping CPU is busy, making
cgroup I/O throttling or storage separation essential.


Kind regards,
-- 
Aaron Tomlin
