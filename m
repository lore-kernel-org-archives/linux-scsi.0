From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 18/24] scsi_dh_alua: update all port states
Date: Mon, 18 Jan 2016 18:51:00 +0100
Message-ID: <20160118175100.GE24303@lst.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de> <1452672599-9820-19-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33486 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbcARRvC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 12:51:02 -0500
Content-Disposition: inline
In-Reply-To: <1452672599-9820-19-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 09:09:53AM +0100, Hannes Reinecke wrote:
> When we read in the target port group state we should be
> updating all affected port groups, otherwise we risk
> running out of sync.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
