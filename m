From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] sg version 3.5.28 for lk 2.5.64
Date: Tue, 11 Mar 2003 09:34:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311173403.GA1209@beaverton.ibm.com>
References: <3E6B405B.3010509@torque.net> <20030311142836.A22992@infradead.org> <20030311081838.A9661@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030311081838.A9661@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

Patrick Mansfield [patmans@us.ibm.com] wrote:
> On Tue, Mar 11, 2003 at 02:28:36PM +0000, Christoph Hellwig wrote:
> > On Sun, Mar 09, 2003 at 11:23:39PM +1000, Douglas Gilbert wrote:
> > > ** Christoph moved the host listing functionality into
> > >     a more central sysfs position (i.e. not dependent on
> > >     sg). However scsi_debug is the only LLD that I can
> > >     get to post any "host" info under the new arrangement.
> 
> > 
> > Hmm, it works for me with aic7xxx (that's how I tested it).
> > 
> 
> Is there a patch for putting the aic or all scsi_hosts into the
> shost_devclass class, like scsi_debug.c does for itself?
> 

Since this capability relies on the driver living on a bus that has been
converted to sysfs there cannot be a patch for all scsi_hosts. If we
want all scsi host to show up we would need to create our own sub-system
like "block" and switch from using devclass.

-andmike
--
Michael Anderson
andmike@us.ibm.com

