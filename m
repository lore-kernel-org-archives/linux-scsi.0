From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: sg driver and Fedora Core 2
Date: 29 May 2004 10:55:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085846125.2101.29.camel@mulgrave>
References: <40B74725.90403@torque.net>
	<20040528172535.GD13961@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:3255 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264308AbUE2Pzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 11:55:33 -0400
In-Reply-To: <20040528172535.GD13961@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Fri, 2004-05-28 at 12:25, Alan Cox wrote:
> On Sat, May 29, 2004 at 12:05:25AM +1000, Douglas Gilbert wrote:
> > The recently released Fedora Core 2 distribution contains
> > a patch that allocates sg device names (e.g. /dev/sg0)
> > only to those SCSI devices _not_ "claimed" by other upper
> 
> This is an error. Linus has also vetoed this change. Consider the
> Fedora kernel wrong on this point. It isnt however your SG_IO issue I think

I don't necessarily regard this as an error: single attachment of ULDs
would be very helpful.  However, since the mechanics of implementing
single attachment are difficult (sg has to be the default attachment of
every unclaimed devices, so you need to sort out issues when an ULD is
probed *after* sg is attached etc.), I'm very happy for Fedora to
demonstrate the feasibility of its implementation before a patch is
proposed to mainline.

James


