From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: 27 Dec 2003 09:52:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072540364.2030.41.camel@mulgrave>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	<3637050000.1054690456@aslan.s
				csiguy.com>
	<2113050000.1072285128@aslan.scsiguy.com>	<1072288242.1906.35.camel@mulgrave
			>	<2148850000.1072292121@aslan.scsiguy.com>
	<1072292714.2415.39.camel@mulgrave	>
		<2304040000.1072326693@aslan.scsiguy.com>	<1072463795.1873.127.camel@mulgra
	ve> <2832150000.1072484024@aslan.scsiguy.com>
	<1072495231.1873.363.camel@mulgrave>
	<2906490000.1072499170@aslan.scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:61840 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264476AbTL0Pwu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Dec 2003 10:52:50 -0500
In-Reply-To: <2906490000.1072499170@aslan.scsiguy.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

On Fri, 2003-12-26 at 22:26, Justin T. Gibbs wrote:
> You're telling me that fail-over for a multi-controller external RAID box
> connected to a single SCSI controller will occur at a higher level?  The
> fail-over has already occurred by the time the HBA see the timeout.  This
> means that completion of recovery is the only impediment to completing the
> fail-over.

The usual architecture of a multiple controller RAID box is no
SPOF...Therefore *two* or more SCSI cards...local in card attempts at
recovery only delays eventual failover.

> I've already written one OpenSource SCSI layer, I think I've contributed
> more than enough in that particular area.  Back in late 2000 and early 2001,
> I voiced my opinions, based on that experience, on how Linux should improve
> its SCSI subsystem.  After 3 years of waiting for improvement in the
> error recovery semantics of Linux, I had to do something to satisfy customer
> complaints on error recovery.  I still don't see things improving in
> this area of Linux and I'm not about to *break* the driver until there is
> a viable alternative.

This is open source...areas which cause problems for many people get
fixed (OK, often many times).  Areas that only annoy one person don't
get fixed just by expressing that annoyance.

> I'm sorry you feel that way.  I suppose I will just have to continue
> to point distributors and users of this driver to my own patch sets since
> that seems to be the only viable alternative you've given me.

OK, I'll be sorry to see it happen, but if Adaptec formally wishes to
relinquish maintainership of the aic7xxx/aic79xx drivers and develop
their own fork of the kernel, that is, of course, their right under the
GPL.  If this is what you want to do, could you send the list a note to
that effect so that I can begin looking for a new maintainer now.

James


