From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] allow NULL dev argument to scsi_add_host
Date: Sun, 12 Jan 2003 22:50:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030113065031.GA4599@beaverton.ibm.com>
References: <20030111203317.A25836@lst.de> <20030112011720.GC1878@beaverton.ibm.com> <20030112090647.A28861@lst.de> <20030112194030.GB1414@beaverton.ibm.com> <20030112231151.GA20678@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030112231151.GA20678@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

Andries Brouwer [aebr@win.tue.nl] wrote:
> On Sun, Jan 12, 2003 at 11:40:30AM -0800, Mike Anderson wrote:
> 
> > Currently we have a couple of issues that might be solved by the creation of a
> > scsi subsystem in /sysfs/scsi:
> 
> Is /sysfs/scsi better than /sysfs/devices/scsiX?

The choice was not better it was just a difference of semantics. The
/sysfs/devices tree normal contains devices with an associated bus
(though you can set this to NULL).  The device tree was meant to contain
real devices. The support I added to scsi_debug was to emulate a real
device so the overhead was needed to try to match the call paths of
other LLDD like some of the converted pci's. The addition of ide-scsi to
the device tree was that there was no other option.

I hoped to get a smaller object to represent the emulated scsi hosts or
hosts that had not been converted in a /sysfs/scsi subsystem. I also
thought we might need other sysfs entries related to the SCSI subsystem
(scsi logging control, sg mapping solution, scsiX host mapping "The
scsi-host class I created sucks right now"). 

-andmike
--
Michael Anderson
andmike@us.ibm.com

