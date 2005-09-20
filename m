From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] zfcp: provide support for NPIV
Date: Tue, 20 Sep 2005 09:58:36 +0100
Message-ID: <20050920085836.GA31792@infradead.org>
References: <OFD2F66C80.E6AB000B-ONC1257081.00515783-C1257081.005185B0@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40119 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964941AbVITI6i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 04:58:38 -0400
Content-Disposition: inline
In-Reply-To: <OFD2F66C80.E6AB000B-ONC1257081.00515783-C1257081.005185B0@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <AHERRMAN@de.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

On Mon, Sep 19, 2005 at 04:53:13PM +0200, Andreas Herrmann wrote:
> > > @@ -68,6 +68,8 @@ ZFCP_DEFINE_ADAPTER_ATTR(s_id, "0x%06x\n
> > >  ZFCP_DEFINE_ADAPTER_ATTR(peer_wwnn, "0x%016llx\n", 
> adapter->peer_wwnn);
> > >  ZFCP_DEFINE_ADAPTER_ATTR(peer_wwpn, "0x%016llx\n", 
> adapter->peer_wwpn);
> > >  ZFCP_DEFINE_ADAPTER_ATTR(peer_d_id, "0x%06x\n", adapter->peer_d_id);
> > > +ZFCP_DEFINE_ADAPTER_ATTR(physical_wwpn, "0x%016llx\n", 
> adapter->physical_wwpn);
> 
> > this information belongs into the transport class, not the driver.
> > What's the peer information above?  is that for point-to-point FC
> > connections?
> 
> Hope it is acceptable to keep this attributes in zfcp sysfs subtree
> until I will send a patch to add physical port_name and physical
> port_id information to the transport class. 

keeping the peer stuff is okay for now, adding the physical attributes
is not, they should be moved to the transport class from the start.

