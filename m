From: Markus Lidel <Markus.Lidel@shadowconnect.com>
Subject: Re: I2O enhancement for Adaptec management software
Date: Thu, 08 Apr 2004 15:14:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40755051.8030201@shadowconnect.com>
References: <40712A47.4090903@shadowconnect.com>	<1081159378.4679.1.camel@laptop.fenrus.	com>	<20040405110524.A3987@infradead.org>	<20040405101007.GA27710@devserv.de	vel.redhat.com> 	<20040405111245.A4077@infradead.org>	<1081370204.1747.5.camel@mulgrave>  <40751B18.9040403@shadowconnect.com> <1081427380.1885.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.133.118.2] ([213.133.118.2]:44178 "EHLO
	mail.shadowconnect.com") by vger.kernel.org with ESMTP
	id S261744AbUDHNNQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 09:13:16 -0400
In-Reply-To: <1081427380.1885.4.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arjan van de Ven <arjanv@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hello,

>>Than i have to move the patch to the i2o_scsi driver, because the 
>>i2o_scsi uses the SCSI subsystem already. But IMHO the i2o_config driver 
>>is better suited, cause the patch is only needed for the management 
>>software. One last question, could i use the SG list building function 
>>without using the SCSI layer?
> Yes.  All sg functions are in block.  Without the SCSI framework, you
> lose the mid-layer managing sglist allocation, so you'd have to do that
> yourself, but every other non-scsi block driver also has that problem.

Okay, sounds reasonable. I'll look at it. Maybe than dpt_i2o can benefit 
too ;-)

Thanks very much for the great hint!



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
