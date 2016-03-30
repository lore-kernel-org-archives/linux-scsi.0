From: jthumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 0/2] Update SCSI target removal path
Date: Wed, 30 Mar 2016 13:01:23 +0200
Message-ID: <da1b6206f0fba95e252e952a3afa07a6@suse.de>
References: <cover.1459249252.git.jthumshirn@suse.de>
 <1459261538.30035.12.camel@localhost.localdomain>
 <yq1twjorday.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbcC3LBZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 07:01:25 -0400
In-Reply-To: <yq1twjorday.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

[+Cc linux-scsi back]
On 2016-03-30 02:59, Martin K. Petersen wrote:
>>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:
> 
> Ewan> I would probably use an APCON or other physical layer switch to
> Ewan> drop the FC link and test the error recovery/device loss.  But we
> Ewan> don't have one.
> 
> They go for a couple of hundred bucks on eBay. I had one of these in a
> previous life and it was awesome.

Though this would work (like any other FC/FCoE switch) I thought more of 
a simulated environment. scsi_debug, Qemu, something like that.

I've had a look at scsi_debug but it seems like it's quite some 
refactoring needed to get it to a point where one can simulate target 
errors. I kinda like the idea of having something in 
tools/testing/selftest but it'll probably end up with a FC switch.

Johannes
