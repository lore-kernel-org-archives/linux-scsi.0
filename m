From: loody <miloody@gmail.com>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Wed, 9 Jul 2014 22:15:56 +0800
Message-ID: <CANudz+vD5MTGXhWtCQ1oj5nPjUoyWC9GzX=rW8hGqHawHvo_4g@mail.gmail.com>
References: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>
	<20140707092029.GA19630@localhost.localdomain>
	<CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>
	<53BAB5DF.5090606@gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D1726D887@AcuExch.aculab.com>
	<CANudz+uOS3VVyz6FcHoui8z678R6Xc0CQrdqFRdS5NyfCB59Zw@mail.gmail.com>
	<20140707155233.GD19630@localhost.localdomain>
	<CANudz+s8R3AnxEJ229EwAOOxEk2WZUjMjoE3rwdRM1YM5ZO=og@mail.gmail.com>
	<20140707162554.GF19630@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39148 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372AbaGIOP6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 10:15:58 -0400
In-Reply-To: <20140707162554.GF19630@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: David Laight <David.Laight@aculab.com>, Lars Melin <larsm17@gmail.com>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

hi Bryn:

2014-07-08 0:25 GMT+08:00 Bryn M. Reeves <bmr@redhat.com>:
> On Tue, Jul 08, 2014 at 12:15:54AM +0800, loody wrote:
>> so sg_read will not hammer on the page cache like dd without "iflags=direct"
>>
>> thanks for your kind help,
>
> The sg_read program (and other programs in sg3_utils) sends a command directly
> to the device using an SG_IO ioctl. This bypasses all the caching layers in
> the kernel and always results in IO to the device (if it succeeds).
>
I download sg utility but I found if I need to use sg_read only, I
need to install sg_lig on my target system.
is there any simple source I can reference for just doing the scsi
read through IOCTL as you explained to us before?

appreciate your kind help,


-- 
Regards,
