From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: SCSI Disk layer performance
Date: Thu, 29 Jan 2004 07:55:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040129075516.A1830@beaverton.ibm.com>
References: <400FF79A.6050108@wanadoo.es> <4018FC0A.3050309@biotek.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:18161 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265895AbUA2Pzs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 10:55:48 -0500
Content-Disposition: inline
In-Reply-To: <4018FC0A.3050309@biotek.uio.no>; from george.magklaras@biotek.uio.no on Thu, Jan 29, 2004 at 01:26:50PM +0100
List-Id: linux-scsi@vger.kernel.org
To: George Magklaras <george.magklaras@biotek.uio.no>
Cc: Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi@vger.kernel.org

On Thu, Jan 29, 2004 at 01:26:50PM +0100, George Magklaras wrote:

> The 2.4.21-9EL might have clever things backported into it, but it is 
> still missing essential things that can make a difference in the block 
> layer, like an anticipatory I/O schedule. My impression is that all 
> 2.4 kernels use the Linus Elevator. That works well with moderate SMP 
> loads, but it does not perform well on my large-ish Hardware RAID0 
> 1.1Tbyte ext3 partition on a Power Vault 220S with a Dell PERC4 host 
> adapter. The 2.6.1 does work a lot more better in that sense, giving 
> me an average read of 90 Mbytes/sec as opposed to 
> 60+somethingMbytes/sec I used to get before with 2.4.21-9ELsmp.
> 
> The new I/O schedulers (let alone driver maturity issues) are the way 
> to go for maximum performance! I won't place -for the moment- a 2.6 on 
> a production grade system, but in a couple of releases, I will put 2.4 
> in the museum :-) with respect to SCSI I/O performance.

How does the anticipatory scheduler compare to the deadline scheduler on
your system?

What types of IO are you doing?

-- Patrick Mansfield
