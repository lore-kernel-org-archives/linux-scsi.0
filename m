From: Christoph Hellwig <hch@lst.de>
Subject: Re: RFC: 512e ZBC host-managed disks
Date: Thu, 12 Jan 2017 09:20:48 +0100
Message-ID: <20170112082048.GA8276@lst.de>
References: <38404478-7b9a-35ed-8148-81a05bd01ac8@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:43621 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750777AbdALIUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 03:20:51 -0500
Content-Disposition: inline
In-Reply-To: <38404478-7b9a-35ed-8148-81a05bd01ac8@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On Thu, Jan 12, 2017 at 05:13:52PM +0900, Damien Le Moal wrote:
> (3) Any other idea ?

Do nothing and ignore the problem.  This whole idea so braindead that
the person coming up with the T10 language should be shot.  Either a device
has 511 logical sectors or 4k but not this crazy mix.

And make sure no one ships such a piece of crap because we are hell
not going to support it.
