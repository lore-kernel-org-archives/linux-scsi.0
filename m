From: Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: isp1020 memory trample in 2.5.66
Date: Thu, 3 Apr 2003 03:27:38 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0304030317230.30262-100000@montezuma.mastecende.com>
References: <Pine.LNX.4.50.0304020101460.8773-100000@montezuma.mastecende.com>
 <20030402080226.A25288@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030402080226.A25288@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 2 Apr 2003, Patrick Mansfield wrote:

> I've been booting OK with 2.5.66 with isp1020 and qlogicisp driver with
> multiple disks, though the boot sometimes hangs.
> 
> I've also booted OK with the feral driver.

I'll be prepping a kernel with that.

> This looks a lot like the oops when trying to send IO to more than one
> disk at a time with the isp1020 + qlogicisp.
> 
> Is there something different causing IO to muliple disks at that point?

Yes it is possible as i have another disk on the same HBA with /usr

> I hit this once when I enabled parallel fsck (it didn't oops until after I
> got a late oops, and rebooted).
> 
> Martin hit it when the queue depth was not properly checked.
> 
> wli has hit it with parallel mkfs (or something).

Ok this thing sounds _very_ fragile ;)

> The following thread was pretty useful, Doug L mentions that the qlogicisp
> does bad things, starting with Martin's analysis:
> 
> http://marc.theaimsgroup.com/?l=linux-kernel&m=104457083601573&w=2

Thanks! that looks very familiar.

	Zwane
-- 
function.linuxpower.ca
