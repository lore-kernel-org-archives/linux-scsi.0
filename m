From: Lee Revell <rlrevell@joe-job.com>
Subject: Re: aic79xx -> can't  suspend
Date: Thu, 23 Jun 2005 16:22:24 -0400
Message-ID: <1119558145.1609.3.camel@mindpipe>
References: <1119549104.13259.1.camel@mindpipe>
	 <20050623193224.GD2251@voodoo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mustang.oldcity.dca.net ([216.158.38.3]:30946 "HELO
	mustang.oldcity.dca.net") by vger.kernel.org with SMTP
	id S263060AbVFWUW0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jun 2005 16:22:26 -0400
In-Reply-To: <20050623193224.GD2251@voodoo>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jim Crilly <jim@why.dont.jablowme.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Thu, 2005-06-23 at 15:32 -0400, Jim Crilly wrote: 
> On 06/23/05 01:51:43PM -0400, Lee Revell wrote:
> > I have a machine with an Adaptec 2940U2W adapter running 2.6.11.  When I
> > try to go into standby like so:
> > 
> >     echo standby > /sys/power/state
> > 
> > this is what happens:
> 
> AFAIK no SCSI drivers have had power management functions implemented, a
> quick grep for PM_ in drivers/scsi seems to confirm that only the PCMCIA
> SCSI drivers even look for PM events.

Hmm, actually, this is still pretty bad.  Shouldn't the suspend fail
with "power management not implemented for device aic9xxx?" rather than
crashing and burning?

Also, who is the aic9xxx maintainer?  I could not find any reference to
it at all in MAINTAINERS.

Finally, is there an authoritative, up to date driver developers guide
for the SCSI subsystem, like the one for ALSA?

TIA,

Lee





