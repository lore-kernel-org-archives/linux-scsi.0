From: Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [Pv-drivers] [PATCH 192/493] scsi: remove use of __devinit
Date: Mon, 26 Nov 2012 09:37:35 -0800
Message-ID: <20121126173735.GC11127@dtor-ws.eng.vmware.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-192-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:46941 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755146Ab2KZRhf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Nov 2012 12:37:35 -0500
Content-Disposition: inline
In-Reply-To: <1353349642-3677-192-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org, Oliver Neukum <oliver@neukum.org>, VMware PV-Drivers <pv-drivers@vmware.com>, Kurt Garloff <garloff@suse.de>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, GOTO Masanori <gotom@debian.or.jp>, Russell King <linux@arm.linux.org.uk>, linux-scsi@vger.kernel.org, Jamie Lenehan <lenehan@twibble.org>, osst-users@lists.sourceforge.net, Michael Reed <mdr@sgi.com>, cbe-oss-dev@lists.ozlabs.org, iss_storagedev@hp.com, Matthew Wilcox <matthew@wil.cx>, Ali Akcaagac <aliakc@web.de>, dc395x@twibble.org, linux-arm-kernel@lists.infradead.org, Neela Syam Kolli <megaraidlinux@lsi.com>, Geoff Levand <geoff@infradead.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Willem Riede <osst@riede.org>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linuxppc-dev@lists.ozlabs.org, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On Mon, Nov 19, 2012 at 01:22:21PM -0500, Bill Pemberton wrote:
> CONFIG_HOTPLUG is going away as an option so __devinit is no longer
> needed.
> 

...

>  drivers/scsi/vmw_pvscsi.c                 |  6 +-

For vmw_pvscsi:

Acked-by: Dmitry Torokhov <dtor@vmware.com>

Thanks,
Dmitry


