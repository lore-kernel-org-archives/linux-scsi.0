From: James.Smart@Emulex.Com
Subject: RE: [Announce] Emulex lpfcdriver v8.0.20 available
Date: Tue, 25 Jan 2005 17:22:50 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F318@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:56005 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262202AbVAYWXG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2005 17:23:06 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

I can easily disable the them. However, I won't sign up for dealing
with this change in the other FC drivers as it could be rather
extensive. A patch to back out the attributes would disable FC
transport support in the other drivers. Their maintainers would need
to re-add support.

-- james s


Christoph Hellwig wrote:
> On Thu, Jan 20, 2005 at 11:26:00AM -0500, 
> James.Smart@Emulex.Com wrote:
> > > This sounds like a good idea, but I wonder if we have 
> userland relying
> > > on those attributes already.  But given that the fc 
> transport class
> > > was mostly a joke before you encehanced it it might be 
> worth breaking
> > > it..
> > 
> > You and James would have to give the approval for this one. 
> I already
> > encountered issues with these attributes when then went 
> from scsi_device
> > to scsi_target. The most significant hiccup was to udev and 
> the projects
> > depending on it... Also, given the potential amount of change may be
> > needed to move to rports, I wouldn't want to pull the rug 
> out from under
> > the other drivers until they are ready...
> 
> James just returned from a long journey and he hasn't read 
> the thread yet,
> but after a short discussion we agree that it's better to 
> move the attributes
> over to the rnode.  If we're seeing compatiblity problems 
> we'll have to
> add symlinks.
