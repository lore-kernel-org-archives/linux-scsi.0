From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Thu, 22 Jan 2004 11:09:07 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401003B3.8050805@us.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com> <20040120180151.A18616@infradead.org> <400EE5E6.9080709@us.ibm.com> <20040122140248.C11283@infradead.org> <20040122083931.A14612@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:43415 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266306AbUAVRJd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 12:09:33 -0500
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Thu, Jan 22, 2004 at 02:02:48PM +0000, Christoph Hellwig wrote:
> 
>>On Wed, Jan 21, 2004 at 02:49:42PM -0600, Brian King wrote:
>>
>>>How about a flag in the scsi_device struct that an LLD could set in
>>>slave_configure, which would prevent upper layer drivers from binding
>>>to it?
>>
>>I'm not that happy about this.  But the other solutions I could think
>>of are ven worse.
>>
>>
>>>Then these devices could be found through the normal scsi scan
>>>and would have nice sysfs entries and sg devices for them. Not sure what
>>>we would call the flag... psuedo_device, fake_device?
>>
>>ghost? hidden?
>>
>>Could you cook up a patch?
> 
> 
> Why not just have the sd's show up? This is not much different then use of
> a volume manager. Finding the /dev/sg of the physical disk is the same
> problem as finding the sd.

We will still get errors logged when the partition table is read,
as the devices are also read protected.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

