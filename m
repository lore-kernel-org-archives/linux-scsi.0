From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 11:57:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529155744.GA32621@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53700 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S263807AbUE2P5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 11:57:52 -0400
Content-Disposition: inline
In-Reply-To: <1085846125.2101.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Sat, May 29, 2004 at 10:55:24AM -0500, James Bottomley wrote:
> > This is an error. Linus has also vetoed this change. Consider the
> > Fedora kernel wrong on this point. It isnt however your SG_IO issue I think
> 
> I don't necessarily regard this as an error: single attachment of ULDs
> would be very helpful.  However, since the mechanics of implementing

Its most definitely problematic - it breaks a ton of existing tools, and
it also doesn't do what you think. Try this for size

insmod scsidriver
open /dev/sg0 (a hard disk)
insmod sd

Apps should migrate to the new facilities when possible but its definitely
not a good idea to make this change

