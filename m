From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] sg version 3.5.28 for lk 2.5.64
Date: Tue, 11 Mar 2003 08:18:38 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311081838.A9661@beaverton.ibm.com>
References: <3E6B405B.3010509@torque.net> <20030311142836.A22992@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030311142836.A22992@infradead.org>; from hch@infradead.org on Tue, Mar 11, 2003 at 02:28:36PM +0000
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Tue, Mar 11, 2003 at 02:28:36PM +0000, Christoph Hellwig wrote:
> On Sun, Mar 09, 2003 at 11:23:39PM +1000, Douglas Gilbert wrote:
> > ** Christoph moved the host listing functionality into
> >     a more central sysfs position (i.e. not dependent on
> >     sg). However scsi_debug is the only LLD that I can
> >     get to post any "host" info under the new arrangement.

> 
> Hmm, it works for me with aic7xxx (that's how I tested it).
> 

Is there a patch for putting the aic or all scsi_hosts into the
shost_devclass class, like scsi_debug.c does for itself?

-- Patrick Mansfield
