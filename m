From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 19/23] scsi_dh_alua: Use workqueue for RTPG
Date: Wed, 2 Sep 2015 08:39:27 +0200
Message-ID: <20150902063927.GA13399@lst.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de> <1440679281-13234-20-git-send-email-hare@suse.de> <20150901111517.GB10589@lst.de> <55E5A0D5.5070402@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38159 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbbIBGja (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Sep 2015 02:39:30 -0400
Content-Disposition: inline
In-Reply-To: <55E5A0D5.5070402@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Todd Gill <tgill@redhat.com>

On Tue, Sep 01, 2015 at 02:57:57PM +0200, Hannes Reinecke wrote:
> That is what I'm eventually planning to do.
> My final goal is to move the multipath path monitoring stuff
> into the kernel (via the block device polling mechanism), and sending
> block events for path failure and re-establishment.

It might be a good idea to prioritize that.  Todd has been asking
for multipath monitoring APIs and suggested adding D-BUS APIs to
multipathd.  I'd much prefer them directly talking to the kernel
instead of cementing multipathd, which is a bit of a wart.
