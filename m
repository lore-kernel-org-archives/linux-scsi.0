From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: Re: syslog message
Date: Mon, 30 Aug 2004 10:16:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408301716.i7UHGagO008392@bach.leonora.org>
Reply-To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:40178
	"EHLO bach.leonora.org") by vger.kernel.org with ESMTP
	id S268577AbUH3RQi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 13:16:38 -0400
Received: from bach.leonora.org (localhost.localdomain [127.0.0.1])
	by bach.leonora.org (8.12.11/8.12.11) with ESMTP id i7UHGbRw008396
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 10:16:37 -0700
Received: from bach.leonora.org (vladimir@localhost)
	by bach.leonora.org (8.12.11/8.12.11/Submit) with ESMTP id i7UHGagO008392
	for <linux-scsi@vger.kernel.org>; Mon, 30 Aug 2004 10:16:37 -0700
In-Reply-To: Your message of "Mon, 30 Aug 2004 10:07:13 PDT."
List-Id: linux-scsi@vger.kernel.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

[Apologies for the previous incomplete message.]

This message:

   kernel: Badness in sym_complete_error at drivers/scsi/sym53c8xx_2/sym_hipd.c:5513
   kernel:  [<82886a76>] sym_complete_error+0x96/0x233 [sym53c8xx]
   kernel:  [<8288021f>] sym53c8xx_intr+0x59/0xc5 [sym53c8xx]
   kernel:  [<021073f1>] handle_IRQ_event+0x21/0x43
   kernel:  [<02107884>] do_IRQ+0x15f/0x22e
   kernel:  =======================
   kernel:  [<021168b6>] smp_apic_timer_interrupt+0x122/0x127
   kernel:  [<02104018>] default_idle+0x0/0x2c
   kernel:  [<022d007b>] unix_stream_data_wait+0x28/0x10c
   kernel:  [<02104041>] default_idle+0x29/0x2c
   kernel:  [<0210409d>] cpu_idle+0x26/0x3b
   kernel:  [<0238d78c>] start_kernel+0x1d0/0x1d5

was in my syslog. 

I have a ASUS CUV4X-DLS motherboard (2xPIII) running Fedora Core 2
kernel (2.6.8-1.525smp)


   kernel: SCSI subsystem initialized
   kernel: sym0: <1010-33> rev 0x1 at pci 0000:00:08.0 irq 177
   kernel: sym0: using 64 bit DMA addressing
   kernel: sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
   kernel: sym0: open drain IRQ line driver, using on-chip SRAM
   kernel: sym0: using LOAD/STORE-based firmware.
   kernel: sym0: handling phase mismatch from SCRIPTS.
   kernel: sym0: SCSI BUS has been reset.
   kernel: scsi0 : sym-2.1.18j
   kernel:   Vendor: QUANTUM   Model: ATLAS10K3_18_WLS  Rev: 020K
   kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
   kernel: sym0:6:0: tagged command queuing enabled, command queue depth 16.
   kernel: scsi(0:0:6:0): Beginning Domain Validation
   kernel: sym0:6: wide asynchronous.
   kernel: sym0:6: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 62)
   kernel: scsi(0:0:6:0): Ending Domain Validation
   kernel: SCSI device sda: 35916548 512-byte hdwr sectors (18389 MB)
   kernel: SCSI device sda: drive cache: write back
   kernel:  sda: sda1 sda2 sda3 sda4
   kernel: Attached scsi disk sda at scsi0, channel 0, id 6, lun 0

--- Vladimir

-- 
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014
