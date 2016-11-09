From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Wed, 9 Nov 2016 22:39:16 +0100
Message-ID: <20161109213916.GA31665@lst.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de> <20161108145802.GB12817@lst.de> <81600b31-5977-f323-6609-7fc2e0ce55b0@suse.de> <20161108150149.GB13184@lst.de> <214a7d50-672e-bc5e-1dd3-c0c5e8366911@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:58264 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751427AbcKIVjR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 16:39:17 -0500
Content-Disposition: inline
In-Reply-To: <214a7d50-672e-bc5e-1dd3-c0c5e8366911@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

On Tue, Nov 08, 2016 at 04:02:54PM +0100, Hannes Reinecke wrote:
>> I've looked at the them but haven't started work, so feel free to go
>> ahead.  The MSI-X handling in mpt3sas is pretty nasty, so be careful.
>>
>> I've also started playing with lpfc, something I'll need to send to
>> you and James for testing and feedback soon.
>>
> Bah. Another duplicate then.
> Let's see who is faster :-)

Here are the lpfc patches - note that it's in a branch that merges
the recent irq affinity changes from the tip tree into the scsi tree
first, as we need updates from both of them:

http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/lpfc-msix
