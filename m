From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Updated osst driver for 2.6.x
Date: Sun, 28 Dec 2003 13:25:18 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031228132518.A20134@infradead.org>
References: <20031223174320.GU1277@linnie.riede.org> <20031223192626.A10262@infradead.org> <20031223212950.GW1277@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:56327 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261270AbTL1NZW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 28 Dec 2003 08:25:22 -0500
Content-Disposition: inline
In-Reply-To: <20031223212950.GW1277@linnie.riede.org>; from wrlk@riede.org on Tue, Dec 23, 2003 at 04:29:50PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org

On Tue, Dec 23, 2003 at 04:29:50PM -0500, Willem Riede wrote:
> > Please don't.  This is exactly what sysfs is for.
> > 
> I was afraid you were going to say that :-)
> 
> The 2.4 version I have on the osst web site has had this /proc file for some time,
> and I simply copied the logic over.
> 
> But if you don't want me to go there, I won't. I'll come back later with a sysfs
> version that provides that info. One question: should each parameter be in its
> own little file, or can I create them all on one line as I do now?

Yes, please do one value per file.

> In the mean time, here is the patch without the offending pieces.
> 
> Is this OK? Thanks, Willem Riede.

The patch looks okay to me.

