From: "Aleks Sheynkman" <aleks@Narus.com>
Subject: RE: blocked mailbox error!!
Date: Wed, 9 Jun 2004 13:36:55 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <FA6D803197D0E14C88E1B74C5A021B8202E7D2@snitch.narus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.narus.com ([66.236.101.211]:6378 "EHLO mx2.narus.com")
	by vger.kernel.org with ESMTP id S265946AbUFIUhA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2004 16:37:00 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Aleks Sheynkman <aleks@Narus.com>, "Mukker, Atul" <Atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

Thanks a lot!!! I think I also have to rebuild scsi_mod module .



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Aleks Sheynkman
> Sent: Wednesday, June 09, 2004 1:22 PM
> To: Mukker, Atul
> Cc: linux-scsi@vger.kernel.org
> Subject: RE: blocked mailbox error!!
> 
> 
> I'm sorry to ask which version of megaraid driver?
> 
> Thanks a lot in advance !
> 
> -Aleks
> 
> > -----Original Message-----
> > From: Mukker, Atul [mailto:Atulm@lsil.com]
> > Sent: Wednesday, June 09, 2004 1:21 PM
> > To: Aleks Sheynkman; Pat LaVarre; Jens Axboe
> > Cc: dougg@torque.net; linux-scsi@vger.kernel.org
> > Subject: RE: blocked mailbox error!!
> > 
> > 
> > All you would need to do is to replace ".vary_io = 1" by 
> > ".can_do_varyio =1"
> > in megaraid2.h
> > 
> > -Atul Mukker
> > 
> > > -----Original Message-----
> > > From: Aleks Sheynkman [mailto:aleks@Narus.com]
> > > Sent: Wednesday, June 09, 2004 2:56 PM
> > > To: Pat LaVarre; Jens Axboe
> > > Cc: dougg@torque.net; linux-scsi@vger.kernel.org
> > > Subject: blocked mailbox error!!
> > > 
> > > 
> > > Hello,
> > >  I was wondering to ask if someone had any luck running 
> > > megraid 2.x drivers on RH 7.3.
> > >  
> > > Please advice ,
> > >  
> > >  Thanks!!
> > >  
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe 
> > > linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
