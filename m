From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: =?UTF-8?q?=5BPATCH=20097/493=5D=20scsi=3A=20remove=20use=20of=20=5F=5Fdevexit=5Fp?=
Date: Fri, 23 Nov 2012 00:02:44 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1211230000500.11581@axis700.grange>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab2KVXC6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Nov 2012 18:02:58 -0500
In-Reply-To: <1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: gregkh@linuxfoundation.org, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Russell King <linux@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Michael Reed <mdr@sgi.com>, Willem Riede <osst@riede.org>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Kurt Garloff <garloff@suse.de>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com, osst-users@lists.sourceforge.net

On Mon, 19 Nov 2012, Bill Pemberton wrote:

> CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
> needed.

>  drivers/scsi/tmscsim.c                    | 2 +-

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
