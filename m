From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 26/30] ext4: do not send discards as barriers
Date: Wed, 25 Aug 2010 17:57:41 +0200
Message-ID: <4C753D75.2010305@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-27-git-send-email-tj@kernel.org> <20100825155842.GA3229@lst.de> <20100825160032.GC3229@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100825160032.GC3229@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jack@suse.cz
Cc: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, rwheeler@redhat.com, hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com, jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On 08/25/2010 06:00 PM, Christoph Hellwig wrote:
> On Wed, Aug 25, 2010 at 05:58:42PM +0200, Christoph Hellwig wrote:
>> On Wed, Aug 25, 2010 at 05:47:43PM +0200, Tejun Heo wrote:
>>> From: Christoph Hellwig <hch@infradead.org>
>>>
>>> ext4 already uses synchronous discards, no need to add I/O barriers.
>>
>> This needs the patch that Jan sent in reply to my initial version merged
>> into it.
> 
> Actually the jbd2 patch needs it merged, but the point still stands.

Yeah, wasn't sure about that one.  Has anyone tested it?  I'll be
happy to merge it but I have no idea whether it's correct or not and
Jan didn't seem to have tested it so...  Jan, shall I merge the patch?

Thanks.

-- 
tejun
