From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_dh: only attach to SCSI devices
Date: Thu, 16 Feb 2017 15:32:13 +0100
Message-ID: <20170216143212.GA32058@lst.de>
References: <1487230394-84552-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:35779 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932067AbdBPOcP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 09:32:15 -0500
Content-Disposition: inline
In-Reply-To: <1487230394-84552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@inter.com>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>

On Thu, Feb 16, 2017 at 08:33:14AM +0100, Hannes Reinecke wrote:
> Any device might be setting a queuedata structure, so we need to
> check if the queuedata really belongs to a SCSI device before
> proceeding.

Can you add a comment next to the scsi_is_sdev_device call explaining
it?  The thing is a bit of a hack, but probably the best we can do for
now.
