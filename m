From: Doug Ledford <dledford@redhat.com>
Subject: Re: What's the state of sdev->tagged_queue
Date: Fri, 06 Jun 2003 10:28:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EE0A4FF.2020106@redhat.com>
References: <20030606074813.GA18748@lst.de> <3EE09F82.2060000@redhat.com> <20030606141933.GA23096@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.200]:42943 "EHLO
	lacrosse.corp.redhat.com") by vger.kernel.org with ESMTP
	id S261564AbTFFOP1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2003 10:15:27 -0400
In-Reply-To: <20030606141933.GA23096@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:

> simple_tags == 1?  in my source it's a bitfield.

Duh, told you I was out of touch.  I wrote that and I forgot what it was :-)


>>Currently, we use the value of host->this_id to skip the scsi device of 
>>the host controller in our device scan.  What I would like to do is 
>>create an sg device entry for this_id that is type processor,
> 
> 
> We already have scsi_get_host_dev to get such a device if the LLDD
> wants it.  Generalizing it sounds like a good idea.  But before
> that we need a 64bit dev_t so we can have sg devices for the
> ever-growing number of scsi_devices :)
> 
> 
>>is a fake 
>>device, that implements whatever ioctls at the mid layer level that are 
>>appropriate, but that also allow the low level driver to register a fall 
>>through host ioctl routine that can be attached to this device.
> 
> 
> I don't think we should another ioctl routine.  Just use the normal
> ioctl routine in the host template and let the LLDD check for
> host->this_id.

More out-of-touchness...

-- 
   Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
            Red Hat, Inc.
            1801 Varsity Dr.
            Raleigh, NC 27606


