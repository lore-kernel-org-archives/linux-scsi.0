From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Tue, 26 Oct 2004 01:20:08 +0200
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <58cb370e0410251620279fb0ee@mail.gmail.com>
References: <58cb370e041024054575c09679@mail.gmail.com>
	 <200410252255.i9PMto6B024865@falcon10.austin.ibm.com>
Reply-To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200410252255.i9PMto6B024865@falcon10.austin.ibm.com>
To: Doug Maxey <dwm@austin.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@samba.org>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 25 Oct 2004 17:55:50 -0500, Doug Maxey <dwm@austin.ibm.com> wrote:

> >The dependency is a bug, <linux/ide.h> is for IDE driver only.
> 
> The isd200 _is_ a bridge to ATA/ATAPI devices.  Does this mean it cannot use
> common code, just because it is not in drivers/ide?

no but the common ATA/ATAPI code resides in hdreg.h or/and ata.h,
ide.h is for IDE driver _only_

> >Doug, if you kill debugging code in isd200.c then only:
> >
> >id->command_set_1
> >id->model
> >id->fw_rev
> >id->capability
> >id->lba_capacity
> >id->heads
> >id->cyls
> >id->sectors
> >id->command_set_2
> >
> >need to be byte-swapped.
> >
> 
> I don't plan on killing any debug code.

I do :)
