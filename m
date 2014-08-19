From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] drivers: message: fusion: Simplify rounding
Date: Tue, 19 Aug 2014 12:12:15 -0500
Message-ID: <20140819171215.GA12722@infradead.org>
References: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1404219380-2712-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 01, 2014 at 02:56:20PM +0200, Rasmus Villemoes wrote:
> Rounding up to a multiple of 4 should be done using the ALIGN
> macro. As a bonus, this also makes the generated code smaller.
> 
> In GetIocFacts(), sz is assigned to a few lines below without being
> read in the meantime, so it is ok that it doesn't end up with the same
> value as facts->FWImageSize.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Reviewed-by: Joe Lawrence <joe.lawrence@stratus.com>

Thanks, applied to the drivers-for-3.18 branch.
