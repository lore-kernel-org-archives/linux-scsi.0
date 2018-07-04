From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [RFC] scsi: switch to scsi-mq by default
Date: Wed, 4 Jul 2018 10:48:12 +0200
Message-ID: <20180704084812.jfeqju3sqtkuwnhu@linux-x5ow.site>
References: <20180703065413.6098-1-jthumshirn@suse.de>
 <7ab21471b799d2a60ccfd8579b2548f58915568a.camel@wdc.com>
 <282521f4-762c-86a5-5ac8-f8cc33b050cc@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <282521f4-762c-86a5-5ac8-f8cc33b050cc@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@lst.de" <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "tom.leiming@gmail.com" <tom.leiming@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, chenxiang <chenxiang66@hisilicon.com>, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 04, 2018 at 09:18:23AM +0100, John Garry wrote:
> We were seeing performance drops previously for hisi_sas when originally
> enabled by default, but results on 4.18 seem almost identical with and
> without MQ default.
> 
> FWIW,
> 
> Acked-by: John Garry <john.garry@huawei.com>

Thanks for letting me know.
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
