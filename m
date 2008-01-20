From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [SCSI] scsi.h: add macro for enclosure bit of inquiry data
Date: Sun, 20 Jan 2008 17:29:04 -0600
Message-ID: <1200871744.3105.33.camel@localhost.localdomain>
References: <1200841780.3105.1.camel@localhost.localdomain>
	 <4793886F.2070707@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35418 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755261AbYATX3K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jan 2008 18:29:10 -0500
In-Reply-To: <4793886F.2070707@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


On Sun, 2008-01-20 at 18:44 +0100, Stefan Richter wrote:
> James Bottomley wrote:
> > The macro tells us whether the device is (or contains) an enclosure device.
> ...
> > +static inline int scsi_device_enclosure(struct scsi_device *sdev)
> > +{
> > +	return sdev->inquiry[6] & (1<<6);
> > +}
> 
> Perhaps call it scsi_device_is_enclosure() to better reflect the nature
> of this function.
> 
> Or if it is an accessor to inquiry data to you, maybe call it
> scsi_device_inquiry_encserv() or
> scsi_device_inquiry_enclosure_services() or
> sdev_to_inquiry_encserv() or
> sdev_to_inquiry_enclosure_services().
> 
> Alas neither of this fits with the existing similar functions in
> scsi_device.h which don't have expressive names.

Right .. that's the problem.  Being potentially clearer in naming but at
odds with what's currently in the file starts to add to the confusion
about the other names in there.  I chose the name primarily because it's
the same form as all the others.

James


