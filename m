From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] iscsi-target: Fix memory leak if iscsit_alloc_buffs()
 fails
Date: Mon, 26 Mar 2012 05:25:06 -0400
Message-ID: <20120326092506.GA27806@infradead.org>
References: <1330046923-4034-1-git-send-email-roland@kernel.org>
 <20120225092455.GA23775@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60520
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755197Ab2CZJZJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Mar 2012 05:25:09 -0400
Content-Disposition: inline
In-Reply-To: <20120225092455.GA23775@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Sat, Feb 25, 2012 at 04:24:55AM -0500, Christoph Hellwig wrote:
> On Thu, Feb 23, 2012 at 05:28:43PM -0800, Roland Dreier wrote:
> > From: Roland Dreier <roland@purestorage.com>
> > 
> > The function kzalloc()s sgl, but if page allocation fails, it never
> > frees sgl on the page_alloc_failed path.
> 
> Can we fix this properly by killing the code?  After the last round
> of cleanups there is no reason why iscsi can't use the generic page
> allocation code in transport_generic_get_mem().

Nic?  Looks like the original version got in instead.

