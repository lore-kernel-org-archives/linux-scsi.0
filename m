From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] linux/types.h: Restore the ability to disable sparse
 endianness checks
Date: Mon, 16 Oct 2017 19:50:45 +0300
Message-ID: <20171016193921-mutt-send-email-mst@kernel.org>
References: <20171006172353.16758-1-bart.vanassche@wdc.com>
 <20171009162008-mutt-send-email-mst@kernel.org>
 <1507561661.2674.3.camel@wdc.com>
 <20171009204139-mutt-send-email-mst@kernel.org>
 <1507653494.2815.27.camel@wdc.com>
 <20171016160316-mutt-send-email-mst@kernel.org>
 <1508162253.2728.1.camel@wdc.com>
 <20171016181159-mutt-send-email-mst@kernel.org>
 <1508168209.2493.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508168209.2493.13.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "qla2xxx-upstream@qlogic.com" <qla2xxx-upstream@qlogic.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2017 at 03:36:50PM +0000, Bart Van Assche wrote:
> On Mon, 2017-10-16 at 18:27 +0300, Michael S. Tsirkin wrote:
> > On Mon, Oct 16, 2017 at 01:57:35PM +0000, Bart Van Assche wrote:
> > > On Mon, 2017-10-16 at 16:34 +0300, Michael S. Tsirkin wrote:
> > > > I don't see how it'll help make things better. OTOH if the specific
> > > > drivers are tagged in the makefile, they can be gradually moved out to
> > > > staging or something to help trigger action.
> > > 
> > > Do you really want to move drivers like qla2xxx to staging? That driver is
> > > important to multiple enterprise distro's.
> > 
> > Frankly I'm surprised this one has sparse issues.
> > Really e.g. drivers/scsi/qla2xxx/qla_nvme.h is new from June 2017.
> > 
> > It's not some ancient piece of code that no one understands so
> > we are afraid to touch it.
> 
> Sorry if I wasn't clear enough but I wasn't referring to the qla2xxx NVMe
> code. I was referring to the qla2xxx FC initiator code. I think that code
> went upstream in January 2004. See also 
> https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/log/drivers/scsi/qla2xxx?ofs=100
> 
> Bart.

Right but qla_nvme also triggers these warnings. That's the problem with
disabling them tree-wide. To me it looks like the time we are spending
arguing about work-arounds would be better spent just fixing the
majority of the code. If a couple of places aren't clean and
need more thought, that's not a big deal.

-- 
MST
