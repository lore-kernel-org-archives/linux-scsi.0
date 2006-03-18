From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] link scsi_debug later
Date: Sat, 18 Mar 2006 07:22:44 -0600
Message-ID: <1142688164.3241.1.camel@mulgrave.il.steeleye.com>
References: <20060317124407.5f19cc09.rdunlap@xenotime.net>
	 <20060317212924.11a86800.akpm@osdl.org>
	 <20060317221920.3c84fc65.rdunlap@xenotime.net>
	 <441BA783.3030807@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2237 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932211AbWCRNXP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 08:23:15 -0500
In-Reply-To: <441BA783.3030807@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

On Sat, 2006-03-18 at 01:24 -0500, Douglas Gilbert wrote:
> Ah, if scsi_debug is a module, nothing is going to
> load it automatically (at least the PCI subsystem
> won't load it). However if it is built in then
> it will "steal" /dev/sda (if some other SCSI LLD
> hasn't already got it). That would then cause
> a SATA driver to get /dev/sdb ... That is enough
> to cause a kernel parameter like "root=/dev/sda8"
> to flounder and give the "could not find root filesystem"
> error.

Is there actually any purpose for not compiling scsi_debug as a module?
i.e. isn't the problem really that we simply shouldn't allow it to be
built directly into the kernel and it should only be compilable as a
module?

James


