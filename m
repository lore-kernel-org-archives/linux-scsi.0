From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Disk simulator driver
Date: Sun, 29 Oct 2006 17:02:43 -0600
Message-ID: <20061029230243.GB13218@lists.us.dell.com>
References: <1162153159.6802.21.camel@home-desk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:13610 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S1030419AbWJ2XCk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Oct 2006 18:02:40 -0500
Content-Disposition: inline
In-Reply-To: <1162153159.6802.21.camel@home-desk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sean Bruno <sean.bruno@dsl-only.net>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Sun, Oct 29, 2006 at 12:19:19PM -0800, Sean Bruno wrote:
> Is there a project/driver that would take a disk/file/lvm partition as
> an argument(/dev/sda, /tmp/my_big_file.bin /dev/Mapper/MYLVMPART eg.)
> and then create a new /dev entry that could be read/written to as though
> it were a disk?
> 
> I think I want to look at sg, but I wasn't sure if that is what I want.
> 
> Just poking around for fun and education.
> 
> Sean

You want something different than losetup and /dev/loop ?
e.g. something you can issue disk-like ioctls to?

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
