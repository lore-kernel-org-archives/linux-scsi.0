From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [fyi] BusLogic module removal causes an oops, 2.6.3
Date: Sun, 22 Feb 2004 17:38:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040222173815.2f08e469.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:20623 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261790AbUBWBhc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Feb 2004 20:37:32 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: doyle@primenet.com



Begin forwarded message:

Date: Sun, 22 Feb 2004 19:20:32 -0500
From: David Ford <david+challenge-response@blue-labs.org>
To: linux-kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [fyi] BusLogic module removal causes an oops, 2.6.3


Unable to handle kernel paging request at virtual address e098f090
 printing eip:
e098f090
*pde = 1ff70067
*pte = 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<e098f090>]    Tainted: PF
EFLAGS: 00210286
EIP is at 0xe098f090
eax: 0000001f   ebx: c06e01c4   ecx: 00009000   edx: dffef0c0
esi: 00000880   edi: c05dce38   ebp: 00000000   esp: d11f3f3c
ds: 007b   es: 007b   ss: 0068
Process rmmod (pid: 8235, threadinfo=d11f2000 task=d61fad40)
Stack: e0a30c8a c06e01c4 00009000 00000100 c06e01c4 e0a30cea c06e0000 
e0a35440
       c0138789 e0a35440 bffff798 0000003b 00000000 4c737542 6369676f 
c014e900
       d4b90280 d54d0180 d7b49680 40016000 40017000 40017000 d7b49680 
d4b90280
Call Trace:
 [<e0a30c8a>] BusLogic_ReleaseHostAdapter+0x4a/0x70 [BusLogic]
 [<e0a30cea>] BusLogic_exit+0x3a/0x49 [BusLogic]
 [<c0138789>] sys_delete_module+0x139/0x1b0
 [<c014e900>] do_munmap+0x50/0x190
 [<c0109335>] sysenter_past_esp+0x52/0x71

Code:  Bad EIP value.

-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

