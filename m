From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc : add module parameter that allows	adapter	instances
 to avoid attachment
Date: Fri, 27 Mar 2009 08:46:09 -0400
Message-ID: <49CCCA91.6020600@emulex.com>
References: <1238097300.27023.2.camel@ogier>	 <1238098747.3342.54.camel@localhost.localdomain>	 <49CBE772.80304@emulex.com> <1238100849.3342.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:34694 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbZC0MqQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2009 08:46:16 -0400
In-Reply-To: <1238100849.3342.58.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Ok - I'll see what I can come up with.

-- james s

James Bottomley wrote:
> On Thu, 2009-03-26 at 16:37 -0400, James Smart wrote:
>> The oem requirement we have explicitly states not to use the unbind interface
>> (we proposed unbind at first as well).
>>
>> The issue is what happens on the link while we are bound for that short
>> amount of time. It confuses the things on the other side of the link.
>> There's a secondary driver that ends up binding to the adapters we exclude,
>> and the things on the other side only expected to see the second driver.
> 
> OK, so it sounds like a proposed extension to the generic unbind
> interfaces where you specify a no_bind list on the kernel or module
> command line.
> 
> Also (as Randy pointed out) you don't account for the domain.  However,
> you could just by not bothering to convert the string to numbers for the
> compare, just compare on dev->bus_id ... which is how a generic one
> would work.
> 
> James
> 
> 
> 
