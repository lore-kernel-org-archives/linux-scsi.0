From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Fri, 7 Nov 2003 09:37:37 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031107093737.B1992@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B0598CE6@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598CE6@AVEXCH02.qlogic.org>; from andrew.vasquez@qlogic.com on Thu, Nov 06, 2003 at 09:45:50AM -0800
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 06, 2003 at 09:45:50AM -0800, Andrew Vasquez wrote:
> No.  We've had this IOWR problem since the inception of 5.x series
> driver.  Software (SMS 3.0) has been built on top of the this IOCTL
> interface.  We painfully discovered this problem when we began to look
> at other non-x86 platforms (ppc64).

I don't know what SMS is, but Linux provides a stable ABI for stable
kernel series and only those.  We already have anough garbage from mistakes
in older kernel releases that we won't accept more with new driver
submission.  If SMS didn't use a abstraction library it would have a problem,
yes.

> >  Also having different ioctl values for different plattforms is not
> >  an option for Linux.
> > 
> 
> The better (right) fix would be to push this interface change onto the
> caller of the IOCTLs where they can manage the differences there, and
> the driver could once and for all shed itself of this nagging problem.
> That is the consensus here.  The _BAD conversion was only done so the
> driver would compile.

Sorry, I don't parse that.  There's no reason different architectures
should have differences in the ioctl calling convention, so there shouldn't
be anything to deal with in the caller either.
