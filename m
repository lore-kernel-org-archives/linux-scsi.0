From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when device
 found
Date: Fri, 04 Jul 2014 14:36:28 -0400
Message-ID: <53B6F42C.7030607@interlog.com>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com> <20140703171106.GA16788@lst.de> <53B5910F.1080405@cs.wisc.edu>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47884 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaGDSgl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2014 14:36:41 -0400
In-Reply-To: <53B5910F.1080405@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, james.bottomley@parallels.com, elliott@hp.com, stephenmcameron@gmail.com, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@linux.intel.com>, James Smart <James.Smart@Emulex.Com>

On 14-07-03 01:21 PM, Mike Christie wrote:
> On 07/03/2014 12:11 PM, Christoph Hellwig wrote:
>> On Thu, Jul 03, 2014 at 10:05:57AM -0500, Stephen M. Cameron wrote:
>>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>>
>>> Don't loop through all the devices even after
>>> finding the one we're looking for
>>
>> The comments in the code seem to indicate that we want to modify
>> the queue depth for all LUNs on a given target.
>>
>> Ccing Mike and Vasu as they wrote this code.
>>
>
> Ccing James Smart for more details.
>
> We copied this behavior from lpfc's SAM_STAT_TASK_SET_FULL handling
> (look at around the 2.6.32 kernel for reference).

Perhaps there should be a knob to control this, maybe within
the scope of a host. I have one RAID controller that has a
JBOD mode in which real disks are presented as LUs in the same
target. Obviously the TSF (queue_type and other) capabilities
of those real disks might differ.

Doug Gilbert


