From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: Problem with USB-to-SATA adapters (was: AS2105-based enclosure
 size issues with >2TB HDDs)
Date: Fri, 29 Aug 2014 16:04:34 -0700
Message-ID: <CAA6KcBCnns-nuE4LA4EqWGhEbisueBNwAjN7vtYcfBdKm2WyUA@mail.gmail.com>
References: <Pine.LNX.4.44L0.1408271551170.1460-100000@iolanthe.rowland.org> <201408292107.s7TL7ZPj017216@hobgoblin.ariadne.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50950 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaH2XEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Aug 2014 19:04:55 -0400
Received: by mail-vc0-f176.google.com with SMTP id ik5so3240576vcb.35
        for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2014 16:04:54 -0700 (PDT)
In-Reply-To: <201408292107.s7TL7ZPj017216@hobgoblin.ariadne.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dale R. Worley" <worley@alum.mit.edu>
Cc: Alan Stern <stern@rowland.harvard.edu>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

Is there an 'easy' way to override the detected size of a storage
device from userspace?  If we had that, someone could write a helper
application which looked for this particular fubar and try to Do The
Right Thing(tm), or at least offer the user some options.

Matt

On Fri, Aug 29, 2014 at 2:07 PM, Dale R. Worley <worley@alum.mit.edu> wrote:
>> From: Alan Stern <stern@rowland.harvard.edu>
>
>> If you try to repartition the drive under Windows using the deficient
>> adapter, you'll see that the problem still exists.  It just doesn't
>> show up during normal use.
>
> So in summary, the Windows workaround is icky, but it allows any use
> but repartitioning to be one on the attached disk.
>
> Dale
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Matthew Dharm
Maintainer, USB Mass Storage driver for Linux
