From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [RESEND PATCH 2/3] dm mpath: add
	'default_hw_handler' feature
Date: Wed, 11 Jul 2012 11:27:54 +0100
Message-ID: <20120711102754.GA2095@agk-dp.fab.redhat.com>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com> <1340735525-21083-3-git-send-email-snitzer@redhat.com> <4FEAA557.7050501@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab2GKK2E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 06:28:04 -0400
Content-Disposition: inline
In-Reply-To: <4FEAA557.7050501@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>, James Bottomley <jbottomley@parallels.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

On Wed, Jun 27, 2012 at 08:16:55AM +0200, Hannes Reinecke wrote:
> On 06/26/2012 08:32 PM, Mike Snitzer wrote:
> > When specifying the feature 'default_hw_handler' multipath will use
> > the currently attached hardware handler instead of trying to attach the
> > one specified during table load.  If no hardware handler is attached the
> > specified hardware handler will be used.
> > 
> > Leverages scsi_dh_attach's ability to increment the scsi_dh's reference
> > count if the same scsi_dh name is provided when attaching -- currently
> > attached scsi_dh name is determined with scsi_dh_attached_handler_name.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > Tested-by: Babu Moger <babu.moger@netapp.com>
> > Reviewed-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Looks good.
 
Maybe, but I'd like to see an inline explanation of what this confusing new
setting means and a better patch header that provides some motivation for this
change.

To my eyes, the word "default" is over-used here.  If I *don't* specify the new
"default" flag, surely I'll get default behaviour, won't I, by definition?  And
if I do specify it, I'm asking for default behaviour too, so isn't it
redundant?

Alasdair

