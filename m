From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] cciss: section mismatch
Date: Fri, 11 Jan 2008 10:13:36 +0100
Message-ID: <20080111091335.GM6258@kernel.dk>
References: <20080110143235.b65d5f19.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23941 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759965AbYAKJNj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 04:13:39 -0500
Content-Disposition: inline
In-Reply-To: <20080110143235.b65d5f19.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, mike.miller@hp.com, iss_storagedev@hp.com, akpm <akpm@linux-foundation.org>, samr <sam@ravnborg.org>

On Thu, Jan 10 2008, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Mark cciss_pci_init() as __devinit, to fix section mismatch warning.
> 
> WARNING: vmlinux.o(.text+0x601fc9): Section mismatch: reference to .init.text: (between 'cciss_pci_init' and 'cciss_getgeometry')

Thanks Randy, added.

-- 
Jens Axboe

