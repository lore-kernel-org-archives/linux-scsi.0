From: Andrew Morton <akpm@osdl.org>
Subject: Re: [2.6 patch] show "Fusion MPT device support" menu only if
 BLK_DEV_SD
Date: Tue, 20 Jan 2004 16:03:46 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040120160346.7e466ad2.akpm@osdl.org>
References: <20040120232507.GC6441@fs.tum.de>
	<20040120233537.A23375@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20040120233537.A23375@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: bunk@fs.tum.de, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Jan 21, 2004 at 12:25:07AM +0100, Adrian Bunk wrote:
> > With BLK_DEV_SD=n, I see a "Fusion MPT device support" menu I can't 
> > enter.
> > 
> > The simple patch below removes the "Fusion MPT device support" menu if 
> > BLK_DEV_SD=n.
> 
> I'd rather see an explanation from LSI why a scsi LLDD depens on a uper
> driver.  This can't be right.

There's a hint in the config help:

          [2] In order enable capability to boot the linux kernel
          natively from a Fusion MPT target device, you MUST
          answer Y here! (currently requires CONFIG_BLK_DEV_SD)

But a kernel built with BLK_DEV_SD=n, FUSION=y builds and links OK.
