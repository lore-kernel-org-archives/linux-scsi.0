From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Date: Mon, 24 Mar 2008 21:19:25 -0700
Message-ID: <20080324211925.dcd25237.akpm@linux-foundation.org>
References: <47E875AD.1000901@rtr.ca>
	<47E87942.2020409@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47E87942.2020409@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 25 Mar 2008 00:02:10 -0400 Mark Lord <lkml@rtr.ca> wrote:

> Is it time now for HDIO_GETGEO64 to make an appearance?
> Similar to how the existing BLKGETSIZE64 is supplanting BLKGETSIZE ?

That sounds useful.

But you're the one who has investigated this - please make a recommendation?
