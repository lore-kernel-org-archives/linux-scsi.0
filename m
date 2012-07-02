From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RESEND PATCH 1/3] scsi_dh: add scsi_dh_attached_handler_name
Date: Mon, 2 Jul 2012 17:07:33 -0400
Message-ID: <20120702210733.GA4097@redhat.com>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com>
 <1340735525-21083-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab2GBVHn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jul 2012 17:07:43 -0400
Content-Disposition: inline
In-Reply-To: <1340735525-21083-2-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, James.Bottomley@hansenpartnership.com
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>

On Tue, Jun 26 2012 at  2:32pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Introduce scsi_dh_attached_handler_name() to retrieve the name of the
> scsi_dh that is attached to the scsi_device associated with the provided
> request queue.  Returns NULL if a scsi_dh is not attached.
> 
> Also, fix scsi_dh_{attach,detach} function header comments to document
> @q rather than @sdev.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Tested-by: Babu Moger <babu.moger@netapp.com>
> Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Acked-by: Hannes Reinecke <hare@suse.de>

Hi James,

Any insight on staging this scsi_dh patch for 3.6?

Or what about adding your Acked-by and allowing Alasdair to submit it
for 3.6 with the corresponding dm-mpath patch?

However you'd like to skin it is fine by me.  I'd just _really_
appreciate some feedback.

Thanks,
Mike

p.s. I'm nothing if not persistent ;)
