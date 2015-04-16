From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: Backport of a fix for HPSA (Disabling a disabled device problem
 during kdump) driver
Date: Thu, 16 Apr 2015 17:03:55 +0100
Message-ID: <20150416160355.GB5949@hercules>
References: <CANcb+4va2cYPtfTwd-Mv2X=cG5vTy=pz_wE3S+-d1-5Z9qSFoA@mail.gmail.com>
 <54AC0A17.8020405@redhat.com>
 <20150128001837.GE17677@kroah.com>
 <CAHTgTXU1GV8JszqJojk9ML7f1yEtERHY0VjrnjX+OMh4Z_=t0g@mail.gmail.com>
 <552BC234.4020000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55036 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbDPQED (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 12:04:03 -0400
Content-Disposition: inline
In-Reply-To: <552BC234.4020000@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Vinson Lee <vlee@twopensource.com>, Greg KH <greg@kroah.com>, Masoud Sharbiani <msharbiani@twopensource.com>, stable@vger.kernel.org, Don Brace <Don.Brace@pmcs.com>, JBottomley@parallels.com, linux-scsi@vger.kernel.org

On Mon, Apr 13, 2015 at 03:18:44PM +0200, Tomas Henzl wrote:
> On 04/11/2015 12:45 AM, Vinson Lee wrote:
> > On Tue, Jan 27, 2015 at 4:18 PM, Greg KH <greg@kroah.com> wrote:
> >> On Tue, Jan 06, 2015 at 05:15:19PM +0100, Tomas Henzl wrote:
> >>> On 01/05/2015 07:41 PM, Masoud Sharbiani wrote:
> >>>> Dear stable maintainers,
> >>>> Can you please backport commitid 132aa220b45d60e9b20def1e9d8be94=
22eed9616
> >>>>  (hpsa: refine the pci enable/disable handling) to 3.10 stable (=
and
> >>>> earlier, if applicable)?
> >>> Please do not apply this patch isolated from his friend, the
> >>> 859c75aba20264d87dd026bab0d0ca3bff385955 hpsa: add missing pci_se=
t_master in kdump path
> >>> needs to be applied together with the 132aa220b45d60e9b20def1e9d8=
be9422eed9616 .
> >>>
> >>> In addition to that, after the original issue goes away you may n=
otice sometimes
> >>> an unhandled irq 16 message, to fix this a patch is posted
> >>> here http://www.spinics.net/lists/linux-scsi/msg80316.html
> >>> This patch still awaits a maintainers review though.
> >>>
> >>> Probably the best idea is to wait until the issue is solved compl=
etely.
> >> I'll wait, when it all gets worked out, please let stable@ know wh=
at
> >> patches to apply where.
> >>
> >> thanks,
> >>
> >> greg k-h
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe stable" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > Hi, Thomas.
> >
> > The unhandled irq 16 issue seems to be fixed by 4.0-rc1 commit "hps=
a:
> > turn off interrupts when kdump starts".
> >
> > Are the following patches suitable for stable now?
>=20
> Yes, I believe they are, just note that=20
> 03741d9 hpsa: fix memory leak in kdump hard reset
> is not a part of that group we discussed before, but it may be added
> to stable too.
>=20
> Cheers,
> Tomas
>=20
> >
> > 3b74729 hpsa: turn off interrupts when kdump starts
> > 03741d9 hpsa: fix memory leak in kdump hard reset
> > 859c75a hpsa: add missing pci_set_master in kdump path
> > 132aa22 hpsa: refine the pci enable/disable handling
> >
> > Cheers,
> > Vinson
>

I am queuing these 4 patches for the 3.16 kernel as well.

Cheers,
--
Lu=EDs

> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
