From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/5] sg_ring for scsi
Date: Thu, 20 Dec 2007 08:58:53 +0100
Message-ID: <20071220075852.GI13958@kernel.dk>
References: <200712201645.19035.rusty@rustcorp.com.au> <20071220160741K.fujita.tomonori@lab.ntt.co.jp> <200712201853.48643.rusty@rustcorp.com.au> <20071219.235807.173273479.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759584AbXLTIDp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071219.235807.173273479.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: rusty@rustcorp.com.au, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, dougg@torque.net
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 19 2007, David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Thu, 20 Dec 2007 18:53:48 +1100
> 
> > Manipulating the magic chains is horrible; it looks simple to the
> > places which simply want to iterate through it, but it's awful for
> > code which wants to create them.
> 
> I'm not saying complexity is inherent in this stuff, but
> assuming that it is the complexity should live as far away
> from the minions (the iterators in this case).  Therefore,
> the creators is the right spot for the hard stuff.

Agree, and the missing bit is just moving the creators out of the driver
parts and into a core helper. See the previous post on the 'sg' branch
for 2.6.25.

-- 
Jens Axboe

