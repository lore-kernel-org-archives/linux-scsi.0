From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Fri, 10 Sep 2010 15:24:04 -0400
Message-ID: <20100910192403.GA24582@redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
 <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
 <20100910184652.GA24470@redhat.com>
 <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, agk@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 10 2010 at  3:05pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 10 Sep 2010, Mike Snitzer wrote:
> > And in fact, this first patch basically is as minimal as it gets
> > relative to bio-based DM's conversion to FLUSH+FUA.
> > 
> > Please direct your energy and talent in a positive way rather than
> > starting a potential flame.
> > 
> > Thanks,
> > Mike
> 
> I don't want to flame. I mean this:
> 
> * person X writes a patch P.
> * person Y reads P, sees that the condition C is true and writes patch Q 
> that dependes on condition C.
> * person X changes a patch P, so that the patch is correct but condition C 
> is no longer true.
> 
> Now, there is a bug in the patch Q and NEITHER X NOR Y can find out about 
> that bug.
> 
> That's why parallel development doesn't work.
> 
> If you develop on things in the kernel, it is different.
> * person X writes a patch P and puts it in the kernel.
> * person Y reads the kernel code, sees that the condition C is true and 
> writes a patch Q that assumes that the condition C is true. He puts this 
> patch to the kernel too.
> * person X wants to change his code so that the condition C isn't true, 
> but it is now his responsibility to search the rest of the kernel to see 
> if it depends on the condition C. He searches the code and finds Q.
> 
> This is not a flamewar, just a technical explanation, why I don't want to 
> develop on interfaces that are not in the kernel.

We're reasonable people and can certainly prevent a flamewar but what
you're doing is an elaborate distraction.  The energy it took you to
write and reason through your logic above could've been used to just
review the DM FLUSH+FUA patches.

The various interfaces are hardened now and staged for inclussion in
2.6.37.  Jens has already pulled the entire 40+ patchset into his
for-next branch for wider linux-next testing.

Tejun, Christoph and others have done an amazing job with this
conversion.  The fact that Tejun tackled the heavy lifting of DM's
conversion was unexpected but 100% appreciated (by me and I assume
others).  Please don't dismiss, or misrepresent the status of, this
FLUSH+FUA work.

Mike
