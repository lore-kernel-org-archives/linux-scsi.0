From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/5] Modify ida_* users to use ida_simple_*
Date: Mon, 5 Oct 2015 13:44:26 -0400
Message-ID: <20151005174426.GB11164@htj.duckdns.org>
References: <cover.1443723136.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1443723136.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 01, 2015 at 11:59:04AM -0700, Lee Duncan wrote:
> The ida index management routines are used in several
> driver modules to manage allocation and release of
> index values. Reviewing the way in which the
> ida routines were called, together with the small
> number of such clients, led to the belief that
> these users should all be able to share a simple
> built-in lock in the ida module by calling the
> ida_simple_*() functions instead of the non-simple
> versions. This means that ida does all the
> required locking so that clients don't have to
> manage that.

The whole series looks good to me.  Please feel free to add

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
