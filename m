From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Thu, 17 Mar 2005 09:08:53 -0800
Message-ID: <20050317170853.GA3006@kroah.com>
References: <20050302194432.GA9743@us.ibm.com> <20050302194553.GA9776@us.ibm.com> <20050302194647.GB9776@us.ibm.com> <20050316224551.GA21918@us.ibm.com> <1111071201.5994.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail.kroah.org ([69.55.234.183]:47571 "EHLO perch.kroah.org")
	by vger.kernel.org with ESMTP id S261971AbVCQRJI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 12:09:08 -0500
Content-Disposition: inline
In-Reply-To: <1111071201.5994.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>

On Thu, Mar 17, 2005 at 09:53:21AM -0500, James Bottomley wrote:
> On Wed, 2005-03-16 at 14:45 -0800, Patrick Mansfield wrote:
> > Any comments on this? Should I resend these patches?
> 
> Well, the basic comment is that there are a lot of features that SCSI
> has that the driver core lacks:
> 
> 1) Attribute overrides.  This is actually part of the published API for
> SCSI
> 2) Ability to add extra attributes---several drivers use this
> 3) Ability to change attribute permissions based on capabilities.
> 
> I really rather like all of these features.
> 
> Initially when we did all this work for SCSI, there wasn't much
> enthusiasm for incorporating these features into drivers/base.  You
> could look and see what it would take to do this, and propose it to
> Greg ... If he's happy, I'd have no problem moving over because now we
> won't lose any functionality.

I would be very interested in seeing the above stuff move into the
driver core.

thanks,

greg k-h
