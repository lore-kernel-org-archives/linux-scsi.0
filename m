From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: use_clustering again (was Re: SCSI tape block size)
Date: Thu, 28 Sep 2006 22:41:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0609282211560.3268@poirot.grange>
References: <200609241605.32327.johna@onevista.com>
 <Pine.LNX.4.60.0609272246320.7350@poirot.grange>
 <Pine.LNX.4.64.0609282231030.6979@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43943 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750718AbWI1Ulg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Sep 2006 16:41:36 -0400
In-Reply-To: <Pine.LNX.4.64.0609282231030.6979@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

On Thu, 28 Sep 2006, Kai Makisara wrote:

> The limits come from the block subsystem that all scsi devices use 
> nowadays. It is a rather long story but can be found from linux-scsi 
> archives, e.g.,
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114147170831847&w=2

Yes, already found the 2 later threads - one on lkml and one on scsi. I 
did look at them briefly back then, but, probably, too briefly.

One of the settings - enable_clustering - seems to be pretty critical and 
can only be verified to be safe by intensive testing of various chips / 
cards. So, how about making it a run-time parameter? A module parameter is 
the easiest, but then each lld would have to do the same thing more or 
less. A sysfs attribute - but where? It is a queue attribute, but st/sg 
don't expose their queues in /sys...

Maybe under /sys/class/scsi_host?

Similar for max_sectors?

Thanks
Guennadi
---
Guennadi Liakhovetski
