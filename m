From: Edward Falk <efalk@google.com>
Subject: Re: map gendisk (or blockdev) -> scsi_device
Date: Thu, 14 Jul 2005 11:38:44 -0700
Message-ID: <db6bfk$pr0$1@sea.gmane.org>
References: <db1npr$c1d$1@sea.gmane.org> <20050713143843.GC26025@infradead.org> <db3nei$nrs$1@sea.gmane.org> <20050713234654.GA7222@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47775 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S261636AbVGNSjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 14:39:10 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Dt8bn-0003LW-BM
	for linux-scsi@vger.kernel.org; Thu, 14 Jul 2005 20:38:55 +0200
Received: from 216-239-45-4.google.com ([216.239.45.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2005 20:38:55 +0200
Received: from efalk by 216-239-45-4.google.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2005 20:38:55 +0200
In-Reply-To: <20050713234654.GA7222@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


> Add or use the attributes under the scsi_device, then use the
> /sysfs/block/sd/device symlink to find the corresponding scsi_device.

Perfect!  Thanks.

