From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/13] target: Inline struct se_tmr_req into se_cmd
Date: Mon, 26 Mar 2012 05:25:59 -0400
Message-ID: <20120326092559.GB27806@infradead.org>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com>
 <1327009163-10177-8-git-send-email-agrover@redhat.com>
 <20120120161209.GA22481@infradead.org>
 <4F19A80B.6000902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F19A80B.6000902@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kiran.patil@intel.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 20, 2012 at 09:44:43AM -0800, Andy Grover wrote:
> On 01/20/2012 08:12 AM, Christoph Hellwig wrote:
> > On Thu, Jan 19, 2012 at 01:39:17PM -0800, Andy Grover wrote:
> >> This saves all fabrics from calling core_tmr_alloc_req() and
> >> having to check the result. The downside is se_cmd gets bigger for all
> >> requests, but hopefully later patches will reduce it.
> > 
> > Without patches to void the overhead it's not acceptable. Fortunately
> > it should be doable fairly simply by using an union for command vs
> > TMR fields.
> 
> This was my thought too. We should be able to move cmd variables into a
> union w/tmr struct very soon, with a low risk of introducing bugs.

Any plans on going back to this?
