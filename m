From: Christoph Hellwig <hch@lst.de>
Subject: Re: dm-mpath: always return reservation conflict
Date: Thu, 29 Sep 2016 17:35:03 +0200
Message-ID: <20160929153502.GC32512@lst.de>
References: <1470141392-25479-1-git-send-email-hch@lst.de> <1470141392-25479-2-git-send-email-hch@lst.de> <20160811183832.GA27144@lst.de> <20160815130829.GA14829@redhat.com> <20160815134039.GA5569@redhat.com> <20160926165230.GA5787@infradead.org> <1474916784.2765.64.camel@HansenPartnership.com> <9f7ee494-1432-90ad-55e2-dbd223cd7bf3@suse.de> <1475002249.2716.31.camel@HansenPartnership.com> <20160929150132.GA31965@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37895 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751710AbcI2PfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 11:35:05 -0400
Content-Disposition: inline
In-Reply-To: <20160929150132.GA31965@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Thu, Sep 29, 2016 at 11:01:33AM -0400, Mike Snitzer wrote:
> I've elected to just take this change for 4.9.  Please see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.9&id=8ff232c1a819c2e98d85974a3bff0b7b8e2970ed

Thanks Mike.

If any problems show up I will send you an incremental patch that limits
this behavior to devices where we created reservations using the kernel
pr_ops API.
