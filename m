From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs
	take 2
Date: 07 Sep 2004 17:14:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094591701.2068.151.camel@mulgrave>
References: <20040907210520.0251476C56@isis.visi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:59543 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268671AbUIGVRX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 17:17:23 -0400
In-Reply-To: <20040907210520.0251476C56@isis.visi.com>
List-Id: linux-scsi@vger.kernel.org
To: "Scott M. Ferris" <sferris@acm.org>
Cc: Mike Christie <mikenc@us.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-09-07 at 17:05, Scott M. Ferris wrote:
> So a host is where you plug your (non-existent) bus?  I think it would
> be clearer to use terminology from SAM.

Actually, no.  A host is a SAM implementation, not SAM itself.  I think
the where are the resources question is the clearest way to look at it.

> > > Do you think switched SCSI transports should allocate one Linux host
> > > for each I_T nexus?
> > 
> > No.
> 
> This is exactly why I ask these questions.  The iSCSI driver
> developers just implemented this, because they thought this is what
> you and Christoph were asking for.  Apparently it's not what you
> wanted.

Well, that seems to be the correct thing to do.  Most of the time (all
of the time?) your virtual connection is to a single storage target, so
its identical to a bus with one device on it, isn't it? 

> > > Do you think switched SCSI transports should allocate one Linux host
> > > for each (SAM-2 or SAM-3) SCSI initiator device?
> > 
> > No.
> 
> Should all drivers that currently use one host for each SCSI initiator
> device, and a channel for each initiator port on each device, be
> modified to use a host for each initiator port?

I've made no secret about wanting to dump our channel abstraction. 
However, I'm not going to force a change like this.

James


