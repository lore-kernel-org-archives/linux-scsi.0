From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel bug triggered in multipath
Date: Sat, 15 Mar 2014 06:23:36 -0700
Message-ID: <20140315132336.GC13647@infradead.org>
References: <1394795632-86434-1-git-send-email-hare@suse.de>
 <20140314111520.GA17288@infradead.org>
 <20140314162111.GB14188@redhat.com>
 <20140314162615.GC14188@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45935 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbaCONXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Mar 2014 09:23:39 -0400
Content-Disposition: inline
In-Reply-To: <20140314162615.GC14188@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Fri, Mar 14, 2014 at 12:26:15PM -0400, Mike Snitzer wrote:
> On Fri, Mar 14 2014 at 12:21pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
> > I have no problem with this patch, added safety-net and all, but
> > bottomline: if scsi_dh interfaces were being called against a DM
> > multipath request_queue that is a bug.
> 
> Sorry, s/DM multipath request_queue/non-SCSI requeue_queue/
> 
> > In practice that never happens
> > in supported configurations.  AFAICT, Hannes just stumbled upon it cause
> > he was trying to get cciss working with dm-multipath.

What prevents an admin from trying to configure a path selector for a
non-scsi device currently?

