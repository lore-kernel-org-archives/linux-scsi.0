From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Wed, 13 Feb 2008 10:43:26 -0600
Message-ID: <1202921006.3109.29.camel@localhost.localdomain>
References: <875344.96222.qm@web31808.mail.mud.yahoo.com>
	 <47B2F9C3.8070207@emulex.com>
	 <1202918691.3109.18.camel@localhost.localdomain>
	 <47B3194C.7070809@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56039 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933182AbYBMQnf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 11:43:35 -0500
In-Reply-To: <47B3194C.7070809@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: ltuikov@yahoo.com, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org

On Wed, 2008-02-13 at 11:22 -0500, James Smart wrote:
> James Bottomley wrote:
> > I don't disagree with that, but the fact is that there isn't such a
> > tool.   It's also a fact that the enterprise is reasonably unhappy with
> > the lack of an enclosure management infrastructure, since it's something
> > they got on all the other unix systems.
> 
> I don't disagree.
> 
> > I think a minimal infrastructure in-kernel does just about everything
> > the enterprise wants ... and since it's stateless, they can always use
> > direct connect tools in addition.
> > 
> > However, I'm happy to be proven wrong ... anyone on this thread is
> > welcome to come up with a userland enclosure infrastructure.  Once it
> > does everything the in-kernel one does (which is really about the
> > minimal possible set), I'll be glad to erase the in-kernel one.
> 
> yeah, but...  putting something new in, only to pull it later, is a bad
> paradigm for adding new mgmt interfaces. Believe me, I've felt users pain in
> the reverse flow : driver-specific stuff that then has to migrate to upstream
> interfaces, complicated by different pull points by different distros. You can
> migrate a management interface, but can you really remove/pull one out ?

That depends on the result.  I agree that migration will be a pain, so I
suppose I set the bar a bit low; the user tool needs to be a bit more
compelling; plus I'll manage the interface transition ... if there is
one; there's no such tool yet.

> Isn't it better to let the lack of an interface give motivation to create
> the "right" interface, once the "right way" is determined - which is what I
> thought we were discussing ?    or is this simply that there is no motivation
> until something exists, that people don't like, thus they become motivated ?

Well ... I did learn the latter from Andrew, so I thought I'd try it.
It's certainly true that the enclosure problem has been an issue for
over a decade, so there doesn't seem to be anything motivating anyone to
solve it.  I wouldn't have bothered except that I could see ad-hoc
in-kernel sysfs solutions beginning to appear.  At least this way they
can all present a unified interface.

James


