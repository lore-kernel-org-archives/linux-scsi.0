From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: 2.6.7 aic7xxx oops
Date: Thu, 1 Jul 2004 07:53:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040701075325.2adc333d.rddunlap@osdl.org>
References: <200407011631.22587.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:52448 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S265778AbUGAO5Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jul 2004 10:57:24 -0400
In-Reply-To: <200407011631.22587.bernd-schubert@web.de>
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd-schubert@web.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 1 Jul 2004 16:31:21 +0200 Bernd Schubert wrote:

| Hi,
| 
| on modprobing the aic7xxx module I just got this oops:
| 
| 
| Unable to handle kernel paging request at virtual address d08ae620
|  printing eip:
| c024e642
| *pde = 0f87b067
| Oops: 0002 [#1]
| PREEMPT SMP DEBUG_PAGEALLOC
| Modules linked in: aic7xxx mga uhci_hcd ohci_hcd md eeprom w83781d i2c_sensor 
| i2c_isa i2c_piix4 i2c_core
| CPU:    0
| EIP:    0060:[<c024e642>]    Not tainted
| EFLAGS: 00010286   (2.6.7-tc1) 
                      ~~~~~~~~~
What kernel (patches applied) is that?

| EIP is at kobject_add+0xc2/0x100
| eax: c04f5948   ebx: c04f58e4   ecx: d08ae620   edx: d0897340
| esi: c04f592c   edi: d0897324   ebp: c1c71f28   esp: c1c71f18
| ds: 007b   es: 007b   ss: 0068
| Process modprobe (pid: 1983, threadinfo=c1c70000 task=c1e11a60)
| Stack: c04f5950 d0897324 ffffffea 00000000 c1c71f40 c024e69d d0897324 d0897324 
|        d0897324 c04f58e0 c1c71f58 c02c03d3 d0897324 d08972e0 00000000 d0897388 
|        c1c71f74 c0258686 d0897304 d0897374 c04b7ae8 00000000 d0897180 c1c71f80 
| Call Trace:
|  [<c0108725>] show_stack+0x75/0x90
|  [<c0108885>] show_registers+0x125/0x180
|  [<c0108a1b>] die+0xab/0x170
|  [<c011c238>] do_page_fault+0x1e8/0x535
|  [<c010837d>] error_code+0x2d/0x40
|  [<c024e69d>] kobject_register+0x1d/0x50
|  [<c02c03d3>] bus_add_driver+0x43/0xb0
|  [<c0258686>] pci_register_driver+0x76/0xa0
|  [<d08846cd>] ahc_linux_pci_init+0xd/0x30 [aic7xxx]
|  [<d087b96e>] ahc_linux_detect+0x4e/0xa0 [aic7xxx]
|  [<d084b00d>] ahc_linux_init+0xd/0x22 [aic7xxx]
|  [<c013fb9f>] sys_init_module+0x15f/0x2f0
|  [<c01071e9>] sysenter_past_esp+0x52/0x79
| 
| Code: 89 11 8b 47 28 8b 18 8d 4b 48 89 c8 ba ff ff 00 00 f0 0f c1 


--
~Randy
