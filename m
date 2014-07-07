From: loody <miloody@gmail.com>
Subject: Re: dummy scsi read or scsi command periodically for external USB
 Hard Disk
Date: Mon, 7 Jul 2014 22:37:47 +0800
Message-ID: <CANudz+uUuhLdfkVSseXXHW6ugm126Q4Taau+s7wavAP=Z9=4XA@mail.gmail.com>
References: <CANudz+sYkDthT9-xpt_hdqXHj+pSeTR5UcNmsPa4uP+YCvzSiw@mail.gmail.com>
	<20140707092029.GA19630@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:45864 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaGGOh4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2014 10:37:56 -0400
In-Reply-To: <20140707092029.GA19630@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryn M. Reeves" <bmr@redhat.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

hi Bryn:

2014-07-07 17:20 GMT+08:00 Bryn M. Reeves <bmr@redhat.com>:
> On Sun, Jul 06, 2014 at 01:18:03AM +0800, loody wrote:
>> hi all:
>>     we met a USB Hard Disk that will go to suspend if host stop
>> sending scsi command over 5mins.
>>     To save the IO, kernel will keep the file in page cache as much as
>> he can and under this circumstances, the scsi command may disappear
>> for a while longer enough to cause the device suspend.
>>
>>     is there any kernel config or module parameter can do the dummy
>> read or scsi command periodically?
>
> No but you could set up a simple cron job to call an sg3_utils command.
>
> E.g. issue an sg_read for one sector to the device every 4m:
>
>   */4 * * * * sg_read count=1 if=/dev/<disk>
Since my target platform arm embedded system,
does that mean I should include sg_read in my Busybox
or
cross-compile sg_read from sg3_utils?

appreciate your kind help,
