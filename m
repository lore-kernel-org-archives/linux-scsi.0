From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: How to add/drop SCSI drives from within the driver?
Date: Wed, 08 Dec 2004 13:06:34 -0600
Message-ID: <1102532794.4013.2.camel@localhost.localdomain>
References: <0E3FA95632D6D047BA649F95DAB60E570230CA8F@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:58777 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261416AbULIBLV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2004 20:11:21 -0500
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570230CA8F@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, "'brking@us.ibm.com'" <brking@us.ibm.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "'bunk@fs.tum.de'" <bunk@fs.tum.de>, 'Andrew Morton' <akpm@osdl.org>, "Ju, Seokmann" <sju@lsil.com>, "Doelfel, Hardy" <hdoelfel@lsil.com>, "Mukker, Atul" <Atulm@lsil.com>

On Wed, 2004-12-08 at 12:56 -0500, Bagalkote, Sreenivas wrote:
> >The real way I'd like to handle this is via hotplug.  The 
> >hotplug event would transmit the HCTL in the environment.  
> >Whether the drive actually gets incorporated into the system 
> >and where is user policy, so it's appropriate that it should 
> >be in userland.
> 
> James, it is the application that is adding the drive. So it is not a
> hotplug
> event for the driver.

Then perhaps I don't understand what the issue is.  If the application
is adding the drive, then surely it would know the numbers.  If not,
then the driver must communicate this back, and that's what the hotplug
would be about.

James


