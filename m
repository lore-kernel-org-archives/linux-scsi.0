From: Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen)
Subject: Re: [lvm] [christophe.varoqui@free.fr: dm multipath target]
Date: Tue, 19 Aug 2003 18:23:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030819182347.O8420@sistina.com>
References: <20030819073926.GA423@fib011235813.fsnet.co.uk> <20030819094838.F8428@sistina.com> <1061283871.3f41e81f8226b@impt3-2.free.fr> <20030819115110.I8420@sistina.com> <1061290087.3f4200678f811@impt2-2.free.fr> <20030819143552.K8420@sistina.com> <1061299572.3f4225742287c@impt1-2.free.fr>
Reply-To: mauelshagen@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout10.sul.t-online.com ([194.25.134.21]:50347 "EHLO
	mailout10.sul.t-online.com") by vger.kernel.org with ESMTP
	id S276339AbTHSQaC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2003 12:30:02 -0400
In-Reply-To: <1061299572.3f4225742287c@impt1-2.free.fr>; from christophe.varoqui@free.fr on Tue, Aug 19, 2003 at 03:26:12PM +0200
List-Id: linux-scsi@vger.kernel.org
To: christophe.varoqui@free.fr
Cc: mauelshagen@sistina.com, mge@sistina.com, linux-scsi@vger.kernel.org

On Tue, Aug 19, 2003 at 03:26:12PM +0200, christophe.varoqui@free.fr wrote:
> > > Yes, but does it mean _your_ multipath tools will need PV UUIDs ?
> > 
> > Yes.
> > 
> You realize that it make those tools unsuitable for general use : 
> * one may not want to use the full lvm compound binary to set up multipaths
> * one may not want to tag its devices to set up multipaths, where its not necessary

The "Yes" was about the LVM2 tools and we do recommend them to be installed
to support the variaty of volume management features.

If you have a corner use case where you don't need any of them but multipath,
dmsetup can be used to cover what you want out of the box (creating ASCII
mapping tables which is simple for multipath).
No need to install LVM2 at all for that.

> 
> Shouldn't LVM2 just rely on an separate multipath management (dm-based). There
> surely will be one such implementation. We users don't need fragmentation in
> such a low-level area.

dm is the multipath runtime (through a dm multipath target).

As said: you can set up multipath configs without LVM2 in case you
don't need full volume management functionality using the dmsetup tool.
This is not the recommended way but you still can do it ;)

> 
> PS: I certainly do not disregard sistina's work on this front, and do not mean
> to be disrepectful. Just trying to forward my admin point of view.

Of course not.

> 
> regards,
> cvaroqui

-- 

Regards,
Heinz    -- The LVM Guy --

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Sistina Software Inc.
Senior Consultant/Developer                       Am Sonnenhang 11
                                                  56242 Marienrachdorf
                                                  Germany
Mauelshagen@Sistina.com                           +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
