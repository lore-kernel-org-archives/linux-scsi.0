From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/18] ALUA device handler update, part 1
Date: Fri, 20 Nov 2015 11:47:10 +0100
Message-ID: <20151120104710.GA24871@lst.de>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40980 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759314AbbKTKrN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 05:47:13 -0500
Content-Disposition: inline
In-Reply-To: <1447081703-110552-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.com>, Ewan Milne <emilne@redhat.com>

On Mon, Nov 09, 2015 at 04:08:05PM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> here's the first part of my ALUA device handler update.
> It's mainly bugfixes and minor improvements; the two important
> things are the addition of VPD parsing functions scsi_vpd_lun_id()
> and scsi_vpd_tpg_id().
> This series has been split off from the original 'Asynchronous ALUA'
> patchset, as these bits are pretty uncontroversial and have a good
> chance of being merged reasonably soon.

I've already reviewed most patches, but the other ones looks fine as
well:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Let's get this into the 4.5 queue ASAP an then tackle the actually
interesting bits next!
