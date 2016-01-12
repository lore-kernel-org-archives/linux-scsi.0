From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 14/22] scsi_dh_alua: Allow workqueue to run
	synchronously
Date: Tue, 12 Jan 2016 18:16:55 +0100
Message-ID: <20160112171655.GF23947@lst.de>
References: <1452613258-94084-1-git-send-email-hare@suse.de> <1452613258-94084-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39026 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762100AbcALRQ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jan 2016 12:16:57 -0500
Content-Disposition: inline
In-Reply-To: <1452613258-94084-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Tue, Jan 12, 2016 at 04:40:50PM +0100, Hannes Reinecke wrote:
> Some arrays may only capable of handling one STPG at a time,
> so this patch adds a singlethreaded workqueue for STPGs to be
> submitted synchronously.
> Synchronous STPG can be activated by setting the second module
> option to '1'. The corresponding entry in multipath.conf would be:
>   hardware_handler "3 alua 1 1"

No new hardware_handle options please.  The SCSI way to handle hardware
tweaks is by a devlist entry.  The devlist entries ensure setups
work out of the box, but if needed still can be updated dynamically.
