From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 04/12] scsi/NCR5380: use NCR5380_dprint() instead of
 NCR5380_print()
Date: Wed, 28 May 2014 02:49:41 -0700
Message-ID: <20140528094941.GD26617@infradead.org>
References: <20140318004212.612472697@telegraphics.com.au>
 <20140318004213.812935479@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaE1Jtn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 05:49:43 -0400
Content-Disposition: inline
In-Reply-To: <20140318004213.812935479@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org

On Tue, Mar 18, 2014 at 11:42:16AM +1100, Finn Thain wrote:
> Only the NCR5380_dprint() macro should invoke the NCR5380_print() function.
> That's why NCR5380.c only defines the function #if NDEBUG. Use the standard
> macro.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
