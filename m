From: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: aacraid broken in git
Date: Fri, 18 Apr 2008 18:55:42 -0700
Message-ID: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755030AbYDSB4A@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mark_Salyzyn@adaptec.com, James.Bottomley@hansenpartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

4/18 2.6-git got

Calling initcall 0xffffffff80f10f97: aac_init+0x0/0x95()
Adaptec aacraid driver 1.1-5[2455]-ms
ACPI: PCI Interrupt 0000:04:00.0[A] -> Link [LNEB] -> GSI 18 (level, low) -> IRQ
 18
PCI: Enabling bus mastering for device 0000:04:00.0
PCI: Setting latency timer of device 0000:04:00.0 to 64
AAC0: kernel 5.2-0[15594]
AAC0: monitor 5.2-0[15594]
AAC0: bios 5.2-0[15594]
AAC0: serial AA0009
AAC0: Non-DASD support enabled.
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
aac_fib_free, XferState != 0, fibptr = 0xffff8108232e0000, XferState = 0x810ad
ACPI: PCI interrupt for device 0000:04:00.0 disabled
aacraid: probe of 0000:04:00.0 failed with error -4
initcall 0xffffffff80f10f97: aac_init+0x0/0x95() returned 0.
initcall 0xffffffff80f10f97 ran for 286 msecs: aac_init+0x0/0x95()


Linux LBSuse 2.6.25-x86-latest.git-01659-g1f8551e #106 SMP Fri Apr 18
18:24:39 PDT 2008 x86_64 x86_64 x86_64 GNU/Linux

YH
