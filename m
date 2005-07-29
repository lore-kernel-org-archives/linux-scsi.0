From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] libata ATAPI alignment
Date: Fri, 29 Jul 2005 14:38:54 +0100
Message-ID: <1122644334.13581.42.camel@localhost.localdomain>
References: <20050729050654.GA10413@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050729050654.GA10413@havoc.gtf.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <axboe@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Gwe, 2005-07-29 at 01:06 -0400, Jeff Garzik wrote:
> So, one thing that's terribly ugly about SATA ATAPI is that we need to
> pad DMA transfers to the next 32-bit boundary, if the length is not
> evenly divisible by 4.

Looks good and avoids the special case leaking into the core code.

> Complicating matters, we currently must support two methods of data
> buffer submission:  a single kernel virtual address, or a struct
> scatterlist.

For the moment - also you turn the single buffer into a one entry sglist
so its not to bad.

> Review is requested by any and all parties, as well as suggestions for
> a prettier approach.

I'd pull the code into seperate functions but thats my only real
comment.
