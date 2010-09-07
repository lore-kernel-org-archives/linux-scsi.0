From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 7 Sep 2010 08:45:00 +0200
Message-ID: <AANLkTi=zS=zTFZ-93vdMwPo1wcRsoLL9fnm5rxNT+4WH@mail.gmail.com>
References: <1283204792.32007.448.camel@haakon2.linux-iscsi.org>
	<4C7FFD1A.8090509@vlnb.net>
	<1283459158.5598.143.camel@haakon2.linux-iscsi.org>
	<20100905201802.GC18411@core.coreip.homeip.net>
	<1283723447.556.133.camel@haakon2.linux-iscsi.org>
	<20100905234134.GA17212@core.coreip.homeip.net>
	<1283731194.556.147.camel@haakon2.linux-iscsi.org>
	<1283769578.15944.1293.camel@mulgrave.site>
	<4C85617E.2080603@vlnb.net>
	<1283810135.556.238.camel@haakon2.linux-iscsi.org>
	<20100907004424.GB21430@core.coreip.homeip.net>
	<AANLkTin9Hk8+oMdXfB4h_DhirRyPf00739g5BpKcUE_5@mail.gmail.com>
	<4C85DBC9.6030601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53427 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab0IGGpC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2010 02:45:02 -0400
Received: by gxk23 with SMTP id 23so1840154gxk.19
        for <linux-scsi@vger.kernel.org>; Mon, 06 Sep 2010 23:45:01 -0700 (PDT)
In-Reply-To: <4C85DBC9.6030601@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, Vladislav Bolkhovitin <vst@vlnb.net>

On Tue, Sep 7, 2010 at 8:29 AM, Hannes Reinecke <hare@suse.de> wrote:
>
> Bart Van Assche wrote:
> [ ... ]
> > You seem to have missed the start of this thread. The design of SCST
> > is significantly more advanced than that of LIO, and it has already
> > been explained in this thread why
> > (http://www.spinics.net/lists/linux-scsi/msg45856.html).
> >
> Hmm. That link seems to be misrouted. I was hoping for a design
> overview of SCST there; however it's just a complain to
> James Bottomley etc.
>
> Care to send the correct link?

An SCST design overview diagram together with SCST API documentation
can be found here: http://scst.sourceforge.net/scst_pg.html (sorry for
the language imperfections on this page, which should not affect
readability though).

Some distinctive features of SCST that give it its high bandwidth and
low latency but that are not mentioned on that page are:
* Multithreaded command processing, even for a single LUN.
* Much care has been taken to minimize command processing latency.
This is why a dedicated SGV cache has been implemented in SCST, which
is, as far as I know, a unique feature.

It is also important to know that the SCST project has a large user
base, and that the SCST users appreciate the proven stability and
reliability of the SCST software and also its excellent SCSI
conformance.

Bart.
