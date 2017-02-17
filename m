From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 11/11] mpt3sas: register reserved commands
Date: Fri, 17 Feb 2017 14:23:58 +0100
Message-ID: <20170217132358.GA24574@lst.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de> <1487319790-97340-12-git-send-email-hare@suse.de> <20170217123859.GB23739@lst.de> <27251371-a96e-11c9-a1ce-cfb2b53f5454@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42664 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933545AbdBQNYA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 08:24:00 -0500
Content-Disposition: inline
In-Reply-To: <27251371-a96e-11c9-a1ce-cfb2b53f5454@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org

On Fri, Feb 17, 2017 at 02:18:42PM +0100, Hannes Reinecke wrote:
> Well, once I'm switching over to embedded commands I'll have to
> integrate with SCSI midlayer to actually _allocate_ the tracker
> structure for me.
> At the same time the midlayer should _not_ use that structure for normal
> I/O; which sounds suspiciously like reserved commands to me ...

Let's defer the issue until that code is actually introduced.  I think
having reserved tag support even for !mq will be useful for the transition
period, so I'm not against it.  But as far as this series is concerned
it's not actually needed, or to be more blunt incorrectly used.
