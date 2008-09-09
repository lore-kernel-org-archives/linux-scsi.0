From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: [PATCH 0/6] detect online disk resize
Date: Tue, 9 Sep 2008 10:41:32 +0300
Message-ID: <20080909074132.GV13941@edu.joroinen.fi>
References: <20080829231254.25065.66052.stgit@bluto.andrew> <x49prnett3p.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from edu.joroinen.fi ([194.89.68.130]:60853 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbYIIHle (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Sep 2008 03:41:34 -0400
Content-Disposition: inline
In-Reply-To: <x49prnett3p.fsf@segfault.boston.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com

On Mon, Sep 08, 2008 at 02:01:14PM -0400, Jeff Moyer wrote:
> Andrew Patterson <andrew.patterson@hp.com> writes:
> 
> > This is version 2 of a patch series I submitted back in May 2008. This
> > version now checks for device size changes in the rescan_partitions()
> > routine.  Which in turn is called when a device is opened and in the
> > BLKRRPART ioctl.
> >
> > I am resubmitting this patch series as I got little response the
> > previous time.  Al Viro has told me offline that he would look at it this
> > time.
> 
> [...]
> 
> > I have tested this patch on SCSI and SmartArray (cciss)
> > devices. Device mapper still does not recognize device size changes
> > until the device is restarted.
> >
> > Jeff Moyer and Andy Ryan have done some light testing on the previous
> > version of this series.
> 
> I re-tested this new patch series using an iSCSI target via the
> following steps:
> 
> 1) Connect to iSCSI storage, creating the /dev/sd* devices.
> 2) Create a file system on the block device
> 3) Mount the file system, and leave a shell active on the mount point.
> 4) resize the iSCSI LUN
> 5) rescan the iSCSI session
> 6) resize the file system
> 
> This procedure worked fine.
> 

So now we just need a sane way to resize dm-multipath devices online :)

-- Pasi
