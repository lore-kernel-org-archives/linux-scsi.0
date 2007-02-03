From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: AIC7xxx on 2.6.18
Date: Fri, 02 Feb 2007 21:27:46 -0800
Message-ID: <1170480466.3387.5.camel@home-desk>
References: <20070128194620.GA6358@animx.eu.org>
	 <20070128162408.9fffb6de.akpm@osdl.org>
	 <20070203004201.GB25027@animx.eu.org>
	 <23196A89-6820-4441-B4AE-199E04B5CF96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:60305 "EHLO iron2.pdx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946347AbXBCF1x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Feb 2007 00:27:53 -0500
In-Reply-To: <23196A89-6820-4441-B4AE-199E04B5CF96@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@gmail.com>
Cc: Wakko Warner <wakko@animx.eu.org>, Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2007-02-02 at 23:12 -0600, Mark Rustad wrote:
> On Feb 2, 2007, at 6:42 PM, Wakko Warner wrote:
> 
> > Andrew Morton wrote:
> >> Yes, getting the oops traces will help, thanks.  And confirmation  
> >> on a more recent kernel would be good.
> >
> > Here's what I get.  I used netconsole so whatever was logged prior  
> > to it
> > starting was lost.
> >
> > The PC is a suprtmicro x5da8 with an onboard dual channel AHA-39320  
> > u320
> > controller.  I have a dual channel AHA-39160 u160 and a dual channel
> > AHA-2940U/UW (ch0/internal is wide/narrow, ch1/externel is narrow).
> 
> I have used an x6-class Supermicro motherboard with the Adaptec u320  
> controller and I had problems hot-swapping drives with 2.6.18. It  
> seemed that the bus reset that the backplane processor generated  
> caused trouble for the driver, killing the SCSI bus. 2.6.16 and  
> 2.6.17 locked up the kernel in the case of hot-swapping drives.
> 
> I switched to 2.6.19.2 and things are better. I did find that a card  
> dump is produced when hot-inserting a drive, so it is way noisier  
> than I think it should be, but it continues to operate and life goes  
> on, which is much better behavior than 2.6.16, 2.6.17 or 2.6.18.
> 
> > I thought it was because I had option roms turned off, but when I  
> > turned
> > them on, it still has problems.  What's odd is the fact that if I  
> > boot with init=/bin/sh, modprobe aic7xxx, it works fine and I can  
> > exec init and it works fine.
> 
> I don't know what is up with that, but based on what I have seen I  
> would recommend using 2.6.19.x instead of 2.6.18 for systems using  
> the aic79xx driver.
> 

Wasn't the original complaint in reference to the aic7xxx driver not
aic79xxx?

Sean

