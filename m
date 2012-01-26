From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [ATTEND] Storage management (API &
 Library)
Date: Fri, 27 Jan 2012 06:12:34 +0900
Message-ID: <20120127060733O.fujita.tomonori@lab.ntt.co.jp>
References: <4F19A981.4080502@redhat.com>
	<20120125174411.GB12620@infradead.org>
	<4F21BD3C.8050809@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38462 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab2AZVNC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 16:13:02 -0500
In-Reply-To: <4F21BD3C.8050809@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: agrover@redhat.com
Cc: hch@infradead.org, tasleson@redhat.com, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Thu, 26 Jan 2012 12:53:16 -0800
Andy Grover <agrover@redhat.com> wrote:

> On 01/25/2012 09:44 AM, Christoph Hellwig wrote:
> > There's another project which is creating a very ad-hoc storage
> > management abstraction, the nova-volume code in openstack.  Right now
> > it supports iSCSI with a few vendor-specific extensions for management,
> > RBD and sheepdog, but it looks like the numbers of vendors that want
> > to be supported is growing.
> > 
> > See https://github.com/openstack/nova/blob/master/nova/volume/driver.py
> > and other files in that directory for the little bits that exist at the
> > moment.
> 
> <two minutes prior>
> On 01/25/2012 09:42 AM, Christoph Hellwig wrote:
> > Wrapping tools from libraries is more of a last resort than a proper
> > solution.  But if we can't get better APIs that's probably what we
> > will have to resort to if vendors don't cooperate.
> 
> Nova is wrapping cmdline tools

I think that some drivers are better a bit. For example, looks like
SolidFire uses the REST API to talk to their storage:

https://review.openstack.org/gitweb?p=openstack%2Fnova.git;a=commit;h=47a357bd2b46a2279a98ed726facd2b12fe0a0f5


, and all the vendors interested so far
> are foss/cloudy.

True (HP lefthand is supported though).


> This definitely shows others see a need for an API, but if we really
> want big storage vendor buy-in, then a better (C?/sockets?) API and
> working with non-foss code seems key.

Agreed.

