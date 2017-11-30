From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: fix race condition when removing target
Date: Thu, 30 Nov 2017 16:40:52 +0000
Message-ID: <20171130164052.GA17869@kroah.com>
References: <20171129030556.47833-1-yanaijie@huawei.com>
 <1511972310.2671.7.camel@wdc.com>
 <20171129162050.GA32071@lst.de>
 <1511977145.2671.13.camel@wdc.com>
 <5A1F5C77.5050405@huawei.com>
 <1512058117.2774.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40008 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752463AbdK3Qks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Nov 2017 11:40:48 -0500
Content-Disposition: inline
In-Reply-To: <1512058117.2774.1.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "yanaijie@huawei.com" <yanaijie@huawei.com>, "zhaohongjiang@huawei.com" <zhaohongjiang@huawei.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hare@suse.de" <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "miaoxie@huawei.com" <miaoxie@huawei.com>

On Thu, Nov 30, 2017 at 04:08:38PM +0000, Bart Van Assche wrote:
> On Thu, 2017-11-30 at 09:18 +0800, Jason Yan wrote:
> > Hi Bart, I chose the approach in my patch because it has been used in
> > scsi_device_get() for years and been proved safe. I think using
> > kobject_get_unless_zero() is safe here and can fix this issue too. And
> > this approach is beneficial to all users.
> 
> Hello Jason,
> 
> A possible approach is that we start with your patch and defer any get_device()
> changes until after your patch has been applied.

That might be good, I don't have the chance to look at any driver core
changes until Monday as I'm on the road until then, sorry...

greg k-h
