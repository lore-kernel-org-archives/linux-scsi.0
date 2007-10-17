From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 13:11:46 +0200
Message-ID: <20071017111146.GW5043@kernel.dk>
References: <20071017.035441.74746708.davem@davemloft.net> <20071017105840.GT5043@kernel.dk> <20071017110142.GU5043@kernel.dk> <20071017.041004.21594558.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934726AbXJQLM2@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20071017.041004.21594558.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Wed, 17 Oct 2007 13:01:42 +0200
> 
> > Actually, just clearing AFTER sg_next() would be fine, since we know
> > that is not a link entry. Duh...
> 
> Yes and I'm running a kernel successfully with this fix.

Great!

> Jens, please also add the following on top of Fujita-san's most recent
> sparc64 patch and we should be good to go.

Awesome, thanks. And sorry for messing up sparc64.

-- 
Jens Axboe
