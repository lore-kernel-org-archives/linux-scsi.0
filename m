From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] scsi_dh: allow 3rd party multipath drivers to
 scsi_dh_detach
Date: Thu, 5 Apr 2012 10:47:22 -0400
Message-ID: <20120405144721.GA18437@redhat.com>
References: <20111215214440.GA17677@redhat.com>
 <4EF039D5.5010201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab2DEOrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Apr 2012 10:47:32 -0400
Content-Disposition: inline
In-Reply-To: <4EF039D5.5010201@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

On Tue, Dec 20 2011 at  2:31am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 12/15/2011 10:44 PM, Mike Snitzer wrote:
> > Some scsi_dh modules are known to conflict with with 3rd party multipath
> > drivers (e.g. scsi_dh_emc conflicts with EMC PowerPath).
> > 
> > Allow 3rd party multipath drivers to programatically detach a scsi_dh
> > using the scsi_dh_detach() interface rather than require writing
> > 'detach' to /sys/block/sdX/queue/dh_state
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> No problem with that.
> 
> Acked-by: Hannes Reinecke <hare@suse.de>

Hi James,

Can we get this patch staged for 3.5?

Thanks,
Mike
