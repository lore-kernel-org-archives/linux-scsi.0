From: Willem Riede <wrlk@riede.org>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Thu, 10 Jun 2004 22:08:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040611020807.GA28060@serve.riede.org>
References: <1086710016.3647.4.camel@patibmrh9> <40C8FB79.1050706@torque.net>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rwcrmhc11.comcast.net ([204.127.198.35]:6643 "EHLO
	rwcrmhc11.comcast.net") by vger.kernel.org with ESMTP
	id S263585AbUFKCIL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jun 2004 22:08:11 -0400
Received: from serve.riede.org (localhost.localdomain [127.0.0.1])
	by serve.riede.org (8.12.11/8.12.10) with ESMTP id i5B2871o029660
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jun 2004 22:08:10 -0400
Content-Disposition: inline
In-Reply-To: <40C8FB79.1050706@torque.net> (from dougg@torque.net on Thu, Jun 10, 2004 at 20:23:21 -0400)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 2004.06.10 20:23, Douglas Gilbert wrote:
> Pat LaVarre wrote:
> > SCSI pass thru in 2.6 omits ide-floppy, except if we do resort to the
> > ide-scsi deprecated there?
> 
> Pat,
> In lk 2.6 the ide-scsi driver is "deprecated" for cd/dvd device types
> but not other device types that use the ATAPI protocol. The ide-scsi
> driver is in the same group as the usb-storage and sbp2 drivers which
> bridge between the SCSI stack and other subsystem stacks. The
> ongoing problems we have with this group of drivers is as much to
> do with their technical complexity (spanning two different driver
> architectures) as it is to do with the politics of kernel
> development.
> 
> Anyway ide-scsi probably needs some repair work in lk 2.6. Both
> Willem Riede and I have tried. IMO the ide-scsi driver looks ok
> from the scsi subsystem side ....

And actually it works very well for me currently. (That's not to say
there couldn't still be issues with other hardware). If you have 
specific problems I'll be happy to try and help.

Regards, Willem Riede.
