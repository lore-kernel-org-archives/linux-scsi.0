From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas: eliminate ghost devices
Date: Fri, 30 Jun 2006 17:28:01 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D701BE483@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:26278 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932410AbWF3X2I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 19:28:08 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Friday, June 30, 2006 4:59 PM, James Bottomley wrote: 

> 
> Yes, but we want an end device for a remote HBA, which your condition
> would also eliminate.  It shows useful information (like sas 
> address and
> parameters).

Yes good point. My thinking was the data is there on the host system
having
the remote HBA.  

> 
> > If the remote initiator is located beyond the 1st leve expander, or
> > direct
> > connected to each other, this condition will not entered.
> 
> Right ... here we'll see the end device, so if we go with your patch
> we'd see an end device for a remote HBA connected to a second level
> expander but not for a first level one.  Whatever happens, we 
> need to be
> consistent ...
> 

Agreed. Your doing referencing checking with host sas address, so 
the only rphys removed are those pointing back to the host, and not
other initiators.  So other initiators can exist on the 1st level
expanders,
as well as 2nd, 3rd, and so one.  Okay your patch is fine. Apply.

Eric
