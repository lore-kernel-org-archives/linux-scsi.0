From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 06/20] libfc: Replace ->rport_lookup callback with
 function call
Date: Tue, 18 Oct 2016 10:48:42 +0200
Message-ID: <20161018084842.j2kllimbtguboh5j@linux-x5ow.site>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
 <1476777714-3543-7-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752710AbcJRIso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 04:48:44 -0400
Content-Disposition: inline
In-Reply-To: <1476777714-3543-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Oct 18, 2016 at 10:01:40AM +0200, Hannes Reinecke wrote:
> The ->rport_lookup callback only ever had a single implementation,
> so we can as well call it directly and drop the callback.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

Looks good,
Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
