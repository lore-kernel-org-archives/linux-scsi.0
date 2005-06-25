From: Andrew Morton <akpm@osdl.org>
Subject: Fw: 2.6.12-git1 onwards: oops whilst reading /proc
 (scsi_is_host_device, adaptec)
Date: Sat, 25 Jun 2005 12:34:47 -0700
Message-ID: <20050625123447.0c781025.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:7338 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261254AbVFYTfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 15:35:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin J. Bligh" <mbligh@mbligh.org>



Begin forwarded message:

Date: Sat, 25 Jun 2005 09:01:18 -0700
From: "Martin J. Bligh" <mbligh@mbligh.org>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.12-git1 onwards: oops whilst reading /proc (scsi_is_host_device, adaptec)


I get lots of these whilst doing runs ... Doesn't happen in 2.6.12, but
does in 2.6.12-git1 onwards.

http://ftp.kernel.org/pub/linux/kernel/people/mbligh/abat/6712/debug/console.log

Unable to handle kernel NULL pointer dereference at virtual address 00000124
 printing eip:
c02ef66c
*pde = 0650e001
*pte = 00000000
Oops: 0000 [#2]
SMP 
CPU:    1
EIP:    0060:[<c02ef66c>]    Not tainted VLI
EFLAGS: 00010296   (2.6.12-git7-autokern1) 
EIP is at scsi_is_host_device+0x4/0x18
eax: 00000014   ebx: 00000014   ecx: 00000000   edx: d7506b80
esi: 00000000   edi: d630c500   ebp: ca5c9ef4   esp: ca5c9dac
ds: 007b   es: 007b   ss: 0068
Process cp (pid: 9354, threadinfo=ca5c8000 task=d39d6540)
Stack: c030f59b 00000014 00000000 ca5c9ef4 d7755200 0000000f 4130fa43 c030fb09 
       d7755200 ca5c9ef4 00000007 00000041 00000000 00000000 ca5c9f68 00000c00 
       d6ada000 ca5c9f64 37636961 3a393938 746c5520 36316172 69572030 43206564 
Call Trace:
 [<c030f59b>] ahc_dump_target_state+0xa3/0x10c
 [<c030fb09>] ahc_linux_proc_info+0x199/0x1ca
 [<c0141fb8>] do_anonymous_page+0x1f0/0x21c
 [<c0141fd0>] do_anonymous_page+0x208/0x21c
 [<c0142039>] do_no_page+0x55/0x3d8
 [<c0136335>] prep_new_page+0x49/0x50
 [<c01369c3>] buffered_rmqueue+0x153/0x1b4
 [<c0136e6b>] __alloc_pages+0x3bb/0x3c8
 [<c02f72bb>] proc_scsi_read+0x2b/0x44
 [<c017dc58>] proc_file_read+0xec/0x200
 [<c0150bf0>] vfs_read+0x90/0xec
 [<c0150e7c>] sys_read+0x40/0x6c
 [<c0102e49>] syscall_call+0x7/0xb
Code: fd ff 83 c4 04 c3 90 68 40 8d 46 c0 e8 2a 30 fd ff 83 c4 04 c3 89 f6 68 40 8d 46 c0 e8 a6 30 fd ff 83 c4 04 c3 89 f6 8b 44 24 04 <81> b8 10 01 00 00 10 f1 2e c0 0f 94 c0 0f b6 c0 c3 8d 76 00 8b 

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
