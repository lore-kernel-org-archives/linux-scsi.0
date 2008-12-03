From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Wed, 03 Dec 2008 09:09:00 -0600
Message-ID: <1228316941.5551.6.camel@localhost.localdomain>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	 <20081203100643.GA29340@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081203100643.GA29340@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bzolnier@gmail.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-12-03 at 05:06 -0500, Christoph Hellwig wrote:
> On Wed, Dec 03, 2008 at 10:38:54AM +0900, FUJITA Tomonori wrote:
> > This is for 2.6.29 (not 2.6.28) as feature-removal-schedule.txt says.
> > 
> > It's against linux-next (which seems to has some changes to ide-scsi
> > for 2.6.29 from the ide tree). 
> 
> Isn't ide-scsi the only way to use ATAPI OnStream tapes supported by
> the osst driver?

Depends.  If you're still using drivers/ide then yes, it is.  With
libata (which is what most modern distros use), osst just works as an
ATAPI transport.

git log tells me ide-scsi has been updated quite a bit recently, but it
mostly looks to be fallout around the drivers/ide churn.  Can we get ide
maintainer's buy in for this (I think they've been maintaining ide-tape
and ide-cd in preference to ide-scsi)?

James


