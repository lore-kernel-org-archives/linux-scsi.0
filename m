From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/12] scsi/NCR5380: merge sun3_scsi_vme.c into
 sun3_scsi.c
Date: Wed, 28 May 2014 02:55:44 -0700
Message-ID: <20140528095544.GL26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004216.172443207@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140318004216.172443207@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:24AM +1100, Finn Thain wrote:
> The sun3 drivers suffer from a whole bunch of duplicated code. Fix this
> by following the g_NCR5380_mmio example. (Notionally, sun3_scsi relates to
> sun3_scsi_vme in the same way that g_NCR5380 relates to g_NCR5380_mmio.)
> 
> Dead code is also removed: we now have working debug macros so
> SUN3_SCSI_DEBUG is undesirable. Dead code within #ifdef OLD_DMA is also
> dropped, consistent with sun3_scsi_vme.c.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
