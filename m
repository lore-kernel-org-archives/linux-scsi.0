From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC] relaxed barrier semantics
Date: Mon, 2 Aug 2010 15:14:29 +0200
Message-ID: <20100802131429.GE3278@quack.suse.cz>
References: <25F5E16E-968D-4FEF-8187-70453985B19B@dilger.ca>
 <20100729230406.GI4506@thunk.org>
 <4C52CBFF.6090406@vlnb.net>
 <20100730130957.GA26894@lst.de>
 <4C52D2E0.5000609@vlnb.net>
 <20100730133410.GA27996@lst.de>
 <4C52D728.6070008@vlnb.net>
 <20100730142025.GA29341@lst.de>
 <20100731004756.GC3273@quack.suse.cz>
 <20100731091245.GA4643@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100731091245.GA4643@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, Vladislav Bolkhovitin <vst@vlnb.net>, Ted Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Sat 31-07-10 11:12:46, Christoph Hellwig wrote:
> On Sat, Jul 31, 2010 at 02:47:57AM +0200, Jan Kara wrote:
> > > There is a few caes where we could do that - the fsync without metadata
> > > changes above would be the prime example.  But there's a lot lower
> > > hanging fruit until we get to the point where it's worth trying.
> >   Umm, I don't understand you. I think that fsync in particular is an
> > example where you have to wait and issue cache flush if the drive has
> > volatile write cache.
> 
> Of course.  What makes you believe anyone said something else?
  Ok, then I just misunderstood which requests you wanted to send ORDERED.
Never mind, I think we agree on what needs to / can be done.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
