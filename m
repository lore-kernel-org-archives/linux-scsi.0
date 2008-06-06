From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Fri, 6 Jun 2008 15:26:13 +0100
Message-ID: <20080606142613.GA22495@shareable.org>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <patchbomb.1212643369@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> Comments and suggestions are welcome.

Flash devices and SSDs (solid-state storage) in general are becoming
more common.

Also, backing a disk with flash.  And increasingly people will stripe,
parity, mirror or concatenate disks and flash just because it's
convenient.

--> So it would be nice if some of the flash alignment characteristics
could be reported.

Some aspects of flash don't fit into block devices - e.g. erase block
and write order requirements.  That's MTD stuff, not appropriate here.

But SSDs present a block device interface, and they still have
alignment characteristics for performance.  Even more important, when
combining multiple SSDs into a RAID.

-- Jamie
