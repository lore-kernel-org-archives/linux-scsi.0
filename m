From: Greg KH <greg@kroah.com>
Subject: Re: next-2008-0306 scsi/libsas build failure
Date: Thu, 6 Mar 2008 10:16:45 -0800
Message-ID: <20080306181645.GA6046@kroah.com>
References: <20080306090904.258f92eb.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53782 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935769AbYCFST1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 13:19:27 -0500
Content-Disposition: inline
In-Reply-To: <20080306090904.258f92eb.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, jejb <James.Bottomley@HansenPartnership.com>

On Thu, Mar 06, 2008 at 09:09:04AM -0800, Randy Dunlap wrote:
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x598fb): undefined reference to `request_firmware'
> drivers/built-in.o: In function `sas_request_addr':
> (.text+0x5998e): undefined reference to `release_firmware'
> make[1]: *** [.tmp_vmlinux1] Error 1
> make: *** [sub-make] Error 2
> 
> drivers/scsi/libsas/sas_scsi_host.c calls request_firmware() and
> release_firmware() without checking to see if CONFIG_FW_LOADER=y.

Sounds like a bug in the firmware code, it should provide stubs if this
config option is not present, right?

thanks,

greg k-h
