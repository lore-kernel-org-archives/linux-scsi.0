From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add release function to sd for scsi_disk structure
Date: Wed, 22 Oct 2003 17:17:31 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031022171731.B24857@infradead.org>
References: <20031018074040.GA1210@beaverton.ibm.com> <20031021092654.A22958@infradead.org> <20031022160855.GC1684@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:1555 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263504AbTJVQRg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 12:17:36 -0400
Content-Disposition: inline
In-Reply-To: <20031022160855.GC1684@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Oct 22, 2003 at 09:08:55AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On Wed, Oct 22, 2003 at 09:08:55AM -0700, Mike Anderson wrote:
> Christoph Hellwig [hch@infradead.org] wrote:
> > 
> > This looks like a reasonable bandaid until the block layer is fixed.  
> > 
> 
> Since I do not know the extent of the block layer changes maybe my
> assumption is incorrect, but wouldn't will still need a release of some
> kind to know when it is safe to do a free?

We'll have to see.  My assumption would be that freeing any private
data should be fine after ->remove.  If that's not going to be guaranteed
we should try to make your patch a bit more generic (e.g. no sd-specific
ktype)

