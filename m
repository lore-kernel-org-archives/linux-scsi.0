From: "Ju, Seokmann" <Seokmann.Ju@lsi.com>
Subject: RE: Recurring MegaRAID SCSI Errors
Date: Fri, 20 Oct 2006 08:08:28 -0600
Message-ID: <890BF3111FB9484E9526987D912B261932E3FA@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7129 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750789AbWJTOI6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 10:08:58 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joshua Schmidlkofer <joshua@imrlive.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Joshua Schmidlkofer <jms@dev.imr-net.com>, Mike Montagne <mike@opsisarch.com>

On Friday, October 20, 2006 9:53 AM, Joshua Schmidlkofer wrote:
>    Thank you for your reply.  This makes me feel _much_ 
> better. =).  We 
> have verified all the firmware levels except the PowerVault 
> 220 external 
> chassis.  We have only hit this error with external devices, 
> and since 
> we went ot the PV220 from an older chassis it has continued. (All new 
> controllers, system and motherboard, but the same Debian Install w/ a 
> newer kernel).   We have scheduled outage this weekend to down the 
> server  and then use the diagnostic tools to check/update the 
> firmware 
> inside the PowerVault. 
Hi Joshua,

If it is happening only with external chassis, you may want to check with DELl as I don't have any valueable clue with it.

Thank you,

Seokmann

> -----Original Message-----
> From: Joshua Schmidlkofer [mailto:joshua@imrlive.com] 
> Sent: Friday, October 20, 2006 9:53 AM
> To: Ju, Seokmann
> Cc: Andrew Morton; linux-scsi@vger.kernel.org; Joshua 
> Schmidlkofer; Mike Montagne
> Subject: Re: Recurring MegaRAID SCSI Errors
> 
> Ju, Seokmann wrote:
> > Hi,
> >   
> >> [17333187.152000] megaraid: aborting-6172714 cmd=2a <c=2 t=1 l=0>
> >> [17333187.152000] megaraid abort: 6172714:124[255:129], fw owner
> >> [17333187.152000] megaraid: 15 outstanding commands. Max 
> wait 300 sec
> >> [17333187.152000] megaraid mbox: Wait for 15 commands to 
> complete:300
> >> [17333192.172000] megaraid mbox: Wait for 10 commands to 
> complete:295
> >> [17333197.192000] megaraid mbox: Wait for 3 commands to 
> complete:290
> >> [17333199.200000] megaraid mbox: reset sequence completed 
> sucessfully
> >>     
> > Above messages indicate that,
> > - there are commands (mostly WRITE(10)) pending in MegaRAID 
> F/W taking longer than given timeout period.
> > - After driver waitinf for 10 seconds, all of those 
> commands had been returned successfully.
> > - So, the driver returned back to normal operation.
> >
> > There is NO data loss/integrity error related to this 
> messages as driver returned back to normal successfully.
> > Howerver, to get rid of those messages, I would like to ask 
> you to check and upgrade F/W image on the controllers, first.
> >
> > Thank you,
> >
> > Seokmann
> >   
> Seokmann,
> 
>    Thank you for your reply.  This makes me feel _much_ 
> better. =).  We 
> have verified all the firmware levels except the PowerVault 
> 220 external 
> chassis.  We have only hit this error with external devices, 
> and since 
> we went ot the PV220 from an older chassis it has continued. (All new 
> controllers, system and motherboard, but the same Debian Install w/ a 
> newer kernel).   We have scheduled outage this weekend to down the 
> server  and then use the diagnostic tools to check/update the 
> firmware 
> inside the PowerVault.
> 
>    Since we have brand-new hardware all over - do you have any other 
> recommendations about what, if anything, further could be 
> done, if the 
> firmware is confirmed up to date?
> 
> 
> Sincerely,
>   Joshua
> 
