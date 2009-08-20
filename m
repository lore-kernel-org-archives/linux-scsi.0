From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Management Ioctls Revisited
Date: Thu, 20 Aug 2009 18:32:21 -0400
Message-ID: <20090820223221.GA3482@infradead.org>
References: <b1bc6a000908191515yef38d4bxaeca8e6e3c761237@mail.gmail.com> <b1bc6a000908201152s154ca680h14741dbfdaedcd01@mail.gmail.com> <1250807022.4302.163.camel@mulgrave.site> <b1bc6a000908201528w1642c3d3q8b6582a3bf8f61b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60782 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbZHTWc0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 18:32:26 -0400
Content-Disposition: inline
In-Reply-To: <b1bc6a000908201528w1642c3d3q8b6582a3bf8f61b6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Linus Torvalds <torvalds@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Mukker, Atul" <Atul.Mukker@lsi.com>, bruce.allen@aei.mpg.de, Christoph Hellwig <hch@infradead.org>

On Thu, Aug 20, 2009 at 03:28:01PM -0700, adam radford wrote:
> On Thu, Aug 20, 2009 at 3:23 PM, James Bottomley<James.Bottomley@suse.de> wrote:
> 
> > Are you talking about a SCSI HBA or a RAID one?
> 
> Hardware RAID HBA.

We would really like to avoid new homegrown interfaces.  But from your
initial mail it sunds like you have a new driver that implement the same
managment interface as the older 3ware drivers do, AND there is opensource
userspace for it.  I don't think anyone in the right mind could say no
to that with our current state of affairs.

