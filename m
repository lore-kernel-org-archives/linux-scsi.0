From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/5] Modify ida_* users to use ida_simple_*
Date: Mon, 05 Oct 2015 10:52:48 -0700
Message-ID: <1444067568.2238.25.camel@HansenPartnership.com>
References: <cover.1443723136.git.lduncan@suse.com>
	 <20151005174426.GB11164@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151005174426.GB11164@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Lee Duncan <lduncan@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2015-10-05 at 13:44 -0400, Tejun Heo wrote:
> On Thu, Oct 01, 2015 at 11:59:04AM -0700, Lee Duncan wrote:
> > The ida index management routines are used in several
> > driver modules to manage allocation and release of
> > index values. Reviewing the way in which the
> > ida routines were called, together with the small
> > number of such clients, led to the belief that
> > these users should all be able to share a simple
> > built-in lock in the ida module by calling the
> > ida_simple_*() functions instead of the non-simple
> > versions. This means that ida does all the
> > required locking so that clients don't have to
> > manage that.
> 
> The whole series looks good to me.  Please feel free to add

Since they're all independent, they can go via the correct trees without
adverse consequences.  It's probably me: 1/5; Jens 2-4/5; Greg 5/5

James
