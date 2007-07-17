From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 06:22:25 +0530
Message-ID: <a781481a0707161752v3dcb794cvc9b9c2f8812def57@mail.gmail.com>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.181]:25792 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbXGQAw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 20:52:28 -0400
Received: by ik-out-1112.google.com with SMTP id b32so758926ika
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jul 2007 17:52:26 -0700 (PDT)
In-Reply-To: <20070716165706.348f6bbf.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 7/17/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>

CONFIG_BLK_DEV_BSG=y
CONFIG_SCSI=m

block/built-in.o: In function `bsg_init':
block/bsg.c:1097: undefined reference to `scsi_register_interface'
make: *** [.tmp_vmlinux1] Error 1

on latest -git.

Satyam
