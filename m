From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v2 0/6] vhost/scsi: Add T10 PI SGL passthrough support
Date: Tue, 10 Jun 2014 16:02:08 +0300
Message-ID: <20140610130208.GA27702@redhat.com>
References: <1400725582-5521-1-git-send-email-nab@daterainc.com>
 <20140609133026.GA6239@redhat.com>
 <1402383912.5774.13.camel@haakon3.risingtidesystems.com>
 <20140610094254.GC7423@redhat.com>
 <20140610215217.495d5476@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbaFJNCD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 09:02:03 -0400
Content-Disposition: inline
In-Reply-To: <20140610215217.495d5476@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>

On Tue, Jun 10, 2014 at 09:52:17PM +1000, Stephen Rothwell wrote:
> Hi Michael,
> 
> On Tue, 10 Jun 2014 12:42:54 +0300 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >
> > So I see two options:
> > - I go ahead with my changes and you with yours and let Linus resolve
> >   the conflict.  This means bisect build will be broken since the
> >   breakage will likely not be noticed until after the merge.
> 
> Well, since the resolution is known, the one who submits their tree
> later should tell Linus (as suggested by Nicholas).  That is part of
> the point of the linux-next tree ... and therefore there would be no
> bisect problem.
> 
> > > Stephen (CC'ed) has included a fix in today's linux-next for the merge
> > > conflict here:
> > > 
> > > https://lkml.org/lkml/2014/6/10/3
> > > 
> > > Please confirm, as it will be a pointer to Linus within the
> > > target-pending/for-next PULL request.
> > 
> > Yes but this does mean people trying to bisect will
> > hit build breakages, not nice.
> 
> Not necessarily.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


I don't see how that's possible.
Here's a point you might have missed.
Nicholas's patch isn't just introducing a merge conflict.
It is also buggy.
Replacing bit access with has_feature silently fixes the bug.

So if we want to avoid bisect breakage target tree will
have to be rebased.

And if doing that anyway, I don't see any reason not
to merge everything through the vhost tree, esp
since I already put the patches there. Less work for
everyone involved.

-- 
MST
