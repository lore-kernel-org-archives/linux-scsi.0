From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: Attributes
Date: 16 Apr 2004 10:15:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082128518.2130.13.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C0169D@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:33246 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263415AbUDPPPX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 11:15:23 -0400
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C0169D@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Fri, 2004-04-16 at 10:03, Smart, James wrote:
> I've considered the daemon approach (using sysfs) - but didn't believe it
> applied for a value that had to be set at boot time (when the link first
> initializes). For boot, the thought is to either compile it in, or perhaps
> get it via a module parameter assuming module.conf get copied into the
> inital ram disk.

Not at all.  All that happens is that you have to run the daemon before
using the devices.  So you'd need an initramfs/initrd daemon but *only*
if your root device is on a fibre whose topology you want to control.

> This brings up another question...  assuming a driver gets into the kernel
> tree, but it has an associated user-space entity like this daemon. How does
> one get the user-space elements onto the different distributions in concert
> with the kernel ?  (other than lobbying each distribution individually ?)

One publishes the user space entries separately.  The distributions
necessarily pick them up if they want the driver to work correctly.

James


