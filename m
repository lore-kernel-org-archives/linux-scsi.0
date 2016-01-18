From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 14/24] scsi_dh_alua: Allow workqueue to run
	synchronously
Date: Mon, 18 Jan 2016 18:45:19 +0100
Message-ID: <20160118174519.GB24303@lst.de>
References: <1452672599-9820-1-git-send-email-hare@suse.de> <1452672599-9820-15-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33428 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbcARRpU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jan 2016 12:45:20 -0500
Content-Disposition: inline
In-Reply-To: <1452672599-9820-15-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart von Assche <bart.vanassche@sandisk.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 09:09:49AM +0100, Hannes Reinecke wrote:
> Some arrays may only capable of handling one STPG at a time,
> so this patch adds a singlethreaded workqueue for STPGs to be
> submitted synchronously.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
