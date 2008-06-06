From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1 of 3] block: Export I/O hints for block devices and partitions
Date: Fri, 6 Jun 2008 15:21:03 +0100
Message-ID: <20080606142103.GA22158@shareable.org>
References: <patchbomb.1212643369@sermon.lab.mkp.net> <3e5d8520d247223a236e.1212643370@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3e5d8520d247223a236e.1212643370@sermon.lab.mkp.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
> +	sector_t phys_offset;
> +	unsigned int optimal_io_block;
> +	unsigned int optimal_io_length;

Wouldn't off_t or sector_t be more appropriate?

I can (vaguely) imagine devices with stripe sizes >= 2GiB in the not
too distant future.  Especially clusters with high speed interconnect
and RAM-backed devices.

There's no harm in an application doing smaller I/O.  It should always
choose appropriate values itself anyway.

But it seems cleaner to report the numbers derived from actual drive
topology.

-- Jamie
