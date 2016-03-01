From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] scsi_dh_rdac: update 'access_state' field
Date: Tue, 1 Mar 2016 14:08:24 +0100
Message-ID: <20160301130824.GE7616@lst.de>
References: <1456808143-88932-1-git-send-email-hare@suse.de> <1456808143-88932-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40422 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbcCANI0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 08:08:26 -0500
Content-Disposition: inline
In-Reply-To: <1456808143-88932-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Mar 01, 2016 at 05:55:41AM +0100, Hannes Reinecke wrote:
> Track attached SCSI devices and update the 'access_state'
> whenever the path state of the device changes.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
