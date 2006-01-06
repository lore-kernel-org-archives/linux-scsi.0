From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_transport_sas.c - mapping the rphy channel equal to the port identifier
Date: Fri, 6 Jan 2006 16:54:21 +0000
Message-ID: <20060106165421.GA3856@infradead.org>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F15386F@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54400 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751948AbWAFQy2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jan 2006 11:54:28 -0500
Content-Disposition: inline
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F15386F@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wed, Jan 04, 2006 at 02:58:40PM -0700, Moore, Eric wrote:
> The sas transport current implementation is mapping
> the channel number for each sas/sata device equal to
> the phy number.  The problem with that is it will be difficult
> to reserve a channel for RAID volumes when hot swap support
> is eventually implemented in the sas transport layer.
> Thus my suggested change is to map the channel to the port 
> identifier, which effectively maps each channel number to its own
> unique sas domain.  Thus we can map the RAID volumes to a reserved
> channel that
> is one larger than the anticapated number of ports on the direct
> attached host
> adapter.

ACK.  The channel isn't used for anything in the transport class or LLDD,
so this is fine.
