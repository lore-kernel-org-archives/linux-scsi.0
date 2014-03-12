From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 3/5] Add EVPD page 0x83 to sysfs
Date: Wed, 12 Mar 2014 01:03:26 -0700
Message-ID: <20140312080326.GB23294@infradead.org>
References: <1394461725-76203-1-git-send-email-hare@suse.de>
 <1394461725-76203-4-git-send-email-hare@suse.de>
 <1394475897.2565.46.camel@dabdike.int.hansenpartnership.com>
 <531E25F3.6090102@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59174 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaCLIDf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Mar 2014 04:03:35 -0400
Content-Disposition: inline
In-Reply-To: <531E25F3.6090102@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "jlinton@tributary.com" <jlinton@tributary.com>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>, "kay@vrfy.org" <kay@vrfy.org>

On Mon, Mar 10, 2014 at 09:52:03PM +0100, Hannes Reinecke wrote:
> Yes, I thought of that, too.
> I thought to remember that binary attributes are reserved for
> firmware/hardware-dependent interfaces.

That's what we're dealing with here, aren't we?

> What should happen with the first patch in the series, then?
> When moving to a binary attribute the first patch isn't required
> anymore; should I drop it or send as a separate patch?

To me it seems useful even without the rest.

