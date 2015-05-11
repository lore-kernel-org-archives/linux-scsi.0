From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/17] scsi_dh_alua: Make stpg synchronous
Date: Mon, 11 May 2015 15:50:26 +0200
Message-ID: <20150511135026.GB7795@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-9-git-send-email-hare@suse.de> <20150511065523.GG30516@lst.de> <55507D74.1070908@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40560 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753390AbbEKNu2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 09:50:28 -0400
Content-Disposition: inline
In-Reply-To: <55507D74.1070908@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Mon, May 11, 2015 at 11:59:16AM +0200, Hannes Reinecke wrote:
> This is just an intermediate step, before the entire thing moves off
> to a workqueue and becomes asynchronous again.
> It's not meant to be as a standalone patch; I've just split it off
> for easier review.

It actually made the review a bit harder.  Also I don't really undertand
what the benfit of running a synchronous STPG in a workqueue is over
running it asynchronously.
