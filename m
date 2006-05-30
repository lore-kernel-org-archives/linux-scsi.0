From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.17-rc5-mm1
Date: Wed, 31 May 2006 00:09:32 +0200
Message-ID: <20060530220931.GA32759@elte.hu>
References: <20060530022925.8a67b613.akpm@osdl.org> <6bffcb0e0605301155h3b472d79h65e8403e7fa0b214@mail.gmail.com> <6bffcb0e0605301157o6b7c5f66q3c9f151cbb4537d5@mail.gmail.com> <20060530194259.GB22742@elte.hu> <6bffcb0e0605301457v9ba284bk75b8b6d14384489a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:38788 "EHLO mx3.mail.elte.hu")
	by vger.kernel.org with ESMTP id S932518AbWE3WJN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 18:09:13 -0400
Content-Disposition: inline
In-Reply-To: <6bffcb0e0605301457v9ba284bk75b8b6d14384489a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>


* Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> >  http://redhat.com/~mingo/lockdep-patches/latency-tracing-lockdep.patch
> >
> >just apply it ontop of your current tree and accept all the new .config
> >options as the kernel suggests them to you.
> 
> I can't boot with that patch. I even don't see "Uncompressing
> Linux..." - machine reboots.
> I have 2.6.17-rc5-mm1 +
> genirq-cleanup-remove-irq_descp-fix.patch
> lock-validator-irqtrace-support-non-x86-architectures.patch
> lock-validator-special-locking-sb-s_umount-2-fix.patch
> from hot fixes
> +
> Arjan's net/ipv4/igmp.c patch.

could you try to 1) disable PREEMPT, 2) apply the -V2 rollup of all 
fixes so far to 2.6.17-rc5-mm1:

 http://redhat.com/~mingo/lockdep-patches/lockdep-combo-2.6.17-rc5-mm1.patch

? I'll try your config meanwhile.

	Ingo
