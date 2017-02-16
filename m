From: Keith Busch <keith.busch@intel.com>
Subject: Re: hch's native NVMe multipathing [was: Re: [PATCH 1/2] Don't
 blacklist nvme]
Date: Thu, 16 Feb 2017 12:38:56 -0500
Message-ID: <20170216173856.GB17828@localhost.localdomain>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
 <20170215145617.GA4241@infradead.org>
 <20170216025357.GA9241@redhat.com>
 <20170216142621.GA21972@infradead.org>
 <20170216151337.GA12678@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:41035 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932465AbdBPRaa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 12:30:30 -0500
Content-Disposition: inline
In-Reply-To: <20170216151337.GA12678@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org

On Thu, Feb 16, 2017 at 10:13:37AM -0500, Mike Snitzer wrote:
> On Thu, Feb 16 2017 at  9:26am -0500,
> Christoph Hellwig <hch@infradead.org> wrote:
>
> > just a little new code in the block layer, and a move of the path
> > selectors from dm to the block layer.  I would not call this
> > fragmentation.
> 
> I'm fine with the path selectors getting moved out; maybe it'll
> encourage new path selectors to be developed.
> 
> But there will need to be some userspace interface stood up to support
> your native NVMe multipathing (you may not think it needed but think in
> time there will be a need to configure _something_).  That is the
> fragmentation I'm referring to.

I'm not sure what Christoph's proposal looks like, but I have to agree
that multipath support directly in the kernel without requiring user
space to setup the mpath block device is easier for everyone. The only
NVMe specific part, though, just needs to be how it reports unique
identifiers to the multipath layer.

Maybe I'm not seeing the bigger picture. Is there some part to multipath
that the kernel is not in a better position to handle?
