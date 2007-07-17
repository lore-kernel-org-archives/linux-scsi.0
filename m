From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 09:57:03 +0900
Message-ID: <20070717095703X.fujita.tomonori@lab.ntt.co.jp>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:35635 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbXGQA5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 20:57:14 -0400
In-Reply-To: <a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satyam.sharma@gmail.com
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 06:22:25 +0530

> On 7/17/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> 
> CONFIG_BLK_DEV_BSG=y
> CONFIG_SCSI=m
> 
> block/built-in.o: In function `bsg_init':
> block/bsg.c:1097: undefined reference to `scsi_register_interface'
> make: *** [.tmp_vmlinux1] Error 1

This should be fixed by the following commit (thanks !):

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29417b899a77aaba1c060f5e123db4f50006f58a
