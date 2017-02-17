From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2] scsi: use 'scsi_device_from_queue()' for scsi_dh
Date: Fri, 17 Feb 2017 09:27:52 +0100
Message-ID: <20170217082752.GA18258@lst.de>
References: <1487257943-72264-1-git-send-email-hare@suse.de> <20170216170519.GA9630@localhost.localdomain> <c889eed7-6262-2e54-0b1e-1d833c033324@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41018 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751646AbdBQI1z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:27:55 -0500
Content-Disposition: inline
In-Reply-To: <c889eed7-6262-2e54-0b1e-1d833c033324@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>

On Fri, Feb 17, 2017 at 09:06:14AM +0100, Hannes Reinecke wrote:
> We could, but why?
> ATM we're only having SCSI devices able to use device handler; adding
> another layer of indirection doesn't solve anything here.
> Moving the infrastructure one level up will only make sense if we're
> getting non-SCSI device handler (ANA?), but until then I'd think it's
> just overengineering.

Agreed.  Independent of what does the balancing between queues hardware
handler should be attached by the low-level driver for any future
transport without any control from DM.
