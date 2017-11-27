From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: Re: [PATCH 0/3] scsi: arcmsr: add driver module parameter -
 msi_enable, msix_enable
Date: Mon, 27 Nov 2017 11:10:59 +0800
Message-ID: <CAKiknE-Hc7HyKt0uAoaD9cCOKb9jK3cXzAL+ptNzU_huEmtrqw@mail.gmail.com>
References: <1511400123.9832.14.camel@Centos6.3-64> <20171123125739.GA25627@infradead.org>
 <1511464359.4370.3.camel@Centos6.3-64> <20171124145357.rtbrqavzne7jkz6l@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35922 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751210AbdK0DLB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Nov 2017 22:11:01 -0500
Received: by mail-lf0-f67.google.com with SMTP id k66so31032865lfg.3
        for <linux-scsi@vger.kernel.org>; Sun, 26 Nov 2017 19:11:00 -0800 (PST)
In-Reply-To: <20171124145357.rtbrqavzne7jkz6l@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>

Dan,

There is our user feedback said that they have some system have MSI
interrupt issue.(but some system are working)
Those have MSI issue system all are old system, even if MSI interrupt
enable and request are successful, there is not any hardware interrupt
for scsi command. Cause each scsi command timeout. So msi_enable
parameter is a way to disable msi interrupt request.
Using legacy interrupt, those have MSI interrupt issue system are
working properly.

Thanks,
Ching

2017-11-24 22:53 GMT+08:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, Nov 24, 2017 at 03:12:39AM +0800, Ching Huang wrote:
>> On Thu, 2017-11-23 at 04:57 -0800, Christoph Hellwig wrote:
>> > On Thu, Nov 23, 2017 at 09:22:03AM +0800, Ching Huang wrote:
>> > > From: Ching Huang <ching2048@areca.com.tw>
>> > >
>> > > Hi all,
>> > >
>> > > The following patches apply to Martin's 4.16/scsi-queue.
>> > >
>> > > Patch 1: Add module parameter msi_enable to has a chance to disable msi interrupt if it does not work properly.
>> > >
>> > > Patch 2: Add module parameter msix_enable to has a chance to disable msix interrupt if it does not work properly.
>> >
>> > Why would it not work properly?
>> This patch is apply to
>> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/tree/?h=4.16/scsi-queue
>>
>
> No, the question is we're adding an option called "msi_enable" which is
> used to disable MSI interrupts "if it does not work properly".  Why is
> the current code not working properly?
>
> Is there a crash or a performance issue?  What does the bug in the
> current code look like from a user perspective?  Can you send us a dmesg
> from a failing system?
>
> regards,
> dan carpenter
