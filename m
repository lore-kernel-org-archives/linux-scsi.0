From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/12] scsi/NCR5380: remove unused BOARD_NORMAL and
 BOARD_NCR53C400
Date: Wed, 28 May 2014 02:48:49 -0700
Message-ID: <20140528094849.GA26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004212.932470722@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140318004212.932470722@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:13AM +1100, Finn Thain wrote:
> BOARD_NORMAL is completely unused and BOARD_NCR53C400 is used only by
> g_NCR5380 internally. Remove the unused definitions.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
