From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: qlogicpti driver hangs the machine
Date: Mon, 29 Sep 2008 09:04:31 -0500
Message-ID: <1222697071.3150.0.camel@localhost.localdomain>
References: <20080924.014553.221132445.davem@davemloft.net>
	 <48DA01A6.1010807@panasas.com>
	 <Pine.SOC.4.64.0809241240440.5968@math.ut.ee>
	 <20080928.134336.26891578.davem@davemloft.net>
	 <20080929063355.GK2677@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20080929063355.GK2677@kernel.dk>
Sender: sparclinux-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: David Miller <davem@davemloft.net>, mroos@ut.ee, bharrosh@panasas.com, matthew@wil.cx, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-09-29 at 08:33 +0200, Jens Axboe wrote:
> On Sun, Sep 28 2008, David Miller wrote:
> > From: Meelis Roos <mroos@ut.ee>
> > Date: Wed, 24 Sep 2008 12:51:09 +0300 (EEST)
> > 
> > > > Subject: [PATCH] fix fall out of sg-chaining patch
> > > > 
> > > > I've reviewed all patches since Matthew's, and I find one small
> > > > problem.
> > > > 
> > > > In the load_cmd() there is a compound loop where the first 4 sg's are
> > > > set then the rest are set into a memory structure in group of 7 sg's.
> > > > 
> > > > Well the second 7-group and on is a bug because sg pointer does not advance.
> > > > This is a fall out from Jens's patch.
> > > > 
> > > > I'm not sure if this is it but it should be fixed
> > > 
> > > This definitely helps,
> > 
> > Can we get this bug fix merged if it isn't already?
> 
> I'll take care of it.

Actually, I already have it in rc fixes which are due out this morning.

James


