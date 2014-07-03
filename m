From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: break from queue depth adjusting loops when device
 found
Date: Thu, 03 Jul 2014 12:21:19 -0500
Message-ID: <53B5910F.1080405@cs.wisc.edu>
References: <20140703150557.21608.37072.stgit@beardog.cce.hp.com> <20140703171106.GA16788@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:56106 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbaGCRZC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2014 13:25:02 -0400
In-Reply-To: <20140703171106.GA16788@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, james.bottomley@parallels.com, elliott@hp.com, stephenmcameron@gmail.com, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@linux.intel.com>, James Smart <James.Smart@Emulex.Com>

On 07/03/2014 12:11 PM, Christoph Hellwig wrote:
> On Thu, Jul 03, 2014 at 10:05:57AM -0500, Stephen M. Cameron wrote:
>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>
>> Don't loop through all the devices even after
>> finding the one we're looking for
> 
> The comments in the code seem to indicate that we want to modify
> the queue depth for all LUNs on a given target.
> 
> Ccing Mike and Vasu as they wrote this code.
> 

Ccing James Smart for more details.

We copied this behavior from lpfc's SAM_STAT_TASK_SET_FULL handling
(look at around the 2.6.32 kernel for reference).
