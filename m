From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/5] osduld: Use device->release instead of internal kref
Date: Thu, 29 Oct 2009 20:10:24 +0200
Message-ID: <4AE9DA90.4040100@panasas.com>
References: <4AE5D374.80400@panasas.com>	 <1256576294-10430-1-git-send-email-bharrosh@panasas.com>	 <1256836303.7191.21.camel@mulgrave.site>  <4AE9CFC6.2080404@panasas.com>	 <1256838073.7191.24.camel@mulgrave.site>  <4AE9D5EB.7080202@panasas.com> <1256839386.7191.31.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:3816 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752550AbZJ2SKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2009 14:10:22 -0400
In-Reply-To: <1256839386.7191.31.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 10/29/2009 08:03 PM, James Bottomley wrote:
> On Thu, 2009-10-29 at 19:50 +0200, Boaz Harrosh wrote:
>> Some thing like below. 
>>
>> There is to much knolage of device in my opinion. To much fidling
>> of private device members. What when some new members are added?
> 
> What private device members ... the pieces you fill in are the public
> ones.  If you want a macro to do that, I'm sure Greg would be
> amenable ...
> 
>> I hate it.
> 
> Because you have to type six more lines of code?  To me it looks cleaner
> because there's only a single allocation instead of two and now no need
> of chaining destructors because everything goes together thus making the
> lifetime rules more obvious and robust.
> 
> It also saves memory because it has two fewer pointers.
> 
> James
> 

OK I'll roll up a patch that introduces a device_init helper
and a patch for Greg that exchanges my helper with an export.

But I will have to test it so only next week.

Thanks for the review. Is that the only thing?

Boaz
