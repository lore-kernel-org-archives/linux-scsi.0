From: "Kai OM" <epimetreus@fastmail.fm>
Subject: Re: Sym53c8xx_2
Date: Fri, 13 Aug 2004 17:24:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092432298.18813.202307545@webmail.messagingengine.com>
References: <1092366037.28144.202254467@webmail.messagingengine.com>
   <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from frontend1.messagingengine.com ([66.111.4.30]:25823 "EHLO
	frontend1.messagingengine.com") by vger.kernel.org with ESMTP
	id S267503AbUHMVZA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Aug 2004 17:25:00 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org




----- Original message -----
From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
To: "Kai OM" <epimetreus@fastmail.fm>
Date: Fri, 13 Aug 2004 21:40:28 +0200 (CEST)
Subject: Re: Sym53c8xx_2

Hi

On Thu, 12 Aug 2004, Kai OM wrote:

> A while back I mailed the list a few times about an issue I was having
> with the Sym53c8xx_2 driver in the 2.6.7-8 kernels, as well as mailing
> the driver maintainer listed in the kernel source.

Disclaimer: I don't think I am the best person to try to solve this 
problem, I'll just try to help you collect some more information...
well, 
will see.

The first thing I would do is try the latest 2.6.8-preX, or, better yet, 
-mmY kernel. If that still doesn't work, try to narrow down the problem
in 
the sequence of changes between 2.6.5 and 2.6.6. It should be possible 
somehow. Are you using BitKeeper?

<<
Negative on that, normally I just download the source from kernel.org.
There was one entry in the 2.6.6 changelog, though, that said something
about modifying the driver in question; adding generic domain validation
and such -- and it's during domain validation that the driver stops.


Other things to do are turn scsi-logging on with something like 
scsi_mod.scsi_logging_level=511 debug
on your kernel command line. But, it would be useless without a serial 
console. Do you really have no chance to configure one? You would also 
need to enable scsi-logging in your kernel SCSI configuration. There are 
also some debug flags in sym53c8xx_2 driver too. Don't think things like 
pci=noacpi would help you...

<<
In the drivers that don't work, I never even get a chance to mount the
root FS. I'll e-mail some logs of what happens, copied by hand, but I do
not have access to a serial console.

Regards
Guennadi
---
Guennadi Liakhovetski

