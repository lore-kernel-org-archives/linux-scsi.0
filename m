From: "hch@lst.de" <hch@lst.de>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Fri, 14 Jul 2017 14:45:39 +0200
Message-ID: <20170714124539.GA26686@lst.de>
References: <1499701840.3555.7.camel@wdc.com> <e3c07504-8538-f2f3-003a-01b72e0c07c6@huawei.com> <1499779970.3345.1.camel@wdc.com> <4cf7ed21-7cf4-a91a-8beb-ba5f92e4eaaf@huawei.com> <1499788012.2586.12.camel@wdc.com> <9c0db5bd-a623-c73e-9f44-a4cfad97e2c8@huawei.com> <581a258d-3da8-5b01-f528-0ce11b74b65e@huawei.com> <1499869093.8204.2.camel@wdc.com> <20170712235401.00004402@huawei.com> <20170714175641.00001cb0@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39033 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754294AbdGNMpu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Jul 2017 08:45:50 -0400
Content-Disposition: inline
In-Reply-To: <20170714175641.00001cb0@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "john.garry@huawei.com" <john.garry@huawei.com>, "linuxarm@huawei.com" <linuxarm@huawei.com>

On Fri, Jul 14, 2017 at 05:56:41PM +0800, Jonathan Cameron wrote:
> Just wondering if you had any thoughts on how we can proceed with tracking
> down this regression?
> 
> I'm not familiar enough with the multiqueue code to really know where
> to start.
> 
> If there are any other tests that would be of use, let us know.

Can you send the blktrace and perf output for each of the runs?

Thanks!
