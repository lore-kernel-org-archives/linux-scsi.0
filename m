From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Tue, 30 Oct 2007 10:00:34 +0100
Message-ID: <20071030100034.64fd9d70@gondolin.boeblingen.de.ibm.com>
References: <1193671019.3383.13.camel@localhost.localdomain>
	<1193676852.2655.21.camel@lov.site>
	<1193677071.3383.56.camel@localhost.localdomain>
	<20071029181814.25410e00@gondolin.boeblingen.de.ibm.com>
	<1193678646.3383.76.camel@localhost.localdomain>
	<4726180E.5030909@garzik.org>
	<1193678967.3383.81.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:15565 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbXJ3JAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Oct 2007 05:00:51 -0400
In-Reply-To: <1193678967.3383.81.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 29 Oct 2007 12:29:27 -0500,
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Mon, 2007-10-29 at 13:27 -0400, Jeff Garzik wrote:
> > James Bottomley wrote:
> > > visibility and creation are the same thing, aren't they?  An invisible
> > > attribute doesn't appear in the sysfs directory, so it's equivalent to
> > > the file for it not being created.
> > 
> > 
> > What about the case where it's visible at creation time, but then needs 
> > to be made selectively invisible later on?
> > 
> > That implies either a remove operation or dentry checks on each lookup?
> 
> Yes, that comes with the bitmap manipulation code.  There will be a way
> to add and remove runtime visibility.  I just wanted to get the basic
> concept agreed to first.

But visibility always comes with creation or deletion of attributes?

Perhaps what we want is to move knowledge of the attributes to the
kobject (when attributes are created/deleted), while we decide on
visibilty of the attributes (creation/deletion of sysfs entries) based
on a filter (where visibility may change, while the attribute still
exists).
