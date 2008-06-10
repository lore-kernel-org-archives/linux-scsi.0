From: Chris Clayton <chris2553@googlemail.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Tue, 10 Jun 2008 18:46:24 +0000
Message-ID: <200806101846.24650.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <200806061735.35268.chris2553@googlemail.com> <da824cf30806082151n12898443p1a780a431e99712f@mail.gmail.com>
Reply-To: chris2553@googlemail.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:49565 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYFJSs7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 14:48:59 -0400
Received: by ug-out-1314.google.com with SMTP id h2so144690ugf.16
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2008 11:48:58 -0700 (PDT)
In-Reply-To: <da824cf30806082151n12898443p1a780a431e99712f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>

On Monday 09 June 2008, Grant Grundler wrote:
> On Fri, Jun 6, 2008 at 10:35 AM, Chris Clayton <chris2553@googlemail.com> 
wrote:
> >...
> > Yes, I still get the boot pause and the delay in desktop icons appearing
> > when a usb-storage device is plugged in with -rc5. A boot log is
> > attached. Is there some sort of verbose scsi boot messaging that I can
> > switch on? I've looked but I'm damned if I can find anything in 'make
> > menuconfig'.
>
> SCSI_CONSTANTS and SCSI_LOGGING might help.
> Both live in the SCSI options menu. Read the Kconfig help on how
> to use SCSI_LOGGING.
>
> Can you please also enable CONFIG_PRINTK_TIME ?

I've enabled CONFIG_PRINTK_TIME and will look into the SCSI options.

Thanks
>
> Using the timestamps in /var/log/messages is ok but not the most
> reliable place to get somewhat accurate time stamps of events.
>
> hth,
> grant



-- 
Beauty is in the eye of the beerholder.
