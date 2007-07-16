From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg helpers
Date: Tue, 17 Jul 2007 01:08:12 +0300
Message-ID: <20070716220812.GL4902@rhun.haifa.ibm.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792681830-git-send-email-jens.axboe@oracle.com> <20070716130608.4d096e29.akpm@linux-foundation.org> <20070716201002.GQ5195@kernel.dk> <20070716133427.e212b753.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765657AbXGPWIp@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070716133427.e212b753.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 16, 2007 at 01:34:27PM -0700, Andrew Morton wrote:

> > I'll keep rebasing sglist and the other branches I pull into for-akpm,
> > so you can just re-enable the for-akpm pull when the a) is true.
> 
> Andi's tree is very out of date and is about to be damaged (to what
> extent I don't yet know) by a xen merge.  I don't know if a) is
> going to happen.

The Xen and Calgary bits are mutually exclusive, so hopefully (a) will
not be held up on account of the Xen merge (or for any other
reason... CalIOC2 machines which are out there won't boot without it
if CONFIG_CALGARY_IOMMU is enabled).

Cheers,
Muli
