From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: sym53c8xx_2 make scsitap slow
Date: Thu, 13 Jan 2005 12:20:20 +0100
Message-ID: <m34qhld18r.fsf@merlin.emma.line.org>
References: <12890.1105611617@www67.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:48040 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261607AbVAMLUV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 06:20:21 -0500
In-Reply-To: <12890.1105611617@www67.gmx.net> (frage schnell's message of
	"Thu, 13 Jan 2005 11:20:17 +0100 (MET)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: frage schnell <frage.schnell1@gmx.de>
Cc: linux-scsi@vger.kernel.org

"frage schnell" <frage.schnell1@gmx.de> writes:

older SuSE kernel:

>   Vendor: HP        Model: Ultrium 1-SCSI    Rev: N27D  
>   Type:   Sequential-Access                  ANSI SCSI revision: 03  
> sym0:5: FAST-40 WIDE SCSI 80.0 MB/s ST (25.0 ns, offset 15)  

newer SuSE Linux 9.2 kernel:

>   Vendor: HP        Model: Ultrium 1-SCSI    Rev: N27D 
>   Type:   Sequential-Access                  ANSI SCSI revision: 03 
> scsi(1:0:5:0): Beginning Domain Validation
> scsi(1:0:5:0): Ending Domain Validation

No information on speed here after domain validation? Suspect.

Is your bus properly terminated (terminator at the end of your cable)?
Proper U2W LVD cable in use?

Or is write validation perhaps stepping on the brake to avoid accidents
because the cabling or termination is hosed?


Example from my machine (an older Tekram adaptor as you can see,
a DC-390F, which can do 16 bit and 20 MXfer/s, only single-ended):

Linux version 2.6.8-24.10-default (geeko@buildhost) (gcc version 3.3.4 (pre 3.3.
5 20040809)) #1 Wed Dec 22 11:54:27 UTC 2004
...
ACPI: PCI interrupt 0000:00:0d.0[A] -> GSI 11 (level, low) -> IRQ 11
sym0: <875> rev 0x26 at pci 0000:00:0d.0 irq 11
sym0: Tekram NVRAM, ID 7, Fast-20, SE, parity checking
sym0: SCSI BUS has been reset.
scsi0 : sym-2.1.18j
...
  Vendor: TANDBERG  Model:  TDC 4222         Rev: =07:
  Type:   Sequential-Access                  ANSI SCSI revision: 02
scsi(0:0:6:0): Beginning Domain Validation
sym0:6: FAST-5 SCSI 4.8 MB/s ST (208.0 ns, offset 8)
scsi(0:0:6:0): Domain Validation skipping write tests
scsi(0:0:6:0): Ending Domain Validation
  Vendor: TANDBERG  Model: SLR6              Rev: 0404
  Type:   Sequential-Access                  ANSI SCSI revision: 02
scsi(0:0:8:0): Beginning Domain Validation
sym0:8: wide asynchronous.
sym0:8: FAST-20 WIDE SCSI 40.0 MB/s ST (50.0 ns, offset 15)
scsi(0:0:8:0): Domain Validation skipping write tests
scsi(0:0:8:0): Ending Domain Validation
...




Please do not forward or Cc: posts to the linux-scsi
mailing list to my mailbox, I'm on the list.

-- 
Matthias Andree
