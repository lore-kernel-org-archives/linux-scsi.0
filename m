From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 0/2] scsi command timeout fixes
Date: Fri, 13 Jun 2014 10:16:13 -0700
Message-ID: <20140613171613.GA7274@infradead.org>
References: <1402660906-74661-1-git-send-email-hare@suse.de>
 <1402678371.2224.35.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbaFMRQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2014 13:16:15 -0400
Content-Disposition: inline
In-Reply-To: <1402678371.2224.35.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "emilne@redhat.com" <emilne@redhat.com>

On Fri, Jun 13, 2014 at 04:52:52PM +0000, James Bottomley wrote:
> If you're seeing double completions it's either because we have a bug in
> SCSI and are doing something with the command before we know block has
> relinquished it.  That's actually why this bug was so serious:

Note that drivers or transports that implement ->eh_timed_out make
this picture even more complicated, as that adds another path
into driver control.

Hannes, what driver do you see this with?

