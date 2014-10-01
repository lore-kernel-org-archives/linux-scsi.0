From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 0/2] wd719x: Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver
Date: Wed, 1 Oct 2014 22:22:13 +0200
Message-ID: <201410012222.14159.linux@rainbow-software.org>
References: <1411757808-12530-1-git-send-email-linux@rainbow-software.org> <20141001181907.GA668@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141001181907.GA668@infradead.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, Kernel development list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wednesday 01 October 2014 20:19:07 Christoph Hellwig wrote:
> On Fri, Sep 26, 2014 at 08:56:46PM +0200, Ondrej Zary wrote:
> > The card requires firmware that can be cut out of the Windows NT driver
> > that can be downloaded from WD at:
> > http://support.wdc.com/product/download.asp?groupid=801&sid=27&lang=en
> > There is no license anywhere in the file or on the page - so I guess that
> > the firmware cannot be added to linux-firmware.
> >
> > This script downloads and extracts the firmware:
> >
> > #!/bin/sh
> > wget http://support.wdc.com/download/archive/pciscsi.exe
> > lha xi pciscsi.exe pci-scsi.exe
> > lha xi pci-scsi.exe nt/wd7296a.sys
> > rm pci-scsi.exe
> > dd if=wd7296a.sys of=wd719x-risc.bin bs=1 skip=5760 count=14336
> > dd if=wd7296a.sys of=wd719x-wcs.bin bs=1 skip=20096 count=514
> > rm wd7296a.sys
>
> Might be worth to add this script to the tree somewhere.

Maybe somewhere in Documentation?

Unfortunately, there is no single place to collect scripts like this.
DVB has nice script at Documentation/dvb/get_dvb_firmware.
But e.g. b43 requires an extrnal tool called b43-fwcutter.

> I'd be happy to merge the driver, but I'd love to get a second review
> for it first.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ondrej Zary
