From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 12:29:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529162912.GA5922@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48079 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264329AbUE2Q3T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 12:29:19 -0400
Content-Disposition: inline
In-Reply-To: <1085846840.2103.47.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Sat, May 29, 2004 at 11:07:19AM -0500, James Bottomley wrote:
> > insmod scsidriver
> > open /dev/sg0 (a hard disk)
> > insmod sd
> 
> Refuse the insertion or do not attach, I suppose.  It would be the app's
> fault for not managing the interface correctly.

So you stop users being able to hotplug controllers while doing firmware
updates. Thats not good either

> about to make any change like it at this point.  But, if fedora can
> demonstrate that it can be made to work sanely and easily, that would be
> a very powerful argument for inclusion.

Fedora bugzilla has demonstrated it *doesn't* work. There is a long list
of broken third party apps such as drive firmware tools many of which will
never include source code. The whole point of sg is arbitary management of
devices. Its like /dev/mem and so forth, its power is in the fact it can
always be used. This is why Linus vetoed the entire concept.

Fedora hasn't solved the open /dev/sg , insmod case either.


