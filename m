From: Luben Tuikov <luben@splentec.com>
Subject: ide-scsi oops
Date: Mon, 23 Dec 2002 15:24:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E07710C.4010300@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id gBNKOgf16537
	for <linux-scsi@vger.kernel.org>; Mon, 23 Dec 2002 15:24:46 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

kernel 2.5.52 + Willem's patch, at boot:
----------------------------------------

scsi2 : SCSI host adapter emulation for IDE ATAPI devices
   Vendor: SONY      Model: CDU5211           Rev: YYS2
   Type:   CD-ROM                             ANSI SCSI revision: 02
ide-scsi: abort called for 40
Unable to handle kernel NULL pointer dereference at virtual address 00000030
  printing eip:
c02ae831
*pde = 00000000
Oops: 0000
CPU:    1
EIP:    0060:[<c02ae831>]    Not tainted
EFLAGS: 00010086
EIP is at idescsi_abort+0x61/0xc0
eax: 00000028   ebx: 00000082   ecx: f7d4b600   edx: 00000000
esi: 00000007   edi: f7fc85e0   ebp: c04d6068   esp: f7cabf60
ds: 0068   es: 0068   ss: 0068
Process scsi_eh_2 (pid: 15, threadinfo=f7caa000 task=f7cc20a0)
Stack: c0395b00 00000028 00000206 f7d4b600 f7caa000 00000000 c0290a84 f7d4b600
        f7d4b600 f7dbb740 c0290be8 f7d4b600 f7dbb740 f7dbb740 f7cabfc4 c0291645
        f7d4b600 f7dbb740 c010a173 f7d4b600 f7dbb740 c02917c8 f7dbb740 c03a3d1a
Call Trace:
  [<c0290a84>] scsi_try_to_abort_cmd+0x64/0x80
  [<c0290be8>] scsi_eh_abort_cmd+0x48/0x90
  [<c0291645>] scsi_unjam_host+0xa5/0xf0
  [<c010a173>] __down_failed_interruptible+0x7/0xc
  [<c02917c8>] scsi_error_handler+0x138/0x1d0
  [<c0291690>] scsi_error_handler+0x0/0x1d0
  [<c0108ffd>] kernel_thread_helper+0x5/0x18

Code: 39 42 30 74 42 89 2c 24 e8 92 94 fa ff 85 c0 75 26 c6 05 80

-- 
Luben


