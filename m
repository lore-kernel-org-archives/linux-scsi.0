From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [dm-devel] hch's native NVMe multipathing [was: Re: [PATCH 1/2]
 Don't blacklist nvme]
Date: Fri, 17 Feb 2017 01:04:20 -0800
Message-ID: <20170217090420.GA29629@infradead.org>
References: <1487107154-24883-1-git-send-email-keith.busch@intel.com>
 <20170215145617.GA4241@infradead.org>
 <20170216025357.GA9241@redhat.com>
 <20170216142621.GA21972@infradead.org>
 <20170216151337.GA12678@redhat.com>
 <20170216173856.GB17828@localhost.localdomain>
 <1487266648.2612.3.camel@sandisk.com>
 <20170216180742.GC17828@localhost.localdomain>
 <20170216182129.GC12678@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755308AbdBQJEY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Feb 2017 04:04:24 -0500
Content-Disposition: inline
In-Reply-To: <20170216182129.GC12678@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, "hch@infradead.org" <hch@infradead.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Thu, Feb 16, 2017 at 01:21:29PM -0500, Mike Snitzer wrote:
> multipath-tools has tables that specify all the defaults for a given
> target backend.  NVMe will just be yet another.

No, if we get things right it won't.  ALUA already got rid of most
of the parameter people would have to set under normal conditions,
and I plan to make sure the NVMe equivalent will do it for all
parameters.  I am active in the NVMe working group and will do my
best to get there.  There's a few others folks here that are more or
less active there as well (Keith, Martin, Jens for example), so I
think we have a chance.

That beeing said Keith is right that we'll always have odd setups
where we need to overrid things, and we will have to provide tunables
for that.  It's no different from any other kernel subsystem in that.
