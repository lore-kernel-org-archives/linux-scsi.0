From: Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH] scsi: remove extra white space at the end of the line
Date: Fri, 22 Dec 2017 09:37:52 +0800
Message-ID: <5A3C61F0.2010508@huawei.com>
References: <20171221024049.36509-1-yanaijie@huawei.com>
 <1513872544.2931.13.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:50520 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753535AbdLVBin (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 20:38:43 -0500
In-Reply-To: <1513872544.2931.13.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, Damien Le Moal <Damien.LeMoal@wdc.com>


On 2017/12/22 0:09, Bart Van Assche wrote:
> On Thu, 2017-12-21 at 10:40 +0800, Jason Yan wrote:
>> My editor always try to remove the extra white space at the end of the
>> line when I make some changes. I'm tired of adjusting them manually.
>> Can we remove them in mainline?
>
> Hello Jason,
>
> I think this means that your editor has been misconfigured. Any kernel code
> changes should be the result of a deliberate action by a human. Configuring an
> editor to apply any changes automatically to existing code is wrong.
>
> There are several reasons why most kernel maintainers ignore patches like this
> one silently:
> * Whitespace changes make it harder than necessary to backport patches to
>    distro kernels. Before a patch that came later than the whitespace changes
>    can be backported, the whitespace change has to be backported. Additionally,
>    if a whitespace change touches many source files, the order in which to
>    backport patches becomes really important.
> * Before a kernel developer posts a patch that fixes a bug she or he has to
>    verify the change history (git log -p) to figure out which patch introduced
>    the bug. Patches that only change coding style pollute the change history.
> * Accepting a patch that only changes whitespace would open the floodgates for
>    other kernel coding style change patches. If a patch that only changes
>    whitespace would get accepted it will become hard to keep other kernel
>    coding style change patches out. A few examples of recently posted coding
>    style patches that do not change any functionality are:
>    - scsi_dh: fix format of struct members
>      (https://marc.info/?l=linux-scsi&m=151344115716122&w=2).
>    - PS3: Adjustments for six function implementations
>      (https://www.spinics.net/lists/linux-kernel-janitors/msg38252.html).
>
> See also https://btrfs.wiki.kernel.org/index.php/Developer%27s_FAQ#How_not_to_start.
>
> Thanks,
>
> Bart.
>

Hi Bart.

I understand all these reasons. But after all these years of
development, the scsi subsystem still have this *huge* number of
whitespaces, especially in the scsi core files. I have not seen this in
other subsystems.

Thanks for your patient explain. So please ignore this patch.

Jason
