From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: can't write to tape
Date: Sat, 8 Jan 2005 22:42:16 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0501082235080.5132@poirot.grange>
References: <200501060518.25782.andrex@alumni.utexas.net>
 <Pine.LNX.4.60.0501062138580.7568@poirot.grange> <200501070552.57607.andrex@alumni.utexas.net>
 <Pine.LNX.4.60.0501072057500.6238@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:61375 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261818AbVAHVmz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jan 2005 16:42:55 -0500
In-Reply-To: <Pine.LNX.4.60.0501072057500.6238@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Schulman <andrex@alumni.utexas.net>
Cc: linux-scsi@vger.kernel.org, Jamie Lenehan <lenehan@twibble.org>

On Fri, 7 Jan 2005, Guennadi Liakhovetski wrote:

> On Fri, 7 Jan 2005, Andrew Schulman wrote:
> 
> > > > Jan  5 22:50:18 helium kernel: dc395x: sg_update_list: sg_to_virt failed

> > > > Jan  5 22:50:18 helium kernel: st0: Error with sense data: Info fld=0x67,
> > > > Current st0: sense = f0  4
> > >
> > > Sense key 4 - hardware error.
> > >
> > > > Jan  5 22:50:18 helium kernel: ASC=80 ASCQ=98
> > >
> > > Additional sense code 0x80 - vendor specific.

Ok. My interpretation of the errors you see is 1) the dc395x driver is 
buggy for highmem, and 2) your tape drive has a problem. For the first 
problem I _could_ try to fix it, however, this will take some time. Unless 
somebody more skilled does it faster and better than I, I will start 
slowly fixing it, but it will take some time. And, although I do have a 
dc-315 adapter, I don't have highmem (would just booting with highmem=64M 
allow me to test it? Oh, I can check it - will just try it and see if I 
now get the same error messages), so, would be good if you, Andrew, could 
test my results, when I am ready (could be a couple of months:-))? I'll 
mail you then.

Thanks
Guennadi
---
Guennadi Liakhovetski

