From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/3] add fc transport events
Date: Thu, 27 May 2004 15:12:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B667B1.2040805@cs.wisc.edu>
References: <OFA5D56AC9.541248A2-ONC1256EA1.006DA3A1@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37640 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S265494AbUE0WMG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 May 2004 18:12:06 -0400
In-Reply-To: <OFA5D56AC9.541248A2-ONC1256EA1.006DA3A1@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Martin Peschke3 wrote:
> 
> 
> 
>>03-convert-fc-class.patch - converts the fc class from a class_device
>>scsi_device to a kobject and adds a basic link_up/down event fucntion.
>>
>>(I did not convert the spi class yet, becuase I wasn't sure how people
>>would feel about such a change)
> 
> 
> Looks promising as to FC. We can add these calls in the zfcp lldd
> provided the patch makes it into the kernel. Then, what would be still
> missing are the required hotplug scripts, I guess.

There are still some other large outstanding issues. For example the
kobject_hotplug function must be called from a process context. I was not
sure if the transport class should provide this, or is it the drivers
responsibilty (some drivers have threads for work already),
or should SCSI ML supply this as it may have to if it is going
to provide events too.

> Martin
> 


