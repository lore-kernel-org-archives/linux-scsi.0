From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 097/493] scsi: remove use of __devexit_p
Date: Wed, 21 Nov 2012 11:45:21 +0000
Message-ID: <20121121114521.GC3290@n2100.arm.linux.org.uk>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu> <1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47706 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab2KULuS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Nov 2012 06:50:18 -0500
Content-Disposition: inline
In-Reply-To: <1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Michael Reed <mdr@sgi.com>, Willem Riede <osst@riede.org>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com, osst-users@lists.sourceforge.net

On Mon, Nov 19, 2012 at 01:20:46PM -0500, Bill Pemberton wrote:
>  drivers/scsi/arm/acornscsi.c              | 2 +-
>  drivers/scsi/arm/arxescsi.c               | 2 +-
>  drivers/scsi/arm/cumana_1.c               | 2 +-
>  drivers/scsi/arm/cumana_2.c               | 2 +-
>  drivers/scsi/arm/eesox.c                  | 2 +-
>  drivers/scsi/arm/oak.c                    | 2 +-
>  drivers/scsi/arm/powertec.c               | 2 +-

For these drivers,

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
