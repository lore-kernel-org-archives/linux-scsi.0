From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] ses: Handle non-unique element descriptors
Date: Mon, 04 Jul 2011 18:00:35 -0500
Message-ID: <1309820435.2606.43.camel@mulgrave>
References: <4E11D946.4050307@suse.de> <1309793724.2606.19.camel@mulgrave>
	 <4E1245DF.5000403@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43870 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab1GDXAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jul 2011 19:00:37 -0400
In-Reply-To: <4E1245DF.5000403@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ankit Jain <jankit@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

On Tue, 2011-07-05 at 04:29 +0530, Ankit Jain wrote:
> On 07/04/2011 09:05 PM, James Bottomley wrote:
> > On Mon, 2011-07-04 at 20:46 +0530, Ankit Jain wrote:
> >> Some SES devices give non-unique Element Descriptors as part of the
> >> Element Descriptor diag page. Since we use these for creating sysfs
> >> entries, they need to be unique.
> >>
> >> Eg:
> >> $ sg_ses -p 7 /dev/sg0
> >>   FTS CORP  TXS6_SAS20BPX12   0500
> >>     enclosure services device
> >> Element descriptor In diagnostic page:
> >>   generation code: 0x0
> >>   element descriptor by type list
> >>     Element type: Array device, subenclosure id: 0
> >>       Overall descriptor: ArrayDevicesInSubEnclsr0
> >>       Element 1 descriptor: ArrayDevice00
> >>       Element 2 descriptor: ArrayDevice01
> >>       Element 3 descriptor: ArrayDevice02
> >>       Element 4 descriptor: ArrayDevice03
> >>       Element 5 descriptor: ArrayDevice03
> >>       Element 6 descriptor: ArrayDevice03
> >>       Element 7 descriptor: ArrayDevice03
> >>       Element 8 descriptor: ArrayDevice03
> >>       Element 9 descriptor: ArrayDevice03
> >>       Element 10 descriptor: ArrayDevice03
> >>       Element 11 descriptor: ArrayDevice03
> >>       Element 12 descriptor: ArrayDevice03
> > 
> > What is the external visible labelling of this topology?  It's
> > completely weird that the enclosure would burn in non-unique names
> > unless there's some reason for it.
> 
> I'm not sure what you mean by "external visible labelling". The system has a
> SAS expanded backplane. I don't have access to the hardware now, but p7 looked
> like this:

The element descriptors usually correspond with labelling on the case of
whatever it is the enclosure is embedded in. Their job is to describe
the location of the device, so they usually get burned in with whatever
the default labelling scheme for the physical device is.  So what I want
to know is what is the labelling scheme in this case?

James

