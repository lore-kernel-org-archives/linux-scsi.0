From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SATA suspend-to-ram patch - merge?
Date: Thu, 22 Sep 2005 15:28:55 +0100
Message-ID: <20050922142855.GA29672@infradead.org>
References: <433104E0.4090308@triplehelix.org> <433221A1.5000600@pobox.com> <20050922061849.GJ7929@suse.de> <4332ABDC.3030106@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4332ABDC.3030106@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Jens Axboe <axboe@suse.de>, Jeff Garzik <jgarzik@pobox.com>, Joshua Kwan <joshk@triplehelix.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 22, 2005 at 09:04:28AM -0400, Mark Lord wrote:
> Rather than sitting around for another six months hoping the problem
> will go away (it won't), perhaps we should just update/merge Jen's
> patch as a sorely needed interim fix.
> 
> This might then prod James et al into looking more at the SCSI side of
> things, and some year we might see this get replaced with a better scheme.
> 
> This is a real problem, and an immediate solution is needed last spring.

Folks, bitching around on lkml on this won't get you far.  Send the
patch to linux-scsi again, and explain what's the current stance on the
disk synchronize cache and spindown issues.
