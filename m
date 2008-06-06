From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: blk_queue_hardsect_size 520-byte sector
Date: Fri, 6 Jun 2008 12:36:17 +0200
Message-ID: <20080606103616.GO5757@kernel.dk>
References: <339116.28290.qm@web32404.mail.mud.yahoo.com> <20080606075432.GH5757@kernel.dk> <20080606111807.44d0be02@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756912AbYFFKge@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080606111807.44d0be02@core>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Anil kumar <anils_r@yahoo.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 06 2008, Alan Cox wrote:
> On Fri, 6 Jun 2008 09:54:33 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Thu, Jun 05 2008, Anil kumar wrote:
> > > Hi,
> > > 
> > > Can I call blk_queue_hardsect_size in a driver and set it to 520-byte
> > > as hardware sector size.  How does the kernel and block layers take
> > > the request, will it be in multiples of 520-bytes aligned or 512 bytes
> > > aligned?
> > 
> > No, Linux only supports power-of-2 hardware block sizes I'm afraid.
> 
> And only some of those - which is why we can't support CP/M disks and
> also early smartmedia stuff (128/256 byte/sector)

Right, should've made that clearer - Linux only really supports
power-of-2 hw block sizes, where the size is >= 512 and <=
PAGE_CACHE_SIZE.

-- 
Jens Axboe
