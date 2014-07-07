From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] Use sdev_scsi2lun for SCSI parallel drivers
Date: Mon, 7 Jul 2014 03:11:21 -0700
Message-ID: <20140707101121.GA15750@infradead.org>
References: <1404474875-109997-1-git-send-email-hare@suse.de>
 <1404474875-109997-2-git-send-email-hare@suse.de>
 <20140704134437.GA12345@infradead.org>
 <53B6B646.5080301@suse.de>
 <20140705094147.GA18130@infradead.org>
 <53BA524B.7060400@suse.de>
 <20140707093746.GA12985@infradead.org>
 <53BA70D0.70801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGGKLW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 06:11:22 -0400
Content-Disposition: inline
In-Reply-To: <53BA70D0.70801@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, Jul 07, 2014 at 12:05:04PM +0200, Hannes Reinecke wrote:
> Ok, so I'll be sending a patchset for fixing up the build warnings
> (and keeping the current accesses to ->lun), and prepare a different
> patchset moving everything onto accessors so that we can use struct scsi_lun
> directly.
> Agreed?

That would be my preference, yes.

Btw, re the build warnings:  what's the reason you prefer casts to u8
over just using the %lld printk specifier?  Avoiding casts generally
seems to be the cleaner variant to me.

