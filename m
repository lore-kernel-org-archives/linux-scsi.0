From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] serialize bus scanning
Date: Thu, 28 Aug 2003 08:59:40 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030827225940.GC7852@krispykreme>
References: <20030825122416.GE15506@lst.de> <20030827202908.GB7852@krispykreme> <20030827223250.GB2664@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:62669 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S262476AbTH0W7s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2003 18:59:48 -0400
Content-Disposition: inline
In-Reply-To: <20030827223250.GB2664@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org


> Since I have not seen your tree I am speaking with lack of knowledge, but
> it seems odd that your device tree would contain spinup knowledge per
> host. The power issue you are trying to avoid is per disk enclosure
> / cabinet. A per host value seems like it could still lead to a power
> issue given a large enough configuration.

Yeah you are right, its currently a global value. The firmware knows
power domains so it could get finer grained but it would be at the host
bridge level.

Anyway all this intelligence to parse this stuff should be in an initramfs 
program talking to sysfs. I was quite pleased with the sysfs rescan
functionality recently, we had someone kick the power on a scsi drawer
and were able to get linux to rescan and spin up the disks again
without rebooting.

Anton
