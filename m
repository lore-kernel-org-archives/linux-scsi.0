From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Emulex] Ready for next round...
Date: Wed, 16 Jun 2004 09:17:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040616081757.GA8683@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:13462 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266214AbUFPISD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jun 2004 04:18:03 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F94D5@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

On Tue, Jun 15, 2004 at 01:32:56PM -0400, Smart, James wrote:
> Christoph, et al...
> 
> I'd like to request the next round of review comments on the driver.
> 
> We believe that tonights posting on SourceForge has addressed all of the
> comments to date with only a couple of exceptions (see below).

Before commenting on anything here's a big diff turning lpfc_fcp.c into
normal driver function ordering, aka function above invokations, scsi
methods over pci methods, and fixes gazillions of leaks in the ->probe
failure cases.  It's guranteed to conflict with just about everything
touching that file.
