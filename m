From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Wed, 7 Mar 2007 19:46:42 +0100
Message-ID: <20070307184641.GY20362@kernel.dk>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:12579 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422997AbXCGSr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Mar 2007 13:47:57 -0500
Content-Disposition: inline
In-Reply-To: <20070228153722.GJ22572@skl-net.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

On Wed, Feb 28 2007, Andre Noll wrote:
> On 16:18, Andre Noll wrote:
> 
> > With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> > writing to both raid systems at the same time via lvm still locks up
> > the system within minutes.
> 
> Screenshot of the resulting kernel panic:
> 
> 	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png

Do you have the full oops as well?

-- 
Jens Axboe

