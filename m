From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] nsp32/nsp_cs driver update
Date: Wed, 3 Nov 2004 10:06:45 +0000
Message-ID: <20041103100645.GA18193@infradead.org>
References: <20041103.141557.74746586.yokota@netlab.is.tsukuba.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:27143 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261497AbUKCKGr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Nov 2004 05:06:47 -0500
Content-Disposition: inline
In-Reply-To: <20041103.141557.74746586.yokota@netlab.is.tsukuba.ac.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yokota Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2004 at 02:15:57PM +0900, Yokota Hiroshi wrote:
>  Hello.
> 
>  "nsp32" and "nsp_cs" driver is now updated for kernel 2.6.9.
> The patch file can download from:
> 
> http://www.netlab.is.tsukuba.ac.jp/~yokota/archive/linux-2.6.9-nsp20041103.diff.bz2

there had been various changes to the nsp32 driver after 2.6.9.  Also
some of your changes are reverting earlier changes. 

Please submit small changes that fix one issue each agains the current
tree in BK.

