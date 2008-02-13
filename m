From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Wed, 13 Feb 2008 10:04:51 -0600
Message-ID: <1202918691.3109.18.camel@localhost.localdomain>
References: <875344.96222.qm@web31808.mail.mud.yahoo.com>
	 <47B2F9C3.8070207@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:49999 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757430AbYBMQEz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 11:04:55 -0500
In-Reply-To: <47B2F9C3.8070207@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: ltuikov@yahoo.com, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org

On Wed, 2008-02-13 at 09:08 -0500, James Smart wrote:
> The keep-it-in-user-space arguments seem fairly compelling to me.
> Especially as we've pushed whole i/o subsystems out to user space
> (iscsi, stgt, talked about fcoe, a lot of dm control, etc).

And to me too.

> The functionality seems to align with Doug's sg/lsscsi utility chain
> as well.  Granted, the new utility would have to be designed in such
> as way that it can incorporate vendor "hardware handlers".  But, if
> James has a somewhat common implementation already for a kernel
> implementation, I'm sure that can be the starting point for lsscsi.
> 
> So, the main question I believe is being asked is:
> - Do we need to represent this via the object/sysfs tree or can an
>    outside utility be depended upon to show it ?
> 
> Note that I am not supporting:
> "Vendors may choose to distribute their own applications".
> For this to become truly useful, there needs to be a common tool/method
> that presents common features in a common manner, regardless of whether
> it is in kernel or not.

I don't disagree with that, but the fact is that there isn't such a
tool.   It's also a fact that the enterprise is reasonably unhappy with
the lack of an enclosure management infrastructure, since it's something
they got on all the other unix systems.

I think a minimal infrastructure in-kernel does just about everything
the enterprise wants ... and since it's stateless, they can always use
direct connect tools in addition.

However, I'm happy to be proven wrong ... anyone on this thread is
welcome to come up with a userland enclosure infrastructure.  Once it
does everything the in-kernel one does (which is really about the
minimal possible set), I'll be glad to erase the in-kernel one.

James


