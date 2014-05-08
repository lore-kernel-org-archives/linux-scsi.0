From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: reintroduce scsi_driver.init_command
Date: Thu, 08 May 2014 09:11:00 +0200
Message-ID: <536B2E04.5040404@suse.de>
References: <1398955865-20629-1-git-send-email-hch@lst.de> <1398955865-20629-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbaEHHLC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 May 2014 03:11:02 -0400
In-Reply-To: <1398955865-20629-4-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org

On 05/01/2014 04:51 PM, Christoph Hellwig wrote:
> Instead of letting the ULD play games with the prep_fn move back to
> the model of a central prep_fn with a callback to the ULD.  This
> already cleans up and shortens the code by itself, and will be requir=
ed
> to properly support blk-mq in the SCSI midlayer.
>

=2E.. And leaving the device handler to still provide a prep_fn().
But that's for another day.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
