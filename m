From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6 patch] show "Fusion MPT device support" menu only if BLK_DEV_SD
Date: Tue, 20 Jan 2004 23:35:37 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120233537.A23375@infradead.org>
References: <20040120232507.GC6441@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:54283 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265918AbUATXfm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 18:35:42 -0500
Content-Disposition: inline
In-Reply-To: <20040120232507.GC6441@fs.tum.de>; from bunk@fs.tum.de on Wed, Jan 21, 2004 at 12:25:07AM +0100
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jan 21, 2004 at 12:25:07AM +0100, Adrian Bunk wrote:
> With BLK_DEV_SD=n, I see a "Fusion MPT device support" menu I can't 
> enter.
> 
> The simple patch below removes the "Fusion MPT device support" menu if 
> BLK_DEV_SD=n.

I'd rather see an explanation from LSI why a scsi LLDD depens on a uper
driver.  This can't be right.

