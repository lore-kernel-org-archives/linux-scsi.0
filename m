From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: in 2.6.23-rc3-git7 in do_cciss_intr
Date: Tue, 18 Nov 2008 21:32:14 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884EACB793EB@GVW0547EXC.americas.hpqcorp.net>
References: <20080821091514.8f56e2d5.randy.dunlap@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A778835118100D6@GVW0547EXC.americas.hpqcorp.net>
	<20080821172653.3e3e855c.randy.dunlap@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A77883511810706@GVW0547EXC.americas.hpqcorp.net>
	<1219420487.3339.22.camel@localhost.localdomain>
	<48AEEE0A.1010900@oracle.com>
	<1219424538.3339.51.camel@localhost.localdomain>
	<0F5B06BAB751E047AB5C87D1F77A77883511810894@GVW0547EXC.americas.hpqcorp.net>
	<48C013D9.7060309@oracle.com>
	<0F5B06BAB751E047AB5C87D1F77A7788413663D229@GVW0547EXC.americas.hpqcorp.net>
	<20080905092838.GS20055@kernel.dk>	<48DBF583.3050307@oracle.com>
 <20080925134000.9b133f8c.randy.dunlap@oracle.com>
 <0F5B06BAB751E047AB5C87D1F77A77884BFF5D1F76@GVW0547EXC.americas.hpqcorp.net>
 <49232232.10604@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:4853 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbYKRVdA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2008 16:33:00 -0500
In-Reply-To: <49232232.10604@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>


> FS:  00000000008558f0(0000) GS:ffff88017fc01c80(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000248 CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400 Process swapper (pid: 0, threadinfo
> ffff88027f660000, task ffff88027f635400)
> Stack:
>  0000000000000030 ffff88017ea73640 0000000000000000 0000000000000000
>  0000000000000057 0000000000000000 ffff88017fa9ff48
> ffffffff8026a8b9  ffffffff8074ab00 0000000000000057
> ffff88017ea73640 ffffffff8074ab58 Call Trace:
>  <IRQ> <0> [<ffffffff8026a8b9>] handle_IRQ_event+0x27/0x57
> [<ffffffff8026c424>] handle_edge_irq+0xde/0x11f
> [<ffffffff8020e29b>] do_IRQ+0xfc/0x175  [<ffffffff8020c3e6>]
> ret_from_intr+0x0/0xa  <EOI> <0> [<ffffffff8023c7d2>] ?
> ksoftirqd+0x0/0xa6  [<ffffffff80212575>] ?
> default_idle+0x2b/0x40  [<ffffffff80212799>] ?
> c1e_idle+0xe5/0xec  [<ffffffff8056a7f6>] ?
> atomic_notifier_call_chain+0xf/0x11
>  [<ffffffff8020acd1>] ? cpu_idle+0x40/0x5e
> [<ffffffff8056284e>] ? start_secondary+0x174/0x179
> Code: 8b 83 48 02 00 00 48 39 d8 74 37 49 39 9c 24 c0 00 01
> 00 75 08 49 89 84 24 c0 00 01 00 48 8b 83 40 02 00 00 48 8b
> 93 48 02 00 00 <48> 89 90 48 02 00 00 48 8b 93 48 02 00 00 48
> 89 82 40 02 00 00 RIP  [<ffffffffa002502b>]
> do_cciss_intr+0x6c8/0xb10 [cciss]  RSP <ffff88017fa9fee8>
> CR2: 0000000000000248
> Kernel panic - not syncing: Fatal exception in interrupt
>
>
> Any ideas/suggestions?
>
> Thanks,
> ~Randy
>

Randy,
I been in and out of the office, mostly out. I finally tracked down a blade. I can't reproduce this on a 385 and the e200 isn't detected in my 585.

So I'm back on this, for what it's worth.

-- mikem
