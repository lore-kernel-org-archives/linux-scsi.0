From: Alan Cox <alan@redhat.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 12:56:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040529165630.GB11042@devserv.devel.redhat.com>
References: <40B74725.90403@torque.net> <20040528172535.GD13961@devserv.devel.redhat.com> <1085846125.2101.29.camel@mulgrave> <20040529155744.GA32621@devserv.devel.redhat.com> <1085846840.2103.47.camel@mulgrave> <20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38106 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264346AbUE2Q4i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 12:56:38 -0400
Content-Disposition: inline
In-Reply-To: <1085849399.2004.101.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Sat, May 29, 2004 at 11:49:58AM -0500, James Bottomley wrote:
> This question only arises if the fw update tools are using the old
> interface ... I think an increasing level of pain on that front might
> cause even closed source vendors to consider shifting to the new
> interface using sd for the disc firmware update.

You think the drive vendors *care* about Linux flash updating tools. You
think they will spend anything but the tiniest amount of funding on it. You
think anyone who gets told "the major supplier of this OS has arbitarily
broken your software during stable releases for no good reason" is likely
to update their firmware.

No. Not a chance. Its also nigh on impossible to use /dev/sd to scan the
scsi busses for devices because you end up force loading modules, waiting
for USB devices to come on line and other nastiness.

> If the Fedora release people ultimately decide that the only way to sort
> all the problems out is to back out the single attachment patch then
> fine, we'll declare the experiment a failure and not consider anything

Given Linus has vetoed the change for 2.6 the experiment is dead. Its a
"won't happen". Doing things with sysfs and 2.7 I can see, since it would
be enumerable, would allow you to walk driver and device paths. The Fedora
stuff is really irrelevant, the patch is a one person crusade without 
consideration of the users

Alan
