From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptfusion - fc transport attributes - REVISED
Date: Thu, 12 Jan 2006 16:17:13 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA347@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61616 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161458AbWALXRV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 18:17:21 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Hickerson, Roger" <Roger.Hickerson@lsil.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>

On Thursday, January 12, 2006 4:04 PM,  Michael Reed wrote:

> 	- it has been rebased to 2.6.15-git8 + two patches from 
> Eric Moore,
> 	  the first is referenced below,
> 
> 	  
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113710143317450&w=3
> 
> 	  and the second I just posted instead of including in 
> this patch.
> 
> 	  
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113710675626733&w=3
> 
> 

One thing is missing in completing the 949ES support.
That is PCI_DEVICE_ID_LSI_FC949ES need to be added in the
mptfc_pci_table[]
in mptfc.c.  This is the table contains the list of support pci device
ids.  
Is that possible to add that?

Eric Moore
