From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 05/12] scsi/NCR5380: fix build failures when debugging
 is enabled
Date: Wed, 28 May 2014 22:09:33 +1000 (EST)
Message-ID: <alpine.LNX.2.00.1405282207580.31798@nippy.intranet>
References: <20140318004212.612472697@telegraphics.com.au> <20140318004214.102469994@telegraphics.com.au> <20140528095015.GE26617@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140528095015.GE26617@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 28 May 2014, Christoph Hellwig wrote:

> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks for reviewing. There was a later submission (version 2) with 
changes made to three of these patches,

[PATCH v2 05/12] scsi/NCR5380: fix build failures when debugging is enabled
[PATCH v2 06/12] scsi/NCR5380: fix dprintk macro usage and definition
[PATCH v2 09/12] scsi/NCR5380: fix and standardize NDEBUG macros

And several patches in the v2 submission had some acked-by tags added.

The v2 series is the one to merge (but I think James intends to do that).

-- 
