From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc : add module parameter that allows adapter	instances
 to avoid attachment
Date: Thu, 26 Mar 2009 16:37:06 -0400
Message-ID: <49CBE772.80304@emulex.com>
References: <1238097300.27023.2.camel@ogier> <1238098747.3342.54.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63927 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZCZUhN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2009 16:37:13 -0400
In-Reply-To: <1238098747.3342.54.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The oem requirement we have explicitly states not to use the unbind interface
(we proposed unbind at first as well).

The issue is what happens on the link while we are bound for that short
amount of time. It confuses the things on the other side of the link.
There's a secondary driver that ends up binding to the adapters we exclude,
and the things on the other side only expected to see the second driver.

-- james s


James Bottomley wrote:
> On Thu, 2009-03-26 at 15:55 -0400, James Smart wrote:
>> This patch adds a module parameter that supplies a text string containing a
>> list of PCI <bus>:<slot>.<func> values to identify adapter instances that
>> should *not* be attached to by the driver.
>>
>> -- james s
>>
>>
>>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
> Is there a reason why you can't just use the generic unbind interface?
> 
> James
> 
> 
> 
