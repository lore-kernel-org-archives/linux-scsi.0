From: Andrew Morton <akpm@osdl.org>
Subject: Re: IA32 (2.6.1 - 2003-12-30.22.30) - 4 New warnings (gcc 3.2.2)
Date: Wed, 31 Dec 2003 04:00:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031231040047.19174e49.akpm@osdl.org>
References: <200312311132.hBVBWcg6008411@cherrypit.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:27563 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S263751AbTLaMAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 07:00:19 -0500
In-Reply-To: <200312311132.hBVBWcg6008411@cherrypit.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: John Cherry <cherry@osdl.org>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

John Cherry <cherry@osdl.org> wrote:
>
> drivers/scsi/aacraid/aachba.c:1409: warning: `flag' might be used uninitialized in this function
> drivers/scsi/eata_generic.h:84:1: warning: "TIMEOUT" redefined
> drivers/scsi/inia100.c:421: warning: `pHCB' might be used uninitialized in this function
> include/scsi/scsi.h:305:1: warning: this is the location of the previous definition

err, yes.  The inia100.c one is 100% deadly.

