From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 03/11] mpt3sas: use 'list_splice_init()'
Date: Fri, 17 Feb 2017 09:33:42 +0100
Message-ID: <20170217083342.GA18443@lst.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de> <1487319790-97340-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41070 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753622AbdBQIdo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:33:44 -0500
Content-Disposition: inline
In-Reply-To: <1487319790-97340-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Feb 17, 2017 at 09:23:02AM +0100, Hannes Reinecke wrote:
> Use 'list_splice_init()' instead of hand-crafted function.
> No functional change.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
