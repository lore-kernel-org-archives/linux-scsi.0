From: li jianyun <jianyunff@gmail.com>
Subject: Re: [PATCH] Add Marvell UMI driver
Date: Wed, 20 Apr 2011 22:58:30 +0800
Message-ID: <BANLkTimL4ndgb7FRkr393AD=yOCVyJ1QuA@mail.gmail.com>
References: <4daee9cb.04558f0a.76dc.4776@mx.google.com> <20110420142626.GA22114@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34335 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1DTO65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2011 10:58:57 -0400
In-Reply-To: <20110420142626.GA22114@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org

Hi Grep KH
      thanks for your remind,I am a beginner=EF=BC=8Cand don't know how=
 to
send patch to kernel.
I will update the Signed-off-by. Do I need update the subject to
"[PATCH][RESEND] Add Marvell UMI driver" when I resend this patch?
     thanks for your patient.


2011/4/20 Greg KH <greg@kroah.com>:
> On Wed, Apr 20, 2011 at 10:02:19PM +0800, Li Jianyun wrote:
>>
>>       The Marvell Universal Message Interface (UMI) defines a messag=
ing
>> interface between host and Marvell products. It considers situations=
 of
>> limited system resource and optimized system performance.
>>       UMI driver translates host request to message and sends messag=
e to
>> FW via UMI, FW receives message and processes it, then sends respons=
e to
>> UMI driver.
>>       FW generates an interrupt when it needs to send information or
>> responseto UMI driver.
>>
>> Signed-off-by: Jianyun Li <jianyunff@gmail.com>
>
> Why not sign off using your marvell.com email address?
>
>> +++ b/drivers/scsi/mvumi.c
>> @@ -0,0 +1,2245 @@
>> +/*
>> + * Marvell UMI driver
>> + *
>> + * Copyright 2011 Marvell. <jyli@marvell.com>
>> + *
>> + * This file is licensed under GPLv2.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation; version 2 of the
>> + * License.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GN=
U
>> + * General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public Licens=
e
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1=
307
>> + * USA
>
> Unless you are willing to track the office location of the FSF for th=
e
> next 40 years, and send patches updating it here, just drop this
> paragraph, it's pointless, as the person _did_ get a copy with the
> kernel.
>
> thanks,
>
> greg k-h
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
