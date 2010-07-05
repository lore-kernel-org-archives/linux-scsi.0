From: Mark Lord <kernel@teksavvy.com>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding directly
 to prep
Date: Mon, 05 Jul 2010 17:50:56 -0400
Message-ID: <4C3253C0.8040900@teksavvy.com>
References: <1277917264.2839.153.camel@mulgrave.site> <20100701104653O.fujita.tomonori@lab.ntt.co.jp> <20100702110343.GA27159@lst.de> <20100705160023S.fujita.tomonori@lab.ntt.co.jp> <20100705192413.GA24189@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20100705192413.GA24189@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/07/10 03:24 PM, Christoph Hellwig wrote:
>
> What codebase were you testing on?  Sorry, but curently I'm a bit lost
> in the maze of patches.  I've got both and intel and an OCZ SSD (right
> now I'm travelling with only access to the OCZ actually) and I'd like
> to test the latest variant again.
..

Speaking of which..  I have recently noticed that some OCZ drives
fail TRIM commands when issued for the final sector of the drive..
which happens by default with "mke2fs -t ext4".

So I now partition those to not include the final sector.

Keep your eyes peeled for stuff like that.

Cheers
