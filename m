From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: libsas: Add missing license and update to SPDX
 license identifier
Date: Thu, 29 Nov 2018 07:49:01 -0800
Message-ID: <1543506541.2881.16.camel@linux.vnet.ibm.com>
References: <1543328132-243266-1-git-send-email-john.garry@huawei.com>
         <20181127144333.GA11004@kroah.com>
         <8ae3a984-b4d4-f2eb-4aaa-b460441fa403@huawei.com>
         <07b65f80-9b73-472f-1fb8-7c0133f1d1ab@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <07b65f80-9b73-472f-1fb8-7c0133f1d1ab@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-11-29 at 11:52 +0000, John Garry wrote:
[...]
> Hi Greg,
> 
> I also note that currently we have an inconsistency in license of 
> sas_init.c:
> 
> /*
>   * Serial Attached SCSI (SAS) Transport Layer initialization
>   *
>   * Copyright (C) 2005 Adaptec, Inc.  All rights reserved.
>   * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
>   *
>   * This file is licensed under GPLv2.
>   *
>   * This program is free software; you can redistribute it and/or
>   * modify it under the terms of the GNU General Public License as
>   * published by the Free Software Foundation; either version 2 of
> the
>   * License, or (at your option) any later version.
>   *
>   * This program is distributed in the hope that it will be useful,
> but
>   * WITHOUT ANY WARRANTY; without even the implied warranty of
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>   * General Public License for more details.
>   *
>   * You should have received a copy of the GNU General Public License
>   * along with this program; if not, write to the Free Software
>   * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-
> 1307
>   * USA
>   *
>   */
> 
> ...
> 
> MODULE_AUTHOR("Luben Tuikov <luben_tuikov@adaptec.com>");
> MODULE_DESCRIPTION("SAS Transport Layer");
> MODULE_LICENSE("GPL v2");
> 
> So the license specifies v2+ but module license states v2.
> 
> I could not find a docment for guidance on this. I also note that
> making sas_task.c v2 would mean mixing v2 and v2+ into the module.

The point here is to get help.  There are three pieces of evidence in
the file one for v2+ and two for v2.  So you can look in the git tree
to when it was actually contributed:

commit 2908d778ab3e244900c310974e1fc1c69066e450
Author: James Bottomley <James.Bottomley@SteelEye.com>
Date:   Tue Aug 29 09:22:51 2006 -0500

    [SCSI] aic94xx: new driver
 
and if you ask the original contributor he can tell you the original
intent was v2 only.  If you want to modify all the files in libsas and
aic9xxx to have that SPDX tag.

> At this point I'm reluctant to touch this in case I mess up, but
> there  is still the missing license in sas_task.c .

Again, the tree will tell you.  In this case it's

commit 366ca51f30de1cbb5b356c70b7bb22051c558e41
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Fri Jan 18 10:47:01 2008 -0600

    [SCSI] libsas: abstract STP task status into a function

So that file is a direct extraction from an existing v2 only file in
aic9xxx, so it's licence is also v2 only.

James
