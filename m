From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Proposal to add a new sysfs attribute to SCSI device
Date: Wed, 23 Mar 2005 10:36:04 -0600
Message-ID: <1111595764.5441.29.camel@mulgrave>
References: <8126E4F969BA254AB43EA03C59F44E8401A88416@pdsmsx404>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:59265 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261636AbVCWQgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2005 11:36:09 -0500
In-Reply-To: <8126E4F969BA254AB43EA03C59F44E8401A88416@pdsmsx404>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Zhao, Forrest" <forrest.zhao@intel.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-03-22 at 11:05 +0800, Zhao, Forrest wrote:
> Let me tell you the testing experience in our lab: 
> 1 we install kernel 2.6.11.2 on a Tiger4 platform, 
> 2 there're two SCSI disks, one is sda for root fs, the other is sdb for
> /mnt
> 3 execute "cp -r /usr/src/linux-2.6.11.2 /mnt"
> 4 during the process of copying, we surprise-removed sdb 
> 5 then system become very busy and freezing, even the user can't login
> into the system whether locally or remotely
> 6 the error output on the screen demonstrates that SCSI mid-layer is
> endless retrying the failed I/O requests

Which HBA driver is this?  As long as the HBA can recognise the device
is missing, the retries should go very fast because it's simply a bounce
between the eh thread and the driver.

James


