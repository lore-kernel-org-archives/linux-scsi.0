From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: fix a few missing return value checks in scsi
Date: Wed, 31 Dec 2003 15:38:21 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031231143821.GA7974@devserv.devel.redhat.com>
References: <1072879141.4292.5.camel@laptop.fenrus.com> <3FF2DEAE.1040009@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:7591 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265132AbTLaOib (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 09:38:31 -0500
Content-Disposition: inline
In-Reply-To: <3FF2DEAE.1040009@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Dec 31, 2003 at 09:35:26AM -0500, Jeff Garzik wrote:
> 
> 
> No offense to you personally, but this is a bunch of crap.  aic7xxx 
> needs to use the standard kernel APIs for pci_set_dma_mask and 
> pci_set_consistent_dma_mask...
> 
> We don't need a wrapper for every kernel API function :(

that's an entirely different argument that I entirely agree with....
