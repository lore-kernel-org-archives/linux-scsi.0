From: Christoph Hellwig <hch@lst.de>
Subject: Re: two more fixes for block/for-linus
Date: Tue, 23 Sep 2014 07:56:54 +0200
Message-ID: <20140923055654.GB10189@lst.de>
References: <1411394371-16254-1-git-send-email-hch@lst.de> <54202CF9.7050303@kernel.dk> <54206D0F.1010506@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54206D0F.1010506@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Elliott, Robert (Server Storage)" <elliott@hp.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 22, 2014 at 02:40:15PM -0400, Douglas Gilbert wrote:
> With these patches applied (actually a resync an hour
> ago with the for-linus tree which includes them), the
> freeze-during-boot-up problem that I have been seeing
> with an old SATA boot disk (perhaps 1.5 Gbps) for
> the last two weeks, has gone away.
>
> That SATA disk is connected to the motherboard (Gigabyte
> Z97M-D3H/Z97M-D3H, BIOS F5 05/30/2014) and has a standard
> AHCI interface as far as I can tell. dmesg confirms that.

Should have thought of the weird ATA error handling earlier.  Sorry Doug!
