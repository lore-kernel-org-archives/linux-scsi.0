From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Thu, 17 Mar 2005 09:53:21 -0500
Message-ID: <1111071201.5994.4.camel@mulgrave>
References: <20050302194432.GA9743@us.ibm.com>
	 <20050302194553.GA9776@us.ibm.com> <20050302194647.GB9776@us.ibm.com>
	 <20050316224551.GA21918@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:26348 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262178AbVCQOxb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 09:53:31 -0500
In-Reply-To: <20050316224551.GA21918@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>

On Wed, 2005-03-16 at 14:45 -0800, Patrick Mansfield wrote:
> Any comments on this? Should I resend these patches?

Well, the basic comment is that there are a lot of features that SCSI
has that the driver core lacks:

1) Attribute overrides.  This is actually part of the published API for
SCSI
2) Ability to add extra attributes---several drivers use this
3) Ability to change attribute permissions based on capabilities.

I really rather like all of these features.

Initially when we did all this work for SCSI, there wasn't much
enthusiasm for incorporating these features into drivers/base.  You
could look and see what it would take to do this, and propose it to
Greg ... If he's happy, I'd have no problem moving over because now we
won't lose any functionality.

James


