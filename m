From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 23/41] dm: implement REQ_FLUSH/FUA support for bio-based
 dm
Date: Fri, 10 Sep 2010 21:46:12 -0400
Message-ID: <20100911014612.GA26517@redhat.com>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
 <1283509796-1510-24-git-send-email-tj@kernel.org>
 <Pine.LNX.4.64.1009101410570.7839@hs20-bc2-1.build.redhat.com>
 <20100910184652.GA24470@redhat.com>
 <Pine.LNX.4.64.1009101456220.21834@hs20-bc2-1.build.redhat.com>
 <20100910192403.GA24582@redhat.com>
 <Pine.LNX.4.64.1009101554300.5286@hs20-bc2-1.build.redhat.com>
 <4C8AC0F5.5080206@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C8AC0F5.5080206@kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com, jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, k-ueda@ct.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 10 2010 at  7:36pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> On 09/10/2010 10:06 PM, Mikulas Patocka wrote:
> > But I have my work rules that I learned: I use no git kernels and no 
> > external patches (except Alasdair's patchset that I want to test). I only 
> > use -rc or final kernels. I need a stable computer --- I don't want to 
> > solve problems like "does it crash because I pulled something or does it 
> > crash because I made a bug in my code?" So, put that into 2.6.37-rc1 and 
> > I'll optimize flushes in dm for -rc2 or -rc3.
> 
> Alright, I'm sorry but this is as far as I would go for dm conversion
> patches.  If you wanna split it further or do it your way, please feel
> free to.  I think it would be beneficial to do things now but, hey,
> you guys are maintaining dm part of the kernel, so it's up to you
> guys.  But, I think it would be silly for everyone else to wait for
> the rather special requirement for dm, so if we have to go forward
> without dm updates, I suppose we will have to.  Jens, please feel free
> to drop dm conversion patches.

Tejun,

Mikulas doesn't speak for Alasdair or the rest of the DM developers.  He
speaks for himself.  He, like me, is a member of the team that helps
maintain DM.  But Alasdair is the upstream DM maintainer.

Please don't latch on to Mikulas' disruptive stone-walling.  As I shared
in my previous reply: your FLUSH+FUA contributions to DM are very much
appreciated!  Kiyoshi, Jun'ichi and myself have all worked with you
effectively and so far the end result DM conversion has proven quite
stable and correct.  Wider testing via linux-next is an important next
step.

Jens, please don't drop the DM FLUSH+FUA conversion patches from your
'for-next' branch.  Mikulas has yet to offer a single substantive
criticism of the code in question.

Alasdair, please advise ASAP.

Thanks,
Mike
