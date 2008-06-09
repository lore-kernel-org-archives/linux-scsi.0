From: "Grant Grundler" <grundler@google.com>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Sun, 8 Jun 2008 21:51:09 -0700
Message-ID: <da824cf30806082151n12898443p1a780a431e99712f@mail.gmail.com>
References: <200806010415.05290.chris2553@googlemail.com>
	 <200806060607.29460.chris2553@googlemail.com>
	 <1212761485.3466.6.camel@localhost.localdomain>
	 <200806061735.35268.chris2553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:19405 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbYFIEvR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 00:51:17 -0400
Received: from spaceape13.eur.corp.google.com (spaceape13.eur.corp.google.com [172.28.16.147])
	by smtp-out.google.com with ESMTP id m594pAiA006690
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jun 2008 05:51:10 +0100
Received: from rv-out-0708.google.com (rvfc5.prod.google.com [10.140.180.5])
	by spaceape13.eur.corp.google.com with ESMTP id m594p9IC021629
	for <linux-scsi@vger.kernel.org>; Mon, 9 Jun 2008 05:51:10 +0100
Received: by rv-out-0708.google.com with SMTP id c5so1759839rvf.52
        for <linux-scsi@vger.kernel.org>; Sun, 08 Jun 2008 21:51:09 -0700 (PDT)
In-Reply-To: <200806061735.35268.chris2553@googlemail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: chris2553@googlemail.com
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>

On Fri, Jun 6, 2008 at 10:35 AM, Chris Clayton <chris2553@googlemail.com> wrote:
>...
> Yes, I still get the boot pause and the delay in desktop icons appearing when a
> usb-storage device is plugged in with -rc5. A boot log is attached. Is there
> some sort of verbose scsi boot messaging that I can switch on? I've looked but
> I'm damned if I can find anything in 'make menuconfig'.

SCSI_CONSTANTS and SCSI_LOGGING might help.
Both live in the SCSI options menu. Read the Kconfig help on how
to use SCSI_LOGGING.

Can you please also enable CONFIG_PRINTK_TIME ?

Using the timestamps in /var/log/messages is ok but not the most
reliable place to get somewhat accurate time stamps of events.

hth,
grant
