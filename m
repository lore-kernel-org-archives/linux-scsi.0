From: Chris Leech <cleech@redhat.com>
Subject: Re: [4.10, panic, regression] iscsi: null pointer deref at
 iscsi_tcp_segment_done+0x20d/0x2e0
Date: Wed, 21 Dec 2016 16:13:03 -0800
Message-ID: <20161222001303.nvrtm22szn3hgxar@straylight.hirudinean.org>
References: <20161214222411.GH4326@dastard>
 <20161214222953.GI4326@dastard>
 <20161216185906.t2wmrr6wqjdsrduw@straylight.hirudinean.org>
 <20161221221638.GD4758@dastard>
 <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFyb1jcdpavyZgZ4nedA0=6tLognyWcJXfOJjMPFTm5GWA@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Duncan <lduncan@suse.com>, open-iscsi@googlegroups.com, Linux SCSI List <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2016 at 03:19:15PM -0800, Linus Torvalds wrote:
> Hi,
> 
> On Wed, Dec 21, 2016 at 2:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Dec 16, 2016 at 10:59:06AM -0800, Chris Leech wrote:
> >> Thanks Dave,
> >>
> >> I'm hitting a bug at scatterlist.h:140 before I even get any iSCSI
> >> modules loaded (virtio block) so there's something else going on in the
> >> current merge window.  I'll keep an eye on it and make sure there's
> >> nothing iSCSI needs fixing for.
> >
> > OK, so before this slips through the cracks.....
> >
> > Linus - your tree as of a few minutes ago still panics immediately
> > when starting xfstests on iscsi devices. It appears to be a
> > scatterlist corruption and not an iscsi problem, so the iscsi guys
> > seem to have bounced it and no-one is looking at it.
> 
> Hmm. There's not much to go by.
> 
> Can somebody in iscsi-land please try to just bisect it - I'm not
> seeing a lot of clues to where this comes from otherwise.

Yeah, my hopes of this being quickly resolved by someone else didn't
work out and whatever is going on in that test VM is looking like a
different kind of odd.  I'm saving that off for later, and seeing if I
can't be a bisect on the iSCSI issue.

Chris
