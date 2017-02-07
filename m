From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 07/10] mpt3sas: use hi-priority queue for TMFs
Date: Tue, 7 Feb 2017 14:19:06 +0100
Message-ID: <20170207131906.GG19247@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-8-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40601 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754710AbdBGNTM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 08:19:12 -0500
Content-Disposition: inline
In-Reply-To: <1485854760-122683-8-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.com>

On Tue, Jan 31, 2017 at 10:25:57AM +0100, Hannes Reinecke wrote:
> When sending a TMF via the ioctl interface we should be using
> the hi-priority queue instead of the scsi queue to be consistent
> with overall TMF usage.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
