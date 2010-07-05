From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 1/2] block: implement an unprep function corresponding directly to prep
Date: Mon, 5 Jul 2010 21:24:13 +0200
Message-ID: <20100705192413.GA24189@lst.de>
References: <1277917264.2839.153.camel@mulgrave.site> <20100701104653O.fujita.tomonori@lab.ntt.co.jp> <20100702110343.GA27159@lst.de> <20100705160023S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100705160023S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, James.Bottomley@suse.de, snitzer@redhat.com, axboe@kernel.dk, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 05, 2010 at 04:00:44PM +0900, FUJITA Tomonori wrote:
> Did you tested my discard branch, right?

I tested the patch that you sent out back then.

> Wired, I've just got Intel SSD X25-M drives and mkfs.xfs worked well.

What codebase were you testing on?  Sorry, but curently I'm a bit lost
in the maze of patches.  I've got both and intel and an OCZ SSD (right
now I'm travelling with only access to the OCZ actually) and I'd like
to test the latest variant again.

