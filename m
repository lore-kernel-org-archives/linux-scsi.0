From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 08/20] libfc: Replace ->rport_create callback with
 function call
Date: Tue, 18 Oct 2016 12:26:08 +0200
Message-ID: <20161018102608.qk6z47f3cwjfo7xi@linux-x5ow.site>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
 <1476777714-3543-9-git-send-email-hare@suse.de>
 <20161018085415.eb33ubgvdegcqrpm@linux-x5ow.site>
 <2b698d8d-2b27-2cda-3435-8f8895673589@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34027 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759016AbcJRK0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Oct 2016 06:26:11 -0400
Content-Disposition: inline
In-Reply-To: <2b698d8d-2b27-2cda-3435-8f8895673589@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Oct 18, 2016 at 12:23:22PM +0200, Hannes Reinecke wrote:
> On 10/18/2016 10:54 AM, Johannes Thumshirn wrote:
> > On Tue, Oct 18, 2016 at 10:01:42AM +0200, Hannes Reinecke wrote:
> >> The ->rport_create callback only ever had a single implementation,
> >> so we can as well call it directly and drop the callback.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.com>
> >> ---
> > 
> > Any reason we can't rename fc_rport_create() with fc_remote_port_create()
> > so the scsi_transport_fc.c patch isn't needed?
> > 
> Yes: consistency.
> 
> Every function in libfc/fc_rport.c is named 'fc_rport_XXX'. So we should
> stick to that naming scheme here, too.
> scsi_transport_fc.c does not have such a strict naming scheme, so it's
> easier to rename that.
> 

OK, 
Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
