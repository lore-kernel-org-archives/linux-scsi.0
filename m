From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Sym53c8xx_2
Date: Fri, 13 Aug 2004 21:40:28 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0408132049060.4069@poirot.grange>
References: <1092366037.28144.202254467@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43471 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267411AbUHMUI6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Aug 2004 16:08:58 -0400
In-Reply-To: <1092366037.28144.202254467@webmail.messagingengine.com>
List-Id: linux-scsi@vger.kernel.org
To: Kai OM <epimetreus@fastmail.fm>
Cc: linux-scsi@vger.kernel.org

Hi

On Thu, 12 Aug 2004, Kai OM wrote:

> A while back I mailed the list a few times about an issue I was having
> with the Sym53c8xx_2 driver in the 2.6.7-8 kernels, as well as mailing
> the driver maintainer listed in the kernel source.

Disclaimer: I don't think I am the best person to try to solve this 
problem, I'll just try to help you collect some more information... well, 
will see.

The first thing I would do is try the latest 2.6.8-preX, or, better yet, 
-mmY kernel. If that still doesn't work, try to narrow down the problem in 
the sequence of changes between 2.6.5 and 2.6.6. It should be possible 
somehow. Are you using BitKeeper?

Other things to do are turn scsi-logging on with something like 
scsi_mod.scsi_logging_level=511 debug
on your kernel command line. But, it would be useless without a serial 
console. Do you really have no chance to configure one? You would also 
need to enable scsi-logging in your kernel SCSI configuration. There are 
also some debug flags in sym53c8xx_2 driver too. Don't think things like 
pci=noacpi would help you...

Regards
Guennadi
---
Guennadi Liakhovetski

