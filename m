From: William Lee Irwin III <wli@holomorphy.com>
Subject: 2.5.59 qlogicisp.c oops
Date: Fri, 17 Jan 2003 17:34:35 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030118013435.GI940@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wli by holomorphy with local (Exim 3.34 #1 (Debian))
	id 18ZhsZ-0003a9-00
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jan 2003 17:34:35 -0800
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Unable to handle kernel NULL pointer dereference a
t virtual address 00000150
 printing eip:
c0214f98
*pde = 0073c001
Oops: 0002
CPU:    2
EIP:    0060:[<c0214f98>]    Not tainted
EFLAGS: 00010046                        
EIP is at isp1020_intr_handler+0x248/0x2f8
eax: 00000000   ebx: d802e140   ecx: 00000000   edx: 00000000
esi: d8065400   edi: 00000002   ebp: d8d99f04   esp: d8d99ee0
ds: 007b   es: 007b   ss: 0068                               
Process swapper (pid: 0, threadinfo=d8d98000 task=d8d9cc80)
Stack: d802e140 d8065410 d8065400 00000002 00000006 00000006 d8065498 d8065400 
       00000000 d8d99f24 c0214d27 00000013 d8065400 d8d99f74 d8defec0 24000001 
       00000013 d8d99f44 c010b034 00000013 d8065400 d8d99f74 c0307a70 c0307a60 
Call Trace:                                                                    
 [<c0214d27>] do_isp1020_intr_handler+0x4b/0x74
 [<c010b034>] handle_IRQ_event+0x28/0x50       
 [<c010b2bd>] do_IRQ+0xf1/0x194         
 [<c0106f04>] default_idle+0x0/0x34
 [<c01099fc>] common_interrupt+0x18/0x20
 [<c0106f04>] default_idle+0x0/0x34
 [<c0106f30>] default_idle+0x2c/0x34
 [<c0106fc6>] cpu_idle+0x3a/0x48
 [<c011fd18>] printk+0x1b0/0x1f4
 
Code: 89 82 50 01 00 00 83 c4 04 eb 0d 8b 4d fc c7 81 50 01 00 00
 <0>Kernel panic: Aiee, killing interrupt handler!
In interrupt handler - not syncing

