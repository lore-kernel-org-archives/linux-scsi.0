From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: blocked mailbox error!!
Date: Wed, 9 Jun 2004 16:20:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC736@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:62351 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S265928AbUFIUVF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2004 16:21:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Aleks Sheynkman' <aleks@Narus.com>, Pat LaVarre <p.lavarre@ieee.org>, Jens Axboe <axboe@suse.de>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

All you would need to do is to replace ".vary_io = 1" by ".can_do_varyio =1"
in megaraid2.h

-Atul Mukker

> -----Original Message-----
> From: Aleks Sheynkman [mailto:aleks@Narus.com]
> Sent: Wednesday, June 09, 2004 2:56 PM
> To: Pat LaVarre; Jens Axboe
> Cc: dougg@torque.net; linux-scsi@vger.kernel.org
> Subject: blocked mailbox error!!
> 
> 
> Hello,
>  I was wondering to ask if someone had any luck running 
> megraid 2.x drivers on RH 7.3.
>  
> Please advice ,
>  
>  Thanks!!
>  
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
