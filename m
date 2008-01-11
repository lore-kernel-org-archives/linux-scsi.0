From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] cciss: section mismatch
Date: Fri, 11 Jan 2008 18:55:08 +0100
Message-ID: <20080111175508.GE28624@uranus.ravnborg.org>
References: <20080110143235.b65d5f19.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:49056 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762350AbYAKRzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 12:55:06 -0500
Content-Disposition: inline
In-Reply-To: <20080110143235.b65d5f19.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, mike.miller@hp.com, iss_storagedev@hp.com, akpm <akpm@linux-foundation.org>, axboe@kernel.dk

On Thu, Jan 10, 2008 at 02:32:35PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Mark cciss_pci_init() as __devinit, to fix section mismatch warning.
> 
> WARNING: vmlinux.o(.text+0x601fc9): Section mismatch: reference to .init.text: (between 'cciss_pci_init' and 'cciss_getgeometry')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
