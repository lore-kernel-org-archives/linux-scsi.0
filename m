From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Fri, 14 Jul 2017 17:56:41 +0800
Message-ID: <20170714175641.00001cb0@huawei.com>
References: <20170616082755.22832-1-hch@lst.de>
        <1499701840.3555.7.camel@wdc.com>
        <e3c07504-8538-f2f3-003a-01b72e0c07c6@huawei.com>
        <1499779970.3345.1.camel@wdc.com>
        <4cf7ed21-7cf4-a91a-8beb-ba5f92e4eaaf@huawei.com>
        <1499788012.2586.12.camel@wdc.com>
        <9c0db5bd-a623-c73e-9f44-a4cfad97e2c8@huawei.com>
        <581a258d-3da8-5b01-f528-0ce11b74b65e@huawei.com>
        <1499869093.8204.2.camel@wdc.com>
        <20170712235401.00004402@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:9772 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdGNJ5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jul 2017 05:57:19 -0400
In-Reply-To: <20170712235401.00004402@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "linuxarm@huawei.com" <linuxarm@huawei.com>

On Wed, 12 Jul 2017 23:54:01 +0800
Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> On Wed, 12 Jul 2017 14:18:14 +0000
> Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> 
> > On Wed, 2017-07-12 at 09:26 +0100, John Garry wrote:  
> > > > > What block driver controls the block device for which the performance
> > > > > regression
> > > > > has been observed? How many hardware queues were created by that block
> > > > > driver
> > > > > (see also /sys/block/*/mq/...)?    
> > > 
> > > Just confirming that we have only 1 queue:
> > > /sys/block/sdc/mq/0 as example    
> > 
> > Hello John,
> > 
> > Can you also check the I/O scheduler that has been selected?
> > 
> > Thanks,
> > 
> > Bart.  
> Hi Bart,
> 
> Original numbers were with deadline-mq (not deliberately specified - so the
> default for this setup)  To flesh them out a bit I've
> run the equivalent test with all the options on today's linux next.
> 
> iodepth=2048, 4k blocks read only 6 disks 6 processes.
> 
> SMMU disabled for now due to ongoing work to reduce it's impact.
> 
> none : 716k IOPS
> mq-deadline : 305k IOPS
> kyber: 321k IOPS
> 
> noop, scsi_mq disable using the kernel commandline option: 937k IOPS
> 
> Thanks,
> 
> Jonathan
> 

Hi Bart,

Just wondering if you had any thoughts on how we can proceed with tracking
down this regression?

I'm not familiar enough with the multiqueue code to really know where
to start.

If there are any other tests that would be of use, let us know.

Thanks for your help on this!

Jonathan
