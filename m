From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: sg driver and Fedora Core 2
Date: 29 May 2004 11:07:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085846840.2103.47.camel@mulgrave>
References: <40B74725.90403@torque.net>
	<20040528172535.GD13961@devserv.devel.redhat.com>
	<1085846125.2101.29.camel@mulgrave>
	<20040529155744.GA32621@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:60344 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264858AbUE2QH1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 12:07:27 -0400
In-Reply-To: <20040529155744.GA32621@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Sat, 2004-05-29 at 10:57, Alan Cox wrote:
> On Sat, May 29, 2004 at 10:55:24AM -0500, James Bottomley wrote:
> > > This is an error. Linus has also vetoed this change. Consider the
> > > Fedora kernel wrong on this point. It isnt however your SG_IO issue I think
> > 
> > I don't necessarily regard this as an error: single attachment of ULDs
> > would be very helpful.  However, since the mechanics of implementing
> 
> Its most definitely problematic - it breaks a ton of existing tools, and
> it also doesn't do what you think. Try this for size
> 
> insmod scsidriver
> open /dev/sg0 (a hard disk)
> insmod sd

Refuse the insertion or do not attach, I suppose.  It would be the app's
fault for not managing the interface correctly.

> Apps should migrate to the new facilities when possible but its definitely
> not a good idea to make this change

Yes, that's why a change like this appeals.

However, as I said, I'm aware it's problematic which is why I'm not
about to make any change like it at this point.  But, if fedora can
demonstrate that it can be made to work sanely and easily, that would be
a very powerful argument for inclusion.

James


