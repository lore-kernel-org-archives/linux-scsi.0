From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg helpers
Date: Tue, 17 Jul 2007 14:10:00 +0300
Message-ID: <20070717111000.GE18721@rhun.ibm.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792681830-git-send-email-jens.axboe@oracle.com> <20070717110312.GD18721@rhun.ibm.com> <20070717110502.GO5195@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54676 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbXGQLKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 07:10:23 -0400
Content-Disposition: inline
In-Reply-To: <20070717110502.GO5195@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de

On Tue, Jul 17, 2007 at 01:05:03PM +0200, Jens Axboe wrote:

> > FYI, here's the Calgary diff on top of the outstanding Calgary
> > changes.
> 
> When are these bits being merged into mainline? I'll hang on to this
> version for helping me rebase the arch bits of chained sglists once
> that happens.

I sincerely hope they'll make 2.6.23 but Andi appears to have fallen
into a black hole.

Cheers,
Muli
