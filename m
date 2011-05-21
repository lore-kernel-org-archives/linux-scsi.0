From: Jim Cromie <jim.cromie@gmail.com>
Subject: Re: [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
Date: Fri, 20 May 2011 22:21:00 -0600
Message-ID: <BANLkTi=6qWpUX6wMi5egRhi+qigaGPgnFQ@mail.gmail.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
 <1305840792-25877-9-git-send-email-jim.cromie@gmail.com> <4DD68BE0.6030003@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37342 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1EUEVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 21 May 2011 00:21:30 -0400
In-Reply-To: <4DD68BE0.6030003@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>, osd-dev@open-osd.org, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

On Fri, May 20, 2011 at 9:42 AM, Boaz Harrosh <bharrosh@panasas.com> wr=
ote:
> On 05/20/2011 12:33 AM, Jim Cromie wrote:
>> cc: Doug Gilbert <dgilbert@interlog.com>
>> cc: linux-scsi@vger.kernel.org
>> cc: Benny Halevy <bhalevy@panasas.com>
>> cc: Boaz Harrosh <bharrosh@panasas.com>
>> cc: osd-dev@open-osd.org
>> cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
>> cc: linux-scsi@vger.kernel.org
>> Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
>> ---
>> =A0drivers/scsi/osd/osd_uld.c | =A0 =A06 +++---
>> =A0drivers/scsi/pmcraid.c =A0 =A0 | =A0 =A03 +--
>> =A0drivers/scsi/sg.c =A0 =A0 =A0 =A0 =A0| =A0 =A06 +++---
>> =A0drivers/scsi/st.c =A0 =A0 =A0 =A0 =A0| =A0 =A07 +++----
>> =A04 files changed, 10 insertions(+), 12 deletions(-)
>
> Do you have a git tree with all these that I can pull
> and test?
>

I do, its at git://github.com/jimc/linux-2.6.git  chrdev-pub1 branch

=46or you, I think there are 3 patches of interest
1 - adds new call, deprecates old.
if you build with this applied and CONFIG_ENABLE_WARN_DEPRECATED=3Dy
you should get a deprecated warning
2 - reimplements alloc_chardev_region() with register_chardev_ids()
your driver may be using register_chardev_region(), if so this is unint=
eresting.
3 - patch that adapts your scsi parts.

> Thanks
> Boaz
>

no, thank you
Jim Cromie
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
