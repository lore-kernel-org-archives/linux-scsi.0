From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: sg driver and Fedora Core 2
Date: 29 May 2004 12:28:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085851726.2004.186.camel@mulgrave>
References: <40B74725.90403@torque.net>
	<20040528172535.GD13961@devserv.devel.redhat.com>
	<1085846125.2101.29.camel@mulgrave>
	<20040529155744.GA32621@devserv.devel.redhat.com>
	<1085846840.2103.47.camel@mulgrave>
	<20040529162912.GA5922@devserv.devel.redhat.com>
	<1085849399.2004.101.camel@mulgrave>
	<20040529165630.GB11042@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:7365 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264386AbUE2R2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:28:53 -0400
In-Reply-To: <20040529165630.GB11042@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: Douglas Gilbert <dougg@torque.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Sat, 2004-05-29 at 11:56, Alan Cox wrote:
> On Sat, May 29, 2004 at 11:49:58AM -0500, James Bottomley wrote:
> > This question only arises if the fw update tools are using the old
> > interface ... I think an increasing level of pain on that front might
> > cause even closed source vendors to consider shifting to the new
> > interface using sd for the disc firmware update.
> 
> You think the drive vendors *care* about Linux flash updating tools. You
> think they will spend anything but the tiniest amount of funding on it. You
> think anyone who gets told "the major supplier of this OS has arbitarily
> broken your software during stable releases for no good reason" is likely
> to update their firmware.

Actually, yes, I think Linux is growing enough market momentum for them
to take notice.

> No. Not a chance. Its also nigh on impossible to use /dev/sd to scan the
> scsi busses for devices because you end up force loading modules, waiting
> for USB devices to come on line and other nastiness.

depending on what your after, device scanning (without any ULDs,
including sg) is simple in 2.6; it's ls /sys/bus/scsi/devices.

> > If the Fedora release people ultimately decide that the only way to sort
> > all the problems out is to back out the single attachment patch then
> > fine, we'll declare the experiment a failure and not consider anything
> 
> Given Linus has vetoed the change for 2.6 the experiment is dead. Its a
> "won't happen". Doing things with sysfs and 2.7 I can see, since it would
> be enumerable, would allow you to walk driver and device paths. The Fedora
> stuff is really irrelevant, the patch is a one person crusade without 
> consideration of the users

There's no patch to veto yet.  If you redhat people are taking it out of
fedora, then, for 2.6, there probably never will be.

I'm not saying "yes" to it's inclusion, I'm just not prepared to say
"no" until I see the patch and it gets debated on the list.

James






