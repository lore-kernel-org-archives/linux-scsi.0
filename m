From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg
 helpers
Date: Mon, 16 Jul 2007 13:06:08 -0700
Message-ID: <20070716130608.4d096e29.akpm@linux-foundation.org>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
	<11845792681830-git-send-email-jens.axboe@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbXGPUGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 16:06:55 -0400
In-Reply-To: <11845792681830-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de

On Mon, 16 Jul 2007 11:47:23 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> This prepares x86-64 for sg chaining support.
> 
> Additional improvements/fixups for pci-gart from
> Benny Halevy <bhalevy@panasas.com>
> 
> Cc: ak@suse.de
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  arch/x86_64/kernel/pci-calgary.c |   25 ++++++++------
>  arch/x86_64/kernel/pci-gart.c    |   63 ++++++++++++++++++++-----------------
>  arch/x86_64/kernel/pci-nommu.c   |    5 ++-
>  3 files changed, 51 insertions(+), 42 deletions(-)

This causes fairly extensive destruction of 2.6.23 changes which are
pending in Andi's tree.

I shall drop the block tree until a) Andi has merged the pending Calgary
changes and b) the block tree has been fixed up to account for those (and
other) changes.

Really, this was the perfectly worst time possible to go tromping all over
everyone else's trees.

