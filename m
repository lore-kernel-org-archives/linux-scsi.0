From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 192/493] scsi: remove use of __devinit
Date: Wed, 21 Nov 2012 11:51:14 +0000
Message-ID: <20121121115114.GF3290@n2100.arm.linux.org.uk>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu> <1353349642-3677-192-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47741 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2KULyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Nov 2012 06:54:10 -0500
Content-Disposition: inline
In-Reply-To: <1353349642-3677-192-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Geoff Levand <geoff@infradead.org>, Michael Reed <mdr@sgi.com>, Willem Riede <osst@riede.org>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com, linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org, osst-users@lists.sourceforge.net

On Mon, Nov 19, 2012 at 01:22:21PM -0500, Bill Pemberton wrote:
>  drivers/scsi/arm/acornscsi.c              |  2 +-
>  drivers/scsi/arm/arxescsi.c               |  2 +-
>  drivers/scsi/arm/cumana_1.c               |  2 +-
>  drivers/scsi/arm/cumana_2.c               |  2 +-
>  drivers/scsi/arm/eesox.c                  |  2 +-
>  drivers/scsi/arm/oak.c                    |  2 +-
>  drivers/scsi/arm/powertec.c               |  2 +-

For these,

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
