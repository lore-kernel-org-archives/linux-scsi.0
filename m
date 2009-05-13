From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense: Logical block address out of range, sector 0
Date: Tue, 12 May 2009 19:27:23 -0700
Message-ID: <20090513022723.GU21505@hexapodia.org>
References: <20090421015234.GA7014@hexapodia.org> <20090422144904.407df635.akpm@linux-foundation.org> <49F00EBB.7040504@gmail.com> <20090423070713.GF19113@hexapodia.org> <20090512215256.GA22095@hexapodia.org> <4A0A050D.4000804@gmail.com> <20090513010056.GT21505@hexapodia.org> <51f3faa70905121808x29c12a35n6905104f45883f17@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51f3faa70905121808x29c12a35n6905104f45883f17@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 12, 2009 at 07:08:54PM -0600, Robert Hancock wrote:
> On Tue, May 12, 2009 at 7:00 PM, Andy Isaacson <adi@hexapodia.org> wrote:
> > Perhaps, I haven't tracked down exactly what the difference in behavior
> > between working 2.6.29 and broken 2.6.30-rc2 is. ?It seems like the disk
> > spins up more often (in response to hal background probes presumably)
> > with 30-rc2 than it did before, and running "udevadm monitor" I do see
> > the following repeated "change" events happening, even on an idle
> > system:
> >
> > KERNEL[1242175547.793029] change ? /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0 (scsi)
> > KERNEL[1242175547.794669] change ? /devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0 (block)
[snip]
> Those events seem rather suspicious. Hmm:
> 
> [    2.770959] ata2.00: ATAPI: TSSTcorp DVD+/-RW TS-U633A, D200, max
> UDMA/100, ATAPI AN
> 
> Did libata report it was using ATAPI AN in 2.6.29?

Yes, AN is present in every log I have for that device (back to
2.6.28.1).

> You could try bisecting to see if you can find which patch started
> triggering those spurious events..

Heh, I was dreading a bisect where each step burned a coaster, but just
looking for events is easy.  I'll try that tomorrow.

-andy
