From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Remove the definition of VLC_SA_RECEIVE_CREDENTIAL
Date: Mon, 26 Jun 2017 09:10:31 +0200
Message-ID: <20170626071031.GA4732@linux-x5ow.site>
References: <20170623173239.16901-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37842 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751252AbdFZHKd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 03:10:33 -0400
Content-Disposition: inline
In-Reply-To: <20170623173239.16901-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

On Fri, Jun 23, 2017 at 10:32:39AM -0700, Bart Van Assche wrote:
> The symbolic name VLC_SA_RECEIVE_CREDENTIAL is not used anywhere
> in the kernel. Additionally, since SPC 5 the RECEIVE CREDENTIAL
> command is obsolete. The VLC_SA_RECEIVE_CREDENTIAL definition is
> misleading since it occurs outside the list of other variable
> length CDB service action codes (READ_32, WRITE_32, ...). Hence
> remove this definition.
> 
> References: commit e9ccc998b70f ("[SCSI] Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] service action definitions")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---

Thanks Bart,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
