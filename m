From: "Aleks Sheynkman" <aleks@Narus.com>
Subject: RE: quitestion about megraid-2.10.3
Date: Fri, 11 Jun 2004 11:16:52 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FA6D803197D0E14C88E1B74C5A021B822DDD6D@snitch.narus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.narus.com ([66.236.101.211]:41353 "EHLO mx2.narus.com")
	by vger.kernel.org with ESMTP id S264307AbUFKSRC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 14:17:02 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Atulm@lsil.com, Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-scsi@vger.kernel.org, mailman-owner@us.dell.com

Sorry for asking , can someone please advice me which version megaraid driver from 2.x is more stable ?
is it 2.10.3 or other ?

Thanks you !!!

-Aleks

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Aleks Sheynkman
> Sent: Friday, June 11, 2004 11:08 AM
> To: Matt Domsch
> Cc: linux-scsi@vger.kernel.org; mailman-owner@us.dell.com
> Subject: RE: quite ion about megraid-2.10.3
> 
> 
> Wheee.... It working sorry for disturbance, and thank you for 
> your help.
> Problem was in host_lock vs. io_request_lock.
> 
> Thanks again !!!
> 
> -Aleks
> 
> 
> > -----Original Message-----
> > From: Aleks Sheynkman 
> > Sent: Friday, June 11, 2004 10:28 AM
> > To: 'Matt Domsch'
> > Cc: linux-scsi@vger.kernel.org; mailman-owner@us.dell.com
> > Subject: quite ion about megraid-2.10.3
> > 
> > 
> > Hi Matt,
> >   I have a 6650 that running RH 7.3 2.4.18-17.7xbigmem kernel 
> > with 1.8f version of megraid driver, I am trying to upgrade 
> > it to megraid-2.10.3. As Atul suggested I change it 
> > .can_do_varyio =1 and also my kernel was not patch so I had 
> > to change host_lock to use io_request_lock in adapter 
> > unitization. So I compile the driver and create a new initrd 
> > image ,every time my system boot up I see following , drivers 
> > seems to load find I see first message which was produced by 
> > mega_find_card() routine
> > 
> >  scsi0:SI Logic MegaRAID 1.72.25 commands 16 targs 5 chans 7 luns
> > 
> >  then I see second message
> > 
> >  scsi1LSI Logic MegaRAID 1.72.25 commands 16 targs 5 chans 7luns, 
> > 
> > and it hangs after that. One interpreting thing is 
> > that it kind of sitting and waiting for something , because I 
> > can input from keyboard. Also If I press  Cntrl -Alt -Delete 
> > it start a shutdown process, it trying to 
> > flush a raid cache etc.
> > 
> > Did anyone ever see or experience this problem before.
> > 
> > Thanks a lot for you help !!!
> > 
> > -Aleks
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
