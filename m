From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] allow a transport to pre-initialize starget_data
Date: Mon, 15 Aug 2005 12:40:10 -0400
Message-ID: <4300C56A.10702@adaptec.com>
References: <20050815134210.GA19426@lst.de>  <4300B232.9000308@adaptec.com>	 <1124119431.5089.9.camel@mulgrave>  <4300B7C4.8060400@adaptec.com>	 <1124121234.5089.14.camel@mulgrave>  <4300BE8D.4070002@adaptec.com> <1124123533.5089.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:54505 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964833AbVHOQkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 12:40:15 -0400
In-Reply-To: <1124123533.5089.24.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 08/15/05 12:32, James Bottomley wrote:
>>What will SCSI Core do with the RAID members?  Why is SCSI Core
>>concerned with this information?  What kind of parameters will
>>it have to set, without the RAID device server knowing about it
>>(which is implemented on the chip if HW RAID)?
> 
> 
> Nothing except expose them ... that's the idea.  The parameters are set
> from user level after that.  This elimiates need for the pass through
> ioctl that all of these drivers have.

Ah, ok.  It is this ioctl thing.  Really it never crossed my mind.

Thanks,
	Luben
