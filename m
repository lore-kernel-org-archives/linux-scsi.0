From: Klaus Steinberger <Klaus.Steinberger@physik.uni-muenchen.de>
Subject: Re: Kernel OOPS with aacraid driver
Date: Fri, 22 Apr 2005 08:49:05 +0200
Message-ID: <200504220849.05896.Klaus.Steinberger@physik.uni-muenchen.de>
References: <200504220749.56416.Klaus.Steinberger@physik.uni-muenchen.de> <20050421232746.62bd4c9a.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.physik.uni-muenchen.de ([192.54.42.129]:59017 "EHLO
	mail.physik.uni-muenchen.de") by vger.kernel.org with ESMTP
	id S261988AbVDVGtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Apr 2005 02:49:19 -0400
In-Reply-To: <20050421232746.62bd4c9a.rddunlap@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Randy.Dunlap (OSDL)" <rddunlap@osdl.org>

Hello Randy,

> BTW, this says that this is the second oops:  "[#2]".
> What was the first one?
Apr 21 10:53:27 www adaptec-smbe: aiomgrd startup succeeded
Apr 21 10:53:27 www kernel: Unable to handle kernel NULL pointer dereference 
at virtual address 00000034
Apr 21 10:53:27 www kernel:  printing eip:
Apr 21 10:53:27 www kernel: c03227a0
Apr 21 10:53:27 www kernel: *pde = 36c2f001
Apr 21 10:53:27 www kernel: Oops: 0000 [#1]
Apr 21 10:53:27 www kernel: SMP
Apr 21 10:53:27 www kernel: Modules linked in: md5 ipv6 iptable_filter 
ip_tables tg3 floppy sg microcode ohci_hcd video button battery ac ext
3 jbd dm_mod aacraid aic79xx sd_mod scsi_mod
Apr 21 10:53:27 www kernel: CPU:    3
Apr 21 10:53:27 www kernel: EIP:    0060:[<c03227a0>]    Not tainted VLI
Apr 21 10:53:27 www kernel: EFLAGS: 00010086   (2.6.11-1.14_FC2.rootsmp)
Apr 21 10:53:27 www kernel: EIP is at _spin_lock_irqsave+0x10/0x60
Apr 21 10:53:27 www kernel: eax: 00000030   ebx: 00000286   ecx: bfff9b4c   
edx: bfff9b4c
Apr 21 10:53:27 www kernel: esi: 00000030   edi: 00000030   ebp: bfff9b4c   
esp: f5f52f14
Apr 21 10:53:27 www kernel: ds: 007b   es: 007b   ss: 0068
Apr 21 10:53:27 www kernel: Process aiomgrd (pid: 3003, threadinfo=f5f52000 
task=f7381020)
Apr 21 10:53:27 www kernel: Stack: 00000000 0000fe01 00042008 00000000 
f886ac4a 00042008 00000000 00000000
Apr 21 10:53:27 www kernel:        f8869b80 42676a06 00000000 42676a06 
00000000 42676a06 00042008 bfff9b4c
Apr 21 10:53:27 www kernel:        00000000 bfff9b4c f886a560 f8871d80 
f6c96880 ffffffe7 c017580a bfff9b4c
Apr 21 10:53:27 www kernel: Call Trace:
Apr 21 10:53:27 www kernel:  [<f886ac4a>] fib_alloc+0x1a/0x70 [aacraid]
Apr 21 10:53:27 www kernel:  [<f8869b80>] ioctl_send_fib+0x10/0x110 [aacraid]
Apr 21 10:53:27 www kernel:  [<f886a560>] aac_do_ioctl+0x60/0xcf [aacraid]
Apr 21 10:53:27 www kernel:  [<c017580a>] do_ioctl+0x6a/0x90
Apr 21 10:53:27 www kernel:  [<c0175a7e>] vfs_ioctl+0x5e/0x1d0
Apr 21 10:53:27 www kernel:  [<c0175c4b>] sys_ioctl+0x5b/0x90
Apr 21 10:53:27 www kernel:  [<c0104203>] syscall_call+0x7/0xb
Apr 21 10:53:27 www kernel: Code: af de 75 0c f0 83 28 01 79 05 e8 9c e4 ff ff 
c3 0f 0b d7 00 78 a7 33 c0 eb ea 90 83 ec 10 89 74 24 0c 89 c6
 89 5c 24 08 9c 5b fa <81> 78 04 ad 4e ad de 75 26 f0 fe 0e 79 13 f7 c3 00 02 
00 00 74


The same can be triggered by starting Adaptecs aaccli and giving the following 
command:

aaccli
CLI > controller list

Sincerly,
Klaus

-- 
Klaus Steinberger         Maier-Leibnitz Labor
Phone: (+49 89)289 14287  Am Coulombwall 6, D-85748 Garching, Germany
FAX:   (+49 89)289 14280  EMail: Klaus.Steinberger@Physik.Uni-Muenchen.DE
URL: http://www.physik.uni-muenchen.de/~k2/

In a world without Walls and Fences, who needs Windows and Gates
