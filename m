From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 11/22] scsi_dh_alua: move optimize_stpg evaluation
Date: Tue, 12 Jan 2016 18:11:25 +0100
Message-ID: <20160112171125.GC23947@lst.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de> <1452613258-94084-12-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38987 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbcALRL1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 12:11:27 -0500
Content-Disposition: inline
In-Reply-To: <1452613258-94084-12-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Jan 12, 2016 at 04:40:47PM +0100, Hannes Reinecke wrote:
> When the optimize_stpg module option is set we should just set it
> once during port_group allocation. Doing so allows us to override
> it later with device specific settings.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
