From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] libsas: flush pending destruct work in sas_unregister_domain_devices()
Date: Sat, 9 Dec 2017 11:51:20 -0800
Message-ID: <CAM_iQpVhH7cL=ZOftOrZsR0bXJX4X89ykmvniyrRxeAUYo7cGA@mail.gmail.com>
References: <20171128002445.16594-1-xiyou.wangcong@gmail.com>
 <20171128082049.5smff3hvrkwrf77o@linux-x5ow.site> <922397da-7dd3-c24e-1d94-e4804a769331@huawei.com>
 <CAM_iQpVXuO=jHg=wyse7OoGDzLNrz3hFc_aqAPR=FsF_+s5gaw@mail.gmail.com>
 <877cfb17-ba90-da91-a549-418bb6eb6391@huawei.com> <CAM_iQpVWmeq5BMvxJmD2FP6Zm6s7O05+NqzYQ6uCAp7iE1asnw@mail.gmail.com>
 <5A2A454E.6050108@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f42.google.com ([209.85.160.42]:41903 "EHLO
        mail-pl0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdLITvl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Dec 2017 14:51:41 -0500
In-Reply-To: <5A2A454E.6050108@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Yan <yanaijie@huawei.com>
Cc: John Garry <john.garry@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>, LKML <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, Praveen Murali <pmurali@logicube.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, chenxiang <chenxiang66@hisilicon.com>

On Thu, Dec 7, 2017 at 11:54 PM, Jason Yan <yanaijie@huawei.com> wrote:
>
> We have sent a patchset to fix this and to enhance libsas hotplug.
> Please refer to https://lkml.org/lkml/2017/9/6/142
>
> And I'm going to send a new version soon.

Thanks for working on it! Please make sure they will be queued
for -stable too, since 3.14, 4.1 and 4.9 are all affected.
