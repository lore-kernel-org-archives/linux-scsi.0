From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg interface
Date: Thu, 11 Sep 2008 20:23:40 -0700
Message-ID: <D2F2E608-6C11-4F94-8051-34E2DCFC51F6@qlogic.com>
References: <0C1F2063-A090-4E57-AAFC-C74B32B43BD5@qlogic.com> <20080911093234.GA4762@schmichrtp.de.ibm.com>
Mime-Version: 1.0 (Apple Message framework v928.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:1872 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbYILDXo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2008 23:23:44 -0400
In-Reply-To: <20080911093234.GA4762@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James.Smart@Emulex.Com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Robert W Love <robert.w.love@intel.com>, Sven Schuetz <sven@linux.vnet.ibm.com>


On Sep 11, 2008, at 2:32 AM, Christof Schmitt wrote:

> On Wed, Sep 10, 2008 at 07:04:01AM -0700, Seokmann Ju wrote:
>
> [...]
>> +struct fc_frame_header {
>> [...]
>> +	u32 ct_cmd[1];
>> +};
>
> I was just reading he patch and i am wondering why the fc_frame_header
> is included here. There was a discussion in August and the conclusion
> was to only include the common ct_hdr in the LLD interface:
>
> http://marc.info/?t=121908849700001&r=1&w=2
>
> The zfcp driver does not care about the FC headers, this is hidden in
> the System z FCP HBA. I would prefer that the interface to the LLD
> does not include the frame_header, otherwise userspace would fill the
> frame_header and zfcp would simply discard it.
Thanks for the pointing out.
I will submit the updated patch, soon.

Seokmann
