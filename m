From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: storageworks controlers & linux-scsi
Date: Thu, 28 Aug 2003 13:06:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030828130626.A15749@beaverton.ibm.com>
References: <1061816116.3f4a073487d64@impt3-1.free.fr> <1061999793.1660.8.camel@mulgrave> <20030828013706.45760cb5.christophe.varoqui@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:44242 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S264221AbTH1UHH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 16:07:07 -0400
Content-Disposition: inline
In-Reply-To: <20030828013706.45760cb5.christophe.varoqui@free.fr>; from christophe.varoqui@free.fr on Thu, Aug 28, 2003 at 01:37:06AM +0200
List-Id: linux-scsi@vger.kernel.org
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Aug 28, 2003 at 01:37:06AM +0200, christophe varoqui wrote:
> 
> I leave for a 2 week vacation, but if the HSV LUNs handling is turned to a usable state I'll be able to post a GPL C agent to handle DM multipath autoconfig & reconfig on event (through VPD 0x83 for wwid detection and TUR for ghosts detection) in  about 3 weeks. In hope there will interest to move it to a broader use.
> 

Hi -

Is that a 2.4 solution?

I was starting to work on a hotplug interface to get and store scsi wwid's
or serial numbers for use with 2.6.

We need a method that would (ideally) work for all users, so we: don't
hang broken devices, can use other pages (0x80), can use vendor
specific methods, and works for udev or multipath config tools.

We need a black/white list (or config file) for the broken or special
devices.

Have you seen the libsysfs/udev code? We can use libsysfs for common
interfaces to get/set a scsi serial number, and for other common uses of
sysfs such as getting the bus_id, or figuring out if we have a scsi
device.

-- Patrick Mansfield
