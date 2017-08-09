From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] hpsa: add support for legacy boards
Date: Wed, 9 Aug 2017 17:59:57 +0200
Message-ID: <20170809155957.GB3141@lst.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de> <1502181315-102499-3-git-send-email-hare@suse.de> <20170809134112.GB25852@lst.de> <a20e126e-4738-aac2-a92e-71a448176c51@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54209 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752572AbdHIP77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 11:59:59 -0400
Content-Disposition: inline
In-Reply-To: <a20e126e-4738-aac2-a92e-71a448176c51@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Aug 09, 2017 at 05:08:05PM +0200, Hannes Reinecke wrote:
> On 08/09/2017 03:41 PM, Christoph Hellwig wrote:
> > On Tue, Aug 08, 2017 at 10:35:11AM +0200, Hannes Reinecke wrote:
> >> Add support for legacy boards, ensuring to enable the driver for
> >> those boards only when 'hpsa_allow_any' is set.
> > 
> > Why the wildcard instead of the specific IDs from the cciss driver?
> > 
> Because I'm lazy? And we're catching those boards with the wildcard
> entry anyway? And the distinction between wildcard entry (designed to
> catch unsupported devices) and pci IDs from the cciss drivers (which
> will be unsupported, too) is meaningless?

So what again is unsupported?

How do we know there never was any other compaq device claiming to be
raid class?
