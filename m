From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: Disk simulator driver
Date: Sun, 29 Oct 2006 16:08:27 -0800
Message-ID: <1162166907.6802.24.camel@home-desk>
References: <1162153159.6802.21.camel@home-desk>
	 <20061029230243.GB13218@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:17307 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1030470AbWJ3AI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Oct 2006 19:08:29 -0500
In-Reply-To: <20061029230243.GB13218@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, 2006-10-29 at 17:02 -0600, Matt Domsch wrote:
> On Sun, Oct 29, 2006 at 12:19:19PM -0800, Sean Bruno wrote:
> > Is there a project/driver that would take a disk/file/lvm partition as
> > an argument(/dev/sda, /tmp/my_big_file.bin /dev/Mapper/MYLVMPART eg.)
> > and then create a new /dev entry that could be read/written to as though
> > it were a disk?
> > 
> > I think I want to look at sg, but I wasn't sure if that is what I want.
> > 
> > Just poking around for fun and education.
> > 
> > Sean
> 
> You want something different than losetup and /dev/loop ?
> e.g. something you can issue disk-like ioctls to?
> 
Precisely.  I am interested in capturing the data that would be sent to
the device and copying it somewhere before it is written to the disk.
Kind of like the way target mode drivers accept a file/disk as a target
for their operations.

Sean

