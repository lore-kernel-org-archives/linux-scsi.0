From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] fix up request buffer reference in various scsi drivers
Date: Thu, 08 Jun 2006 10:44:34 -0400
Message-ID: <448837D2.8060601@garzik.org>
References: <20060603112113.GA17018@lst.de>  <44880BEA.90707@garzik.org>	 <1149771978.3436.4.camel@mulgrave.il.steeleye.com>	 <44882592.5090701@garzik.org>	 <1149774847.3436.11.camel@mulgrave.il.steeleye.com>	 <4488315D.9040001@garzik.org> <1149777346.3436.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:62155 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S964848AbWFHOoj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 10:44:39 -0400
In-Reply-To: <1149777346.3436.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@SteelEye.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2006-06-08 at 10:17 -0400, Jeff Garzik wrote:
>> If the submittor is under the impression that libata's error handling
>> is 
>> "very broken", I would appreciate a clarification.  Otherwise, one
>> must 
>> assume that the submittor should have CC'd linux-ide and relevant 
>> maintainers, because they do not understand the code they are
>> patching.
>>
>> What _precisely_ is broken, given that libata does all its own error 
>> handling, and ignores scsi_unjam_host() ?
> 
> The problem being fixed is that the two fields in question are
> exclusively for the use of the error handler.  No driver should ever
> touch them ... there are equivalent fields for the drivers to use which
> contain the correct values, which is what this patch is switching to.  I
> don't believe any criticism of the libata error handler was implied or
> intended ... the problem is the driver piece of libata uses fields it
> shouldn't, which the patch fixes.

ACK, with the added explanation of why this is needed.

Thanks,

	Jeff



