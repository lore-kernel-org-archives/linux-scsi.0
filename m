From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: blocked mailbox error!!
Date: Wed, 9 Jun 2004 16:23:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC737@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:23696 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S265939AbUFIUXs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2004 16:23:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Aleks Sheynkman' <aleks@Narus.com>, "Mukker, Atul" <Atulm@lsil.com>
Cc: linux-scsi@vger.kernel.org

The latest public driver is 2.10.6 and should be available on mailing list
achieve.

-Atul Mukker

> -----Original Message-----
> From: Aleks Sheynkman [mailto:aleks@Narus.com]
> Sent: Wednesday, June 09, 2004 4:22 PM
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
> 
