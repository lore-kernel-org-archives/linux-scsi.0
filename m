From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libata: add TRIM support
Date: Tue, 17 Nov 2009 10:00:13 -0500
Message-ID: <20091117150012.GA10748@infradead.org>
References: <20091116154343.GA6672@infradead.org> <4B02AD86.8010304@rtr.ca> <20091117143507.GC588@infradead.org> <20091117145239.768072c9@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091117145239.768072c9@lxorguk.ukuu.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Lord <liml@rtr.ca>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2009 at 02:52:39PM +0000, Alan Cox wrote:
> I'm not convinced that is the right way to handle it. If we start doing
> that we'll have this massive unmanagable set of magic flags and twiddles
> for every possible host specific corner case.
> 
> Far better to keep the issue of the command as Christoph has done and
> block the command issue in the afflicted devices qc_issue so that you get
> an error back. That keeps the mess in the right places.

Ok, new version of the patch without this will go out this minute.  I'm
happy to add whatever patch is nessecary to block it for controllers
that can't accept it once we agree on a method.

