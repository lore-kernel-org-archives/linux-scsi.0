From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] dm-mq and end_clone_request()
Date: Sun, 7 Aug 2016 15:31:11 -0700
Message-ID: <ae1a211d-9351-e5fa-e3cb-0a9ba5be9dcd@acm.org>
References: <20160801175948.GA6685@redhat.com>
	<eb1af921-d874-1f6a-c5d0-12d3cae04256@sandisk.com>
	<20160804161047.GC6989@redhat.com>
	<4d60017e-818c-5630-549e-bf280abcf1c3@sandisk.com>
	<20160804235850.GB13132@redhat.com>
	<1649218.8261013.1470359248073.JavaMail.zimbra@redhat.com>
	<1931660518.8323360.1470397410683.JavaMail.zimbra@redhat.com>
	<73e2aeda-140d-72ab-d295-57f35139ae55@sandisk.com>
	<1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf1.bxl.stone.is ([87.238.167.36]:48995 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbcHGXRV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Aug 2016 19:17:21 -0400
In-Reply-To: <1616390775.11191.1470494853559.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/06/16 07:47, Laurence Oberman wrote:
> [66813.933246] Workqueue: srp_remove srp_remove_work [ib_srp]
> [ ... ]
> [66815.152051]  [<ffffffff814ac790>] scsi_forget_host+0x60/0x70
> [66815.183939]  [<ffffffff814a0137>] scsi_remove_host+0x77/0x110
> [66815.216152]  [<ffffffffa0677be0>] srp_remove_work+0x90/0x200 [ib_srp]
> [66815.253221]  [<ffffffff810a2e72>] process_one_work+0x152/0x400
> [66815.286221]  [<ffffffff810a3765>] worker_thread+0x125/0x4b0
> [66815.317313]  [<ffffffff810a3640>] ? rescuer_thread+0x380/0x380
> [66815.349770]  [<ffffffff810a9298>] kthread+0xd8/0xf0
> [66815.376082]  [<ffffffff816c6b3f>] ret_from_fork+0x1f/0x40
> [66815.404767]  [<ffffffff810a91c0>] ? kthread_park+0x60/0x60

Hello Laurence,

This is a callstack I have not yet encountered myself during any test. 
Please provide the output of the following commands:
$ gdb /lib/modules/$(uname -r)/build/vmlinux
(gdb) list *(scsi_forget_host+0x60)

Thanks,

Bart.

