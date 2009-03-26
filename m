From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] lpfc : add module parameter that allows adapter	instances
 to avoid attachment
Date: Thu, 26 Mar 2009 13:41:15 -0700
Message-ID: <49CBE86B.4050701@oracle.com>
References: <1238097300.27023.2.camel@ogier> <1238098747.3342.54.camel@localhost.localdomain> <49CBE772.80304@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:60665 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbZCZUlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 16:41:51 -0400
In-Reply-To: <49CBE772.80304@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Smart wrote:
> The oem requirement we have explicitly states not to use the unbind
> interface
> (we proposed unbind at first as well).
> 
> The issue is what happens on the link while we are bound for that short
> amount of time. It confuses the things on the other side of the link.
> There's a secondary driver that ends up binding to the adapters we exclude,
> and the things on the other side only expected to see the second driver.
> 
> -- james s
> 
> 
> James Bottomley wrote:
>> On Thu, 2009-03-26 at 15:55 -0400, James Smart wrote:
>>> This patch adds a module parameter that supplies a text string
>>> containing a
>>> list of PCI <bus>:<slot>.<func> values to identify adapter instances
>>> that
>>> should *not* be attached to by the driver.

What does this do on systems that use PCI domains?

  domain:bus:slot.func  (??)


>>> -- james s
>>>
>>>
>>>  Signed-off-by: James Smart <james.smart@emulex.com>
>>
>> Is there a reason why you can't just use the generic unbind interface?
>>
>> James


-- 
~Randy
