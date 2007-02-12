From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Fwd: kernel oops SCSI tape drive access kernel 2.6.18
Date: Mon, 12 Feb 2007 23:50:55 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0702122332530.6245@kai.makisara.local>
References: <20070212204752.kkm3rcnvlk84kg4g@raudies.homeip.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:34858 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030194AbXBLVws (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Feb 2007 16:52:48 -0500
In-Reply-To: <20070212204752.kkm3rcnvlk84kg4g@raudies.homeip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Paulus <oliver@code-project.org>
Cc: linux-scsi@vger.kernel.org

On Mon, 12 Feb 2007, Oliver Paulus wrote:

> Hello,
> 
> I get a kernel oops if I want to read from my SCSI HP tape (C5683A) drive -
> using tar command.
> 
> Here my system information:
> 1. Kernel: 2.6.18-3-vserver-amd64
> 2. OS: Debian Etch
> 
...
> I get a kernel oops if I want to access the /dev/st0 with tar (or mondorescue
> restore - because this program uses tar too). Here the oops info:
> Feb  8 20:15:35 hal9000 kernel: st0: Block limits 1 - 16777215 bytes.
> Feb  8 20:15:56 hal9000 kernel: Unable to handle kernel paging request at
> ffff82bc8057b000 RIP:
> Feb  8 20:15:56 hal9000 kernel:  [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
> Feb  8 20:15:56 hal9000 kernel: PGD 0
> Feb  8 20:15:56 hal9000 kernel: Oops: 0000 [13] SMP
> Feb  8 20:15:56 hal9000 kernel: CPU 0
> Feb  8 20:15:56 hal9000 kernel: Modules linked in: usb_storage cdc_acm ipv6
> dm_snapshot dm_mirror dm_mod loop snd_hda_intel snd_hda_codec serio_raw snd_pcm
> snd_timer snd soundcore snd_page_alloc pcspkr psmouse shpchp pci_hotplug st
> joydev evdev ext3 jbd mbcache raid1 md_mod ide_generic sd_mod ide_cd cdrom
> usbhid aic7xxx scsi_transport_spi via_rhine mii ehci_hcd sata_via via82cxxx
> uhci_hcd libata scsi_mod generic ide_core processor
> Feb  8 20:15:56 hal9000 kernel: Pid: 16448, comm: tar Not tainted
> 2.6.18-3-vserver-amd64 #1
> Feb  8 20:15:56 hal9000 kernel: RIP: 0010:[<ffffffff8020748b>]
> [<ffffffff8020748b>] kmem_cache_free+0x42/0x1bb
...
> Would be great if you can help me. Is this an already known issue?
> 
It may be a known issue. A somewhat similar oops was reported in the 
Bugzilla item 7919. See 
http://marc.theaimsgroup.com/?l=linux-scsi&m=117050154700255&w=2
for more information and a patch. The patch is also in the current linux 
git tree.

Kai
