From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] tmscsim: remove kernel kenel 2.2 #ifdef's
Date: Sat, 28 Feb 2004 10:00:17 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040228100017.A10822@infradead.org>
References: <20040228094732.GL5499@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:28940 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261175AbUB1KAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Feb 2004 05:00:21 -0500
Content-Disposition: inline
In-Reply-To: <20040228094732.GL5499@fs.tum.de>; from bunk@fs.tum.de on Sat, Feb 28, 2004 at 10:47:33AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Kurt Garloff <kurt@garloff.de>, ching@tekram.com.tw, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Feb 28, 2004 at 10:47:33AM +0100, Adrian Bunk wrote:
> The patch below removes #ifdefs for kernel 2.0 and 2.2 from the tmscsim 
> driver.

There's currently lots of patches for this driver pending, I'd rather
wait with these cleanups after they're in.

