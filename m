From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: I2O enhancement for Adaptec management software
Date: Fri, 23 Apr 2004 10:31:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4088D471.9000201@shadowconnect.com>
References: <40712A47.4090903@shadowconnect.com>	<1081159378.4679.1.camel@laptop.fenrus.	com>	<20040405110524.A3987@infradead.org>	<20040405101007.GA27710@devserv.de	vel.redhat.com> 	<20040405111245.A4077@infradead.org>	<1081370204.1747.5.camel@mulgrave>  <40751B18.9040403@shadowconnect.com> <1081427380.1885.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.133.118.2] ([213.133.118.2]:49283 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S264749AbUDWI2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Apr 2004 04:28:45 -0400
In-Reply-To: <1081427380.1885.4.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjanv@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

James Bottomley wrote:
>>The patch is for i2o_config, not for dpt_i2o! These are different 
>>drivers and have (from the architecture view) not much in common. 
>>dpt_i2o is a driver which let access to the disks entirely using the 
>>SCSI subsystem. The i2o subsystem uses i2o_core and i2o_block to access 
>>disks (which doesn't use SCSI at all), and also have an SCSI driver, 
>>which let access to each connected disk (i2o_scsi). But the i2o_scsi is 
>>not needed for normal disk access.
> There appears to be some confusion:  SG_IO is a *block* layer ioctl (it
> happens to be in the slightly misnamed drivers/block/scsi_ioctl.c file,
> but it is usable for all block devices).

As promised i have looked at the sg_io() function, but i think it's not 
possible to use this function, because it is for block devices, but the 
i2o_config uses a char device to communicate with the controller. I 
didn't find a function, which makes the same as sg_io, but only with 
char devices.

Any suggestions, what to do in this case?


Best regards,


Markus Lidel
------------------------------------------
Markus Lidel (Senior IT Consultant)

Shadow Connect GmbH
Carl-Reisch-Weg 12
D-86381 Krumbach
Germany

Phone:  +49 82 82/99 51-0
Fax:    +49 82 82/99 51-11

E-Mail: Markus.Lidel@shadowconnect.com
URL:    http://www.shadowconnect.com
