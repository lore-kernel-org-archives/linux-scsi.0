From: "Caspar Smit" <caspar@ketsers.dhs.org>
Subject: Re: MVSAS status
Date: Wed, 10 Feb 2010 10:36:05 +0100 (CET)
Message-ID: <2514.62.195.29.195.1265794565.squirrel@ketsers.dhs.org>
References: <loom.20100210T002935-813@post.gmane.org>
    <333bc7e11002100122m5eb97d7ey78a31df91dee2405@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:56504 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0BJJq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Feb 2010 04:46:58 -0500
In-Reply-To: <333bc7e11002100122m5eb97d7ey78a31df91dee2405@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Audio Haven <audiohaven@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

> I'm still experiencing issues with this patched driver (using patches
> posted in November '09), but I believe I'm hitting known issues in th=
e
> following Western Digital green drives.
>
> WDC WD15EADS-00P8B0
>
> I have five of those 00P8B0, some of them have a really high
> Load_Cycle_Count, or they become slow during a raid rebuild, or they
> just timeout when not using WDIDLE3.EXE (and using the default 8sec
> Intellipark feature which is really bad design) ... they are reported
> as BAD and "NOT RECOMMENDED" all over the internet. WD doesn't provid=
e
> a decent solution yet for these.
>
> My three newer WD15EADS-00S2B0 are also running on the same Marvell
> controller and were never kicked out of the raid. Stable and decent
> speed. I didn't see any issue with those newer 00S2B0 drives, so I
> believe this is actually a WD issue and not a Marvell issue. Maybe th=
e
> timeouts are not handled well by the Marvell driver and we're seeing
> mvs_abort_task , but that looks more like a symptom.
>
> I disabled the intellipark feature of the WD drives using WDIDLE3.EXE
> via a DOS usb bootable stick, and instead of timing out, the
> WD15EADS-00P8B0 just have become extremely slow now, iostat reports
> 1.5 MB/s writes to the  raid rebuild drive.
>
> I believe the current MVSAS patches should be good enough if you avoi=
d
> WD Green drives;

Well,

I am still experiencing very unstable SATA hotplugging, 9 out of 10
hotplugs end up in a kernel panic (only with SATA disks, SAS is fine).
Still problems with using 3 controllers in 1 machine using SATA disks i=
s
instant kernel panic.

Using 2.6.32.2 kernel with the november (1-6/7) patches from Andy Yan.

Kind regards,
Caspar Smit

>
> Best regards,
>
> Audio Haven
>
> On Wed, Feb 10, 2010 at 12:32 AM, Orion Poplawski <orion@cora.nwra.co=
m>
> wrote:
>> What's the status of the MVSAS patches posted in November '09? =A0I'=
m just
>> trying
>> to get started with mvsas and running into the mvs_abort_task issue.=
 =A0At
>> least
>> one person has reported that stability improved, but it looks like t=
here
>> were
>> some other issues with the patches. =A0Any chance on seeing this in =
the
>> mainline
>> kernel soon? =A0Are there updated versions? =A0A git tree to pull fr=
om?
>>
>> Thanks!
>>
>> - Orion Poplawski
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
