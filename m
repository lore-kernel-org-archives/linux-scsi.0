From: Brian King <brking@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 05 Dec 2003 11:03:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FD0BA64.5080807@us.ibm.com>
References: <200310231734.10263.krmurthy@cisco.com>	<200312011740.09693.krmurthy@cisco.com> <1070292174.2007.14.camel@mulgrave>	<200312041800.55663.krmurthy@cisco.com> <1070594036.1603.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:60803 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S264245AbTLEREV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 12:04:21 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "N.C.Krishna Murthy" <krmurthy@cisco.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

James Bottomley wrote:
>>If the generic infrastructure which you mentioned does not exist now and in 
>>case there is a plan to do one such thing is there any framework for that?
>>Wouldn't that require a kernel API which is capable of both 
>>"adding new luns" and "deleting luns which no longer exist"?
> 
> 
> Well, a hotplug event feeds certain information into the environment
> when it triggers the call.  All we really need is a wrapper in SCSI to
> add the SCSI information to the environment and trigger the event in a
> generic fashion.
> 


This would be wonderful. I am currently writing a LLD and was going to 
use the scsi_add_device and scsi_remove_device interfaces to add/remove 
devices as the devices show up and disappear at runtime, but this was 
going to require me to go through a bit of complexity using a workqueue 
to do it at task level. If a LLD had interfaces to do this that could be 
called at interrupt context these interfaces would be much easier to use.



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

