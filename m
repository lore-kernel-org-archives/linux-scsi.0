From: "Vladimir G. Ivanovic" <vladimir@acm.org>
Subject: Re: sym53c8xx_2 version 2.1.18j domain validation failures (was Re: Sym53c8xx_2)
Date: Sat, 21 Aug 2004 19:45:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408220245.i7M2j0DQ012126@bach.leonora.org>
References: <4127D208.6010600@jound.net>
Reply-To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-052-249.sfo1.dsl.speakeasy.net ([64.81.52.249]:46062
	"EHLO bach.leonora.org") by vger.kernel.org with ESMTP
	id S265768AbUHVCpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Aug 2004 22:45:02 -0400
Received: from bach.leonora.org (localhost.localdomain [127.0.0.1])
	by bach.leonora.org (8.12.11/8.12.11) with ESMTP id i7M2j1GU012134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Sat, 21 Aug 2004 19:45:01 -0700
Received: from bach.leonora.org (vladimir@localhost)
	by bach.leonora.org (8.12.11/8.12.11/Submit) with ESMTP id i7M2j0DQ012126
	for <linux-scsi@vger.kernel.org>; Sat, 21 Aug 2004 19:45:01 -0700
In-Reply-To: Your message of "Sat, 21 Aug 2004 18:51:52 EDT."
             <4127D208.6010600@jound.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have posted to this list examples of the kinds of errors that I get
with my Atlas drive, but I haven't gotten any response or suggestion on
how to debug.

My boot command line includes "buschk:0x2", and my smartd configuration
file includes "/dev/sda -a -d scsi". 

Here are some examples (more or less in chronological order). (I've
elided the date and time, and my machine name from entries below. I can
provide them if anyone wishes.)  

Boot-time information:

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

Right after smartd starts up:

   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).
   kernel: sym0:6:0:ODD transfer in DATA IN phase.
   kernel: sym0:6:0:COMMAND FAILED (87 0 10).

Still during bootup, but I can't associate any particular event with the
errors: 

   kernel: sym0:6:0:ordered tag forced.
   kernel: sym0:6:0:ordered tag forced.

Here is are the errors I get during a typical night:

   kernel: sym0:6: ERROR (81:0) (8-0-0) (3e/18/80) @ (scripta 50:f31c0004).
   kernel: sym0: script cmd = 90080000
   kernel: sym0: regdump: da 00 00 18 47 3e 06 0f 00 08 86 00 80 00 07 0a 89 cd c1 e9 02 00 00 00.
   kernel: sym0: SCSI BUS reset detected.
   kernel: sym0: SCSI BUS has been reset.

   kernel:   "ff ff ff 7f b1 2d 24 02 8c 41 44 02 c0 6c 34 02 "
   kernel: sym0:6: ERROR (81:0) (8-0-0) (3e/18/80) @ (scripta 50:f31c0004).
   kernel: sym0: script cmd = 90080000
   kernel: sym0: regdump: da 00 00 18 47 3e 06 0f 04 08 86 00 80 00 0f 0a 89 cd c1 e9 02 00 00 00.
   kernel: sym0: SCSI BUS reset detected.
   kernel: sym0: SCSI BUS has been reset.

--- Vladimir

------------------------------------------------------------------------
Vladimir G. Ivanovic                        http://leonora.org/~vladimir
Palo Alto, CA 94306                                      +1 650 678 8014
------------------------------------------------------------------------
