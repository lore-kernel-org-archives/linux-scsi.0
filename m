From: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 03:01:29 +0200
Message-ID: <469C14E9.5070909@googlemail.com>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org> <a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:15077 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760675AbXGQBCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 21:02:17 -0400
Received: by ug-out-1314.google.com with SMTP id j3so48392ugf
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2007 18:02:15 -0700 (PDT)
In-Reply-To: <a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Satyam Sharma wrote:
> On 7/17/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>   
>
> CONFIG_BLK_DEV_BSG=y
> CONFIG_SCSI=m
>
> block/built-in.o: In function `bsg_init':
> block/bsg.c:1097: undefined reference to `scsi_register_interface'
> make: *** [.tmp_vmlinux1] Error 1
>
> on latest -git.
>   

Should be fixed by this commit :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=29417b899a77aaba1c060f5e123db4f50006f58a

> Satyam
>
>   

Gabriel

