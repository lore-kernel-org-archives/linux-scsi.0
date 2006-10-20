From: <Patrick_Boyd@Dell.com>
Subject: RE: Recurring MegaRAID SCSI Errors
Date: Fri, 20 Oct 2006 10:07:14 -0500
Message-ID: <FCD01C3AA0ADFB498F9BB1A6173DFC5DE5AB1D@ausx3mpc120.aus.amer.dell.com>
References: <890BF3111FB9484E9526987D912B261932E3FA@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:9879 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S2992641AbWJTPHQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Oct 2006 11:07:16 -0400
Content-class: urn:content-classes:message
In-Reply-To: <890BF3111FB9484E9526987D912B261932E3FA@NAMAIL3.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann.Ju@lsi.com, joshua@imrlive.com
Cc: akpm@osdl.org, linux-scsi@vger.kernel.org, jms@dev.imr-net.com, mike@opsisarch.com

You aren't lossing any data your commands are just taking a lot longer
than they should and the only variables left are your drives and your
enclosure. I would make sure that you are at firmware level E19 on the
PV220. If you still experience issue you might want to start looking at
firmware on the drives.

Patrick Boyd
Dell Storage Software Engineer
(512)728-3182


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ju, Seokmann
Sent: Friday, October 20, 2006 9:08 AM
To: Joshua Schmidlkofer
Cc: Andrew Morton; linux-scsi@vger.kernel.org; Joshua Schmidlkofer; Mike
Montagne
Subject: RE: Recurring MegaRAID SCSI Errors

On Friday, October 20, 2006 9:53 AM, Joshua Schmidlkofer wrote:
>    Thank you for your reply.  This makes me feel _much_ better. =).  
> We have verified all the firmware levels except the PowerVault 220 
> external chassis.  We have only hit this error with external devices, 
> and since we went ot the PV220 from an older chassis it has continued.

> (All new controllers, system and motherboard, but the same Debian 
> Install w/ a
> newer kernel).   We have scheduled outage this weekend to down the 
> server  and then use the diagnostic tools to check/update the firmware

> inside the PowerVault.
Hi Joshua,

If it is happening only with external chassis, you may want to check
with DELl as I don't have any valueable clue with it.

Thank you,

Seokmann

> -----Original Message-----
> From: Joshua Schmidlkofer [mailto:joshua@imrlive.com]
> Sent: Friday, October 20, 2006 9:53 AM
> To: Ju, Seokmann
> Cc: Andrew Morton; linux-scsi@vger.kernel.org; Joshua Schmidlkofer; 
> Mike Montagne
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
>    Thank you for your reply.  This makes me feel _much_ better. =).  
> We have verified all the firmware levels except the PowerVault 220 
> external chassis.  We have only hit this error with external devices, 
> and since we went ot the PV220 from an older chassis it has continued.

> (All new controllers, system and motherboard, but the same Debian 
> Install w/ a
> newer kernel).   We have scheduled outage this weekend to down the 
> server  and then use the diagnostic tools to check/update the firmware

> inside the PowerVault.
> 
>    Since we have brand-new hardware all over - do you have any other 
> recommendations about what, if anything, further could be done, if the

> firmware is confirmed up to date?
> 
> 
> Sincerely,
>   Joshua
> 
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
