From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Fwd: 32bit dev_t
Date: Wed, 22 Jan 2003 09:18:15 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030122091815.A32098@beaverton.ibm.com>
References: <3E2DC21D.9010204@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3E2DC21D.9010204@torque.net>; from dougg@torque.net on Wed, Jan 22, 2003 at 08:56:45AM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org, sdake@mvista.com, Joel.Becker@oracle.com

On Wed, Jan 22, 2003 at 08:56:45AM +1100, Douglas Gilbert wrote:
> This post appeared recently on the linux kernel list.
> What is the maximum number of disks that can be attached
> in lk 2.5? Is it 256 (double the number of SCSI disk majors)
> or larger. I remember Richard Gooch's "sd-many" patch
> was rejected for 2.5 because it was said there was a
> better mechanism around the corner.
> 
> BTW when I tested 129 (1 real + 128 dummies) disks with
> scsi_debug there was a problem the last one. Has anyone
> tested > 128 disks in lk 2.5?
> 
> Doug Gilbert

It should be 16 sd majors * 16 disks per major = 256.

What was the problem with scsi_debug? I thought you got it past 128 LUNs
at some point. There are no longer kmalloc (or vmalloc) issues with sd.c.

-- Patrick Mansfield
