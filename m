From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: Re: [Emulex] Ready for next round...
Date: Wed, 16 Jun 2004 09:35:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616133518.GS11371@ma.emulex.com>
References: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com> <20040616081757.GA8683@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dhcp-78-101.ma.emulex.com ([138.239.78.101]:7124 "EHLO
	wintermute.ma.emulex.com") by vger.kernel.org with ESMTP
	id S263735AbUFPNf0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 09:35:26 -0400
Content-Disposition: inline
In-Reply-To: <20040616081757.GA8683@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Smart, James" <James.Smart@emulex.com>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Christoph,

Am I missing the big diff for lpfc_fcp.c?  I don't see it . . .

Thanks,
Jamie

On Wed, Jun 16, 2004 at 09:17:57AM +0100, Christoph Hellwig wrote:
> On Tue, Jun 15, 2004 at 01:32:56PM -0400, Smart, James wrote:
> > Christoph, et al...
> > 
> > I'd like to request the next round of review comments on the driver.
> > 
> > We believe that tonights posting on SourceForge has addressed all of the
> > comments to date with only a couple of exceptions (see below).
> 
> Before commenting on anything here's a big diff turning lpfc_fcp.c into
> normal driver function ordering, aka function above invokations, scsi
> methods over pci methods, and fixes gazillions of leaks in the ->probe
> failure cases.  It's guranteed to conflict with just about everything
> touching that file.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
