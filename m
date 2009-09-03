From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: [PATCH] SCSI driver for VMware's virtual HBA.
Date: Thu, 03 Sep 2009 17:21:52 -0400
Message-ID: <4AA03370.4080905@gmail.com>
References: <1251415060.16297.58.camel@ank32.eng.vmware.com> <1251911789.23106.25.camel@ank32.eng.vmware.com> <1252008182.3941.61.camel@mulgrave.site> <200909031331.03037.dtor@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f192.google.com ([209.85.211.192]:56236 "EHLO
	mail-yw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380AbZICV1o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Sep 2009 17:27:44 -0400
In-Reply-To: <200909031331.03037.dtor@vmware.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Torokhov <dtor@vmware.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Alok Kataria <akataria@vmware.com>, Matthew Wilcox <matthew@wil.cx>, Roland Dreier <rdreier@cisco.com>, Bart Van Assche <bvanassche@acm.org>, Robert Love <robert.w.love@intel.com>, Randy Dunlap <randy.dunlap@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rolf Eike Beer <eike-kernel@sf-tec.de>, Maxime Austruy <maustruy@vmware.com>

On 09/03/2009 04:31 PM, Dmitry Torokhov wrote:
> On Thursday 03 September 2009 01:03:02 pm James Bottomley wrote:
>    
>>>> I'm not really asking you to standardise anything (yet).  I was more
>>>> probing for why you hadn't included any of the SCSI control plane
>>>> interfaces and what lead you do produce a different design from the
>>>> current patterns in virtual I/O.  I think what I'm hearing is "Because
>>>> we didn't look at how modern SCSI drivers are constructed" and "Because
>>>> we didn't look at how virtual I/O is currently done in Linux".  That's
>>>> OK (it's depressingly familiar in drivers),
>>>>          
>>> I am sorry that's not the case, the reason we have different design as I
>>> have mentioned above is because we want a generic mechanism which works
>>> for all/most of the GOS's out their and doesn't need to be specific to
>>> Linux.
>>>        
>> Slightly confused now ... you're saying you did look at the transport
>> class and virtio?  But you chose not to do a virtio like interface (for
>> reasons which I'm still not clear on) ...
>>      
> Virtio is Linux-specific and is not available on older kernels which
> our hypervisor/PVSCSI combination does support. Even if we were to use
> virtio-like schema in the hypervisor code we would have to re-implement
> much of the virtio code for kernels earlier than those shipped in '07
> and do the same for other operating systems for no apparent benefit.
> The PCI device abstraction is self-contained and works well on Windows,
> Linux and other guest operating systems and so it was chosen.
>
>    

Several arguments have a history of never winning when you try to get a 
new bit of code in linux.

Number one in the bad justifications is that your design is good because 
it avoids being "linux specific" closely followed by needing to backport :-)

ric

