From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] get the kernel to warn about deprecated SCSI ioctls
Date: Thu, 19 Aug 2004 12:41:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4124D83E.3000201@pobox.com>
References: <1092932342.2378.430.camel@mulgrave> 	<20040819162357.GA26375@havoc.gtf.org> <1092932940.2025.463.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:4017 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266679AbUHSQlu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 12:41:50 -0400
In-Reply-To: <1092932940.2025.463.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2004-08-19 at 12:23, Jeff Garzik wrote:
> 
>>On Thu, Aug 19, 2004 at 12:19:01PM -0400, James Bottomley wrote:
>>
>>>The non unique SCSI ioctls:
>>>
>>>SCSI_IOCTL_SEND_COMMAND
>>>SCSI_IOCTL_TEST_UNIT_READY
>>>SCSI_IOCTL_BENCHMARK_COMMAND
>>>SCSI_IOCTL_SYNC
>>>SCSI_IOCTL_START_UNIT
>>>SCSI_IOCTL_STOP_UNIT
>>>
>>>Have been deprecated for a while now.  We should make the kernel
>>>complain when a program actually uses one of them, so users have had
>>>adequate warning before they are removed.
>>
>>any chance of deprecating the doorlock ioctls too?
> 
> 
> The doorlock ones are unique, and are used by some of the CD tools.
> 
> We really need to know when an app locks the door rather than having to
> scan the commands in SG_IO.


You need to scan the commands in SG_IO anyway, otherwise you do not know 
in all cases when an app locks the door :)

	Jeff


