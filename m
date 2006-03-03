From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] make some sas class properties optional
Date: Fri, 3 Mar 2006 09:42:18 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F327822@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:6546 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932308AbWCCQmX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 11:42:23 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Friday, March 03, 2006 9:38 AM, James Bottomley wrote: 

> As you can see, for a driver that provides an SMP tap, like 
> aic94xx then
> these parameters can be got by the transport class sending the SMP
> queries ... the driver doesn't need to know about it.
> 
> James


That maybe true for expanders, but what about the host adapter.  The SMP
hooks
will not retrieve these properties for the phys directly attached to
the host adapter.  Meaning you can reset the link between phy on the
hba, and
device direct attached; e.g. SMP_PHY_CONTROL will not work for that.
Thus
I recommend this is needed.

Eric Moore
