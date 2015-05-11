From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/17] scsi_dh_alua: Disable ALUA handling for non-disk
	devices
Date: Mon, 11 May 2015 14:19:15 +0200
Message-ID: <20150511121915.GA5661@lst.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-3-git-send-email-hare@suse.de> <20150511064643.GB30516@lst.de> <555083AF.1000605@suse.de> <20150511113451.GA4803@lst.de> <555098A3.6030106@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40153 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbbEKMTR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 08:19:17 -0400
Content-Disposition: inline
In-Reply-To: <555098A3.6030106@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Mon, May 11, 2015 at 01:55:15PM +0200, Hannes Reinecke wrote:
> As said above; we _could_ drop this patch and update error
> handling, but then we'll risk of having more bug reports
> due to invalid ALUA implementations.
> Might be worth it, though, as then we could get in touch
> with the respective vendors. But then, maybe not, as not
> every vendor is willing to listen to us...
> 
> I don't really have a fixed opinion here; either way is
> fine with me.

For now mayeb reject a everything but TYPE_SBC and add a comment
explaining why, i.e. a short form of the reasons in this mail.
