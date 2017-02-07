From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/10] mpt3sas: full mq support
Date: Tue, 7 Feb 2017 16:40:52 +0100
Message-ID: <20170207154052.GA22384@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <20170207131909.GH19247@lst.de> <eb606203-9adf-4200-ae1c-7f518342f863@suse.de> <20170207153446.GA22228@lst.de> <6e7b8750-a355-0607-875f-751a0f9fdae8@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41260 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753840AbdBGPky (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 10:40:54 -0500
Content-Disposition: inline
In-Reply-To: <6e7b8750-a355-0607-875f-751a0f9fdae8@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com

On Tue, Feb 07, 2017 at 04:39:01PM +0100, Hannes Reinecke wrote:
> But we do; we're getting the index/tag/smid from the high-priority list,
> which is separated from the normal SCSI I/O tag space.
> (which reminds me; there's another cleanup patch to be had in
> _ctl_do_mpt_command(), but that's beside the point).

The calls to blk_mq_tagset_busy_iter added in patch 8 indicate the
contrary.
