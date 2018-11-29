From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: Add missing license and update to SPDX
 license identifier
Date: Thu, 29 Nov 2018 11:52:39 +0000
Message-ID: <07b65f80-9b73-472f-1fb8-7c0133f1d1ab@huawei.com>
References: <1543328132-243266-1-git-send-email-john.garry@huawei.com>
 <20181127144333.GA11004@kroah.com>
 <8ae3a984-b4d4-f2eb-4aaa-b460441fa403@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8ae3a984-b4d4-f2eb-4aaa-b460441fa403@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 27/11/2018 15:23, John Garry wrote:
> On 27/11/2018 14:43, Greg KH wrote:
>
> Hi Greg,
>
>> On Tue, Nov 27, 2018 at 10:15:32PM +0800, John Garry wrote:
>>> Currently sas_task.c has no license specifier, so add SPDX license
>>> identifier for GPL-2.0+.
>>>
>>> As mentioned in commit b24413180f56 ("License cleanup: add SPDX GPL-2.0
>>> license identifier to files with no license"), files with no license in
>>> the kernel are under default kernel license.
>>
>> The default is GPLv2, not v2+.
>
> So sas_task.c should be v2.

Hi Greg,

I also note that currently we have an inconsistency in license of 
sas_init.c:

/*
  * Serial Attached SCSI (SAS) Transport Layer initialization
  *
  * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
  * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
  *
  * This file is licensed under GPLv2.
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation; either version 2 of the
  * License, or (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful, but
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
  * USA
  *
  */

...

MODULE_AUTHOR("Luben Tuikov <luben_tuikov@adaptec.com>");
MODULE_DESCRIPTION("SAS Transport Layer");
MODULE_LICENSE("GPL v2");

So the license specifies v2+ but module license states v2.

I could not find a docment for guidance on this. I also note that making 
sas_task.c v2 would mean mixing v2 and v2+ into the module.

I did find an example of someone changing the license:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/i2c/busses/i2c-designware-slave.c?h=v4.20-rc4&id=15c566fcff9cc7b8fd64461d6ee6fd1bc665b444

Then someone changes the module license (but same company):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/sound/soc/sh/rcar/core.c?h=v4.20-rc4&id=1e0edd4deadbbacd3b35179c233efa26624ab2af

At this point I'm reluctant to touch this in case I mess up, but there 
is still the missing license in sas_task.c .

Thanks,
John

>
>>
>>>
>>> While I'm at it, all other libsas source code files are updated to use
>>> SPDX license identifier for GPL-2.0+.
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>>
>>> diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
>>> index 13739bfa..bdc6bce 100644
>>> --- a/drivers/scsi/libsas/Kconfig
>>> +++ b/drivers/scsi/libsas/Kconfig
>>> @@ -4,22 +4,7 @@
>>>  # Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
>>>  # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
>>>  #
>>> -# This file is licensed under GPLv2.
>>> -#
>>> -# This program is free software; you can redistribute it and/or
>>> -# modify it under the terms of the GNU General Public License as
>>> -# published by the Free Software Foundation; version 2 of the
>>> -# License.
>>> -#
>>> -# This program is distributed in the hope that it will be useful,
>>> -# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> -# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>> -# General Public License for more details.
>>> -#
>>> -# You should have received a copy of the GNU General Public License
>>> -# along with this program; if not, write to the Free Software
>>> -# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
>>> -# USA
>>> +# SPDX-License-Identifier: GPL-2.0+
>>
>> No, the above license is GPLv2 only, do NOT change the license of a file
>> unless you have permission to do so.
>
> Of course. That was not my intention. My mistake.
>
>>
>> Also, the spdx line goes at the first line of the file.
>
> JFYI, checkpatch.pl does pick up on this for .c/.h files but not this one.
>
>>
>>
>>>  #
>>>
>>>  config SCSI_SAS_LIBSAS
>>> diff --git a/drivers/scsi/libsas/Makefile b/drivers/scsi/libsas/Makefile
>>> index 5d51520..75998b7 100644
>>> --- a/drivers/scsi/libsas/Makefile
>>> +++ b/drivers/scsi/libsas/Makefile
>>> @@ -4,22 +4,7 @@
>>>  # Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
>>>  # Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
>>>  #
>>> -# This file is licensed under GPLv2.
>>> -#
>>> -# This program is free software; you can redistribute it and/or
>>> -# modify it under the terms of the GNU General Public License as
>>> -# published by the Free Software Foundation; version 2 of the
>>> -# License.
>>> -#
>>> -# This program is distributed in the hope that it will be useful,
>>> -# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> -# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>> -# General Public License for more details.
>>> -#
>>> -# You should have received a copy of the GNU General Public License
>>> -# along with this program; if not, write to the Free Software
>>> -# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
>>> -# USA
>>> +# SPDX-License-Identifier: GPL-2.0+
>>
>> Again you changed the license, not good :(
>
> I was thrown by having a different license for the Kconfig+Makefile vs
> .c/.h.
>
>>
>> Please do not make these types of changes unless you really know what
>> you are doing, it is not ok to change the license of files.
>
> Right, of course.
>
>>
>> greg k-h
>>
>
> Thanks, I'll fix them properly,
> John
>
>
>
>
> .
>
