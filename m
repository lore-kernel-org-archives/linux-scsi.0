From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 10:45:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020410104550.A9957@beaverton.ibm.com>
References: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com> <yq18z7w1awn.fsf@austin.mkp.net> <20020410091918.C546@thunk.org> <200204101405.KAA09838@hancock.sc.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200204101405.KAA09838@hancock.sc.steeleye.com>; from Eddie.Williams@steeleye.com on Wed, Apr 10, 2002 at 10:04:01AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Eddie Williams <Eddie.Williams@steeleye.com>
Cc: Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <mkp@mkp.net>, linux-scsi@vger.kernel.org

Eddie Williams [Eddie.Williams@steeleye.com] wrote:
> On Wednesday 10 April 2002 09:19 am, Theodore Tso wrote:
> 
> > That is indeed a hard problem, and ultimately, the thing that will
> > make this easier is if there's some way we can read out a
> > drive-specific serial number out of the ATAPI or SCSI interfaces.  I
> > don't know if disk serial numbers are commonly supported by disk
> > manufacturers, but hopefully the newer disks have something like that
> > we can use.  Without it, though, the problem is very, very hard if you
> > want to make it 100% foolproof --- and hence, something which
> > civilians (i.e., stupid users) can use.
> 
> While I enjoy bashing stupid users I would like to point out that persistent 
> naming, while it makes life easier for stupid users, it has tremendous 
> benefits for all of us.  
> 
> We (the product I work on) have used serial numbers for a long time to 
> uniquely identify devices and this improves the ease of use tremendously.  In 
> a cluster this is really critical or one can easily try to bring an 
> application in-service on a wrong device with catestrophic results.

Agreed,

While the immutablity / uniqueness of uuids across different name spaces
may vary depending on device capability there are still useful. Many have
been obtaining IDs from devices for years using a method of obtaining the
most unique ID the device can provide and then ensuring that names spaces
do not collide (i.e go for page 0x83, then 0x80, vendor-product-serial,
vendor unique).

We have also found in the past that when users make complete copies of
there volumes (for the purpose of hot-backup) that a uuid is one of the
few methods that can be used to differ the clone from the original.


-Mike
-- 
Michael Anderson
andmike@us.ibm.com

