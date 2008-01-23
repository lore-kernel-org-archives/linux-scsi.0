From: Greg KH <greg@kroah.com>
Subject: Re: PATCH: usb-storage-set-last-sector-bug-flag.patch
Date: Wed, 23 Jan 2008 10:50:28 -0800
Message-ID: <20080123185028.GA23177@kroah.com>
References: <20080120205625.GB28842@kroah.com> <Pine.LNX.4.44L0.0801201642460.8504-100000@netrider.rowland.org> <20080123181239.GA21836@kroah.com> <1201113579.3110.64.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53447 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbYAWStu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 13:49:50 -0500
Content-Disposition: inline
In-Reply-To: <1201113579.3110.64.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Hans de Goede <j.w.r.degoede@hhs.nl>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>, David Brown <usb-storage2@davidb.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, Jan 23, 2008 at 12:39:39PM -0600, James Bottomley wrote:
> 
> On Wed, 2008-01-23 at 10:12 -0800, Greg KH wrote:
> > On Sun, Jan 20, 2008 at 04:45:36PM -0500, Alan Stern wrote:
> > > On Sun, 20 Jan 2008, Greg KH wrote:
> > > 
> > > > On Sun, Jan 20, 2008 at 11:27:29AM +0100, Hans de Goede wrote:
> > > > > Hi all,
> > > > >
> > > > > This patch sets the last_sector_bug flag to 1 for all USB disks. This is
> > > > > needed to makes the cardreader on various HP multifunction printers work.
> > > > >
> > > > > Since the performance impact is negible we set this flag for all USB disks 
> > > > > to avoid an unusual_devs.h nightmare.
> > > > 
> > > > Oh great, now my "working just fine" USB devices, which happen to have
> > > > data in the last sector, suddenly stop working.
> > > > 
> > > > That's not acceptable :(
> > > 
> > > These patches really should not impact existing devices.  If they do
> > > then something is definitely wrong.
> > > 
> > > Can you provide detailed logging information showing your problem?  For 
> > > example, a usbmon trace would be good.  Better yet, a usbmon trace 
> > > without the patches and a usbmon trace with the patches, for 
> > > comparison.
> > 
> > I don't have a device with such a problem, I just am worried that we are
> > now suddenly keeping access from the last sector for devices that
> > currently did work just fine.
> > 
> > If you all guarantee that this will not happen, hey, I'm happy, and I'll
> > gladly point all bug reports on to you all :)
> 
> 
> Hey, you can trust me ... I'm a doctor ...
> 
> Would you like me to add your 'Responsibility-disclamed-by:' to the
> patch ...?

Heh.

As long as you take it through your trees, I inherently disclaim any
responsibility :)

greg k-h
