From: Michael Stroucken <mxs@cmu.edu>
Subject: Re: UltraStar fails detection with "Unsupported sector size 524"
Date: Sun, 12 Sep 2010 14:08:42 -0400
Message-ID: <4C8D172A.1020100@cmu.edu>
References: <19597.3653.893156.794645@pilspetsen.it.uu.se>	<4C8D0ED2.8080005@cmu.edu> <19597.5297.146253.996923@pilspetsen.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tamade.ascient.net ([65.99.219.195]:60455 "EHLO
	tamade.ascient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab0ILSJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2010 14:09:36 -0400
In-Reply-To: <19597.5297.146253.996923@pilspetsen.it.uu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-scsi@vger.kernel.org

Mikael Pettersson wrote:
> Michael Stroucken writes:
>  > Mikael Pettersson wrote:
>  > > I got a bunch of 72G IBM UltraStars that were taken from some
>  > > kind of IBM storage server.  The Linux kernel however doesn't
>  > > like them, complaining about a non-512 byte sector size:
>  > >
>  > > According to the datasheets these drives have soft-configurable
>  > > sector sizes from 512 up to 528 bytes, but they don't say how
>  > > that configuration is done.
>  > >
>  > > Any ideas on how to reconfigure these drives for 512-byte sectors?
>  > >   
>  > 
>  > Low level format?
>
> How would I do that in Linux?  I assume it requires some
> SCSI-specific tool, or perhaps even a vendor-specific one.
>
>   
I've only done this in BSD before, but it looks like something like 
http://sg.danny.cz/sg/sg3_utils.html could be useful.

I don't know about the software configurability here, but normally you 
would first need to update the firmware to something that understands 
512b sectors, then low level format.

Greetings,
Michael.
