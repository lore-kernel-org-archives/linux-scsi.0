From: Jeff Garzik <jgarzik@pobox.com>
Subject: [Fwd: Re: libata oops 2.6.11-rc4 yesterdays BK]
Date: Wed, 16 Feb 2005 12:26:29 -0500
Message-ID: <42138245.8080806@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010508020905020205090309"
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:16340 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262010AbVBPR0o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2005 12:26:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

This is a multi-part message in MIME format.
--------------010508020905020205090309
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Did anything in SCSI change recently that could be associated with this 
oops?

--------------010508020905020205090309
Content-Type: message/rfc822;
 name="Re: libata oops 2.6.11-rc4 yesterdays BK"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Re: libata oops 2.6.11-rc4 yesterdays BK"

Return-Path: <SRS0=46ll=Q6=vger.kernel.org=linux-ide-owner@bounce2.pobox.com>
X-Original-To: garzik@gtf.org
Delivered-To: garzik@gtf.org
Received: from integer.pobox.com (integer.pobox.com [208.58.1.194])
	by havoc.gtf.org (Postfix) with ESMTP id E8F821C0A815
	for <garzik@gtf.org>; Wed, 16 Feb 2005 06:01:49 -0500 (EST)
Received: from integer.pobox.com (localhost [127.0.0.1])
	by integer.pobox.com (Postfix) with ESMTP id B05E4FC82C
	for <garzik@gtf.org>; Wed, 16 Feb 2005 06:01:47 -0500 (EST)
Delivered-To: jgarzik@pobox.com
Received: from vger.kernel.org (vger.kernel.org [12.107.209.244])
	by integer.pobox.com (Postfix) with ESMTP id 0F0E5FC7FA;
	Wed, 16 Feb 2005 06:01:46 -0500 (EST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S262003AbVBPLBl (ORCPT <rfc822;andyw@pobox.com> + 1 other);
	Wed, 16 Feb 2005 06:01:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S262004AbVBPLBl
	(ORCPT <rfc822;linux-ide-outgoing>); Wed, 16 Feb 2005 06:01:41 -0500
Received: from wasp.net.au ([203.190.192.17]:34228 "EHLO wasp.net.au")
	by vger.kernel.org with ESMTP id S262003AbVBPLBd (ORCPT
	<rfc822;linux-ide@vger.kernel.org>); Wed, 16 Feb 2005 06:01:33 -0500
Received: from [127.0.0.1] (softdnserr [::ffff:127.0.0.1])
  by wasp.net.au with esmtp; Wed, 16 Feb 2005 19:01:28 +0800
  id 00045C37.42132809.00003A7C
Message-ID: <42132803.2080701@wasp.net.au>
Date: Wed, 16 Feb 2005 15:01:23 +0400
From: Brad Campbell <brad@wasp.net.au>
User-Agent: Mozilla Thunderbird 1.0 (X11/20050115)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
Subject: Re: libata oops 2.6.11-rc4 yesterdays BK
References: <4212CBD6.7020703@wasp.net.au>
In-Reply-To: <4212CBD6.7020703@wasp.net.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-ide-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-ide@vger.kernel.org
X-Spam-Checker-Version: SpamAssassin 3.0.1 (2004-10-22) on havoc.gtf.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=7.0 tests=AWL,BAYES_00,SPF_HELO_PASS,
	SPF_PASS autolearn=ham version=3.0.1
X-IMAPbase: 1107904907 3161
X-UID: 3160
X-Keywords: 

Brad Campbell wrote:
> Woke up to this, this morning.
> This is yesterdays 2.6.11-rc4 BK + libata BK + libata-dev BK
> It was in the middle of a RAID-6 rebuild (scheduled to take about 740 
> minutes)
> 

Oh well, it appears to be reproducible anyway!

Regards,
Brad

ata15: status=0x51 { DriveReady SeekComplete Error }
ata15: called with no error (51)!
------------[ cut here ]------------
kernel BUG at drivers/scsi/scsi.c:299!
invalid operand: 0000 [#1]
CPU:    0
EIP:    0060:[<c0257a0b>]    Not tainted VLI
EFLAGS: 00010046   (2.6.11-rc4)
EIP is at scsi_put_command+0x8b/0xa0
eax: ddaf85c0   ebx: ddaf85c0   ecx: ddaf85d0   edx: ddaf85d0
esi: dfc70000   edi: 00000292   ebp: dfc66400   esp: dfcabe7c
ds: 007b   es: 007b   ss: 0068
Process scsi_eh_14 (pid: 799, threadinfo=dfcaa000 task=dfc73a20)
Stack: df945f58 dfcc6200 dfc65a28 ddaf85c0 00000296 dfc65a28 c025c859 ddaf85c0
        df945f58 c025c97f ddaf85c0 00000001 00000000 ddaf85c0 ddaf85c0 00000004
        ddaf867c c025ccfe ddaf85c0 00000001 00000000 00000000 000057a8 000057a8
Call Trace:
  [<c025c859>] scsi_next_command+0x19/0x30
  [<c025c97f>] scsi_end_request+0xbf/0xe0
  [<c025ccfe>] scsi_io_completion+0x1ae/0x490
  [<c026927b>] sd_rw_intr+0xcb/0x280
  [<c02580ea>] scsi_finish_command+0x7a/0xc0
  [<c0266ad9>] ata_scsi_qc_complete+0x39/0x70
  [<c026460a>] ata_qc_complete+0x3a/0xc0
  [<c0267e30>] pdc_eng_timeout+0x90/0x120
  [<c026663a>] ata_scsi_error+0x1a/0x30
  [<c025bd4e>] scsi_error_handler+0x9e/0xe0
  [<c025bcb0>] scsi_error_handler+0x0/0xe0
  [<c0100831>] kernel_thread_helper+0x5/0x14
Code: 5c 24 08 8b 74 24 0c 89 44 24 1c 8b 7c 24 10 8b 6c 24 14 83 c4 18 e9 e5 15
  fd ff 89 43 10 89 48 04 31 db 89 51 04 89 4e 0c eb b7 <0f> 0b 2b 01 e7 1a 32 c0
  eb 95 8d 74 26 00 8d bc 27 00 00 00 00
  <1>Unable to handle kernel NULL pointer dereference at virtual address 00000004
  printing eip:
c01333c3
*pde = 00000000
Oops: 0000 [#2]
CPU:    0
EIP:    0060:[<c01333c3>]    Not tainted VLI
EFLAGS: 00010016   (2.6.11-rc4)
EIP is at free_block+0x43/0xd0
eax: 00800000   ebx: 00000000   ecx: 00000000   edx: c1000000
esi: c1506d60   edi: 00000000   ebp: c1506d6c   esp: c14e9ef0
ds: 007b   es: 007b   ss: 0068
Process events/0 (pid: 3, threadinfo=c14e8000 task=c14da020)
Stack: c14da020 dffe69f0 c1506d7c dff08b70 dff08b60 00000001 c1506d60 c0133a0a
        c1506d60 dff08b70 00000001 c1506d60 00000001 c1506dd0 c1506a7c c0133aaa
        c1506d60 dff08b60 00000000 c14da170 00000293 00000000 c051fca4 c0133a50
Call Trace:
  [<c0133a0a>] drain_array_locked+0x7a/0xc0
  [<c0133aaa>] cache_reap+0x5a/0x150
  [<c0133a50>] cache_reap+0x0/0x150
  [<c012326e>] worker_thread+0x19e/0x240
  [<c0111b50>] default_wake_function+0x0/0x20
  [<c0111b50>] default_wake_function+0x0/0x20
  [<c01230d0>] worker_thread+0x0/0x240
  [<c0126ae5>] kthread+0xa5/0xb0
  [<c0126a40>] kthread+0x0/0xb0
  [<c0100831>] kernel_thread_helper+0x5/0x14
Code: 83 00 00 00 8d 46 1c 8d 6e 0c 89 44 24 08 8b 44 24 24 8b 15 b0 fd 51 c0 8b
  0c b8 8d 81 00 00 00 40 c1 e8 0c c1 e0 05 8b 5c 02 1c <8b> 53 04 8b 03 89 50 04
  89 02 c7 43 04 00 02 20 00 2b 4b 0c c7



-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
-
To unsubscribe from this list: send the line "unsubscribe linux-ide" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------010508020905020205090309--
