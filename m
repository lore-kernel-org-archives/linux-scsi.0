From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SCSI core patches for kernel 3.12
Date: Tue, 20 Aug 2013 23:48:47 -0700
Message-ID: <20130821064847.GA9043@infradead.org>
References: <52135B99.2000102@acm.org>
 <1377015091.5302.47.camel@haakon3.risingtidesystems.com>
 <52139608.5040608@acm.org>
 <1377018283.5302.48.camel@haakon3.risingtidesystems.com>
 <5213AEBD.2020303@acm.org>
 <1377031084.5302.54.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3HUGsz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Aug 2013 02:48:55 -0400
Content-Disposition: inline
In-Reply-To: <1377031084.5302.54.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Aug 20, 2013 at 01:38:04PM -0700, Nicholas A. Bellinger wrote:
> <yawn>, I only care about the performance against upstream code, so that
> would mean scsi_debug here.  Typically the onus of demonstrating a
> performance improvement is on the patch submitter (eg: not the
> reviewer).

Do you really care?  If the patchset introduced a lot of code or
ugliness I might agreee to your above statement, but it actually
makes the code more obvious, simpler and also fixes some small issues
so I don't think we'll need an exact performance improvement to justify
it.

> But it would be at least useful to know the actual benefit with results
> as an incremental step, short of avoiding this code entirely for
> scsi-mq.

I don't think you can avoid the device put/get entirely for that case.
I've been looking over the mq code a bit more lately, and in a few
places it just seems to try to cut a few too many corners.  To get
it out of the prototype status we'll need to make sure all edge cases
are handled correctly.

