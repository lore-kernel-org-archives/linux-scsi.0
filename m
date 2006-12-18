From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 2/2] cciss: fix XFER_READ/XFER_WRITE in do_cciss_request
Date: Mon, 18 Dec 2006 10:58:53 +0100
Message-ID: <20061218095852.GF5010@kernel.dk>
References: <20061215212817.GA10996@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:11384 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbWLRJ5O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Dec 2006 04:57:14 -0500
Content-Disposition: inline
In-Reply-To: <20061215212817.GA10996@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, daniel_frazier@hp.com, andrew.patterson@hp.com

On Fri, Dec 15 2006, Mike Miller (OS Dev) wrote:
> Patch 2 of 2
> 
> This patch fixes a stupid bug. Sometime during the 2tb enhancement I ended up
> replacing the macros XFER_READ and XFER_WRITE with h->cciss_read and
> h->cciss_write respectively. It seemed to work somehow at least on x86_64 and
> ia64. I don't know how. But people started complaining about command timeouts
> on older controllers like the 64xx series and only on ia32. This resolves the
> issue reproduced in our lab. Please consider this for inclusion. 

Great, works here as well. Applied 1+2.

-- 
Jens Axboe

