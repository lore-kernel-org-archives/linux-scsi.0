From: Marcelo Tosatti <marcelo@conectiva.com.br>
Subject: Re: [PATCH] Additional BLIST_LARGELUN devices
Date: Thu, 27 Jun 2002 17:22:14 -0300 (BRT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206271721270.11790-100000@freak.distro.conectiva>
References: <20020627145301.GB11237@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from burns.conectiva (burns.conectiva [10.0.0.4])
	by perninha.conectiva.com.br (Postfix) with SMTP id 9E60A39033
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2002 18:17:20 -0300 (EST)
In-Reply-To: <20020627145301.GB11237@gum01m.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <kurt@garloff.de>
Cc: Michael Clark <michael@metaparadigm.com>, Dave Jones <davej@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>



On Thu, 27 Jun 2002, Kurt Garloff wrote:

> Hi Michael,
>
> On Thu, Jun 27, 2002 at 10:09:11PM +0800, Michael Clark wrote:
> > On 06/27/02 00:47, Kurt Garloff wrote:
> > >here are some additional devices that need the BLIST_LARGELUN flag.
> > >
> > >+	{"CNSi", "G8324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     //
> > >Chaparral G8324 RAID
> >
> > The G8324 correctly identifies itself as SCSI-3 so doesn't
> > need the BLIST_LARGELUN flag (proc output below
> > from 2.4.18 with automated large lun scanning).
>
> OK, it got in that list by accident then. Won't hurt, of course.
> I removed the flag. New patch attached.

Could you please send me a patch to remove that one list entry because I
already applied the previous one.

