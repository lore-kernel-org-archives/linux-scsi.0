From: Edward Falk <efalk@google.com>
Subject: Re: map gendisk (or blockdev) -> scsi_device
Date: Thu, 14 Jul 2005 15:54:52 -0700
Message-ID: <42D6ED3C.8030307@google.com>
References: <db1npr$c1d$1@sea.gmane.org> <20050713143843.GC26025@infradead.org> <db3nei$nrs$1@sea.gmane.org> <20050713234654.GA7222@us.ibm.com> <20050714195613.GA22935@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-239-45-4.google.com ([216.239.45.4]:27942 "EHLO
	216-239-45-4.google.com") by vger.kernel.org with ESMTP
	id S263158AbVGNWzV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 18:55:21 -0400
In-Reply-To: <20050714195613.GA22935@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jul 13, 2005 at 04:46:54PM -0700, Patrick Mansfield wrote:
> 
>>Add or use the attributes under the scsi_device, then use the
>>/sysfs/block/sd/device symlink to find the corresponding scsi_device.
> 
> 
> yupp, the /sys/block/* attributes are really only meant to be for
> thing related to the actual block device, not the underlying hardware.

What is the difference between "actual block device" and "underlying 
hardware"?

	-ed

