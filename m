From: Jim Paris <jim@jtan.com>
Subject: Re: [PATCH 4/4] cdrom: revert commit 22a9189 (cdrom: use kmalloced
	buffers instead of buffers on stack)
Date: Tue, 20 May 2008 03:42:04 -0400
Message-ID: <20080520074203.GA20933@jim.sh>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1211259514-9131-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1211259514-9131-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1211259514-9131-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1211259514-9131-5-git-send-email-fujita.tomonori@lab.ntt.co.jp> <87skwdv39v.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87skwdv39v.fsf@denkblock.local>
Sender: linux-ide-owner@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, akpm@linux-foundation.org, davem@davemloft.net
List-Id: linux-scsi@vger.kernel.org

Elias Oltmanns wrote:
> > +	char buffer[255];
> >  	int ret;
> >  
> > -	buffer = kmalloc(255, GFP_KERNEL);
> > -	if (!buffer)
> > -		return -ENOMEM;
> > -
> > -	init_cdrom_command(&cgc, buffer, 4, CGC_DATA_READ);
> > +	init_cdrom_command(&cgc, &buffer, 4, CGC_DATA_READ);
> 				 ^
> Careful here.

They're the same in C.

-jim
