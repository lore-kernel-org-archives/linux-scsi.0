From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Tue, 24 Aug 2004 21:50:39 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824205039.GC16196@parcelfarce.linux.theplanet.co.uk>
References: <20040824203914.GA25755@us.ibm.com> <200408242048.i7OKmtRQ002174@bach.leonora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:11435 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268300AbUHXUul
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 16:50:41 -0400
Content-Disposition: inline
In-Reply-To: <200408242048.i7OKmtRQ002174@bach.leonora.org>
List-Id: linux-scsi@vger.kernel.org
To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Cc: Mike Anderson <andmike@us.ibm.com>, Olaf Hering <olh@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Anton Blanchard <anton@samba.org>

On Tue, Aug 24, 2004 at 01:48:55PM -0700, Vladimir G. Ivanovic wrote:
> I don't know what an ACARD is, but I have similar issues when I boot my
> SMP system (ASUS CUV4X-DLS).
> 
>    kernel: VFS: Mounted root (ext2 filesystem).
>    kernel: SCSI subsystem initialized
>    kernel: ACPI: PCI interrupt 0000:00:08.0[A] -> GSI 19 (level, low) -> IRQ 177
>    kernel: sym0: <1010-33> rev 0x1 at pci 0000:00:08.0 irq 177
>    kernel: sym0: using 64 bit DMA addressing
>    kernel: sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
>    kernel: sym0: open drain IRQ line driver, using on-chip SRAM
>    kernel: sym0: using LOAD/STORE-based firmware.
>    kernel: sym0: handling phase mismatch from SCRIPTS.
>    kernel: sym0: SCSI BUS has been reset.
>    kernel: scsi0 : sym-2.1.18j
>    kernel:   Vendor: QUANTUM   Model: ATLAS10K3_18_WLS  Rev: 020K
>    kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
>    kernel: sym0:6:0: tagged command queuing enabled, command queue depth 16.
>    kernel: scsi(0:0:6:0): Beginning Domain Validation
>    kernel: sym0:6: wide asynchronous.
>    kernel: sym0:6: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
>    kernel: scsi(0:0:6:0): Ending Domain Validation
>    kernel: SCSI device sda: 35916548 512-byte hdwr sectors (18389 MB)
>    kernel: SCSI device sda: drive cache: write back
>    kernel:  sda: sda1 sda2 sda3 sda4
>    kernel: Attached scsi disk sda at scsi0, channel 0, id 6, lun 0
>    kernel: ACPI: PCI interrupt 0000:00:08.1[B] -> GSI 16 (level, low) -> IRQ 185

Erm, I see no sign of any problem in this log.  You negotiated to 160MB/s.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
