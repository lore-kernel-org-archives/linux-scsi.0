From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: sg driver and Fedora Core 2
Date: 29 May 2004 11:49:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085849399.2004.101.camel@mulgrave>
References: <40B74725.90403@torque.net>
	<20040528172535.GD13961@devserv.devel.redhat.com>
	<1085846125.2101.29.camel@mulgrave>
	<20040529155744.GA32621@devserv.devel.redhat.com>
	<1085846840.2103.47.camel@mulgrave>
	<20040529162912.GA5922@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:18623 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263301AbUE2QuG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 12:50:06 -0400
In-Reply-To: <20040529162912.GA5922@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Sat, 2004-05-29 at 11:29, Alan Cox wrote:
> On Sat, May 29, 2004 at 11:07:19AM -0500, James Bottomley wrote:
> > > insmod scsidriver
> > > open /dev/sg0 (a hard disk)
> > > insmod sd
> > 
> > Refuse the insertion or do not attach, I suppose.  It would be the app's
> > fault for not managing the interface correctly.
> 
> So you stop users being able to hotplug controllers while doing firmware
> updates. Thats not good either

This question only arises if the fw update tools are using the old
interface ... I think an increasing level of pain on that front might
cause even closed source vendors to consider shifting to the new
interface using sd for the disc firmware update.

> > about to make any change like it at this point.  But, if fedora can
> > demonstrate that it can be made to work sanely and easily, that would be
> > a very powerful argument for inclusion.
> 
> Fedora bugzilla has demonstrated it *doesn't* work. There is a long list
> of broken third party apps such as drive firmware tools many of which will
> never include source code. The whole point of sg is arbitary management of
> devices. Its like /dev/mem and so forth, its power is in the fact it can
> always be used. This is why Linus vetoed the entire concept.

If there's enough evidence, open minds can be changed.

> Fedora hasn't solved the open /dev/sg , insmod case either.

I think it's too early to declare this experiment in Fedora a failure. 
If the Fedora release people ultimately decide that the only way to sort
all the problems out is to back out the single attachment patch then
fine, we'll declare the experiment a failure and not consider anything
like it for mainline.  However, while fedora is still trying to get
everything working with single attachment, I'm not going to prejudge.

James


