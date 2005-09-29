From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Thu, 29 Sep 2005 13:03:51 -0400
Message-ID: <433C1E77.3000708@pobox.com>
References: <Pine.LNX.4.10.10509281227570.19896-100000@master.linux-ide.org>	 <433B0374.4090100@adaptec.com> <20050928223542.GA12559@alpha.home.local>	 <433BFB1F.2020808@adaptec.com> <1128007032.11443.77.camel@tara.firmix.at> <433C174D.4050302@adaptec.com> <433C1CD0.9080906@pobox.com> <433C1D28.6080900@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:49644 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932269AbVI2RDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Sep 2005 13:03:55 -0400
In-Reply-To: <433C1D28.6080900@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Bernd Petrovitsch <bernd@firmix.at>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andre Hedrick <andre@linux-ide.org>, Patrick Mansfield <patmans@us.ibm.com>, Luben Tuikov <ltuikov@yahoo.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

Luben Tuikov wrote:
> On 09/29/05 12:56, Jeff Garzik wrote:
> 
>>Luben Tuikov wrote:
>>
>>
>>>On 09/29/05 11:17, Bernd Petrovitsch wrote:
>>>
>>>
>>>
>>>>Then submit your driver as a (separate) block device in parallel to the
>>>>existing SCSI subsystem. People will use it for/with other parts if it
>>>
>>>
>>>SAS is ultimately SCSI.  I'll just have to write my own SCSI core.
>>>_We_ together can do this in parallel to the old SCSI Core.
>>
>>
>>You should have stated this plainly, from the start.
>>
>>If you want to do your own SCSI layer, you need to do it at the block 
>>layer rather than poking around drivers/scsi/
> 
> 
> So now you are saying that I should _not_ poke at drivers/scsi?
> (as I haven't done)
> 
> Are you going to make up your mind?

Are you:  are you going to rewrite the SCSI core, or work to improve the 
existing one?

Your choice, not mine.  Your time, not mine.

	Jeff



