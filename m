From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: [PATCH RFC 0/4] use scatter lists for all block pc	requests	and simplify hw handlers
Date: Tue, 7 Jun 2005 09:34:00 -0400
Message-ID: <007901c56b65$90f918c0$e0019d89@cybernetics.com>
References: <42A59C35.5060207@torque.net>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:9732 "EHLO
	cyborg.cybernetics.com") by vger.kernel.org with ESMTP
	id S261864AbVFGNdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Jun 2005 09:33:54 -0400
In-Reply-To: <42A59C35.5060207@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Mike Christie' <michaelc@cs.wisc.edu>, 'device-mapper development' <dm-devel@redhat.com>, 'linux-scsi' <linux-scsi@vger.kernel.org>, 'Jens Axboe' <axboe@suse.de>, LIRANS@il.ibm.com

> James Bottomley wrote:
> > Well ... while I've got your attention, the only complexity I see to
> > converting sg is the hd->iovec_count != 0 case, which is doing
vectored
> > SG from user land.
> >
> > This can be implemented (basically you do multiple bio attachment to
a
> > request), and probably in the block layer (since block SG_IO would
then
> > pick up the capability).
> >
> > How important is this functionality?  Are there any applications
using
> > it?
>
> I don't think it is important and I'm not aware of any
> real world applications that are using it. Naturally,
> I will find out if that is actually true after it
> gets removed.

My company (Cybernetics) sells several products that run embedded Linux
which use the userspace scatter-gather capability of the SG driver.
They are still running the 2.4 kernel series, but we will probably
switch to 2.6 at some point.

Anthony J. Battersby
Cybernetics

