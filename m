From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 06/18] scsi: Make scsi_ioctl_reset() pass the request
        queue pointer to blk_rq_init()
Date: Sun, 21 May 2017 08:50:03 +0200
Message-ID: <20170521065003.GE12891@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-7-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42798 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdEUGuF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 May 2017 02:50:05 -0400
Content-Disposition: inline
In-Reply-To: <20170519183016.12646-7-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Although we really need to stop abusing requests/cmds for EH..
(Hannes, time to dust off your old patches!)
