From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: mvsas escalated kernel crash and ata mapping mvsas driver question
Date: Thu, 26 Jan 2017 11:17:31 +0100
Message-ID: <CAD+HZHW-0keq5RUiqMGpO_EnOLa7Z6ZeAtwtkGXvThi=sf4siw@mail.gmail.com>
References: <362cdbe9-3633-499e-9ee4-b1a8afed2e40@powercraft.nl>
 <2d56a20b-628f-d621-6c9b-ba5cdf8bf6a0@powercraft.nl> <c9684a81-901d-03ea-e322-c27089c4b204@powercraft.nl>
 <d8615494-756f-0fe9-9969-8e850fc5984d@powercraft.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34407 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752956AbdAZKRc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2017 05:17:32 -0500
Received: by mail-oi0-f51.google.com with SMTP id s203so1189291oie.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 02:17:32 -0800 (PST)
In-Reply-To: <d8615494-756f-0fe9-9969-8e850fc5984d@powercraft.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jelle de Jong <jelledejong@powercraft.nl>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

2017-01-26 10:51 GMT+01:00 Jelle de Jong <jelledejong@powercraft.nl>:
> Hello everybody,
>
> I got a server that seemingly random gets kernel crashes, due to an
> escalation of events from most likely the mvsas based disk controller.
>
> The harddisk should be okay, I replaced a whole bunch to be sure, but the
> server does not get stable. I can not seem to figure out how to map for
> example ata21.00 to an disk so I can do a deep badblock check.
>
> I have to complete boot with kernel crash log saved with additional
> information.
>
> http://paste.debian.net/plainh/96325d89
>
> Can somebody take a look and maybe help?
>
>
> 08:00.0 SCSI storage controller: Areca Technology Corp. ARC-1300ix-16
> 16-Port PCI-Express to SAS Non-RAID Host Adapter (rev 02)
>
> Kind regards,
>
> Jelle de Jong

Your IO error seems related to NCQ, have you tried to disable NCQ?

echo 1 > /sys/block/sdX/device/queue_depth

Maybe try 4.10-rc5 is also a option?

Regards,
Jack

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
