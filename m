From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SNIA iSCSI Management API Public Review
Date: Tue, 26 Oct 2004 21:23:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026202311.GA17844@infradead.org>
References: <20041026182914.GA6006@lists.us.dell.com> <20041026194926.GA17456@infradead.org> <417EAC8F.5010109@netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:64269 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261431AbUJZUXP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 16:23:15 -0400
Content-Disposition: inline
In-Reply-To: <417EAC8F.5010109@netapp.com>
List-Id: linux-scsi@vger.kernel.org
To: David Wysochanski <davidw@netapp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Domsch <Matt_Domsch@dell.com>, linux-scsi@vger.kernel.org

On Tue, Oct 26, 2004 at 03:59:11PM -0400, David Wysochanski wrote:
> Christoph Hellwig wrote:
> >On Tue, Oct 26, 2004 at 01:29:14PM -0500, Matt Domsch wrote:
> > > FYI.
> >
> >It has the usual SNIA spec quality - aka totally useless.
> >
> 
> What specifically is so bad to describe it as totally useless?

it throws far too much things together, own type and object system,
functions to deal with firmware.  there's ill suited abstractions like
the phba, etc..

as I said it's the usual SNIA design by commitee mess.

> (Note that this API isn't kernel related.)

actual it is - as most of the calls end up in an device driver,
or because the API is totally messed up with networking bits the
networking layer.

to take a very concrete example:

IMA_SetSubnetMask (sets the subnet mask for a specified network port)
doesn't make any sense at all in Linux with a software iscsi implementation
as IP addresses and thus netmasks aren't bound to network interfaces at all.

