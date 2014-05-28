From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/12] scsi/NCR5380: reduce depth of sun3_scsi nested
 includes
Date: Wed, 28 May 2014 02:55:15 -0700
Message-ID: <20140528095515.GK26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004215.872456456@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140318004215.872456456@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:23AM +1100, Finn Thain wrote:
> Move the #include "NCR5380.h" out of the sun3_scsi.h header file and into
> the driver .c files, like all the other NCR5380 drivers in the tree.
> 
> This improves uniformity and reduces the depth of nested includes. The
> sequence of #include's, #define's and #if's no longer does my head in.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
