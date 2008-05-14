From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: blk_queue_init_tags warning
Date: Tue, 13 May 2008 21:37:49 -0500
Message-ID: <1210732670.3077.79.camel@localhost.localdomain>
References: <86802c440805131900r2c3cca56sb45f80f26dc65780@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57383 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbYENChx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2008 22:37:53 -0400
In-Reply-To: <86802c440805131900r2c3cca56sb45f80f26dc65780@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Tue, 2008-05-13 at 19:00 -0700, Yinghai Lu wrote:
> ------------[ cut here ]------------
> WARNING: at include/linux/blkdev.h:431 blk_queue_init_tags+0xfe/0x154()
> Modules linked in:
> Pid: 1509, comm: scsi_wq_0 Not tainted
> 2.6.26-rc1-sched-devel.git-x86-latest.git-00589-g5bb43f9-dirty #382

Fixed by aa94b5371f6f898558d9fa5690cc6e4bf917a572 in -rc2.

James


