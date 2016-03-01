From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] scsi_dh_emc: update 'access_state' field
Date: Tue, 1 Mar 2016 14:08:40 +0100
Message-ID: <20160301130840.GF7616@lst.de>
References: <1456808143-88932-1-git-send-email-hare@suse.de> <1456808143-88932-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40424 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbcCANIl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Mar 2016 08:08:41 -0500
Content-Disposition: inline
In-Reply-To: <1456808143-88932-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Tue, Mar 01, 2016 at 05:55:42AM +0100, Hannes Reinecke wrote:
> Update the 'access_state' field of the SCSI device whenever
> the path state changes.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
