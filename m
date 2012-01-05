From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] scsi_dh: allow 3rd party multipath drivers to
 scsi_dh_detach
Date: Thu, 5 Jan 2012 10:24:41 -0500
Message-ID: <20120105152441.GA5130@redhat.com>
References: <20111215214440.GA17677@redhat.com>
 <4EF039D5.5010201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874Ab2AEPYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2012 10:24:45 -0500
Content-Disposition: inline
In-Reply-To: <4EF039D5.5010201@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

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

Thanks Hannes,

So will this change make it into 3.3?  In general, I'm not clear on
where scsi_dh changes are staged for upstream inclusion.

Mike
