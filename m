From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block
	pc	requests	and simplify hw handlers
Date: Wed, 8 Jun 2005 09:09:37 +0200
Message-ID: <20050608070937.GB5749@suse.de>
References: <1117901234.5005.9.camel@mulgrave> <1117955727.4961.8.camel@mina>
	<1117982408.4990.12.camel@mulgrave>
	<1117998665.4990.17.camel@mulgrave> <42A3E275.6030106@torque.net>
	<1118067544.5045.17.camel@mulgrave> <42A59C35.5060207@torque.net>
	<1118159966.4813.8.camel@mulgrave> <20050607180719.GB8172@suse.de>
	<1118172394.4791.9.camel@mulgrave>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1118172394.4791.9.camel@mulgrave>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: LIRANS@il.ibm.com, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dougg@torque.net>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 07 2005, James Bottomley wrote:
> On Tue, 2005-06-07 at 20:07 +0200, Jens Axboe wrote:
> > Why multi-bio? No one should ever have to build a request with multiple
> > bio's in one go, that's pointless. The only reason multi-bio requests
> > exist is because of the file systems not submitting big extents in one
> > submission. The whole io path would be faster and simpler were it not
> > for multi-bio requests :-)
> 
> OK, OK, sorry thinko ... I meant multi-biovec (which can be a single
> bio) ... however, I'm not the only one who keeps being confused by
> this ...
> 
> Incidentally, do I take it you're happy with all of this and I can take
> (at least the block pieces) through the SCSI tree?

I was planning on trying a block tree out, let me try and merge it first
and look it over if you don't mind.

-- 
Jens Axboe
