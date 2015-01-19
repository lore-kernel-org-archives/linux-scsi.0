From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Mon, 19 Jan 2015 01:21:53 -0800
Message-ID: <20150119092153.GA8666@infradead.org>
References: <54B63F74.2040702@sandisk.com>
 <20150115090829.GA14154@infradead.org>
 <54B7E70C.8020304@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54B7E70C.8020304@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 15, 2015 at 05:13:00PM +0100, Bart Van Assche wrote:
> My goal is to realize this proposal without adding hooks for out-of-tree
> code in the upstream kernel. What I had in mind is to raise the
> abstraction level of the API between LIO core and target drivers a
> little bit (e.g. by using accessor functions where necessary instead of
> accessing structure members directly)

That's very much a hook, althiugh a week one.

Either way I don't think bringing up a very much political topic
without even any code to discuss isn't a very valueable use of our time
slots.
