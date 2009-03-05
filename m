From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] 2.6.29-rc6-2450cf in scsi_lib.c (was: Large amount of
 scsi-sgpool)objects
Date: Thu, 5 Mar 2009 13:09:02 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0903051246190.3048@localhost.localdomain>
References: <20090305182958Q.fujita.tomonori@lab.ntt.co.jp> <20090305100901.GU11787@kernel.dk> <20090305101436.GV11787@kernel.dk> <20090305192737I.fujita.tomonori@lab.ntt.co.jp> <20090305103023.GW11787@kernel.dk> <20090305104159.GE32407@elte.hu>
 <20090305110534.GX11787@kernel.dk> <20090305110736.GJ32407@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090305110736.GJ32407@elte.hu>
Sender: linux-ide-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@HansenPartnership.com, jengelh@medozas.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens,

On Thu, 5 Mar 2009, Ingo Molnar wrote:
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Thu, Mar 05 2009, Ingo Molnar wrote:
> It pulled without conflicts so we are good. Started testing it. 
> Once Thomas is around i suspect he'll be able to test it too 
> with his reproducer.

I started the tests on the reproducer machine and the first result
looks good so far. I let the tests run in a loop to make sure that it
fixes the problem for real. Will report later today what the long run
outcome is.

Thanks,

	tglx


