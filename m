From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [ANNOUNCE] iSCSI enterprise target software
Date: Tue, 01 Mar 2005 14:01:43 -0500
Message-ID: <4224BC17.7000103@pobox.com>
References: <OF00F39C19.AE2C12A8-ON88256FB7.00641755-88256FB7.0065149B@us.ibm.com>	 <1109702227.6293.137.camel@laptopd505.fenrus.org> <1109702911.2878.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3011 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261700AbVCATCE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2005 14:02:04 -0500
In-Reply-To: <1109702911.2878.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Arjan van de Ven <arjan@infradead.org>, Bryan Henderson <hbryan@us.ibm.com>, Tomonori Fujita <fujita.tomonori@lab.ntt.co.jp>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, linux-scsi <linux-scsi@vger.kernel.org>

Ming Zhang wrote:
> On Tue, 2005-03-01 at 13:37, Arjan van de Ven wrote:
> 
>>On Tue, 2005-03-01 at 10:24 -0800, Bryan Henderson wrote:
>>
>>>One thing that's implicit in your reasons for wanting to be in the kernel 
>>>is that you've chosen to exploit the kernel's page cache.  As a user of 
>>>the page cache, you have more control from inside the kernel than from 
>>>user space.  The page cache was designed to be fundamentally invisible to 
>>>user space.
>>>
>>>A pure user space implementation of an ISCSI target would use process 
>>>virtual memory for a cache and manage it itself.  It would access the 
>>>storage with direct I/O. 
>>
>>why would it use direct I/O ? Direct I/O would be really stupid for such
>>a thing to use since that means there's no caching going on *at all*.
>>
> 
> what Bryan suggest is a privately owned and managed user space cache. so
> for that disk write should be real write-through.
> 
> it is hard to beat linux kernel cache performance though.

A privately managed user space cache uses Linux kernel cache.

As does mmap/sendfile...

	Jeff



