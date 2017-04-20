From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH-v1 00/22] lpfc updates for 11.2.0.12
Date: Thu, 20 Apr 2017 11:54:17 -0700
Message-ID: <aeb01fc4-1f18-3e8a-0c45-fb31f6d20eb0@broadcom.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
 <20170420183047.GD22378@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33260 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S946892AbdDTSyU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 14:54:20 -0400
Received: by mail-oi0-f42.google.com with SMTP id y11so31181103oie.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 11:54:20 -0700 (PDT)
In-Reply-To: <20170420183047.GD22378@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com

On 4/20/2017 11:30 AM, Jens Axboe wrote:
> On Wed, Apr 19 2017, jsmart2021@gmail.com wrote:
>> From: James Smart <jsmart2021@gmail.com>
>>
>> This patch set provides a number of bug fixes, code cleanups, and error
>> handling, mostly in the nvme area of lpfc.
>>
>> There is one new feature in the series to add Fabric Assigned WWN support.
>>
>> The patches were cut against the linux-block tree, for-4.12/block branch,
>> and are intended to be pulled in through that tree rather than the scsi trees.
>>
>> The patches are dependent on the FC nvme/nvmet patches from the following 2
>> series:
>> http://lists.infradead.org/pipermail/linux-nvme/2017-April/009250.html
>> http://lists.infradead.org/pipermail/linux-nvme/2017-April/009256.html
> James, if you can address the (minor) review comments from Johannes and
> repost with the reviewed/tested-by collected, we can get this applied. I
> almost applied it as-is, but we may as well just get the last little
> bits fixed up.
>
> Thanks!
>
yes - posting shortly.

-- james
