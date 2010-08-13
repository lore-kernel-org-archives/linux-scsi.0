From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/11] block: kill QUEUE_ORDERED_BY_TAG
Date: Fri, 13 Aug 2010 15:06:57 +0200
Message-ID: <20100813130657.GA4140@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <1281616891-5691-3-git-send-email-tj@kernel.org> <4C654100.3060307@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C654100.3060307@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Tejun Heo <tj@kernel.org>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, jack@suse.cz, rwheeler@redhat.com, hare@suse.de, Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Jeremy Fitzhardinge <jeremy@xensource.com>, Chris Wright <chrisw@sous-sol.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 13, 2010 at 04:56:32PM +0400, Vladislav Bolkhovitin wrote:
> Tejun Heo, on 08/12/2010 04:41 PM wrote:
> >Nobody is making meaningful use of ORDERED_BY_TAG now and queue
> >draining for barrier requests will be removed soon which will render
> >the advantage of tag ordering moot.
> 
> Have you seen Hannes Reinecke's and my measurements in 
> http://marc.info/?l=linux-scsi&m=128110662528485&w=2 and 
> http://marc.info/?l=linux-scsi&m=128111995217405&w=2 correspondingly?
> 
> If yes, what else evidences do you need to see that the tag ordering is 
> a big performance win?

It's not tag odering that is a win but big queue depth.  That's what you
measured and what I fully agree on.  I haven't been able to get out of
Hannes what he actually measured.

And if you'd actually look at the patchset allowing deep queues is
exactly what it allows us, and while I haven't done testing on this
patchset but only on my previous version it does get us back to use
the full potential of large arrays exactly because of that.
