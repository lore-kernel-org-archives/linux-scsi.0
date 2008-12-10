From: "Dmitri Vorobiev" <dmitri.vorobiev@gmail.com>
Subject: cache `scsi_sense_cache': double free detected
Date: Wed, 10 Dec 2008 22:41:10 +0200
Message-ID: <90edad820812101241k50b95448hb5b3d753edf95b9e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:47608 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYLJUlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 15:41:11 -0500
Received: by yx-out-2324.google.com with SMTP id 8so334807yxm.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 12:41:10 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

wd33c93-0: chip=WD33c93B/13 no_sync=0x0 no_dma=0 debug_flags=0x00
           setup_args=,,,,,,,,,,
           Version 1.26++ - 10/Feb/2007, Compiled Dec 10 2008 at 22:08:31
scsi0 : SGI WD93
 sending SDTR 010301190c 010301190c sync_xfer=ac
scsi 0:0:4:0: Direct-Access     IBM      DNES-309170      SA30 PQ: 0 ANSI: 3
slab error in verify_redzone_free(): cache `scsi_sense_cache': double
free detected
Call Trace:
[<ffffffff8800a228>] dump_stack+0x8/0x38
[<ffffffff8809a218>] cache_free_debugcheck+0x2d0/0x300
[<ffffffff8809a7f0>] kmem_cache_free+0x58/0x130
[<ffffffff88192680>] scsi_pool_free_command+0x38/0x58
[<ffffffff88192750>] __scsi_put_command+0xb0/0xf8
[<ffffffff88199514>] scsi_next_command+0x34/0x58
[<ffffffff8819988c>] scsi_end_request+0xcc/0x108
[<ffffffff88199f34>] scsi_io_completion+0xe4/0x470
[<ffffffff881960b8>] scsi_eh_flush_done_q+0xb0/0x100
[<ffffffff8819750c>] scsi_error_handler+0x424/0x488
[<ffffffff8804e018>] kthread+0x58/0xa8
[<ffffffff8800fb68>] kernel_thread_helper+0x10/0x18

ffffffff8fa3f740: redzone 1:0x9f911029d74e35b, redzone 2:0x9f911029d74e35b.

BR,
Dmitri
