From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 13:38:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529173809.GB24516@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave> <20040529165630.GB11042@devserv.devel.redhat.com> <1085851726.2004.186.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:2794 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264411AbUE2RiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:38:16 -0400
Content-Disposition: inline
In-Reply-To: <1085851726.2004.186.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Sat, May 29, 2004 at 12:28:45PM -0500, James Bottomley wrote:
> > think anyone who gets told "the major supplier of this OS has arbitarily
> > broken your software during stable releases for no good reason" is likely
> > to update their firmware.
> 
> Actually, yes, I think Linux is growing enough market momentum for them
> to take notice.

If we act professionally maybe. But breaking that the way FC2 did wasnt
professional

> depending on what your after, device scanning (without any ULDs,
> including sg) is simple in 2.6; it's ls /sys/bus/scsi/devices.

and opening those is probably a 2.7 way to get rid of /dev/sg

> There's no patch to veto yet.  If you redhat people are taking it out of
> fedora, then, for 2.6, there probably never will be.

That is Arjan's call. I already build Fedora 2 kernels with it removed
and I'm far from unique in that. The simple fact its an API change makes
it a 2.7 kernel thing.
