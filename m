From: Christoph Hellwig <hch@infradead.org>
Subject: Re: uas breakage when using scsi_mod.blk_mq=Y
Date: Wed, 1 Oct 2014 10:31:05 -0700
Message-ID: <20141001173105.GA4193@infradead.org>
References: <542BB8A5.4000308@redhat.com>
 <20141001124543.GB14872@infradead.org>
 <542C2366.30700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbaJARbH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 13:31:07 -0400
Content-Disposition: inline
In-Reply-To: <542C2366.30700@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>

On Wed, Oct 01, 2014 at 05:53:10PM +0200, Hans de Goede wrote:
> So let me see if I understand this correctly, blk-mq will never queue
> more then qdepth commands, but it will use higher tag numbers ?

Correct.

> If that is the case fixing this should be easy, uas already has
> an array to map stream-ids to scsi cmnds so that when it gets a status
> urb, it can find the scsi cmnd which belongs to that status urb. We
> can just search for a free slot in that array.

That sounds good.

