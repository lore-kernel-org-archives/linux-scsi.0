From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 10:04:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200204101405.KAA09838@hancock.sc.steeleye.com>
References: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com> <yq18z7w1awn.fsf@austin.mkp.net> <20020410091918.C546@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by hancock.sc.steeleye.com (8.9.3/8.9.3) id KAA10212
	for <linux-scsi@vger.kernel.org>; Wed, 10 Apr 2002 10:05:58 -0400
In-Reply-To: <20020410091918.C546@thunk.org>
List-Id: linux-scsi@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, "Martin K. Petersen" <mkp@mkp.net>
Cc: linux-scsi@vger.kernel.org

On Wednesday 10 April 2002 09:19 am, Theodore Tso wrote:

> That is indeed a hard problem, and ultimately, the thing that will
> make this easier is if there's some way we can read out a
> drive-specific serial number out of the ATAPI or SCSI interfaces.  I
> don't know if disk serial numbers are commonly supported by disk
> manufacturers, but hopefully the newer disks have something like that
> we can use.  Without it, though, the problem is very, very hard if you
> want to make it 100% foolproof --- and hence, something which
> civilians (i.e., stupid users) can use.

While I enjoy bashing stupid users I would like to point out that persistent 
naming, while it makes life easier for stupid users, it has tremendous 
benefits for all of us.  

We (the product I work on) have used serial numbers for a long time to 
uniquely identify devices and this improves the ease of use tremendously.  In 
a cluster this is really critical or one can easily try to bring an 
application in-service on a wrong device with catestrophic results.

Eddie

