From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bugme-new] [Bug 11088] New: Warning about NULL pointer dereference
 when attaching usb hd
Date: Wed, 16 Jul 2008 09:40:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807160939250.2142-100000@iolanthe.rowland.org>
References: <4104961b0807152239k177262c8w2ad15077fe94c37f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55437 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755363AbYGPNkO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jul 2008 09:40:14 -0400
In-Reply-To: <4104961b0807152239k177262c8w2ad15077fe94c37f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, bugme-daemon@bugzilla.kernel.org, hanno@gentoo.org, akpm@linux-foundation.org

On Wed, 16 Jul 2008, jidong xiao wrote:

> Hi, Alan,
> 
> I disassembled the source code via kdb.
> slave_alloc+0x2b: call blk_queue_update_dma_alignment
> scsi_alloc_sdev+0x143: call scsi_adjust_queue_depth

> So the problems is, either sdev->request_queue or bulk_in_ep is NULL pointer.
> In my opinion, bulk_in_ep is more likely to be a NULL pointer as it is
> just calculated in the prior line.
> 
> What do you think about this issue?

Read the full report in Bugzilla and you'll see.

Alan Stern

