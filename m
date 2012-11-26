From: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [Pv-drivers] [PATCH 097/493] scsi: remove use of __devexit_p
Date: Mon, 26 Nov 2012 09:36:52 -0800
Message-ID: <20121126173651.GB11127@dtor-ws.eng.vmware.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:46653 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933642Ab2KZRgw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 12:36:52 -0500
Content-Disposition: inline
In-Reply-To: <1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, Russell King <linux@arm.linux.org.uk>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, VMware PV-Drivers <pv-drivers@vmware.com>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, dc395x@twibble.org, Kurt Garloff <garloff@suse.de>, Willem Riede <osst@riede.org>, Jamie Lenehan <lenehan@twibble.org>, osst-users@lists.sourceforge.net, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Michael Reed <mdr@sgi.com>, linux-arm-kernel@lists.infradead.org

On Mon, Nov 19, 2012 at 01:20:46PM -0500, Bill Pemberton wrote:
> CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
> needed.
> 

...

>  drivers/scsi/vmw_pvscsi.c                 | 2 +-

For vmw_pvscsi:
 
Acked-by: Dmitry Torokhov <dtor@vmware.com>

Thanks,
Dmitry

