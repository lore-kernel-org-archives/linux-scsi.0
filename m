From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] 2/2 Use bus dev_attrs to create scsi_device attributes
Date: Wed, 30 Mar 2005 20:32:44 +0200
Message-ID: <1112207564.4631.59.camel@localhost.localdomain>
References: <20050302194432.GA9743@us.ibm.com>
	 <20050302194553.GA9776@us.ibm.com> <20050302194647.GB9776@us.ibm.com>
	 <20050316224551.GA21918@us.ibm.com>  <1111071201.5994.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from soundwarez.org ([217.160.171.123]:27839 "EHLO soundwarez.org")
	by vger.kernel.org with ESMTP id S262383AbVC3Scq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2005 13:32:46 -0500
In-Reply-To: <1111071201.5994.4.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Thu, 2005-03-17 at 09:53 -0500, James Bottomley wrote:
> On Wed, 2005-03-16 at 14:45 -0800, Patrick Mansfield wrote:
> > Any comments on this? Should I resend these patches?
> 
> Well, the basic comment is that there are a lot of features that SCSI
> has that the driver core lacks:
> 
> 1) Attribute overrides.  This is actually part of the published API for SCSI

What does this exactly mean? Handle the same attribute dynamically with
a different source of data?

> 2) Ability to add extra attributes---several drivers use this

What is missing in the driver core here? Why can't you add/remove
attribute files at any time? 

Thanks,
Kay

