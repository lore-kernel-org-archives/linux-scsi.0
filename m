From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: PATAPI via libata promise 20275 (was: RFC: moving drivers to a new drivers/ata directory)
Date: Thu, 21 Oct 2004 20:53:34 +0200
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <58cb370e041021115367c80c55@mail.gmail.com>
References: <4176883D.7070905@pobox.com>
	 <200410211704.i9LH4jMR008268@falcon30.maxeymade.com>
Reply-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200410211704.i9LH4jMR008268@falcon30.maxeymade.com>
To: Doug Maxey <dwm@maxeymade.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Albert CC Lee <albertcc@tw.ibm.com>
List-Id: linux-scsi@vger.kernel.org

ATAPI is working just fine for me (ata_piix) in both PIO/DMA
and thanks to Jeff all my ATAPI work is now in -linus tree. :)

Just enable ATA_ENABLE_ATAPI in <linux/libata.h>.

On Thu, 21 Oct 2004 12:04:45 -0500, Doug Maxey <dwm@maxeymade.com> wrote:
> Continuing down a somewhat related path,  what is the outlook for PATAPI
> via libata?
> 
> There is a high level of interest to have hotplug controllers for ppc64, and
> the primary (exclusive at this point) application is to drive PATAPI optical.
> 
> I know you have indicated that you have some WIP to get there.  I would like
> to offer any help to reach that goal.
> 
> Would you point me to any code available?
> 
> ++doug
