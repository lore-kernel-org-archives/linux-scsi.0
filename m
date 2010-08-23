From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Mon, 23 Aug 2010 14:48:15 +0200
Message-ID: <20100823124815.GA20095@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100820132214.GA6184@lst.de> <4C6E9CAF.5010202@redhat.com> <4C7269E9.9070304@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C7269E9.9070304@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 23, 2010 at 02:30:33PM +0200, Tejun Heo wrote:
> It might be useful to give several example configurations with
> different cache configurations.  I don't have much experience with
> battery backed arrays but aren't they suppose to report write through
> cache automatically?

They usually do.  I have one that doesn't, but SYNCHRONIZE CACHE on
it is so fast that it effectively must be a no-op.

