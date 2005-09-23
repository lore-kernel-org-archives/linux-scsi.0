From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] updated version of Jens' SATA suspend-to-ram patch
Date: Fri, 23 Sep 2005 13:23:54 -0700 (PDT)
Message-ID: <Pine.LNX.4.58.0509231323120.3325@g5.osdl.org>
References: <20050923163334.GA13567@triplehelix.org> <20050923180711.GH22655@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050923180711.GH22655@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: joshk@triplehelix.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org



On Fri, 23 Sep 2005, Jens Axboe wrote:
> 
> Port looks fine, thanks. The only problem I've seen with the base patch
> is that sometimes ata_do_simple_cmd() seems to be invoked right before a
> previous command has completed. So I needed this addon to work around
> that issue.

Ok. Can we have this in -mm for a few days just to shake out anything 
interesting, and then merge it into mainline?

		Linus
