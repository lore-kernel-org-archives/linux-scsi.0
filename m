From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] megaraid: fix section mismatch
Date: Fri, 11 Jan 2008 18:57:54 +0100
Message-ID: <20080111175754.GG28624@uranus.ravnborg.org>
References: <20080110143316.071efbc1.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:52024 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761579AbYAKR54 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 12:57:56 -0500
Content-Disposition: inline
In-Reply-To: <20080110143316.071efbc1.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: megaraidlinux@lsi.com, scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>, akpm <akpm@linux-foundation.org>

On Thu, Jan 10, 2008 at 02:33:16PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change megaraid_pci_driver_g variable name so that it matches the modpost
> whitelist that allows pointers to init text/data.
> 
> WARNING: vmlinux.o(.data+0x1a8e30): Section mismatch: reference to .init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and 'class_device_attr_megaraid_mbox_app_hndl')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
