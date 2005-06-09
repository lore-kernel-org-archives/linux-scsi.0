From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc
	requests and simplify hw handlers
Date: Thu, 9 Jun 2005 08:18:39 +0200
Message-ID: <20050609061838.GB5140@suse.de>
References: <1117847972.23638.62.camel@mina> <1117901234.5005.9.camel@mulgrave>
	<1117955727.4961.8.camel@mina> <20050606190205.GA6817@us.ibm.com>
	<1118157976.42a5bc98d6f75@webmail.cs.wisc.edu>
	<20050607182317.GA12959@us.ibm.com> <42A711BC.9020108@cs.wisc.edu>
	<20050609000830.GA20616@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050609000830.GA20616@us.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 08 2005, Patrick Mansfield wrote:
> On Wed, Jun 08, 2005 at 10:41:48AM -0500, Mike Christie wrote:
> > Patrick Mansfield wrote:
> > >On Tue, Jun 07, 2005 at 10:26:16AM -0500, Michael Christie wrote:
> > >
> > >>Quoting Patrick Mansfield <patmans@us.ibm.com>:
> > >
> > >
> > >>>Why can't the retries be passed down via a new blk req->retries?
> > >>>
> > >>
> > >>Is that all that is needed for dm-multipath? I thought this would be a 
> > >>good time
> > >>to add some code to allow the finer grained control of retries that could 
> > >>also
> > >>be used by dm and md. For example do you only want to retry certain 
> > >>failures X
> > >>numbeer of times?
> > >
> > >
> > >I was looking/thinking about the scsi_scan retries not multipath.
> > 
> > And I was hoping the same code/framework can be used for scsi, DM, MD, 
> > SG_IO and all other block layer drivers.
> 
> So use a req->retries instead of the fail fast flag?

Would be fine. Some drivers are messing with ->errors for that anyways,
so would be nice to clean that up.

It would need to be done _very_ carefully though!

-- 
Jens Axboe
