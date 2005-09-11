From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process (end devices)
Date: Sun, 11 Sep 2005 10:46:56 +0100
Message-ID: <20050911094656.GC5429@infradead.org>
References: <1126308304.4799.45.camel@mulgrave> <20050910024454.20602.qmail@web51613.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964851AbVIKJq7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050910024454.20602.qmail@web51613.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 09, 2005 at 07:44:54PM -0700, Luben Tuikov wrote:
> > this one completely duplicates the
> > mid-layer infrastructure for handling devices with Logical Units.
> 
> No, it does *not*.  James, you have _stop_ spreading FUD, relying
> that other people have not read the SCSI Core code.
> 
> See here:
>     SCSI Core has *no representation* of a SCSI Device with a
> SCSI Target Port.

struct scsi_target

> I've _clearly_ outlined that in the comments of the code,
> which you _conveniently_ did _not_ cut and paste here.

 * Discover logical units present in the SCSI device.  I'd like this
 * to be moved to SCSI Core, but SCSI Core has no concept of a "SCSI
 * device with a SCSI Target port".  A SCSI device with a SCSI Target
 * port is a device which the _transport_ found, but other than that,
 * the transport has little or _no_ knowledge about the device.
 * Ideally, a LLDD would register a "SCSI device with a SCSI Target
 * port" with SCSI Core and then SCSI Core would do LU discovery of
 * that device.

So what does this mean except "Luben tries to impress everyone with
standards gibberish, at the same time ignoring we soluitions that
work despite maybe not 100% elegant".

Sure, we'd like to move away from needing the ->id target id specifier.
But right now we need it, even you're code sets it in over-complicated
ways.  But if you send a nice patch to get rid everyone will be happy.
