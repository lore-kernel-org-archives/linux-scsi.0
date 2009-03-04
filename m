From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 4 Mar 2009 11:11:14 -0800
Message-ID: <20090304111114.aed7b225.akpm@linux-foundation.org>
References: <20090303192212.GA20705@elte.hu>
	<1236115544.15993.22.camel@localhost.localdomain>
	<20090303214454.GA8288@elte.hu>
	<1236119990.24019.35.camel@localhost.localdomain>
	<20090303230323.GA21644@elte.hu>
	<49ADBE29.4040706@s5r6.in-berlin.de>
	<20090303234834.GA13389@elte.hu>
	<49AE221D.9010909@s5r6.in-berlin.de>
	<1236150752.6049.19.camel@marge.simson.net>
	<49AE32B5.9040603@s5r6.in-berlin.de>
	<20090304112455.GB14593@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <20090304112455.GB14593@elte.hu>
Sender: linux-rt-users-owner@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: stefanr@s5r6.in-berlin.de, efault@gmx.de, James.Bottomley@HansenPartnership.com, jengelh@medozas.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org, tglx@linutronix.de
List-Id: linux-scsi@vger.kernel.org

On Wed, 4 Mar 2009 12:24:55 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> FYI, we still have not tracked down the SCSI bug. Latest 
> tip:master is able to boot and work on the affected systems, 
> while the upstream kernel does not even boot because the fix (or 
> the revert, should the fix be deemed unwanted) is stuck in the 
> SCSI tree.

<wakes up>

There are fixes in the scsi tree?

Does the scsi tree fix all the regressions which you guys are seeing?

I must say that it seems to be awfully late in the cycle to have this
amount of breakage remaining in mainline when we know exactly which
patches need to be reverted to unbreak things.

