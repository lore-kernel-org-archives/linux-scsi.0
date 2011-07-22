From: Jonathan McDowell <noodles@earth.li>
Subject: Re: Linux 3.0 STILL dies on USB device hotplug - please merge fix
 ASAP
Date: Fri, 22 Jul 2011 19:23:40 +0100
Message-ID: <20110722182340.GS6432@earth.li>
References: <20110722170214.GR8006@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110722170214.GR8006@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: James.Bottomley@HansenPartnership.com, stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@linux-foundation.org, stable@kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2011 at 07:02:14PM +0200, Andi Kleen wrote:
> 3.0 still oopses and dies immediately on USB device hot unplug.
> The same problem also triggered with SAS device according to Dan.
> 
> There was a lot of debugging on this a few weeks back and Alan Stern
> posted a SCSI layer patch that fixed the problem (for both USB
> and SAS):
> 
> http://68.183.106.108/lists/linux-usb/msg49001.html

It also affects disappearing Fibre Channel devices and Alan's patch
fixes that too.

J.

-- 
One-seventh of your life is spent on Monday.
