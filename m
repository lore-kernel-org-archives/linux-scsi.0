From: Doug Ledford <dledford@redhat.com>
Subject: Re: replace deprecated hosts.h file
Date: Sat, 29 May 2004 21:36:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085880986.18642.351.camel@compaq.xsintricity.com>
References: <20040529142126.GA31365@devserv.devel.redhat.com>
	 <40B8A7FA.8070802@pobox.com>
	 <20040529151431.GD31365@devserv.devel.redhat.com>
	 <40B8B383.4050602@pobox.com>
	 <20040529164056.GH31365@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56998 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261443AbUE3Bhy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 21:37:54 -0400
In-Reply-To: <20040529164056.GH31365@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan Van de Ven <arjanv@redhat.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

On Sat, 2004-05-29 at 12:40, Arjan van de Ven wrote:
> On Sat, May 29, 2004 at 12:00:03PM -0400, Jeff Garzik wrote:
> > Arjan van de Ven wrote:
> > >On Sat, May 29, 2004 at 11:10:50AM -0400, Jeff Garzik wrote:
> > >
> > >>Rejected, libata stays with the old headers until 2.7 (when it leaves 
> > >>scsi).
> > >
> > >
> > >why ?
> > 
> > Because I am actively maintaining the 2.4 version of libata.
> 
> ... and that involves not fixing 2.6 drivers.... how ?

For the sake of everyone listening:

core kernel code == specifically tied to kernel major/minor
hardware driver code != tied to kernel major/minor

While things like mm/filemap.c are expected to work only in the kernel
they belong to, the actual hardware drivers in drivers/* are mostly
expected to work in multiple kernel versions.  Cleanups to stuff in
drivers/* that does *not* take into account other kernel versions is not
only counter productive, it's down right rude and inconsiderate to the
people who have the job of making sure that their driver works in as
many places as possible with as few bugs as possible (obviously, this
applies to actively maintained or developed drivers, abandoned drivers
you can do whatever you want with since no one's trying to backport any
fixes you might make to the driver anyway).  The driver world does not
equal a single kernel version, don't try and pretend that it does.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


