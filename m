From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 11/18] scsi: Move most of scsi_init_command() into
        scsi_initialize_rq()
Date: Sun, 21 May 2017 08:47:05 +0200
Message-ID: <20170521064705.GA12891@lst.de>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com> <20170519183016.12646-12-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42775 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750786AbdEUGrH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 May 2017 02:47:07 -0400
Content-Disposition: inline
In-Reply-To: <20170519183016.12646-12-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

On Fri, May 19, 2017 at 11:30:09AM -0700, Bart Van Assche wrote:
> Move the initializations that only have to be performed once and
> not every time a request is prepared from scsi_init_command()
> into scsi_initialize_rq(). This patch also moves the
> jiffies_at_alloc assignment such that it gets back the meaning it
> had before commit e9c787e65c0c, namely the value of the jiffies
> counter at request allocation time.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
