From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/2] sysfs: allow the group is_visible() method to
	return a mode and add an update API
Date: Tue, 1 Apr 2008 23:30:47 -0700
Message-ID: <20080402063047.GC8158@kroah.com>
References: <1206134832.2961.64.camel@localhost.localdomain> <20080321222635.GA2674@kroah.com> <1206208949.4393.25.camel@localhost.localdomain> <1206896083.4224.40.camel@localhost.localdomain> <1206970929.20492.27.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56171 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYDBGc5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Apr 2008 02:32:57 -0400
Content-Disposition: inline
In-Reply-To: <1206970929.20492.27.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Mar 31, 2008 at 03:42:09PM +0200, Kay Sievers wrote:
> On Sun, 2008-03-30 at 11:54 -0500, James Bottomley wrote:
> > On Sat, 2008-03-22 at 13:02 -0500, James Bottomley wrote:
> > > On Fri, 2008-03-21 at 15:26 -0700, Greg KH wrote:
> > > > On Fri, Mar 21, 2008 at 04:27:12PM -0500, James Bottomley wrote:
> > > > > We have a problem in scsi_transport_spi in that we need to customise
> > > > > not only the visibility of the attributes, but also their mode.  Fix
> > > > > this by making the is_visible() callback return a mode, with 0
> > > > > indicating is not visible.
> > > > > 
> > > > > Also add a sysfs_update_group() API to allow us to change either the
> > > > > visibility or mode of the files at any time on the fly.
> > > > > 
> > > > > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > > ---
> > > > > 
> > > > > Greg, can I take this through SCSI, please ... assuming it's OK?  We
> > > > > need this to fix up the SPI transport class.
> > > > 
> > > > Sure.  But can you document that "update" field a bit more so we can
> > > > remember what it means in the future?
> > > 
> > > How about this?  I also added docbook for create and update attribute
> > > group.
> 
> Looks good to me.
> 
> I think with the "visible" stuff for attribute groups, will be able to
> fix the USB event timing problem, by moving the creation of the device
> attributes to default attributes. So I'm looking forward to have this in
> the tree.

Me too.

> > Can I get an ACK from someone from sysfs for this, please?
> 
> > > ---
> > > 
> > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > Date: Thu, 20 Mar 2008 20:47:52 -0500
> > > Subject: [SCSI] sysfs: make group is_valid return a mode_t
> > > 
> > > We have a problem in scsi_transport_spi in that we need to customise
> > > not only the visibility of the attributes, but also their mode.  Fix
> > > this by making the is_visible() callback return a mode, with 0
> > > indicating is not visible.
> > > 
> > > Also add a sysfs_update_group() API to allow us to change either the
> > > visibility or mode of the files at any time on the fly.
> 
> Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

