From: Caspar Smit <c.smit@truebit.nl>
Subject: Re: mpt2sas: bug in disk ordering?
Date: Fri, 13 May 2011 12:56:31 +0200
Message-ID: <BANLkTintzQ6DpvHgw=YHQ2YJ1D65KfMpgA@mail.gmail.com>
References: <BANLkTi=SsdjeHJOU_we+kZMgM0qm7eaVjg@mail.gmail.com>
	<BANLkTikmS3ytn2MNczbvRinvwk4M-ba90g@mail.gmail.com>
	<4DCD09D9.4080702@die-jansens.de>
	<BANLkTi=QOSDOvgfXX9qqgdmOSicQpV4ViA@mail.gmail.com>
	<4DCD0D2D.4050807@die-jansens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36459 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492Ab1EMK4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2011 06:56:32 -0400
Received: by qyk7 with SMTP id 7so251124qyk.19
        for <linux-scsi@vger.kernel.org>; Fri, 13 May 2011 03:56:31 -0700 (PDT)
In-Reply-To: <4DCD0D2D.4050807@die-jansens.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Jansen <lists@die-jansens.de>
Cc: linux-scsi@vger.kernel.org

No,

I'm not using an expander.

The 9211-8i is connected to a Supermicro SAS113TQ rev 1.1 backplane
which has 8 ports.

Kind regards,

Caspar Smit

2011/5/13 Arne Jansen <lists@die-jansens.de>
>
> On 13.05.2011 12:41, Caspar Smit wrote:
> > That is something I really don't like.
> >
> > After more checking I noticed the /dev/disk/by-path doesn't have any
> > links for the disks and their slots anymore.
>
> > 2011/5/13 Arne Jansen <lists@die-jansens.de>:
> >> On 13.05.2011 12:34, Caspar Smit wrote:
> >>> I tried with Debian Squeeze with the latest backports kernel 2.6.38,
> >>> which has mpt2sas version 07.100.00.00
> >>> and now the disks are ordered this way:
> >>>
> >>> /dev/sdb = slot 3
> >>> /dev/sdc = slot 2
> >>> /dev/sdd = slot 1
> >>> /dev/sde = slot 0
> >>> /dev/sdf = slot 7
> >>> /dev/sdg = slot 6
> >>> /dev/sdh = slot 5
> >>> /dev/sdi = slot 4
> >>
> >> I see something similar here, and, what's worse, the order may very from
> >> boot to boot.
>
>
> It might also be a problem of the expander, in that it reports the disk
> in this order. Are you using an expander?
>
