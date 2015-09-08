From: Jiang Liu <jiang.liu@linux.intel.com>
Subject: Re: [Bugfix] PCI, x86: Correctly allocate IRQs for PCI devices
 managed by non-PCI drivers
Date: Tue, 8 Sep 2015 17:44:57 +0800
Message-ID: <55EEAE19.2070606@linux.intel.com>
References: <55EE8106.6060100@internode.on.net>
 <1441697190-27993-1-git-send-email-jiang.liu@linux.intel.com>
 <55EEA45D.2070709@internode.on.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <55EEA45D.2070709@internode.on.net>
Sender: linux-pci-owner@vger.kernel.org
To: Arthur Marsh <arthur.marsh@internode.on.net>, Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2015/9/8 17:03, Arthur Marsh wrote:
> 
> 
> Jiang Liu wrote on 08/09/15 16:56:
> Thanks, I removed the test patch and applied the revised patch and built
> and rebooted the kernel and successfully mounted file systems on a disk
> attached to the DPT 2044W card using the eata driver:
> 
> [    0.000000] Linux version 4.2.0+ (root@victoria) (gcc version 5.2.1
> 20150903
> (Debian 5.2.1-16) ) #31 SMP PREEMPT Tue Sep 8 17:36:28 ACST 2015
> ...
> 
> [   80.691097] EATA0: IRQ 10 mapped to IO-APIC IRQ 17.
> [   80.724519] EATA/DMA 2.0x: Copyright (C) 1994-2003 Dario Ballabio.
> [   80.752035] EATA config options -> tm:1, lc:y, mq:16, rs:y, et:n,
> ip:n, ep:n, pp:y.
> [   80.777063] EATA0: 2.0C, PCI 0xd890, IRQ 17, BMST, SG 122, MB 64.
> [   80.802391] EATA0: wide SCSI support enabled, max_id 16, max_lun 8.
> [   80.827959] EATA0: SCSI channel 0 enabled, host target ID 7.
> [   80.853413] scsi host3: EATA/DMA 2.0x rev. 8.10.00
> [   82.445662] scsi 3:0:6:0: Direct-Access     IBM      DCAS-34330W
>  S65A PQ: 0 ANSI: 2
> [   82.471584] scsi 3:0:6:0: cmds/lun 16, sorted, simple tags.
> [   84.571451] sd 3:0:6:0: Attached scsi generic sg4 type 0
> [   84.597572] sd 3:0:6:0: [sdd] 8466688 512-byte logical blocks: (4.33
> GB/4.03 GiB)
> [   84.659874] sd 3:0:6:0: [sdd] Write Protect is off
> [   84.688543] sd 3:0:6:0: [sdd] Mode Sense: b3 00 00 08
> [   84.714021] sd 3:0:6:0: [sdd] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [   84.817682]  sdd: sdd1 sdd2 < sdd5 >
> [   84.919267] sd 3:0:6:0: [sdd] Attached SCSI disk
Hi Arthur,
Thanks for testing:)

> 
> Arthur.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
