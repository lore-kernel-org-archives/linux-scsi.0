From: Christoph Hellwig <hch@infradead.org>
Subject: Re: many-disk support
Date: Mon, 29 Dec 2003 11:06:04 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031229110603.A27408@infradead.org>
References: <20031229022549.50bae6d7.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:25356 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263002AbTL2LGF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2003 06:06:05 -0500
Content-Disposition: inline
In-Reply-To: <20031229022549.50bae6d7.akpm@osdl.org>; from akpm@osdl.org on Mon, Dec 29, 2003 at 02:25:49AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, "viro@parcelfarce.linux.theplanet.co.uk" <viro@parcelfarce.linux.theplanet.co.uk>

On Mon, Dec 29, 2003 at 02:25:49AM -0800, Andrew Morton wrote:
> Guys, I've had this patch for ages.  Badari seemed to say that it wasn't
> the "right" way to do it.
> 
> Can we get this nailed down please?

 - I think the bitmap overhead was killing us on big x86 machines, right?
   so that might need some swork.
 - a config option definitly is the wrong way to go.
 - I don't think assigning more numbers to the last major is a bad idea,
   better assign them to the first one, maybe with a hole for what we're
   using the other majors currently for, so when udev gets more mature
   we can kill the additional majors.

